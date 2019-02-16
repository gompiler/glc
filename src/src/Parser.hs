{-# LANGUAGE DataKinds      #-}
{-# LANGUAGE GADTs          #-}
{-# LANGUAGE KindSignatures #-}

module Parser where

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty

-- note that I do not classify blank identifiers as a separate type
-- because we can easily pattern match it already
type Identifier = String

type IfStmt = (Expr, Stmt)

type TODO = () -- temp

-- | See https://golang.org/ref/spec#Source_file_organization
data Program = Program
  { package   :: String
  , imports   :: [ImportSpec]
  -- I'm looking into datakinds. I don't want to declare a new type for topdecl and then link all the constructors again
  , topLevels :: [TODO]
  }

-- | Identifier here can either be:
-- * blank - same name as package
-- * '.' - imports all packages in folder without qualifier
-- * '_' - ignored; imported solely for side-effects (initialization)
-- * some string - qualified name
data ImportSpec =
  ImportSpec (Maybe Identifier)
             String

----------------------------------------------------------------------
-- Declarations
-- | See https://golang.org/ref/spec#VarDecl
-- TODO, I don't really like this format
data VarDecl =
  VarDecl Identifier
          (Either (Type, Maybe Expr) Expr)

data VarDecl'
  = VarDecl' VarDecl
  | VarDecl'' [VarDecl]

-- | See https://golang.org/ref/spec#ConstDecl
data ConstDecl =
  ConstDecl Identifier
            (Maybe Type)
            Expr

data ConstDecl'
  = ConstDecl' ConstDecl
  | ConstDecl'' [ConstDecl]

-- | See https://golang.org/ref/spec#TypeDecl
data TypeDecl
  = TypeDef Identifier
            Type
  | AliasDecl Identifier
              Type

-- | See https://golang.org/ref/spec#FunctionDecl
-- If no stmt, func is implemented externally
data FuncDecl =
  FuncDecl Identifier
           Signature
           (Maybe FuncBody)

type FuncBody = Stmt

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

--data TopDeclaration = ConstDecl | TypeDecl | VarDecl | FuncDecl | MethodDecl
data Scope
  = UniverseScope
  | PackageScope
  | FuncScope
  | StmtScope

data Stmt
  = BlockStmt [Stmt]
  | If IfStmt
       (Maybe IfStmt)
  | While Expr
          Stmt
  | Blank

-- | Notes on parser todo:
-- * Integer must parse all valid int types
-- * Floats must support exponents
data Expr
  = IntConst IntType
             Integer -- note that this is not Int, which is limited to 2^29 - 1
  | FloatConst Float
  | RuneConst Char
  | StringConst StringType
                String
  | Var Identifier -- todo look at predeclared identifiers? https://golang.org/ref/spec#Predeclared_identifiers

data IntType
  = Decimal
  | Octal
  | Hexadecimal

data StringType
  = Interpreted
  | Raw

data Type
  = Integer IntType
  | Float
  | Rune
  | String StringType

data Infix' =
  Infix'

data Prefix' =
  Prefix'
