{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE InstanceSigs          #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns        #-}
{-# LANGUAGE ScopedTypeVariables   #-}

-- | Builder module to convert from
-- CheckedData to ResourceData
-- We do the following:
-- * Clean up ast structure
-- * Extract all structs, and give them unique names
-- * Convert types so structs get class names rather than fields
-- * Convert scoped idents to an offset value (for JVM bytecode)
-- * Add defaults for for loop condition and switch expr (both True by default)
module ResourceBuilder
  ( convertProgram
  , resourceGen
  ) where

import           Base
import qualified CheckedData      as T
import           Control.Monad.ST
import qualified Cyclic           as C
import           Data.Maybe       (catMaybes, fromMaybe, listToMaybe)
import           Prelude          hiding (init)
import qualified ResourceContext  as RC
import           ResourceData
import           SymbolTable      (typecheckGen)

resourceGen :: String -> Glc Program
resourceGen p = convertProgram <$> typecheckGen p

convertProgram :: T.Program -> Program
convertProgram p =
  runST $ do
    rc <- RC.new
    convert rc p

class Converter a b where
  convert :: forall s. RC.ResourceContext s -> a -> ST s b

instance Converter T.Program Program where
  convert rc T.Program {T.package, T.topLevels} = do
    topLevels' <- mapM (convert rc) topLevels
    structs <- RC.getAllStructs rc
    return $
      Program
        { package = package
        , structs = structs
        , topVars = concat [vars | TopVar vars <- topLevels']
        , init = [stmt | TopInit stmt <- topLevels']
        , functions = [func | TopFunc func <- topLevels']
        }

data TopLevel
  = TopVar [TopVarDecl]
  | TopFunc FuncDecl
  | TopInit Stmt

instance Converter T.TopDecl TopLevel where
  convert rc topDecl =
    case topDecl of
      T.TopDecl decl     -> TopVar <$> convert rc decl
      T.TopFuncDecl decl -> funcDecl <$> convert rc decl
    where
      funcDecl :: FuncDecl -> TopLevel
      funcDecl (FuncDecl (T.Ident "init") (Signature (Parameters []) Nothing) body) =
        TopInit body
      funcDecl d = TopFunc d

instance Converter T.FuncDecl FuncDecl where
  convert rc (T.FuncDecl (T.ScopedIdent _ i) sig body) =
    wrap $ FuncDecl <$-> i <*> convert rc sig <*> wrap (convert rc body)
    where
      wrap = RC.wrap rc

instance Converter T.Signature Signature where
  convert rc (T.Signature params retType) =
    Signature <$> convert rc params <*>
    maybe (return Nothing) (Just <$$> convert rc) retType

instance Converter T.ParameterDecl ParameterDecl where
  convert rc (T.ParameterDecl i t) =
    ParameterDecl <$> RC.getVarIndex rc i <*> convert rc t

instance Converter T.Parameters Parameters where
  convert rc (T.Parameters params) = Parameters <$> mapM (convert rc) params

instance Converter T.Decl [TopVarDecl] where
  convert :: forall s. RC.ResourceContext s -> T.Decl -> ST s [TopVarDecl]
  convert rc decl =
    case decl of
      T.VarDecl decls -> mapM convertVarDecl decls
      T.TypeDef decls -> mapM_ convertTypeDecl decls $> []
    where
      convertVarDecl :: T.VarDecl' -> ST s TopVarDecl
      convertVarDecl (T.VarDecl' (T.ScopedIdent _ i) t expr) =
        TopVarDecl <$-> i <*> convert rc t <*>
        maybe (return Nothing) (Just <$$> convert rc) expr
      convertTypeDecl :: T.TypeDef' -> ST s ()
      convertTypeDecl _ = return ()

instance Converter T.Decl [Stmt] where
  convert :: forall s. RC.ResourceContext s -> T.Decl -> ST s [Stmt]
  convert rc decl =
    case decl of
      T.VarDecl decls -> mapM convertVarDecl decls
      T.TypeDef decls -> mapM_ convertTypeDecl decls $> []
    where
      convertVarDecl :: T.VarDecl' -> ST s Stmt
      convertVarDecl (T.VarDecl' i t expr) =
        VarDecl <$> RC.getVarIndex rc i <*> convert rc t <*>
        maybe (return Nothing) (Just <$$> convert rc) expr
      convertTypeDecl :: T.TypeDef' -> ST s ()
      convertTypeDecl _ = return ()

instance Converter T.CType Type where
  convert :: forall s. RC.ResourceContext s -> T.CType -> ST s Type
  convert rc type' =
    case C.getActual type' of
      T.ArrayType i t -> ArrayType i <$> ct (C.set type' t)
      T.SliceType t -> SliceType <$> ct (C.set type' t)
      T.StructType fields ->
        let cfields = zip (repeat type') fields
         in StructType <$> (RC.getStructName rc =<< mapM (convert rc) cfields)
      T.TypeMap t -> ct t
      T.PInt -> return PInt
      T.PFloat64 -> return PFloat64
      T.PBool -> return PBool
      T.PRune -> return PRune
      T.PString -> return PString
      T.Cycle -> undefined
    where
      ct :: T.CType -> ST s Type
      ct = convert rc

instance Converter (T.CType, T.FieldDecl) FieldDecl where
  convert ::
       forall s.
       RC.ResourceContext s
    -> (T.CType, T.FieldDecl)
    -> ST s FieldDecl
  convert rc (ctype, T.FieldDecl ident t) =
    FieldDecl ident <$> convert rc (C.set ctype t)

instance Converter T.Expr Expr where
  convert :: forall s. RC.ResourceContext s -> T.Expr -> ST s Expr
  convert rc expr =
    case expr of
      T.Unary t op e -> Unary <$> ct t <*-> op <*> ce e
      T.Binary t op e1 e2 ->
        Binary <$> RC.getLabel rc <*> ct t <*-> op <*> ce e1 <*> ce e2
      T.Lit lit -> return $ Lit lit
      T.Var t i -> Var <$> ct t <*> RC.getVarIndex rc i
      T.AppendExpr t e1 e2 -> AppendExpr <$> ct t <*> ce e1 <*> ce e2
      T.LenExpr e -> LenExpr <$> ce e
      T.CapExpr e -> CapExpr <$> ce e
      T.Selector t _ e i -> Selector <$> ct t <*> ce e <*-> i
      T.Index t e1 e2 -> Index <$> ct t <*> ce e1 <*> ce e2
      T.Arguments t i exprs -> Arguments <$> ct t <*-> i <*> mapM ce exprs
    where
      ct :: T.CType -> ST s Type
      ct = convert rc
      ce :: T.Expr -> ST s Expr
      ce = convert rc

instance Converter T.SimpleStmt SimpleStmt where
  convert :: forall s. RC.ResourceContext s -> T.SimpleStmt -> ST s SimpleStmt
  convert rc stmt =
    case stmt of
      T.EmptyStmt           -> return EmptyStmt
      T.ExprStmt e          -> ExprStmt <$> ce e
      T.VoidExprStmt idt el -> VoidExprStmt idt <$> mapM ce el
      T.Increment e         -> Increment <$> ce e
      T.Decrement e         -> Decrement <$> ce e
      T.Assign op exprs     -> Assign op <$> mapM convertAssign exprs
      T.ShortDeclare decls  -> ShortDeclare <$> mapM convertShortDecl decls
    where
      convertAssign :: (T.Expr, T.Expr) -> ST s (Expr, Expr)
      convertAssign (e1, e2) = (,) <$> ce e1 <*> ce e2
      convertShortDecl :: (T.ScopedIdent, T.Expr) -> ST s (VarIndex, Expr)
      convertShortDecl (i, e) = (,) <$> RC.getVarIndex rc i <*> ce e
      ce :: T.Expr -> ST s Expr
      ce = convert rc

instance Converter T.Stmt Stmt
  -- | TODO check if block stmt should become a scoped block (for temp gen)
                                                                            where
  convert :: forall s. RC.ResourceContext s -> T.Stmt -> ST s Stmt
  convert rc stmt =
    case stmt of
      T.BlockStmt stmts -> BlockStmt <$> mapM cs stmts
      T.SimpleStmt s -> SimpleStmt <$> css s
      T.If se s1 s2 ->
        wrap $ If <$> label <*> cse se <*> wrap (cs s1) <*> wrap (cs s2)
      T.Switch s e cases ->
        wrap $
        Switch <$> label <*> css s <*>
        maybe (return $ Lit $ T.BoolLit True) ce e <*>
        fmap catMaybes (mapM convertSwitchCase cases) <*>
        -- Note that we find a list of all defaults
        -- and only use the first one
        -- It is guaranteed in the weeding phase that we have at most one default,
        -- even if it isn't reflected structurally
        fmap
          (fromMaybe (SimpleStmt EmptyStmt) . listToMaybe . catMaybes)
          (mapM convertDefaultCase cases)
      T.For clause s ->
        wrap $ For <$> label <*> convertForClause clause <*> wrap (cs s)
      T.Break -> return Break
      T.Continue -> return Continue
        -- TODO ensure blockstmt doesn't end up adding scopes for this case
      T.Declare decl -> BlockStmt <$> convert rc decl
      T.Print exprs -> Print <$> mapM ce exprs
      T.Println exprs -> Println <$> mapM ce exprs
      T.Return e -> Return <$> maybe (return Nothing) (Just <$$> ce) e
    where
      label = RC.getLabel rc
      wrap = RC.wrap rc
      cse :: (T.SimpleStmt, T.Expr) -> ST s (SimpleStmt, Expr)
      cse (s, e) = (,) <$> css s <*> ce e
      css :: T.SimpleStmt -> ST s SimpleStmt
      css = convert rc
      cs :: T.Stmt -> ST s Stmt
      cs = convert rc
      ce :: T.Expr -> ST s Expr
      ce = convert rc
      convertForClause :: T.ForClause -> ST s ForClause
      convertForClause (T.ForClause pre e post) =
        ForClause <$> css pre <*> maybe (pure $ Lit $ T.BoolLit True) ce e <*>
        css post
      convertSwitchCase :: T.SwitchCase -> ST s (Maybe SwitchCase)
      convertSwitchCase (T.Case exprs s) =
        wrap $ Just <$$> Case <$> mapM ce exprs <*> wrap (cs s)
      convertSwitchCase _ = return Nothing
      convertDefaultCase :: T.SwitchCase -> ST s (Maybe Stmt)
      convertDefaultCase (T.Default s) = Just <$> wrap (cs s)
      convertDefaultCase _             = return Nothing
