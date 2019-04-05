{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module CheckedPrettify
  ( Prettify(..)
  ) where

import           Base               (Offset (..))
import           CheckedData
import qualified Cyclic             as C
import qualified Data               as D
import           Data.List          (intercalate)
import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NE (unzip)
import qualified Data.Maybe         as Maybe (mapMaybe)
import qualified Prettify           as P (Prettify (..))

o :: Offset
o = Offset 0

class Convert a b where
  convert :: a -> b

instance (Convert a1 a2, Convert b1 b2) => Convert (a1, b1) (a2, b2) where
  convert (a, b) = (convert a, convert b)

instance (Convert a b, Functor f) => Convert (f a) (f b) where
  convert = fmap convert

instance Convert Ident D.Identifier where
  convert (Ident vname) = D.Identifier o vname

instance Convert ScopedIdent D.Identifier where
  convert (ScopedIdent _ i) = convert i

-- | Scoped identifier to non empty idents with offsets
instance Convert ScopedIdent D.Identifiers where
  convert si = convert si :| []

instance Convert Program D.Program where
  convert (Program i tl) = D.Program (convert i) (convert tl)

instance Convert TopDecl D.TopDecl where
  convert (TopDecl d)      = D.TopDecl (convert d)
  convert (TopFuncDecl fd) = D.TopFuncDecl (convert fd)

instance Convert Decl D.Decl where
  convert (VarDecl vdl) = D.VarDecl (convert vdl)
  convert (TypeDef tdl) = D.TypeDef (Maybe.mapMaybe convert tdl)

instance Convert VarDecl' D.VarDecl' where
  convert (VarDecl' si t (Just e)) =
    D.VarDecl' (convert si) (Left (convert t, [convert e]))
  convert (VarDecl' si t Nothing) =
    D.VarDecl' (convert si) (Left (convert t, []))

instance Convert TypeDef' (Maybe D.TypeDef') where
  convert NoDef = Nothing

instance Convert FuncDecl D.FuncDecl where
  convert (FuncDecl si sig fb) =
    D.FuncDecl (convert si) (convert sig) (convert fb)

instance Convert ParameterDecl D.ParameterDecl where
  convert (ParameterDecl si t) = D.ParameterDecl (convert si) (convert t)

instance Convert Parameters D.Parameters where
  convert (Parameters pdl) = D.Parameters (convert pdl)

instance Convert Signature D.Signature where
  convert (Signature params t) = D.Signature (convert params) (convert t)

instance Convert SimpleStmt D.SimpleStmt where
  convert EmptyStmt = D.EmptyStmt
  convert (ExprStmt e) = D.ExprStmt (convert e)
  convert (VoidExprStmt (Ident vname) el) =
    D.ExprStmt (D.Arguments o (D.Var $ D.Identifier o vname) (convert el))
  convert (Increment e) = D.Increment o (convert e)
  convert (Decrement e) = D.Decrement o (convert e)
  convert (Assign op eltup) =
    uncurry (D.Assign o (convert op)) (convert $ NE.unzip eltup)
  convert (ShortDeclare ideltup) =
    uncurry D.ShortDeclare (convert $ NE.unzip ideltup)

instance Convert Stmt D.Stmt where
  convert (BlockStmt sl) = D.BlockStmt (convert sl)
  convert (SimpleStmt ss) = D.SimpleStmt (convert ss)
  convert (If (ss, e) s1 s2) =
    D.If (convert ss, convert e) (convert s1) (convert s2)
  convert (Switch ss e scl) = D.Switch (convert ss) (convert e) (convert scl)
  convert (For fcl s) = D.For (convert fcl) (convert s)
  convert Break = D.Break o
  convert Continue = D.Continue o
  convert (Declare d) = D.Declare (convert d)
  convert (Print el) = D.Print (convert el)
  convert (Println el) = D.Println (convert el)
  convert (Return e) = D.Return o (convert e)

instance Convert SwitchCase D.SwitchCase where
  convert (Case nle s) = D.Case o (convert nle) (convert s)
  convert (Default s)  = D.Default o (convert s)

instance Convert ForClause D.ForClause where
  convert (ForClause pre e post) =
    D.ForClause (convert pre) (convert e) (convert post)

instance Convert Expr D.Expr where
  convert (Unary _ op e) = D.Unary o (convert op) (convert e)
  convert (Binary _ op e1 e2) =
    D.Binary o (convert op) (convert e1) (convert e2)
  convert (Lit lit) = either D.Lit id (convert lit)
  convert (Var _ si) = D.Var (convert si)
  convert (AppendExpr _ e1 e2) = D.AppendExpr o (convert e1) (convert e2)
  convert (LenExpr e) = D.LenExpr o (convert e)
  convert (CapExpr e) = D.CapExpr o (convert e)
  convert (Selector _ _ e (Ident vname)) =
    D.Selector o (convert e) (D.Identifier o vname)
  convert (Index _ e1 e2) = D.Index o (convert e1) (convert e2)
  convert (Arguments _ (Ident vname) el) =
    D.Arguments o (D.Var (D.Identifier o vname)) (convert el)

instance Convert Literal (Either D.Literal D.Expr) where
  convert (IntLit i) = Left $ D.IntLit o D.Decimal (show i)
  convert (FloatLit f) = Left $ D.FloatLit o (show f)
  convert (RuneLit c) = Left $ D.RuneLit o (show c)
  convert (StringLit s) = Left $ D.StringLit o D.Interpreted $ "\"" ++ s ++ "\""
  convert (BoolLit True) = Right $ D.Var (D.Identifier o "true")
  convert (BoolLit False) = Right $ D.Var (D.Identifier o "false")

instance Convert BinaryOp D.BinaryOp where
  convert op =
    case op of
      Or             -> D.Or
      And            -> D.And
      Arithm aop     -> D.Arithm (convert aop)
      CheckedData.EQ -> D.EQ
      NEQ            -> D.NEQ
      CheckedData.LT -> D.LT
      LEQ            -> D.LEQ
      CheckedData.GT -> D.GT
      GEQ            -> D.GEQ

instance Convert ArithmOp D.ArithmOp where
  convert op =
    case op of
      Add       -> D.Add
      Subtract  -> D.Subtract
      BitOr     -> D.BitOr
      BitXor    -> D.BitXor
      Multiply  -> D.Multiply
      Divide    -> D.Divide
      Remainder -> D.Remainder
      ShiftL    -> D.ShiftL
      ShiftR    -> D.ShiftR
      BitAnd    -> D.BitAnd
      BitClear  -> D.BitClear

instance Convert UnaryOp D.UnaryOp where
  convert op =
    case op of
      Pos           -> D.Pos
      Neg           -> D.Neg
      Not           -> D.Not
      BitComplement -> D.BitComplement

instance Convert AssignOp D.AssignOp where
  convert (AssignOp op) = D.AssignOp (convert op)

instance Convert CType D.Type where
  convert = convert . C.get

instance Convert CType D.Type' where
  convert t = (o, convert t)

instance Convert Type D.Type' where
  convert t = (o, convert t)

instance Convert Type D.Type where
  convert (ArrayType i t) =
    D.ArrayType (D.Lit (D.IntLit o D.Decimal (show i))) (convert t)
  convert (SliceType t) = D.SliceType (convert t)
  convert (StructType fdl) = D.StructType (convert fdl)
  convert PInt = D.Type (D.Identifier o "int")
  convert PFloat64 = D.Type (D.Identifier o "float64")
  convert PBool = D.Type (D.Identifier o "bool")
  convert PRune = D.Type (D.Identifier o "rune")
  convert PString = D.Type (D.Identifier o "string")
  convert Cycle = D.Type (D.Identifier o "cycle")
  convert (TypeMap t) = convert t -- TODO verify

instance Convert FieldDecl D.FieldDecl where
  convert (FieldDecl i t) = D.FieldDecl (convert i :| []) (convert t)

-- This is a new class because if we declare an instance of prettify here
-- we will get an orphan instance warning
class Prettify a where
  prettify :: a -> String
  prettify = intercalate "\n" . prettify'
  prettify' :: a -> [String]

instance Prettify Program where
  prettify' p = P.prettify' (convert p :: D.Program)
