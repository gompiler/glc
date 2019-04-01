{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE InstanceSigs          #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module ResourceBuilder
  ( convertProgram
  ) where

--import           Base
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
--instance Converter T.Stmt Stmt where
--  convert :: forall s. RC.ResourceContext s -> T.Stmt -> ST s Stmt
--  convert rc stmt =
--    case stmt of
--      T.BlockStmt stmts -> BlockStmt <$> mapM cs stmts
--    where
--      cs :: T.Stmt -> ST s Stmt
--      cs = convert rc
--      ce :: T.Expr -> ST s Expr
--      ce = convert rc
