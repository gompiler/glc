{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module CheckedData
  ( ArithmOp(..)
  , AssignOp(..)
  , BinaryOp(..)
  , CType
  , Decl(..)
  , Expr(..)
  , FieldDecl(..)
  , ForClause(..)
  , FuncDecl(..)
  , Ident(..)
  , Literal(..)
  , ParameterDecl(..)
  , Parameters(..)
  , Program(..)
  , Scope(..)
  , ScopedIdent(..)
  , Signature(..)
  , SimpleStmt(..)
  , Stmt(..)
  , SwitchCase(..)
  , TopDecl(..)
  , Type(..)
  , TypeDef'(..)
  , UnaryOp(..)
  , VarDecl'(..)
  ) where

import           Base
import           Converter
import qualified Cyclic             as C
import           Data               (ArithmOp (..), AssignOp (..),
                                     BinaryOp (..), UnaryOp (..))
import qualified Data               as T
import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NE (unzip)
import qualified Data.Maybe         as Maybe (mapMaybe)
import           Prettify

data ScopedIdent =
  ScopedIdent Scope
              Ident
  deriving (Show, Eq)

newtype Ident =
  Ident String
  deriving (Show, Eq)

newtype Scope =
  Scope Int
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Source_file_organization
-- Imports not supported in golite
data Program = Program
  { package   :: Ident
  , topLevels :: [TopDecl]
  } deriving (Show, Eq)

----------------------------------------------------------------------
-- Declarations
-- | See https://golang.org/ref/spec#TopLevelDecl
data TopDecl
  = TopDecl Decl
  | TopFuncDecl FuncDecl
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Declaration
-- Golite does not support type alias
data Decl
  -- | See https://golang.org/ref/spec#VarDecl
  -- If only one entry exists, it is treated as a single line declaration
  -- Otherwise, it is treated as var ( ... )
  = VarDecl [VarDecl']
  | TypeDef [TypeDef']
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#VarDecl
-- Note that a proper declaration can be mapped to pairs of ids and expressions
-- The inferred type here is a valid type after we check that
-- the expression type matches the declared type, if any.
-- This is necessary for cases like var a float = 5,
-- where the expression type is not necessarily the same as the declared one
data VarDecl' =
  VarDecl' ScopedIdent
           CType
           (Maybe Expr) -- Can declare a variable without an expression
  deriving (Show, Eq)

-- | Placeholder, no typedefs
-- This is here since generating this new AST at typecheck is a one to one map
data TypeDef' =
  NoDef
  deriving (Show, Eq)

----------------------------------------------------------------------
-- | See https://golang.org/ref/spec#Function_declarations
-- Eg func f(a int, b int, c string, d int)
-- Eg func f(a, b int, c string) string
-- Not supported:
-- * Arbitrary return value count
-- * Named return values
-- * Optional body
-- * Unnamed input parameters
-- * Variadic parameters
data FuncDecl =
  FuncDecl ScopedIdent
           Signature
           FuncBody
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#ParameterDecl
-- Func components
-- Golite does not support unnamed parameters
-- At this stage, we can map each individual identifier to its expected type
data ParameterDecl =
  ParameterDecl ScopedIdent
                CType
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Parameters
-- Variadic parameters aren't supported in golite
newtype Parameters =
  Parameters [ParameterDecl]
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Signature
-- Golite does not support multiple return values or named values;
-- No result type needed
data Signature =
  Signature Parameters
            (Maybe CType)
  deriving (Show, Eq)

----------------------------------------------------------------------
-- Func body/statements
type FuncBody = Stmt

-- | See https://golang.org/ref/spec#SimpleStmt
data SimpleStmt
  = EmptyStmt
  -- | See https://golang.org/ref/spec#Expression_statements
  -- Note that expr must be some function
  | ExprStmt Expr
  | VoidExprStmt Ident
                 [Expr] -- For void calls only as they don't have a return type
  -- | See https://golang.org/ref/spec#IncDecStmt
  | Increment Expr
  | Decrement Expr
  -- | See https://golang.org/ref/spec#Assignments
  | Assign AssignOp
           (NonEmpty (Expr, Expr))
  -- | See https://golang.org/ref/spec#ShortVarDecl
  | ShortDeclare (NonEmpty (ScopedIdent, Expr))
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Statement
-- & See https://golang.org/ref/spec#Block
-- Note that Golang specs makes a distinction of blocks and statements,
-- where blocks are wrapped with braces
-- However, at the AST level, this distinction no longer exists
data Stmt
  = BlockStmt [Stmt]
  | SimpleStmt SimpleStmt
  -- | See https://golang.org/ref/spec#If_statements
  -- Note that the simple stmt is optional;
  -- however, we already have a representation for an 'empty' simple stmt
  -- Note that the last entry is an optional block or if statement
  -- however, this all falls into our stmt category
  | If (SimpleStmt, Expr)
       Stmt
       Stmt
  -- | See https://golang.org/ref/spec#Switch_statements
  -- | See https://golang.org/ref/spec#ExprSwitchStmt
  -- Golite does not support type switches
  -- Note that there should be at most one default
  -- The next AST model can make that distinction
  | Switch SimpleStmt
           (Maybe Expr)
           [SwitchCase]
  -- | See https://golang.org/ref/spec#For_statements
  | For ForClause
        Stmt
  -- | See https://golang.org/ref/spec#Break_statements
  -- Labels are not supported in Golite
  | Break
  -- | See https://golang.org/ref/spec#Continue_statements
  -- Labels are not supported in Golite
  | Continue
  -- | See https://golang.org/ref/spec#Declaration
  | Declare Decl
  -- Golite exclusive
  | Print [Expr]
  -- Golite exclusive
  | Println [Expr]
  -- | See https://golang.org/ref/spec#Return_statements
  -- In golite, at most one expr can be returned
  | Return (Maybe Expr)
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#ExprSwitchStmt
data SwitchCase
  = Case (NonEmpty Expr)
         Stmt
  | Default Stmt
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#For_statements
-- Golite does not support range statement
data ForClause =
  ForClause SimpleStmt
            (Maybe Expr)
            SimpleStmt
  deriving (Show, Eq)

----------------------------------------------------------------------
--Expressions
-- | See https://golang.org/ref/spec#Expression
-- Note that we don't care about parentheses here;
-- We can infer them from the AST
data Expr
  = Unary CType
          UnaryOp
          Expr
  | Binary CType
           BinaryOp
           Expr
           Expr
  -- | See https://golang.org/ref/spec#Operands
  | Lit Literal
  -- | See https://golang.org/ref/spec#OperandName
  | Var CType
        ScopedIdent
  -- | Golite spec
  -- See https://golang.org/ref/spec#Appending_and_copying_slices
  -- First expr should be a slice
  | AppendExpr CType
               Expr
               Expr
  -- | Golite spec
  -- See https://golang.org/ref/spec#Length_and_capacity
  -- Supports strings, arrays, and slices
  | LenExpr Expr
  -- | Golite spec
  -- See https://golang.org/ref/spec#Length_and_capacity
  -- Supports arrays and slices
  | CapExpr Expr
  -- | See https://golang.org/ref/spec#Selector
  -- Eg a.b
  | Selector CType
             [FieldDecl] -- For the struct type so we know what class to refer to
             Expr
             Ident
  -- | See https://golang.org/ref/spec#Index
  -- Eg expr1[expr2]
  | Index CType
          Expr
          Expr
  -- | See https://golang.org/ref/spec#Arguments
  -- Eg expr(expr1, expr2, ...)
  | Arguments CType
              Ident
              [Expr]
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Literal
data Literal
  = IntLit Int
  | BoolLit Bool
  | FloatLit Float
  | RuneLit Char
  | StringLit String
  deriving (Show, Eq)

type CType = C.CyclicContainer Type

instance C.Cyclic Type where
  isRoot Cycle = True
  isRoot _     = False
  hasRoot Cycle = True
  hasRoot (ArrayType _ t) = C.hasRoot t
  hasRoot (SliceType t) = C.hasRoot t
  hasRoot (StructType fields) = any hasRoot' fields
    where
      hasRoot' :: FieldDecl -> Bool
      hasRoot' (FieldDecl _ t) = C.hasRoot t
  -- Note that an infer within another typemap is no longer the same
  -- root as the current cycle. We therefore also mark it as false
  hasRoot _ = False

-- Use Type for base type resolution instead
-- | See https://golang.org/ref/spec#Types
data Type
  -- | See https://golang.org/ref/spec#Array_types
  -- Note that golite only supports int literal sizes
  = ArrayType Int
              Type
  -- | See https://golang.org/ref/spec#Slice_types
  | SliceType Type
  -- | See https://golang.org/ref/spec#Struct_types
  | StructType [FieldDecl]
  | PInt
  | PFloat64
  | PBool
  | PRune
  | PString
  -- | Base types allow for cycles
  -- For instance,
  -- type a []a
  -- and
  -- type b struct { cycle b; }
  -- are all valid in golite
  -- While we can represent it with an infinite data structure,
  -- It makes modification more difficult
  -- TODO check if we actually want to support this
  | Cycle
  | TypeMap CType
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#FieldDecl
-- Golite does not support embedded fields
-- Note that these fields aren't scope related
data FieldDecl =
  FieldDecl Ident
            Type
  deriving (Show, Eq)

------------------------------------------------------------------------
-- Converter logic
-- The following maps CheckedData to Data,
-- allowing us to derive Prettify
------------------------------------------------------------------------
o :: Offset
o = Offset 0

instance Convert Ident T.Identifier where
  convert (Ident vname) = T.Identifier o vname

instance Convert ScopedIdent T.Identifier where
  convert (ScopedIdent _ i) = convert i

instance Convert Ident ScopedIdent where
  convert = ScopedIdent (Scope 0)

-- | Scoped identifier to non empty idents with offsets
instance Convert ScopedIdent T.Identifiers where
  convert si = convert si :| []

instance Convert Program T.Program where
  convert (Program i tl) = T.Program (convert i) (convert tl)

instance Convert TopDecl T.TopDecl where
  convert (TopDecl d)      = T.TopDecl (convert d)
  convert (TopFuncDecl fd) = T.TopFuncDecl (convert fd)

instance Convert Decl T.Decl where
  convert (VarDecl vdl) = T.VarDecl (convert vdl)
  convert (TypeDef tdl) = T.TypeDef (Maybe.mapMaybe convert tdl)

instance Convert VarDecl' T.VarDecl' where
  convert (VarDecl' si t (Just e)) =
    T.VarDecl' (convert si) (Left (convert t, [convert e]))
  convert (VarDecl' si t Nothing) =
    T.VarDecl' (convert si) (Left (convert t, []))

instance Convert TypeDef' (Maybe T.TypeDef') where
  convert NoDef = Nothing

instance Convert FuncDecl T.FuncDecl where
  convert (FuncDecl si sig fb) =
    T.FuncDecl (convert si) (convert sig) (convert fb)

instance Convert ParameterDecl T.ParameterDecl where
  convert (ParameterDecl si t) = T.ParameterDecl (convert si) (convert t)

instance Convert Parameters T.Parameters where
  convert (Parameters pdl) = T.Parameters (convert pdl)

instance Convert Signature T.Signature where
  convert (Signature params t) = T.Signature (convert params) (convert t)

instance Convert SimpleStmt T.SimpleStmt where
  convert EmptyStmt = T.EmptyStmt
  convert (ExprStmt e) = T.ExprStmt (convert e)
  convert (VoidExprStmt i el) =
    T.ExprStmt (T.Arguments o (T.Var $ convert i) (convert el))
  convert (Increment e) = T.Increment o (convert e)
  convert (Decrement e) = T.Decrement o (convert e)
  convert (Assign op eltup) = uncurry (T.Assign o op) (convert $ NE.unzip eltup)
  convert (ShortDeclare ideltup) =
    uncurry T.ShortDeclare (convert $ NE.unzip ideltup)

instance Convert Stmt T.Stmt where
  convert (BlockStmt sl) = T.BlockStmt (convert sl)
  convert (SimpleStmt ss) = T.SimpleStmt (convert ss)
  convert (If (ss, e) s1 s2) =
    T.If (convert ss, convert e) (convert s1) (convert s2)
  convert (Switch ss e scl) = T.Switch (convert ss) (convert e) (convert scl)
  convert (For fcl s) = T.For (convert fcl) (convert s)
  convert Break = T.Break o
  convert Continue = T.Continue o
  convert (Declare d) = T.Declare (convert d)
  convert (Print el) = T.Print (convert el)
  convert (Println el) = T.Println (convert el)
  convert (Return e) = T.Return o (convert e)

instance Convert SwitchCase T.SwitchCase where
  convert (Case nle s) = T.Case o (convert nle) (convert s)
  convert (Default s)  = T.Default o (convert s)

instance Convert ForClause T.ForClause where
  convert (ForClause pre e post) =
    T.ForClause (convert pre) (convert e) (convert post)

instance Convert Expr T.Expr where
  convert (Unary _ op e) = T.Unary o op (convert e)
  convert (Binary _ op e1 e2) = T.Binary o op (convert e1) (convert e2)
  convert (Lit lit) = either T.Lit id (convert lit)
  convert (Var _ si) = T.Var (convert si)
  convert (AppendExpr _ e1 e2) = T.AppendExpr o (convert e1) (convert e2)
  convert (LenExpr e) = T.LenExpr o (convert e)
  convert (CapExpr e) = T.CapExpr o (convert e)
  convert (Selector _ _ e i) = T.Selector o (convert e) (convert i)
  convert (Index _ e1 e2) = T.Index o (convert e1) (convert e2)
  convert (Arguments _ i el) = T.Arguments o (T.Var (convert i)) (convert el)

instance Convert Literal (Either T.Literal T.Expr) where
  convert (IntLit i) = Left $ T.IntLit o T.Decimal (show i)
  convert (FloatLit f) = Left $ T.FloatLit o (show f)
  convert (RuneLit c) = Left $ T.RuneLit o (show c)
  convert (StringLit s) = Left $ T.StringLit o T.Interpreted $ "\"" ++ s ++ "\""
  convert (BoolLit True) = Right $ T.Var (convert $ Ident "true")
  convert (BoolLit False) = Right $ T.Var (convert $ Ident "false")

instance Convert CType T.Type where
  convert = convert . C.get

instance Convert CType T.Type' where
  convert t = (o, convert t)

instance Convert Type T.Type' where
  convert t = (o, convert t)

instance Convert Type T.Type where
  convert (ArrayType i t) =
    T.ArrayType (T.Lit (T.IntLit o T.Decimal (show i))) (convert t)
  convert (SliceType t) = T.SliceType (convert t)
  convert (StructType fdl) = T.StructType (convert fdl)
  convert PInt = T.Type (convert $ Ident "int")
  convert PFloat64 = T.Type (convert $ Ident "float64")
  convert PBool = T.Type (convert $ Ident "bool")
  convert PRune = T.Type (convert $ Ident "rune")
  convert PString = T.Type (convert $ Ident "string")
  convert Cycle = T.Type (convert $ Ident "cycle")
  convert (TypeMap t) = convert t -- TODO verify

instance Convert FieldDecl T.FieldDecl where
  convert (FieldDecl i t) = T.FieldDecl (convert i :| []) (convert t)

instance Prettify Program where
  prettify' p = prettify' (convert p :: T.Program)
