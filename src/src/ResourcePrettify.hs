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

class Convert a b where
  convert :: a -> b

instance (Convert a1 a2, Convert b1 b2) =>
         Convert (a1, b1) (a2, b2) where
  convert (a, b) = (convert a, convert b)

instance (Convert a b) => Convert (NonEmpty a) (NonEmpty b) where
  convert = NE.map convert

instance (Convert a b) => Convert [a] [b] where
  convert = map convert

instance Convert VarIndex T.ScopedIdent where
  convert (VarIndex i) = T.ScopedIdent (T.Scope 0) (T.Ident $ "var" ++ show i)

instance Convert T.Ident T.ScopedIdent where
  convert = T.ScopedIdent (T.Scope 0)

instance Convert Program T.Program where
  convert Program {package, structs, topVars, functions} =
    T.Program {T.package = package, T.topLevels = topLevels}
    -- TODO save init
    where
      topLevels =
        convert structs ++ convert topVars ++ map T.TopFuncDecl (convert functions)

instance Convert StructType T.TopDecl where
  convert (Struct _ _) = T.TopDecl $ T.TypeDef []

instance Convert TopVarDecl T.TopDecl where
  convert (TopVarDecl i t e) =
    T.TopDecl $ T.VarDecl [T.VarDecl' (convert i) (convert t) (convert <$> e)]

instance Convert FuncDecl T.FuncDecl where
  convert (FuncDecl i sig fb) = T.FuncDecl (convert i) (convert sig) (convert fb)

instance Convert ParameterDecl T.ParameterDecl where
  convert (ParameterDecl si t) = T.ParameterDecl (convert si) (convert t)

instance Convert Parameters T.Parameters where
  convert (Parameters pdl) = T.Parameters (convert pdl)

instance Convert Signature T.Signature where
  convert (Signature params (Just t)) =
    T.Signature (convert params) (Just (convert t))
  convert (Signature params Nothing) = T.Signature (convert params) Nothing

instance Convert SimpleStmt T.SimpleStmt where
  convert EmptyStmt              = T.EmptyStmt
  convert (ExprStmt e)           = T.ExprStmt $ convert e
  convert (VoidExprStmt i exprs) = T.VoidExprStmt i $ convert exprs
  convert (Increment e)          = T.Increment $ convert e
  convert (Decrement e)          = T.Decrement $ convert e
  convert (Assign op eltup)      = T.Assign op (convert eltup)
  convert (ShortDeclare ideltup) = T.ShortDeclare (convert ideltup)

instance Convert Stmt T.Stmt where
  convert (BlockStmt sl) = T.BlockStmt (convert sl)
  convert (SimpleStmt ss) = T.SimpleStmt (convert ss)
  convert (If (ss, e) s1 s2) = T.If (convert ss, convert e) (convert s1) (convert s2)
  convert (Switch ss e scl d) =
    T.Switch
      (convert ss)
      (Just (convert e))
      (convert scl ++ [T.Default $ convert d])
  convert (For fcl s) = T.For (convert fcl) (convert s)
  convert Break = T.Break
  convert Continue = T.Continue
  convert (VarDecl i t e) =
    T.Declare $ T.VarDecl [T.VarDecl' (convert i) (convert t) (convert <$> e)]
  convert (Print el) = T.Print (convert el)
  convert (Println el) = T.Println (convert el)
  convert (Return e) = T.Return (convert <$> e)

instance Convert SwitchCase T.SwitchCase where
  convert (Case nle s) = T.Case (convert nle) (convert s)

instance Convert ForClause T.ForClause where
  convert (ForClause pre cond post) =
    T.ForClause (convert pre) (Just (convert cond)) (convert post)

instance Convert Expr T.Expr where
  convert (Unary t op e) = T.Unary (convert t) op (convert e)
  convert (Binary t op e1 e2) = T.Binary (convert t) op (convert e1) (convert e2)
  convert (Lit lit) = T.Lit lit
  convert (Var t i) = T.Var (convert t) (convert i)
  convert (AppendExpr t e1 e2) = T.AppendExpr (convert t) (convert e1) (convert e2)
  convert (LenExpr e) = T.LenExpr (convert e)
  convert (CapExpr e) = T.CapExpr (convert e)
  convert (Selector t e i) = T.Selector (convert t) [] (convert e) i
  convert (Index t e1 e2) = T.Index (convert t) (convert e1) (convert e2)
  convert (Arguments t i exprs) = T.Arguments (convert t) i (convert exprs)

instance Convert Type T.CType where
  convert = C.new . convert

instance Convert Type T.Type where
  convert (ArrayType i t) = T.ArrayType i (convert t)
  convert (SliceType t)   = T.SliceType (convert t)
  convert (StructType _)  = T.StructType []
  convert PInt            = T.PInt
  convert PFloat64        = T.PFloat64
  convert PBool           = T.PBool
  convert PRune           = T.PRune
  convert PString         = T.PString

instance Convert FieldDecl T.FieldDecl where
  convert (FieldDecl i t) = T.FieldDecl i (convert t)

-- This is a new class because if we declare an instance of prettify here
-- we will get an orphan instance warning
class Prettify a where
  prettify :: a -> String
  prettify = intercalate "\n" . prettify'
  prettify' :: a -> [String]

instance Prettify Program where
  prettify' p = P.prettify' (convert p :: T.Program)
