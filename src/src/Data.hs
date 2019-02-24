module Data where

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
import           GHC.Exts           (Constraint)
import           GHC.TypeLits

-- note that I do not classify blank identifiers as a separate type
-- because we can easily pattern match it already
type Identifier = String

newtype TODO =
  TODO String -- temp

-- | See https://golang.org/ref/spec#Source_file_organization
-- Imports not supported in golite
data Program = Program
  { package   :: PackageName
  , topLevels :: [TopDecl]
  }

----------------------------------------------------------------------
-- Declarations
-- | See https://golang.org/ref/spec#Declarations_and_scope
data TopDecl
  = TopDecl Decl
  | TopFuncDecl FuncDecl

-- Golite does not support type alias
data Decl
  -- | See https://golang.org/ref/spec#VarDecl
  -- If only on entry exists, it is treated as a single line declaration
  -- Otherwise, it is treated as var ( ... )
  = VarDecl [VarDecl']
  -- | See https://golang.org/ref/spec#TypeDecl
  -- Same spec as VarDecl
  | TypeDef [TypeDef']

-- | See https://golang.org/ref/spec#VarDecl
-- A single declaration line can declare one or more identifiers
-- There is an optional type, as well as an optional list of expressions.
-- The expression list should match the length of the identifier list,
-- though we make no guarantees at this AST stage
-- Should a type be specified, the expression list is optional
data VarDecl' =
  VarDecl' (NonEmpty Identifier)
           (Either (Type, [Expr]) (NonEmpty Expr))

data TypeDef' =
  TypeDef' Identifier
           Type

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

-- Func components
data ParameterDecl =
  ParameterDecl [Identifier]
                Type

-- Variadic parameters aren't supported in golite
newtype Parameters =
  Parameters [ParameterDecl]

-- Golite does not support multiple return values or named values;
-- No result type needed
-- TODO see if we want this or if we want to merge this into FuncDecl
data Signature =
  Signature Parameters
            (Maybe Type)

----------------------------------------------------------------------
-- Func body/statements
-- Just a test; not necessary
data Scope
  = UniverseScope
  | PackageScope
  | FuncScope
  | StmtScope

-- WIP
type FuncBody = Stmt

-- | See https://golang.org/ref/spec#SimpleStmt
data SimpleStmt
  = EmptyStmt
  -- | See https://golang.org/ref/spec#Expression_statements
  | ExprStmt TODO
  -- | See https://golang.org/ref/spec#IncDecStmt
  -- TODO check if we want to split these or add a new field for inc and dec
  | Increment Expr
  | Decrement Expr
  -- | See https://golang.org/ref/spec#Assignments
  -- TODO confirm that expression lists should be equal
  | Assign AssignOp
           (NonEmpty Expr)
           (NonEmpty Expr)
  -- | See https://golang.org/ref/spec#ShortVarDecl
  | ShortDeclare (NonEmpty Identifier)
                 (NonEmpty Expr)

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
  -- Golite does not support type switches
  -- Note that there should be at most one default
  -- The next AST model can make that distinction
  | Switch [SwitchCase]
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

newtype Label =
  Label Identifier

-- | See https://golang.org/ref/spec#ExprSwitchStmt
data SwitchCase
  = Case (NonEmpty Expr)
         Stmt
  | Default Stmt

-- | See https://golang.org/ref/spec#For_statements
-- Golite does not support range statement
data ForClause
  = ForInfinite -- blank clause
  | ForCond Expr
  | ForClause SimpleStmt
              Expr
              SimpleStmt

----------------------------------------------------------------------
--Expressions
-- | See https://golang.org/ref/spec#Expression
-- Note that we don't care about parentheses here;
-- We can infer them from the AST
-- TODO support slices? index?
data Expr
  = Unary UnaryOp
          Expr
  | Binary Expr
           BinaryOp
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
  | Conversion Type
               Expr

-- | See https://golang.org/ref/spec#Literal
-- TODO do we want to store string and type?
-- Type can be inferred from string
-- If we want to keep erroneous states invalid,
-- we might want just string, or store as int and reformat on pretty print
-- TODO support other literals?
data Literal
  = IntLit IntType'
           String
  | FloatLit Float
  | RuneLit Char
  | StringLit StringType'
              String
  -- | See https://golang.org/ref/spec#FunctionLit
  | FuncLit Signature
            FuncBody

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

-- | See https://golang.org/ref/spec#unary_op
-- Golite only supports the four ops below
data UnaryOp
  = Pos -- +
  | Neg -- -
  | Not -- !
  | BitComplement -- ^

-- | See https://golang.org/ref/spec#assign_op
-- Symbol is the arithm op followed by '='
newtype AssignOp =
  AssignOp (Maybe ArithmOp)

data IntType'
  = Decimal
  | Octal
  | Hexadecimal

data StringType'
  = Interpreted
  | Raw

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
  | PointerType Type
  | FuncType Signature
  | Type Identifier

-- | See https://golang.org/ref/spec#string_lit
-- TODO check if we want to use a data kind and reuse the StringLit constructor within Literals
data StringLiteral =
  StringLiteral StringType'
                String

data FieldDecl
  = FieldDecl (NonEmpty Identifier)
              Type
              (Maybe StringLiteral)
  | EmbeddedField Identifier
                  (Maybe StringLiteral)

type PackageName = String
