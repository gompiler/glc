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
import qualified Data.List.NonEmpty as NE (map, unzip)
import qualified Data.Maybe         as Maybe (mapMaybe)
import qualified Prettify           as P (Prettify (..))

class ConvertAST a b where
  toOrig :: a -> b

o :: Offset
o = Offset 0

-- | Scoped identifier to identifier with offset
si2ident :: ScopedIdent -> D.Identifier
si2ident (ScopedIdent _ (Ident vname)) = D.Identifier o vname

-- | Scoped identifier to non empty idents with offsets
si2idents :: ScopedIdent -> D.Identifiers
si2idents si = si2ident si :| []

instance ConvertAST Program D.Program where
  toOrig (Program (Ident vname) tl) =
    D.Program (D.Identifier o vname) (map toOrig tl)

instance ConvertAST TopDecl D.TopDecl where
  toOrig (TopDecl d)      = D.TopDecl (toOrig d)
  toOrig (TopFuncDecl fd) = D.TopFuncDecl (toOrig fd)

instance ConvertAST Decl D.Decl where
  toOrig (VarDecl vdl) = D.VarDecl (map toOrig vdl)
  toOrig (TypeDef tdl) = D.TypeDef (Maybe.mapMaybe toOrig tdl)

instance ConvertAST VarDecl' D.VarDecl' where
  toOrig (VarDecl' si t (Just e)) =
    D.VarDecl' (si2idents si) (Left (toOrig t, [toOrig e]))
  toOrig (VarDecl' si t Nothing) =
    D.VarDecl' (si2idents si) (Left (toOrig t, []))

instance ConvertAST TypeDef' (Maybe D.TypeDef') where
  toOrig NoDef = Nothing

instance ConvertAST FuncDecl D.FuncDecl where
  toOrig (FuncDecl si sig fb) =
    D.FuncDecl (si2ident si) (toOrig sig) (toOrig fb)

instance ConvertAST ParameterDecl D.ParameterDecl where
  toOrig (ParameterDecl si t) = D.ParameterDecl (si2idents si) (toOrig t)

instance ConvertAST Parameters D.Parameters where
  toOrig (Parameters pdl) = D.Parameters (map toOrig pdl)

instance ConvertAST Signature D.Signature where
  toOrig (Signature params (Just t)) =
    D.Signature (toOrig params) (Just (toOrig t))
  toOrig (Signature params Nothing) = D.Signature (toOrig params) Nothing

instance ConvertAST SimpleStmt D.SimpleStmt where
  toOrig EmptyStmt = D.EmptyStmt
  toOrig (ExprStmt e) = D.ExprStmt (toOrig e)
  toOrig (VoidExprStmt (Ident vname) el) =
    D.ExprStmt (D.Arguments o (D.Var $ D.Identifier o vname) (map toOrig el))
  toOrig (Increment e) = D.Increment o (toOrig e)
  toOrig (Decrement e) = D.Decrement o (toOrig e)
  toOrig (Assign op eltup) =
    let (nel1, nel2) = NE.unzip eltup
     in D.Assign o (toOrig op) (NE.map toOrig nel1) (NE.map toOrig nel2)
  toOrig (ShortDeclare ideltup) =
    let (nsil, nel) = NE.unzip ideltup
     in D.ShortDeclare (NE.map si2ident nsil) (NE.map toOrig nel)

instance ConvertAST Stmt D.Stmt where
  toOrig (BlockStmt sl) = D.BlockStmt (map toOrig sl)
  toOrig (SimpleStmt ss) = D.SimpleStmt (toOrig ss)
  toOrig (If (ss, e) s1 s2) = D.If (toOrig ss, toOrig e) (toOrig s1) (toOrig s2)
  toOrig (Switch ss (Just e) scl) =
    D.Switch (toOrig ss) (Just (toOrig e)) (map toOrig scl)
  toOrig (Switch ss Nothing scl) = D.Switch (toOrig ss) Nothing (map toOrig scl)
  toOrig (For fcl s) = D.For (toOrig fcl) (toOrig s)
  toOrig Break = D.Break o
  toOrig Continue = D.Continue o
  toOrig (Declare d) = D.Declare (toOrig d)
  toOrig (Print el) = D.Print (map toOrig el)
  toOrig (Println el) = D.Println (map toOrig el)
  toOrig (Return (Just e)) = D.Return o (Just (toOrig e))
  toOrig (Return Nothing) = D.Return o Nothing

instance ConvertAST SwitchCase D.SwitchCase where
  toOrig (Case nle s) = D.Case o (NE.map toOrig nle) (toOrig s)
  toOrig (Default s)  = D.Default o (toOrig s)

instance ConvertAST ForClause D.ForClause where
  toOrig (ForClause ss1 (Just e) ss2) =
    D.ForClause (toOrig ss1) (Just (toOrig e)) (toOrig ss2)
  toOrig (ForClause ss1 Nothing ss2) =
    D.ForClause (toOrig ss1) Nothing (toOrig ss2)

instance ConvertAST Expr D.Expr where
  toOrig (Unary _ op e) = D.Unary o (toOrig op) (toOrig e)
  toOrig (Binary _ op e1 e2) = D.Binary o (toOrig op) (toOrig e1) (toOrig e2)
  toOrig (Lit lit) = either D.Lit id (toOrig lit)
  toOrig (Var _ si) = D.Var (si2ident si)
  toOrig (AppendExpr _ e1 e2) = D.AppendExpr o (toOrig e1) (toOrig e2)
  toOrig (LenExpr e) = D.LenExpr o (toOrig e)
  toOrig (CapExpr e) = D.CapExpr o (toOrig e)
  toOrig (Selector _ e (Ident vname)) =
    D.Selector o (toOrig e) (D.Identifier o vname)
  toOrig (Index _ e1 e2) = D.Index o (toOrig e1) (toOrig e2)
  toOrig (Arguments _ (Ident vname) el) =
    D.Arguments o (D.Var (D.Identifier o vname)) (map toOrig el)

instance ConvertAST Literal (Either D.Literal D.Expr) where
  toOrig (IntLit i)      = Left $ D.IntLit o D.Decimal (show i)
  toOrig (FloatLit f)    = Left $ D.FloatLit o (show f)
  toOrig (RuneLit c)     = Left $ D.RuneLit o (show c)
  toOrig (StringLit s)   = Left $ D.StringLit o D.Interpreted s
  toOrig (BoolLit True)  = Right $ D.Var (D.Identifier o "true")
  toOrig (BoolLit False) = Right $ D.Var (D.Identifier o "false")

instance ConvertAST BinaryOp D.BinaryOp where
  toOrig op =
    case op of
      Or             -> D.Or
      And            -> D.And
      Arithm aop     -> D.Arithm (toOrig aop)
      CheckedData.EQ -> D.EQ
      NEQ            -> D.NEQ
      CheckedData.LT -> D.LT
      LEQ            -> D.LEQ
      CheckedData.GT -> D.GT
      GEQ            -> D.GEQ

instance ConvertAST ArithmOp D.ArithmOp where
  toOrig op =
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

instance ConvertAST UnaryOp D.UnaryOp where
  toOrig op =
    case op of
      Pos           -> D.Pos
      Neg           -> D.Neg
      Not           -> D.Not
      BitComplement -> D.BitComplement

instance ConvertAST AssignOp D.AssignOp where
  toOrig (AssignOp (Just op)) = D.AssignOp (Just (toOrig op))
  toOrig (AssignOp Nothing)   = D.AssignOp Nothing

instance ConvertAST CType D.Type where
  toOrig = toOrig . C.get

instance ConvertAST CType D.Type' where
  toOrig t = (o, toOrig t)

instance ConvertAST Type D.Type' where
  toOrig t = (o, toOrig t)

instance ConvertAST Type D.Type where
  toOrig (ArrayType i t) =
    D.ArrayType (D.Lit (D.IntLit o D.Decimal (show i))) (toOrig t)
  toOrig (SliceType t) = D.SliceType (toOrig t)
  toOrig (StructType fdl) = D.StructType (map toOrig fdl)
  toOrig PInt = D.Type (D.Identifier o "int")
  toOrig PFloat64 = D.Type (D.Identifier o "float64")
  toOrig PBool = D.Type (D.Identifier o "bool")
  toOrig PRune = D.Type (D.Identifier o "rune")
  toOrig PString = D.Type (D.Identifier o "string")
  toOrig Cycle = D.Type (D.Identifier o "cycle")
  toOrig (TypeMap t) = toOrig t -- TODO verify

instance ConvertAST FieldDecl D.FieldDecl where
  toOrig (FieldDecl (Ident vname) t) =
    D.FieldDecl (D.Identifier o vname :| []) (toOrig t)

-- This is a new class because if we declare an instance of prettify here
-- we will get an orphan instance warning
class Prettify a where
  prettify :: a -> String
  prettify = intercalate "\n" . prettify'
  prettify' :: a -> [String]

instance Prettify Program where
  prettify' p = P.prettify' (toOrig p :: D.Program)
