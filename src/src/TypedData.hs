{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module TypedData where

import           Base
import           Data               (Identifier (..), Identifiers)
import           Data.List.NonEmpty (NonEmpty (..))

type TODO = ()

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
  -- If only on entry exists, it is treated as a single line declaration
  -- Otherwise, it is treated as var ( ... )
  = VarDecl [VarDecl']
  -- | See https://golang.org/ref/spec#TypeDecl
  -- Same spec as VarDecl
  | TypeDef [TypeDef']
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#VarDecl
-- A single declaration line can declare one or more identifiers
-- There is an optional type, as well as an optional list of expressions.
-- The expression list should match the length of the identifier list,
-- though we make no guarantees at this AST stage
-- Should a type be specified, the expression list is optional
data VarDecl' =
  VarDecl' Identifiers
           (Either (Type', [Expr]) (NonEmpty Expr))
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#TypeDef
data TypeDef' =
  TypeDef' Identifier
           Type'
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
  FuncDecl Identifier
           Signature
           FuncBody
  deriving (Show, Eq)

instance ErrorBreakpoint FuncDecl where
  offset (FuncDecl ident _ _) = offset ident

-- | See https://golang.org/ref/spec#ParameterDecl
-- Func components
-- Golite does not support unnamed parameters
data ParameterDecl =
  ParameterDecl Identifiers
                Type'
  deriving (Show, Eq)

instance ErrorBreakpoint ParameterDecl where
  offset (ParameterDecl idents _) = offset idents

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
            (Maybe Type')
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
  | Increment Offset
              Expr
  | Decrement Offset
              Expr
  -- | See https://golang.org/ref/spec#Assignments
  | Assign Offset
           AssignOp
           (NonEmpty (Expr, Expr))
  -- | See https://golang.org/ref/spec#ShortVarDecl
  | ShortDeclare (NonEmpty (Identifiers, Expr))
  deriving (Show, Eq)

instance ErrorBreakpoint SimpleStmt where
  offset EmptyStmt                        = error "EmptyStmt has no offset"
  offset (ExprStmt e)                     = offset e
  offset (Increment o _)                  = o
  offset (Decrement o _)                  = o
  offset (Assign o _ _)                   = o
  offset (ShortDeclare ((ident, _) :| _)) = offset ident

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
  | Break Offset
  -- | See https://golang.org/ref/spec#Continue_statements
  -- Labels are not supported in Golite
  | Continue Offset
  -- | See https://golang.org/ref/spec#Fallthrough_statements
  -- | Fallthrough Offset
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
  = Case Offset
         (NonEmpty Expr)
         Stmt
  | Default Offset
            Stmt
  deriving (Show, Eq)

instance ErrorBreakpoint SwitchCase where
  offset (Case o _ _)  = o
  offset (Default o _) = o

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
  = Unary Offset
          UnaryOp
          Expr
  | Binary Offset
           BinaryOp
           Expr
           Expr
  -- | See https://golang.org/ref/spec#Operands
  | Lit Literal
  -- | See https://golang.org/ref/spec#OperandName
  | Var Identifier
  -- | Golite spec
  -- See https://golang.org/ref/spec#Appending_and_copying_slices
  -- First expr should be a slice
  | AppendExpr Offset
               Expr
               Expr
  -- | Golite spec
  -- See https://golang.org/ref/spec#Length_and_capacity
  -- Supports strings, arrays, and slices
  | LenExpr Offset
            Expr
  -- | Golite spec
  -- See https://golang.org/ref/spec#Length_and_capacity
  -- Supports arrays and slices
  | CapExpr Offset
            Expr
  -- | See https://golang.org/ref/spec#Selector
  -- Eg a.b
  | Selector Offset
             Expr
             Identifier
  -- | See https://golang.org/ref/spec#Index
  -- Eg expr1[expr2]
  | Index Offset
          Expr
          Expr
  -- | See https://golang.org/ref/spec#Arguments
  -- Eg expr(expr1, expr2, ...)
  -- Note that type must be explicit here since
  | Arguments Offset
              Expr
              [Expr]
  -- | Variant of arguments that is known to be a type cast
  -- Eg int(expr)
  -- Constraint is that there must only be one expression within parentheses,
  -- and that the cast expression is a known type
  -- the offset is included within Type'
  | TypeCast Type'
             Expr
  deriving (Show, Eq)

instance ErrorBreakpoint Expr where
  offset (Unary o _ _)      = o
  offset (Binary o _ _ _)   = o
  offset (Lit l)            = offset l
  offset (Var ident)        = offset ident
  offset (AppendExpr o _ _) = o
  offset (LenExpr o _)      = o
  offset (CapExpr o _)      = o
  offset (Selector o _ _)   = o
  offset (Index o _ _)      = o
  offset (Arguments o _ _)  = o
  offset (TypeCast t _)     = offset t

-- | See https://golang.org/ref/spec#Literal
-- Type can be inferred from string
-- If we want to keep erroneous states invalid,
-- we might want just string, or store as int and reformat on pretty print
data Literal
  = IntLit Offset
           Int
  | FloatLit Offset
             Float
  | RuneLit Offset
            String
  | StringLit Offset
              String
  deriving (Show, Eq)

instance ErrorBreakpoint Literal where
  offset (IntLit o _)    = o
  offset (FloatLit o _)  = o
  offset (RuneLit o _)   = o
  offset (StringLit o _) = o

--  offset (StringLit o _ _) = o
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

-- | Type with offset value
-- We do not include offsets within types as
-- it results in unnecessary nested offsets
type Type' = (Offset, Scope, Identifier, Type)

instance ErrorBreakpoint Type' where
  offset (o, _, _, _) = o

-- | See https://golang.org/ref/spec#Types
data Type
  -- | See https://golang.org/ref/spec#Array_types
  -- Note that expr must evaluate to int const
  = ArrayType Expr
              Type
  -- | See https://golang.org/ref/spec#Slice_types
  | SliceType Type
  -- | See https://golang.org/ref/spec#Struct_types
  | StructType [FieldDecl]
  -- | See https://golang.org/ref/spec#Function_types
  | FuncType Signature
  | Type Identifier
  -- | Empty return type
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#FieldDecl
-- Golite does not support embedded fields
data FieldDecl =
  FieldDecl Identifiers
            Type'
  deriving (Show, Eq)

instance ErrorBreakpoint FieldDecl where
  offset (FieldDecl idents _) = offset idents
