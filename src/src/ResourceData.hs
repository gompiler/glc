module ResourceData where

import           CheckedData        (AssignOp, BinaryOp, Ident, Literal,
                                     UnaryOp)
import           Data.List.NonEmpty (NonEmpty (..))

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
