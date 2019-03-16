{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module CheckedData where

import           Data               (Identifier (..))
import           Data.List.NonEmpty (NonEmpty (..))

data ScopedIdent =
  ScopedIdent Scope
              Ident
  deriving (Show, Eq)

newtype Ident =
  Ident String
  deriving (Show, Eq)

-- TODO I recommend this be separate from symbol table,
-- even if it's the same thing since there's no reason to have the
-- base symbol table be dependent on the data module
newtype Scope =
  Scope Int
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Source_file_organization
-- Imports not supported in golite
data Program = Program
  { package   :: String
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
           Expr
           Type
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#TypeDef
data TypeDef' =
  TypeDef' Identifier
           Type
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
  -- | See https://golang.org/ref/spec#IncDecStmt
  | Increment Expr
  | Decrement Expr
  -- | See https://golang.org/ref/spec#Assignments
  | Assign AssignOp
           (NonEmpty (Expr, Expr))
  -- | See https://golang.org/ref/spec#ShortVarDecl
  | ShortDeclare (NonEmpty (ScopedIdent, Expr))
  deriving (Show, Eq)

-- | Shortcut for a blank stmt
blank :: Stmt
blank = SimpleStmt EmptyStmt

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
  = Unary UnaryOp
          Expr
  | Binary BinaryOp
           Expr
           Expr
  -- | See https://golang.org/ref/spec#Operands
  | Lit Literal
  -- | See https://golang.org/ref/spec#OperandName
  | Var Identifier
  -- | Golite spec
  -- See https://golang.org/ref/spec#Appending_and_copying_slices
  -- First expr should be a slice
  | AppendExpr Expr
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
  | Selector Expr
             Identifier
  -- | See https://golang.org/ref/spec#Index
  -- Eg expr1[expr2]
  | Index Expr
          Expr
  -- | See https://golang.org/ref/spec#Arguments
  -- Eg expr(expr1, expr2, ...)
  | Arguments Expr
              [Expr]
              Signature
  -- | Variant of arguments that is known to be a type cast
  -- Eg int(expr)
  -- Constraint is that there must only be one expression within parentheses,
  -- and that the cast expression is a known type
  | TypeConvert Type
                Expr
                Type
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#Literal
data Literal
  = IntLit Int
  | FloatLit Float
  | RuneLit Char
  | StringLit String
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#binary_op
-- & See https://golang.org/ref/spec#rel_op
data BinaryOp
  = Or -- ||
  | And -- &&
  | Arithm ArithmOp
  | EQ -- ==
  | NEQ -- !=
  | LT -- <
  | LEQ -- <=
  | GT -- >
  | GEQ -- >=
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#add_op
-- & See https://golang.org/ref/spec#mul_op
-- We make no distinction between addop and mulop
-- As they are separated in the specs purely to show the order of operations
data ArithmOp
  --- Add Ops
  = Add -- +
  | Subtract -- -
  | BitOr -- |
  | BitXor -- ^
  --- Mul Ops
  | Multiply -- *
  | Divide -- /
  | Remainder -- %
  | ShiftL -- <<
  | ShiftR -- >>
  | BitAnd -- &
  | BitClear -- &^
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#unary_op
-- Golite only supports the four ops below
data UnaryOp
  = Pos -- +
  | Neg -- -
  | Not -- !
  | BitComplement -- ^
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#assign_op
-- Symbol is the arithm op followed by '='
newtype AssignOp =
  AssignOp (Maybe ArithmOp)
  deriving (Show, Eq)

-- | Type with scope value
-- Used for caching inferrable types
-- type InferredType = (Scope, Type)
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
  -- | See https://golang.org/ref/spec#Function_types
  | TypeMap ScopedIdent
            Type
  | Type ScopedIdent
  -- | Empty return type
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#FieldDecl
-- Golite does not support embedded fields
-- Note that these fields aren't scope related
data FieldDecl =
  FieldDecl Identifier
            Type
  deriving (Show, Eq)
