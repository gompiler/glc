{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module CheckedData
  ( blank
  , Ident(..)
  , Scope(..)
  , ScopedIdent(..)
  , Program(..)
  , Type(..)
  , Stmt(..)
  , Expr(..)
  , SimpleStmt(..)
  , FieldDecl(..)
  , Literal(..)
  , SwitchCase(..)
  , ArithmOp(..)
  , UnaryOp(..)
  , BinaryOp(..)
  , AssignOp(..)
  , TopDecl(..)
  , Decl(..)
  , VarDecl'(..)
  , TypeDef'(..)
  , ForClause(..)
  , Signature(..)
  , Parameters(..)
  , ParameterDecl(..)
  , FuncDecl(..)
  ) where

import           Base               (Offset (..))
import qualified Data               as D
import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NE (map, unzip)
import qualified Data.Maybe         as Maybe (mapMaybe)
import           Prettify

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
           Type
           (Maybe Expr) -- Can declare a variable without an expression
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#TypeDef
data TypeDef'
  = TypeDef' ScopedIdent
             Type
  -- For mappings that aren't structs, we resolve them to their base types so we don't need to define them anymore
  | NoDef
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
        ScopedIdent
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
              Expr
              [Expr]
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
  | PInt
  | PFloat64
  | PBool
  | PRune
  | PString
  -- | Empty return type
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#FieldDecl
-- Golite does not support embedded fields
-- Note that these fields aren't scope related
data FieldDecl =
  FieldDecl Ident
            Type
  deriving (Show, Eq)

class ConvertAST a b where
  toOrig :: a -> b

o :: Offset
o = Offset 0

-- | Scoped identifier to identifier with offset
si2ident :: ScopedIdent -> D.Identifier
si2ident (ScopedIdent _ (Ident vname)) = D.Identifier o vname

-- | Scoped identifier to non empty idents with offsets
si2idents :: ScopedIdent -> D.Identifiers
si2idents si = si2ident si :| []

instance ConvertAST Program D.Program where
  toOrig (Program (Ident vname) tl) =
    D.Program (D.Identifier o vname) (map toOrig tl)

instance ConvertAST TopDecl D.TopDecl where
  toOrig (TopDecl d)      = D.TopDecl (toOrig d)
  toOrig (TopFuncDecl fd) = D.TopFuncDecl (toOrig fd)

instance ConvertAST Decl D.Decl where
  toOrig (VarDecl vdl) = D.VarDecl (map toOrig vdl)
  toOrig (TypeDef tdl) = D.TypeDef (Maybe.mapMaybe toOrig tdl)

instance ConvertAST VarDecl' D.VarDecl' where
  toOrig (VarDecl' si t (Just e)) =
    D.VarDecl' (si2idents si) (Left (toOrig t, [toOrig e]))
  toOrig (VarDecl' si t Nothing) =
    D.VarDecl' (si2idents si) (Left (toOrig t, []))

instance ConvertAST TypeDef' (Maybe D.TypeDef') where
  toOrig (TypeDef' si t) = Just $ D.TypeDef' (si2ident si) (toOrig t)
  toOrig NoDef           = Nothing

instance ConvertAST FuncDecl D.FuncDecl where
  toOrig (FuncDecl si sig fb) =
    D.FuncDecl (si2ident si) (toOrig sig) (toOrig fb)

instance ConvertAST ParameterDecl D.ParameterDecl where
  toOrig (ParameterDecl si t) = D.ParameterDecl (si2idents si) (toOrig t)

instance ConvertAST Parameters D.Parameters where
  toOrig (Parameters pdl) = D.Parameters (map toOrig pdl)

instance ConvertAST Signature D.Signature where
  toOrig (Signature params (Just t)) =
    D.Signature (toOrig params) (Just (toOrig t))
  toOrig (Signature params Nothing) = D.Signature (toOrig params) Nothing

instance ConvertAST SimpleStmt D.SimpleStmt where
  toOrig EmptyStmt = D.EmptyStmt
  toOrig (ExprStmt e) = D.ExprStmt (toOrig e)
  toOrig (Increment e) = D.Increment o (toOrig e)
  toOrig (Decrement e) = D.Decrement o (toOrig e)
  toOrig (Assign op eltup) =
    let (nel1, nel2) = NE.unzip eltup
     in D.Assign o (toOrig op) (NE.map toOrig nel1) (NE.map toOrig nel2)
  toOrig (ShortDeclare ideltup) =
    let (nsil, nel) = NE.unzip ideltup
     in D.ShortDeclare (NE.map si2ident nsil) (NE.map toOrig nel)

instance ConvertAST Stmt D.Stmt where
  toOrig (BlockStmt sl) = D.BlockStmt (map toOrig sl)
  toOrig (SimpleStmt ss) = D.SimpleStmt (toOrig ss)
  toOrig (If (ss, e) s1 s2) = D.If (toOrig ss, toOrig e) (toOrig s1) (toOrig s2)
  toOrig (Switch ss (Just e) scl) =
    D.Switch (toOrig ss) (Just (toOrig e)) (map toOrig scl)
  toOrig (Switch ss Nothing scl) = D.Switch (toOrig ss) Nothing (map toOrig scl)
  toOrig (For fcl s) = D.For (toOrig fcl) (toOrig s)
  toOrig Break = D.Break o
  toOrig Continue = D.Continue o
  toOrig (Declare d) = D.Declare (toOrig d)
  toOrig (Print el) = D.Print (map toOrig el)
  toOrig (Println el) = D.Println (map toOrig el)
  toOrig (Return (Just e)) = D.Return o (Just (toOrig e))
  toOrig (Return Nothing) = D.Return o Nothing

instance ConvertAST SwitchCase D.SwitchCase where
  toOrig (Case nle s) = D.Case o (NE.map toOrig nle) (toOrig s)
  toOrig (Default s)  = D.Default o (toOrig s)

instance ConvertAST ForClause D.ForClause where
  toOrig (ForClause ss1 (Just e) ss2) =
    D.ForClause (toOrig ss1) (Just (toOrig e)) (toOrig ss2)
  toOrig (ForClause ss1 Nothing ss2) =
    D.ForClause (toOrig ss1) Nothing (toOrig ss2)

instance ConvertAST Expr D.Expr where
  toOrig (Unary _ op e) = D.Unary o (toOrig op) (toOrig e)
  toOrig (Binary _ op e1 e2) = D.Binary o (toOrig op) (toOrig e1) (toOrig e2)
  toOrig (Lit lit) = D.Lit (toOrig lit)
  toOrig (Var _ si) = D.Var (si2ident si)
  toOrig (AppendExpr _ e1 e2) = D.AppendExpr o (toOrig e1) (toOrig e2)
  toOrig (LenExpr e) = D.LenExpr o (toOrig e)
  toOrig (CapExpr e) = D.CapExpr o (toOrig e)
  toOrig (Selector _ e (Ident vname)) =
    D.Selector o (toOrig e) (D.Identifier o vname)
  toOrig (Index _ e1 e2) = D.Index o (toOrig e1) (toOrig e2)
  toOrig (Arguments _ e el) = D.Arguments o (toOrig e) (map toOrig el)

instance ConvertAST Literal D.Literal where
  toOrig (IntLit i)    = D.IntLit o D.Decimal (show i)
  toOrig (FloatLit f)  = D.FloatLit o (show f)
  toOrig (RuneLit c)   = D.RuneLit o (show c)
  toOrig (StringLit s) = D.StringLit o D.Interpreted s

instance ConvertAST BinaryOp D.BinaryOp where
  toOrig op =
    case op of
      Or             -> D.Or
      And            -> D.And
      Arithm aop     -> D.Arithm (toOrig aop)
      CheckedData.EQ -> D.EQ
      NEQ            -> D.NEQ
      CheckedData.LT -> D.LT
      LEQ            -> D.LEQ
      CheckedData.GT -> D.GT
      GEQ            -> D.GEQ

instance ConvertAST ArithmOp D.ArithmOp where
  toOrig op =
    case op of
      Add       -> D.Add
      Subtract  -> D.Subtract
      BitOr     -> D.BitOr
      BitXor    -> D.BitXor
      Multiply  -> D.Multiply
      Divide    -> D.Divide
      Remainder -> D.Remainder
      ShiftL    -> D.ShiftL
      ShiftR    -> D.ShiftR
      BitAnd    -> D.BitAnd
      BitClear  -> D.BitClear

instance ConvertAST UnaryOp D.UnaryOp where
  toOrig op =
    case op of
      Pos           -> D.Pos
      Neg           -> D.Neg
      Not           -> D.Not
      BitComplement -> D.BitComplement

instance ConvertAST AssignOp D.AssignOp where
  toOrig (AssignOp (Just op)) = D.AssignOp (Just (toOrig op))
  toOrig (AssignOp Nothing)   = D.AssignOp Nothing

instance ConvertAST Type D.Type' where
  toOrig t = (o, toOrig t)

instance ConvertAST Type D.Type where
  toOrig (ArrayType i t) =
    D.ArrayType (D.Lit (D.IntLit o D.Decimal (show i))) (toOrig t)
  toOrig (SliceType t) = D.SliceType (toOrig t)
  toOrig (StructType fdl) = D.StructType (map toOrig fdl)
  toOrig PInt = D.Type (D.Identifier o "int")
  toOrig PFloat64 = D.Type (D.Identifier o "float64")
  toOrig PBool = D.Type (D.Identifier o "bool")
  toOrig PRune = D.Type (D.Identifier o "rune")
  toOrig PString = D.Type (D.Identifier o "string")

instance ConvertAST FieldDecl D.FieldDecl where
  toOrig (FieldDecl (Ident vname) t) =
    D.FieldDecl (D.Identifier o vname :| []) (toOrig t)

instance Prettify Program where
  prettify' p = prettify' (toOrig p :: D.Program)
