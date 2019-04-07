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
import qualified CheckedData        as T
import           Control.Monad.ST
import qualified Cyclic             as C
import           Data.List.NonEmpty (NonEmpty (..))
import           Data.Maybe         (catMaybes, fromMaybe, listToMaybe)
import           Prelude            hiding (init)
import qualified ResourceContext    as RC
import           ResourceData
import           SymbolTable        (typecheckGen)

resourceGen :: String -> Glc Program
resourceGen p = convertProgram <$> typecheckGen p

convertProgram :: T.Program -> Program
convertProgram p =
  runST $ do
    rc <- RC.new
    convert rc p
      -- Add a main function if one is not declared

class Converter a b where
  convert :: forall s. RC.ResourceContext s -> a -> ST s b

instance Converter T.Program Program where
  convert rc T.Program {T.package, T.topLevels} = do
    topLevels' <- mapM (convert rc) topLevels
    structs <- RC.allStructs rc
    let vars = [v | TVar v <- topLevels']
    let inits = [(body, limit) | TInit body limit <- topLevels']
    let mains = [(body, limit) | TMain body limit <- topLevels']
    let funcs = [f | TFunc f <- topLevels']
    let initFuncs = renameInits inits
    return $
      Program
        { package = package
        , structs = structs
        , topVars = concat vars
        , init = createInit $ map funcName initFuncs
        , main = createMain mains
        -- Functions contain the list of inits (renamed), and the list of functions, excluding main
        , functions = initFuncs ++ funcs
        }
    where
      funcName :: FuncDecl -> T.Ident
      funcName (FuncDecl i _ _ _) = i
      -- | From previous AST's, we have at most one main function
      -- We therefore return it if it exists, and default to a blank main func
      createMain :: [(Stmt, LocalLimit)] -> MainDecl
      createMain mains =
        uncurry MainDecl $
        fromMaybe (Return Nothing, LocalLimit 0) (listToMaybe mains)
      -- | Given collection of init identifiers,
      -- Create an init declaration that calls each function in the provided order
      createInit :: [T.Ident] -> InitDecl
      createInit funcs =
        InitDecl
          (BlockStmt $ map (\i -> SimpleStmt $ VoidExprStmt i []) funcs)
          (LocalLimit 0)
      -- | Given init contents, convert to function
      renameInits :: [(Stmt, LocalLimit)] -> [FuncDecl]
      renameInits = zipWith createInitFunc (map initIdent [0 ..])
      createInitFunc :: T.Ident -> (Stmt, LocalLimit) -> FuncDecl
      createInitFunc i (body, limit) =
        FuncDecl i (Signature (Parameters []) Nothing) body limit
      initIdent :: Int -> T.Ident
      initIdent i = T.Ident $ "__glc$init__" ++ show i

data TopLevel
  = TVar [TopVarDecl]
  | TFunc FuncDecl
  | TInit Stmt
          LocalLimit
  | TMain Stmt
          LocalLimit

instance Converter T.TopDecl TopLevel where
  convert rc topDecl =
    case topDecl of
      T.TopDecl decl     -> TVar <$> convert rc decl
      T.TopFuncDecl decl -> funcDecl <$> convert rc decl
    where
      funcDecl :: FuncDecl -> TopLevel
      funcDecl d@(FuncDecl (T.Ident ident) (Signature (Parameters []) Nothing) body limit) =
        case ident of
          "init" -> TInit body limit
          "main" -> TMain body limit
          _      -> TFunc d
      funcDecl d = TFunc d

instance Converter T.FuncDecl FuncDecl where
  convert rc (T.FuncDecl (T.ScopedIdent _ i) sig body) =
    wrap $
    injectRet <$-> i <*> convert rc sig <*> wrap (convert rc body) <*>
    RC.localLimit rc
    where
      wrap = RC.wrap rc
      -- Inject return as last statement if function is void
      -- ensure no falloff in generated bytecode
      injectRet :: Ident -> Signature -> Stmt -> LocalLimit -> FuncDecl
      injectRet ident sig'@(Signature _ rt) body'@(BlockStmt sl) limit =
        FuncDecl
          ident
          sig'
          (case rt of
             Just _  -> body'
             Nothing -> BlockStmt $ sl ++ [Return Nothing])
          limit
      injectRet ident sig' sl' limit = FuncDecl ident sig' sl' limit

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
         in StructType <$> (RC.structName rc =<< mapM (convert rc) cfields)
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
        Binary <$> RC.newLabel rc <*> ct t <*-> op <*> ce e1 <*> ce e2
      T.Lit lit -> return $ Lit lit
      -- Global vars are accessed by field names vs indices
      T.Var t (T.ScopedIdent (T.Scope 2) i) -> TopVar <$> ct t <*-> i
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
      T.Increment e         -> inc2assn <$> ce e
      T.Decrement e         -> dec2assn <$> ce e
      T.Assign op exprs     -> Assign op <$> mapM convertAssign exprs
      T.ShortDeclare decls  -> ShortDeclare <$> mapM convertShortDecl decls
    where
      convertAssign :: (T.Expr, T.Expr) -> ST s (Expr, Expr)
      convertAssign (e1, e2) = (,) <$> ce e1 <*> ce e2
      convertShortDecl :: (T.ScopedIdent, T.Expr) -> ST s (VarIndex, Expr)
      convertShortDecl (i, e) = (,) <$> RC.getVarIndex rc i <*> ce e
      ce :: T.Expr -> ST s Expr
      ce = convert rc
      inc2assn :: Expr -> SimpleStmt
      inc2assn e =
        Assign (T.AssignOp $ Just T.Add) ((e, Lit $ T.IntLit 1) :| [])
      dec2assn :: Expr -> SimpleStmt
      dec2assn e =
        Assign (T.AssignOp $ Just T.Subtract) ((e, Lit $ T.IntLit 1) :| [])

instance Converter T.Stmt Stmt
  -- | TODO check if block stmt should become a scoped block (for temp gen)
                                                                            where
  convert :: forall s. RC.ResourceContext s -> T.Stmt -> ST s Stmt
  convert rc stmt =
    case stmt of
      T.BlockStmt stmts -> BlockStmt <$> mapM cs stmts
      T.SimpleStmt s -> SimpleStmt <$> css s
      T.If se s1 s2 ->
        wrap $
        If <$> RC.newLabel rc <*> cse se <*> wrap (cs s1) <*> wrap (cs s2)
      T.Switch s e cases ->
        wrap $
        Switch <$> RC.newLabel rc <*> css s <*>
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
        wrap $
        For <$> RC.newLoopLabel rc <*> convertForClause clause <*> wrap (cs s)
      T.Break -> Break <$> RC.currentLoopLabel rc
      T.Continue -> Continue <$> RC.currentLoopLabel rc
        -- TODO ensure blockstmt doesn't end up adding scopes for this case
      T.Declare decl -> BlockStmt <$> convert rc decl
      T.Print exprs -> Print <$> mapM ce exprs
      T.Println exprs -> Println <$> mapM ce exprs
      T.Return e -> Return <$> maybe (return Nothing) (Just <$$> ce) e
    where
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
