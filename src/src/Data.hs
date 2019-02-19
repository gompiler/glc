--{-# LANGUAGE ConstraintKinds #-}
--{-# LANGUAGE DataKinds       #-}
--{-# LANGUAGE GADTs           #-}
--{-# LANGUAGE PolyKinds       #-}
--{-# LANGUAGE TypeFamilies    #-}
--{-# LANGUAGE TypeOperators   #-}
module Data where

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
import           GHC.Exts           (Constraint)
import           GHC.TypeLits

-- note that I do not classify blank identifiers as a separate type
-- because we can easily pattern match it already
type Identifier = String

-- Identifier + optional package name (qualified identifier)
type Identifier' = (Maybe PackageName, Identifier)

type IfStmt = (Expr, Stmt)

newtype TODO =
  TODO String -- temp

-- | See https://golang.org/ref/spec#Source_file_organization
-- Imports not supported in golite
data Program = Program
  { package   :: String
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
-- The expression list should match the length of the identifier list
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

-- WIP: taken from assignment
data Stmt
  = BlockStmt [Stmt]
  | If IfStmt
       (Maybe IfStmt)
  | While Expr
          Stmt
  | Blank

----------------------------------------------------------------------
-- Expressions
-- | Notes on parser todo:
-- * Integer must parse all valid int types
-- * Floats must support exponents
-- Note that this is largely WIP; golite will probably have a separated structure
data Expr
  = IntConst IntType'
             Integer -- note that this is not Int, which is limited to 2^29 - 1
  | FloatConst Float
  | RuneConst Char
  | StringConst StringType'
                String
  | Var Identifier -- todo look at predeclared identifiers? https://golang.org/ref/spec#Predeclared_identifiers

data IntType'
  = Decimal
  | Octal
  | Hexadecimal

data StringType'
  = Interpreted
  | Raw

-- | See https://golang.org/ref/spec#Types
-- TODO check if we support custom types? Looks like no aliasing
data Type
  = IntType IntType'
  | FloatType
  | BoolType
  | RuneType
  | StringType StringType'
  -- | See https://golang.org/ref/spec#Array_types
  -- Note that expr must evaluate to int const
  | ArrayType Expr
              Type
  -- | See https://golang.org/ref/spec#Slice_types
  | SliceType Type
  -- | See https://golang.org/ref/spec#Struct_types
  | StructType [FieldDecl]
  | PointerType Type
  | FuncType Signature

--  | InterfaceType (Either (Identifier, Signature) TypeName)
--  | MapType Type Type
-- TODO; this should be expr of type StringType
type StringLiteral = TODO

data FieldDecl
  = FieldDecl (NonEmpty Identifier)
              Type
              (Maybe StringLiteral)
  | EmbeddedField Identifier'
                  (Maybe StringLiteral)

type PackageName = String

data Infix' =
  Infix'

data Prefix' =
  Prefix'
