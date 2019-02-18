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
  | TopFuncDecl Identifier
                Signature
                (Maybe FuncBody)

-- Golite does not support type alias
data Decl
  -- | See https://golang.org/ref/spec#VarDecl
  = VarDecl [VarDecl']
  -- | See https://golang.org/ref/spec#TypeDecl
  | TypeDef [TypeDef']

data VarDecl' =
  VarDecl' (NonEmpty Identifier)
           (Either (Type, Maybe Expr) Expr)

data TypeDef' =
  TypeDef' Identifier
           Type

----------------------------------------------------------------------
-- Func components
data ParameterDecl =
  ParameterDecl [Identifier]
                Type

-- Bool refers to variadic type, which may be applied to thee last parameter only
-- Note that in the specs, it is defined within ParameterDecl, but it makes sense here for the AST
data Parameters =
  Parameters [ParameterDecl]
             Bool

newtype Result =
  Result (Either Parameters Type)

data Signature =
  Signature Parameters
            (Maybe Result)

type Receiver = Parameters

-- | See https://golang.org/ref/spec#Method_declarations
data MethodDecl =
  MethodDecl Receiver
             Signature
             (Maybe FuncBody)

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

data Type
  = IntType IntType'
  | FloatType
  | RuneType
  | StringType StringType'
  | CustomType Identifier'
  -- Note that expr must evaluate to int const
  | ArrayType Expr
              Type
  | SliceType Type
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
