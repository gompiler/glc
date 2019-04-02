{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE InstanceSigs          #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns        #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeSynonymInstances  #-}

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
  ) where

import           Base
import qualified CheckedData      as T
import           Control.Monad.ST
import qualified Cyclic           as C
import           Data.Maybe       (catMaybes, fromMaybe, listToMaybe)
import           Prelude          hiding (init)
import qualified ResourceContext  as RC
import           ResourceData

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
  = TopVar [VarDecl]
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
    RC.wrap rc $ do
      sig' <- convert rc sig
      RC.wrap rc $ do
        body' <- convert rc body
        return $ FuncDecl i sig' body'

instance Converter T.Signature Signature where
  convert rc (T.Signature params retType) =
    Signature <$> convert rc params <*>
    maybe (return Nothing) (Just <$$> convert rc) retType

instance Converter T.ParameterDecl ParameterDecl where
  convert rc (T.ParameterDecl i t) =
    ParameterDecl <$> RC.getVarIndex rc i <*> convert rc t

instance Converter T.Parameters Parameters where
  convert rc (T.Parameters params) = Parameters <$> mapM (convert rc) params

instance Converter T.Decl [VarDecl] where
  convert :: forall s. RC.ResourceContext s -> T.Decl -> ST s [VarDecl]
  convert rc decl =
    case decl of
      T.VarDecl decls -> mapM convertVarDecl decls
      T.TypeDef decls -> mapM_ convertTypeDecl decls $> []
    where
      convertVarDecl :: T.VarDecl' -> ST s VarDecl
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
      T.Unary t op e        -> Unary <$> ct t <*-> op <*> ce e
      T.Binary t op e1 e2   -> Binary <$> ct t <*-> op <*> ce e1 <*> ce e2
      T.Lit lit             -> return $ Lit lit
      T.Var t i             -> Var <$> ct t <*> RC.getVarIndex rc i
      T.AppendExpr t e1 e2  -> AppendExpr <$> ct t <*> ce e1 <*> ce e2
      T.LenExpr e           -> LenExpr <$> ce e
      T.CapExpr e           -> CapExpr <$> ce e
      T.Selector t e i      -> Selector <$> ct t <*> ce e <*-> i
      T.Index t e1 e2       -> Index <$> ct t <*> ce e1 <*> ce e2
      T.Arguments t e exprs -> Arguments <$> ct t <*> ce e <*> mapM ce exprs
    where
      ct :: T.CType -> ST s Type
      ct = convert rc
      ce :: T.Expr -> ST s Expr
      ce = convert rc

instance Converter T.SimpleStmt SimpleStmt where
  convert :: forall s. RC.ResourceContext s -> T.SimpleStmt -> ST s SimpleStmt
  convert rc stmt =
    case stmt of
      T.EmptyStmt          -> return EmptyStmt
      T.ExprStmt e         -> ExprStmt <$> ce e
      T.Increment e        -> Increment <$> ce e
      T.Decrement e        -> Decrement <$> ce e
      T.Assign op exprs    -> Assign op <$> mapM convertAssign exprs
      T.ShortDeclare decls -> ShortDeclare <$> mapM convertShortDecl decls
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
      T.If (s, e) s1 s2 ->
        wrap $ do
          s' <- css s
          e' <- ce e
          s1' <- wrap $ cs s1
          s2' <- wrap $ cs s2
          return $ If (s', e') s1' s2'
      T.Switch s e cases ->
        Switch <$> css s <*> maybe (return undefined) ce e <*>
        fmap catMaybes (mapM convertSwitchCase cases) <*>
        fmap -- TODO add bool as default
          (fromMaybe undefined . listToMaybe . catMaybes)
          (mapM convertDefaultCase cases)
      T.For clause s ->
        wrap $ do
          clause' <- convertForClause clause
          s' <- wrap $ cs s
          -- TODO add label tags?
          -- TODO check that clause scope is correct (post in same scope)
          return $ For clause' s'
      T.Break -> return Break
      T.Continue -> return Continue
        -- TODO ensure blockstmt doesn't end up adding scopes for this case
      T.Declare decl -> BlockStmt . fmap Declare <$> convert rc decl
      T.Print exprs -> Print <$> mapM ce exprs
      T.Println exprs -> Println <$> mapM ce exprs
      T.Return e -> Return <$> maybe (return Nothing) (Just <$$> ce) e
    where
      wrap = RC.wrap rc
      css :: T.SimpleStmt -> ST s SimpleStmt
      css = convert rc
      cs :: T.Stmt -> ST s Stmt
      cs = convert rc
      ce :: T.Expr -> ST s Expr
      ce = convert rc
      convertForClause :: T.ForClause -> ST s ForClause
      convertForClause (T.ForClause pre e post)
        -- TODO add constant bool for default
       = ForClause <$> css pre <*> maybe (pure undefined) ce e <*> css post
      convertSwitchCase :: T.SwitchCase -> ST s (Maybe SwitchCase)
      convertSwitchCase (T.Case exprs s) =
        wrap $ do
          exprs' <- mapM ce exprs
          s' <- wrap $ cs s
          return $ Just $ Case exprs' s'
      convertSwitchCase _ = return Nothing
      convertDefaultCase :: T.SwitchCase -> ST s (Maybe Stmt)
      convertDefaultCase (T.Default s) = Just <$> wrap (cs s)
      convertDefaultCase _             = return Nothing
