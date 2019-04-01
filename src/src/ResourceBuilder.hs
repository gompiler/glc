{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE InstanceSigs          #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module ResourceBuilder
  ( convertProgram
  ) where

import           Base
import qualified CheckedData      as T
import           Control.Monad    (liftM2, liftM3, liftM4)
import           Control.Monad.ST
import qualified Cyclic           as C
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
  convert = undefined

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
      T.Unary t op e        -> liftM3 Unary (ct t) (pure op) (ce e)
      T.Binary t op e1 e2   -> liftM4 Binary (ct t) (pure op) (ce e1) (ce e2)
      T.Lit lit             -> return $ Lit lit
      T.Var t i             -> liftM2 Var (ct t) (RC.getVarIndex rc i)
      T.AppendExpr t e1 e2  -> liftM3 AppendExpr (ct t) (ce e1) (ce e2)
      T.LenExpr e           -> LenExpr <$> ce e
      T.CapExpr e           -> CapExpr <$> ce e
      T.Selector t e i      -> liftM3 Selector (ct t) (ce e) (pure i)
      T.Index t e1 e2       -> liftM3 Index (ct t) (ce e1) (ce e2)
      T.Arguments t e exprs -> liftM3 Arguments (ct t) (ce e) (mapM ce exprs)
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
      convertAssign (e1, e2) = liftM2 (,) (ce e1) (ce e2)
      convertShortDecl :: (T.ScopedIdent, T.Expr) -> ST s (VarIndex, Expr)
      convertShortDecl (i, e) = liftM2 (,) (RC.getVarIndex rc i) (ce e)
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
      T.If (s, e) s1 s2 -> liftM3 If (liftM2 (,) (css s) (ce e)) (cs s1) (cs s2)
      T.Switch s e cases -> undefined
      T.For clause s -> undefined
        -- TODO add label tags?
      T.Break -> return Break
      T.Continue -> return Continue
        -- TODO ensure blockstmt doesn't end up adding scopes for this case
      T.Declare decl -> BlockStmt . fmap Declare <$> convert rc decl
      T.Print exprs -> Print <$> mapM ce exprs
      T.Println exprs -> Println <$> mapM ce exprs
      T.Return e -> Return <$> maybe (return Nothing) (Just <$$> ce) e
    where
      css :: T.SimpleStmt -> ST s SimpleStmt
      css = convert rc
      cs :: T.Stmt -> ST s Stmt
      cs = convert rc
      ce :: T.Expr -> ST s Expr
      ce = convert rc
      convertForClause :: T.ForClause -> ST s ForClause
      convertForClause (T.ForClause pre e post) =
        -- TODO add constant bool for default
        liftM3 ForClause (css pre) (maybe (pure undefined) ce e) (css post)

instance Converter T.Decl [VarDecl] where
  convert :: forall s. RC.ResourceContext s -> T.Decl -> ST s [VarDecl]
  convert rc decl =
    case decl of
      T.VarDecl decls -> mapM convertVarDecl decls
      T.TypeDef decls -> mapM_ convertTypeDecl decls $> []
    where
      convertVarDecl :: T.VarDecl' -> ST s VarDecl
      convertVarDecl (T.VarDecl' i t expr) =
        liftM3
          VarDecl
          (RC.getVarIndex rc i)
          (convert rc t)
          (maybe (return Nothing) (Just <$$> convert rc) expr)
      convertTypeDecl :: T.TypeDef' -> ST s ()
      convertTypeDecl _ = return ()
