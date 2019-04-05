{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns        #-}

module ResourceData
  ( ArithmOp(..)
  , AssignOp(..)
  , BinaryOp(..)
  , Expr(..)
  , FieldDecl(..)
  , ForClause(..)
  , FuncDecl(..)
  , Ident(..)
  , Literal(..)
  , ParameterDecl(..)
  , Parameters(..)
  , Program(..)
  , Signature(..)
  , SimpleStmt(..)
  , Stmt(..)
  , StructType(..)
  , SwitchCase(..)
  , TopVarDecl(..)
  , Type(..)
  , UnaryOp(..)
  , VarIndex(..)
  ) where

import           CheckedData        (ArithmOp (..), AssignOp (..),
                                     BinaryOp (..), Ident (..), Literal (..),
                                     UnaryOp (..))
import qualified CheckedData        as T
import           Converter          (Convert (..))
import qualified Cyclic             as C
import           Data.List.NonEmpty (NonEmpty (..))
import           Prelude            hiding (init)
import           Prettify           (Prettify (..))

-- Represents the stack index within a method
newtype VarIndex =
  VarIndex Int
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Source_file_organization
-- Imports not supported in golite
-- Note the following changes:
-- * We collect all possible structs and provide a list of unique struct types
-- * We collect all init operations and put them in one section
-- * We separate var declarations and function declarations
-- To create a working program, data should be loaded in this order
data Program = Program
  { package   :: Ident
  , structs   :: [StructType]
  , topVars   :: [TopVarDecl]
  , init      :: [Stmt]
  , functions :: [FuncDecl]
  } deriving (Show, Eq)

----------------------------------------------------------------------
-- Declarations
-- | See https://golang.org/ref/spec#VarDecl
data TopVarDecl =
  TopVarDecl Ident
             Type
             (Maybe Expr)
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
  FuncDecl Ident -- TODO check if we want this
           Signature
           FuncBody
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#ParameterDecl
-- Func components
-- Golite does not support unnamed parameters
-- At this stage, we can map each individual identifier to its expected type
data ParameterDecl =
  ParameterDecl VarIndex
                Type
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
            (Maybe Type)
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
                 [Expr]
  -- | See https://golang.org/ref/spec#IncDecStmt
  | Increment Expr
  | Decrement Expr
  -- | See https://golang.org/ref/spec#Assignments
  | Assign AssignOp
           (NonEmpty (Expr, Expr))
  -- | See https://golang.org/ref/spec#ShortVarDecl
  | ShortDeclare (NonEmpty (VarIndex, Expr))
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
  -- In this AST, we now separate the default case from the other switch cases
  -- If none exists, we will simply provide an empty statement
  -- The expression also defaults to True if none exists
  | Switch SimpleStmt
           Expr
           [SwitchCase]
           Stmt
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
  -- At this stage, we only have var declarations
  -- If no expr is provided, we will also assign a default
  | VarDecl VarIndex
            Type
            (Maybe Expr)
  -- Golite exclusive
  | Print [Expr]
  -- Golite exclusive
  | Println [Expr]
  -- | See https://golang.org/ref/spec#Return_statements
  -- In golite, at most one expr can be returned
  | Return (Maybe Expr)
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#ExprSwitchStmt
data SwitchCase =
  Case (NonEmpty Expr)
       Stmt
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#For_statements
-- Golite does not support range statement
data ForClause =
  ForClause SimpleStmt
            Expr
            SimpleStmt
  deriving (Show, Eq)

----------------------------------------------------------------------
--Expressions
-- | See https://golang.org/ref/spec#Expression
-- Note that we don't care about parentheses here;
-- We can infer them from the AST
data Expr
  = Unary Type
          UnaryOp
          Expr
  | Binary Type
           BinaryOp
           Expr
           Expr
  -- | See https://golang.org/ref/spec#Operands
  | Lit Literal
  -- | See https://golang.org/ref/spec#OperandName
  | Var Type
        VarIndex
  -- | Golite spec
  -- See https://golang.org/ref/spec#Appending_and_copying_slices
  -- First expr should be a slice
  | AppendExpr Type
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
  | Selector Type
             Expr
             Ident
  -- | See https://golang.org/ref/spec#Index
  -- Eg expr1[expr2]
  | Index Type
          Expr
          Expr
  -- | See https://golang.org/ref/spec#Arguments
  -- Eg expr(expr1, expr2, ...)
  | Arguments Type
              Ident
              [Expr]
  deriving (Show, Eq)

data Type
  -- | See https://golang.org/ref/spec#Array_types
  -- Note that golite only supports int literal sizes
  = ArrayType Int
              Type
  -- | See https://golang.org/ref/spec#Slice_types
  | SliceType Type
  -- | See https://golang.org/ref/spec#Struct_types
  | PInt
  | PFloat64
  | PBool
  | PRune
  | PString
  | StructType Ident
  deriving (Show, Eq)

data StructType =
  Struct Ident
         [FieldDecl]
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#FieldDecl
-- Golite does not support embedded fields
-- Note that these fields aren't scope related
data FieldDecl =
  FieldDecl Ident
            Type
  deriving (Show, Eq)

instance Convert VarIndex T.ScopedIdent where
  convert (VarIndex i) = T.ScopedIdent (T.Scope 0) (T.Ident $ "var" ++ show i)

instance Convert Program T.Program where
  convert Program {package, structs, topVars, functions} =
    T.Program {T.package = package, T.topLevels = topLevels}
    -- TODO save init
    where
      topLevels =
        convert structs ++
        convert topVars ++ map T.TopFuncDecl (convert functions)

instance Convert StructType T.TopDecl where
  convert (Struct _ _) = T.TopDecl $ T.TypeDef []

instance Convert TopVarDecl T.TopDecl where
  convert (TopVarDecl i t e) =
    T.TopDecl $ T.VarDecl [T.VarDecl' (convert i) (convert t) (convert e)]

instance Convert FuncDecl T.FuncDecl where
  convert (FuncDecl i sig fb) =
    T.FuncDecl (convert i) (convert sig) (convert fb)

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
  convert (If (ss, e) s1 s2) =
    T.If (convert ss, convert e) (convert s1) (convert s2)
  convert (Switch ss e scl d) =
    T.Switch
      (convert ss)
      (Just (convert e))
      (convert scl ++ [T.Default $ convert d])
  convert (For fcl s) = T.For (convert fcl) (convert s)
  convert Break = T.Break
  convert Continue = T.Continue
  convert (VarDecl i t e) =
    T.Declare $ T.VarDecl [T.VarDecl' (convert i) (convert t) (convert e)]
  convert (Print el) = T.Print (convert el)
  convert (Println el) = T.Println (convert el)
  convert (Return e) = T.Return (convert e)

instance Convert SwitchCase T.SwitchCase where
  convert (Case nle s) = T.Case (convert nle) (convert s)

instance Convert ForClause T.ForClause where
  convert (ForClause pre cond post) =
    T.ForClause (convert pre) (Just (convert cond)) (convert post)

instance Convert Expr T.Expr where
  convert (Unary t op e) = T.Unary (convert t) op (convert e)
  convert (Binary t op e1 e2) =
    T.Binary (convert t) op (convert e1) (convert e2)
  convert (Lit lit) = T.Lit lit
  convert (Var t i) = T.Var (convert t) (convert i)
  convert (AppendExpr t e1 e2) =
    T.AppendExpr (convert t) (convert e1) (convert e2)
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

instance Prettify Program where
  prettify' p = prettify' (convert p :: T.Program)
