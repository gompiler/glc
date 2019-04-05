{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns        #-}

module ResourcePrettify
  ( Prettify(..)
  ) where

import qualified CheckedData        as T
import qualified CheckedPrettify    as P (Prettify (..))
import qualified Cyclic             as C
import           Data.List          (intercalate)
import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NE (map)
import           Prelude            hiding (init)
import           ResourceData

class ConvertAST a b where
  toOrig :: a -> b

instance (ConvertAST a1 a2, ConvertAST b1 b2) =>
         ConvertAST (a1, b1) (a2, b2) where
  toOrig (a, b) = (toOrig a, toOrig b)

instance (ConvertAST a b) => ConvertAST (NonEmpty a) (NonEmpty b) where
  toOrig = NE.map toOrig

instance (ConvertAST a b) => ConvertAST [a] [b] where
  toOrig = map toOrig

instance ConvertAST VarIndex T.ScopedIdent where
  toOrig (VarIndex i) = T.ScopedIdent (T.Scope 0) (T.Ident $ "var" ++ show i)

instance ConvertAST T.Ident T.ScopedIdent where
  toOrig = T.ScopedIdent (T.Scope 0)

instance ConvertAST Program T.Program where
  toOrig Program {package, structs, topVars, functions} =
    T.Program {T.package = package, T.topLevels = topLevels}
    -- TODO save init
    where
      topLevels =
        toOrig structs ++ toOrig topVars ++ map T.TopFuncDecl (toOrig functions)

instance ConvertAST StructType T.TopDecl where
  toOrig (Struct _ _) = T.TopDecl $ T.TypeDef []

instance ConvertAST TopVarDecl T.TopDecl where
  toOrig (TopVarDecl i t e) =
    T.TopDecl $ T.VarDecl [T.VarDecl' (toOrig i) (toOrig t) (toOrig <$> e)]

instance ConvertAST FuncDecl T.FuncDecl where
  toOrig (FuncDecl i sig fb) = T.FuncDecl (toOrig i) (toOrig sig) (toOrig fb)

instance ConvertAST ParameterDecl T.ParameterDecl where
  toOrig (ParameterDecl si t) = T.ParameterDecl (toOrig si) (toOrig t)

instance ConvertAST Parameters T.Parameters where
  toOrig (Parameters pdl) = T.Parameters (toOrig pdl)

instance ConvertAST Signature T.Signature where
  toOrig (Signature params (Just t)) =
    T.Signature (toOrig params) (Just (toOrig t))
  toOrig (Signature params Nothing) = T.Signature (toOrig params) Nothing

instance ConvertAST SimpleStmt T.SimpleStmt where
  toOrig EmptyStmt              = T.EmptyStmt
  toOrig (ExprStmt e)           = T.ExprStmt $ toOrig e
  toOrig (VoidExprStmt i exprs) = T.VoidExprStmt i $ toOrig exprs
  toOrig (Increment e)          = T.Increment $ toOrig e
  toOrig (Decrement e)          = T.Decrement $ toOrig e
  toOrig (Assign op eltup)      = T.Assign op (toOrig eltup)
  toOrig (ShortDeclare ideltup) = T.ShortDeclare (toOrig ideltup)

instance ConvertAST Stmt T.Stmt where
  toOrig (BlockStmt sl) = T.BlockStmt (toOrig sl)
  toOrig (SimpleStmt ss) = T.SimpleStmt (toOrig ss)
  toOrig (If (ss, e) s1 s2) = T.If (toOrig ss, toOrig e) (toOrig s1) (toOrig s2)
  toOrig (Switch ss e scl d) =
    T.Switch
      (toOrig ss)
      (Just (toOrig e))
      (toOrig scl ++ [T.Default $ toOrig d])
  toOrig (For fcl s) = T.For (toOrig fcl) (toOrig s)
  toOrig Break = T.Break
  toOrig Continue = T.Continue
  toOrig (VarDecl i t e) =
    T.Declare $ T.VarDecl [T.VarDecl' (toOrig i) (toOrig t) (toOrig <$> e)]
  toOrig (Print el) = T.Print (toOrig el)
  toOrig (Println el) = T.Println (toOrig el)
  toOrig (Return e) = T.Return (toOrig <$> e)

instance ConvertAST SwitchCase T.SwitchCase where
  toOrig (Case nle s) = T.Case (toOrig nle) (toOrig s)

instance ConvertAST ForClause T.ForClause where
  toOrig (ForClause pre cond post) =
    T.ForClause (toOrig pre) (Just (toOrig cond)) (toOrig post)

instance ConvertAST Expr T.Expr where
  toOrig (Unary t op e) = T.Unary (toOrig t) op (toOrig e)
  toOrig (Binary t op e1 e2) = T.Binary (toOrig t) op (toOrig e1) (toOrig e2)
  toOrig (Lit lit) = T.Lit lit
  toOrig (Var t i) = T.Var (toOrig t) (toOrig i)
  toOrig (AppendExpr t e1 e2) = T.AppendExpr (toOrig t) (toOrig e1) (toOrig e2)
  toOrig (LenExpr e) = T.LenExpr (toOrig e)
  toOrig (CapExpr e) = T.CapExpr (toOrig e)
  toOrig (Selector t e i) = T.Selector (toOrig t) [] (toOrig e) i
  toOrig (Index t e1 e2) = T.Index (toOrig t) (toOrig e1) (toOrig e2)
  toOrig (Arguments t i exprs) = T.Arguments (toOrig t) i (toOrig exprs)

instance ConvertAST Type T.CType where
  toOrig = C.new . toOrig

instance ConvertAST Type T.Type where
  toOrig (ArrayType i t) = T.ArrayType i (toOrig t)
  toOrig (SliceType t)   = T.SliceType (toOrig t)
  toOrig (StructType _)  = T.StructType []
  toOrig PInt            = T.PInt
  toOrig PFloat64        = T.PFloat64
  toOrig PBool           = T.PBool
  toOrig PRune           = T.PRune
  toOrig PString         = T.PString

instance ConvertAST FieldDecl T.FieldDecl where
  toOrig (FieldDecl i t) = T.FieldDecl i (toOrig t)

-- This is a new class because if we declare an instance of prettify here
-- we will get an orphan instance warning
class Prettify a where
  prettify :: a -> String
  prettify = intercalate "\n" . prettify'
  prettify' :: a -> [String]

instance Prettify Program where
  prettify' p = P.prettify' (toOrig p :: T.Program)
