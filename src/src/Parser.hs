module Parser where

type IfStmt = (Expr, Stmt)

data Stmt
  = Block [Stmt]
  | If IfStmt
       (Maybe IfStmt)
  | While Expr
          Stmt

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
  | RawStringConst String

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
