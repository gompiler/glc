{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Prettify
  ( Prettify(..)
  ) where

import           Data
import           Data.List          (dropWhileEnd, intercalate, intersperse,
                                     null)
import           Data.List.NonEmpty (NonEmpty (..), toList)
import qualified Data.Maybe         as Maybe
import           Data.Text          (strip)
import           GHC.Unicode        (isSpace)

tab :: [String] -> [String]
tab = map ("\t" ++)

commaJoin :: Prettify a => [a] -> String
commaJoin p = intercalate ", " $ map prettify p

-- | Joins last line of first list with first line of last list with a space
skipNewLine :: [String] -> [String] -> [String]
[] `skipNewLine` a = a
a `skipNewLine` [] = a
[a] `skipNewLine` (b:b') = (a ++ " " ++ b) : b'
(a:a') `skipNewLine` b = a : a' `skipNewLine` b

-- | Some prettified components span a single line
-- In that case, we can implement prettify by default
-- And use this function to derive the list format from the string format
prettify'' :: Prettify a => a -> [String]
prettify'' item = [prettify item]

-- | TODO: Replace this

class Prettify a where
  prettify :: a -> String
  prettify = intercalate "\n" . prettify'
  prettify' :: a -> [String]

instance Prettify Identifier where
  prettify (Identifier _ id) = id
  prettify' = prettify''

instance Prettify Identifiers where
  prettify ids = commaJoin $ toList ids
  prettify' = prettify''

instance Prettify Program where
  prettify' Program {package = package, topLevels = topLevels} =
    ("package " ++ package ++ "\n") : (topLevels >>= prettify')

instance Prettify TopDecl where
  prettify' (TopDecl decl)     = prettify' decl
  prettify' (TopFuncDecl decl) = prettify' decl

instance Prettify Decl where
  prettify' (VarDecl [decl]) = ["var " ++ prettify decl]
  prettify' (VarDecl decls)  = "var (" : tab (map prettify decls) ++ [")"]
  prettify' (TypeDef [def])  = ["type " ++ prettify def]
  prettify' (TypeDef defs)   = "type (" : tab (map prettify defs) ++ [")"]

instance Prettify VarDecl' where
  prettify (VarDecl' ids (Left (t, exprs))) = prettify ids ++ " " ++ prettify t ++ exprs'
    where
      exprs' =
        if null exprs
          then ""
          else " = " ++ intercalate ", " (map prettify exprs)
  prettify (VarDecl' ids (Right exprs)) = prettify ids ++ " = " ++ intercalate ", " (map prettify $ toList exprs)
  prettify' = prettify''

instance Prettify TypeDef' where
  prettify (TypeDef' id t) = prettify id ++ " = " ++ prettify t
  prettify' = prettify''

instance Prettify FuncDecl where
  prettify' (FuncDecl id sig body) =
    [("func " ++ prettify id)] `skipNewLine` (prettify' sig `skipNewLine` ["{"]) ++ tab (prettify' body) ++ ["}"]

instance Prettify ParameterDecl where
  prettify (ParameterDecl ids t) = prettify ids ++ " " ++ prettify t
  prettify' = prettify''

instance Prettify Parameters where
  prettify (Parameters params) = commaJoin params
  prettify' = prettify''

instance Prettify Signature where
  prettify' (Signature params t) = ["(" ++ prettify params ++ ")" ++ Maybe.maybe "" prettify t]

--instance Prettify Scope
instance Prettify SimpleStmt where
  prettify' EmptyStmt = []
  prettify' (ExprStmt e) = prettify' e
  prettify' (Increment _ e) = ["(" ++ prettify e ++ ")++"]
  prettify' (Decrement _ e) = ["(" ++ prettify e ++ ")--"]
  prettify' (Assign _ op e1 e2) = [prettify e1 ++ " " ++ prettify op ++ " " ++ prettify e2]
  prettify' (ShortDeclare ids exprs) = [prettify ids ++ " := " ++ prettify exprs]

instance Prettify Stmt where
  prettify' (BlockStmt stmts) = stmts >>= prettify'
  prettify' (SimpleStmt s) = prettify' s
  prettify' (If c i e) = ("if " ++ prettify c ++ " {") : i' ++ e'
    where
      i' = tab $ prettify' i
      e' =
        case e of
          If {} -> ["} else"] `skipNewLine` prettify' e -- Else If
          SimpleStmt EmptyStmt -> ["}"] -- No real else block, don't print anything
          _     -> "} else {" : tab (prettify' e) ++ ["}"]
  prettify' (Switch ss se cases) = ("switch " ++ ss' ++ "{") : tab (cases >>= prettify') ++ ["}"]
    where
      ss' =
        case se of
          Just se' -> prettify (ss, se')
          Nothing  -> prettify ss
  prettify' (For fc s) = ("for " ++ (prettify fc) ++ " {") : (tab $ prettify' s) ++ ["}"]
  prettify' (Break _) = ["break"]
  prettify' (Continue _) = ["continue"]
  prettify' (Fallthrough _) = ["fallthrough"]
  prettify' (Declare d) = prettify' d
  prettify' (Print es) = ["print(" ++ concat(intersperse ", " (es >>= prettify')) ++ ")"]
  prettify' (Println es) = ["println(" ++ concat(intersperse ", " (es >>= prettify')) ++ ")"]
  prettify' (Return m) = ["return"] `skipNewLine` (maybe [] (prettify') m)

instance Prettify SwitchCase where
  prettify' (Case _ e s)  = ("case " ++ prettify e ++ ":") : tab (prettify' s)
  prettify' (Default _ s) = "default:" : tab (prettify' s)

instance Prettify (SimpleStmt, Expr) where
  prettify (EmptyStmt, e) = prettify e
  prettify (s, e)         = prettify s ++ "; " ++ prettify e
  prettify' = prettify''

instance Prettify ForClause where
  prettify ForInfinite         = ""
  prettify (ForCond e)         = prettify e
  prettify (ForClause cs ce s) = (prettify cs) ++ "; " ++ (prettify ce) ++ "; " ++ (prettify s)
  prettify' = prettify''

instance Prettify (NonEmpty Expr) where
  prettify e = commaJoin $ toList e
  prettify' = prettify''

instance Prettify Expr where
  prettify (Unary _ o e) = "(" ++ prettify o ++ prettify e ++ ")"
  prettify (Binary _ o e1 e2) = "(" ++ prettify e1 ++ " " ++ prettify o ++ " " ++ prettify e2 ++ ")"
  prettify (Lit l) = prettify l
  prettify (Var i) = prettify i
  prettify (AppendExpr _ e1 e2) = "append(" ++ prettify e1 ++ ", " ++ prettify e2 ++ ")"
  prettify (LenExpr _ e) = "len(" ++ prettify e ++ ")"
  prettify (CapExpr _ e) = "cap(" ++ prettify e ++ ")"
  prettify (Conversion _ t e) = prettify t ++ "(" ++ prettify e ++ ")"
  prettify (Selector _ e i) = prettify e ++ "." ++ prettify i
  prettify (Index _ e1 e2) = prettify e1 ++ "[" ++ prettify e2 ++ "]"
  prettify (TypeAssertion _ e t) = prettify e ++ ".(" ++ prettify t ++ ")"
  prettify (Arguments _ e ee) = prettify e ++ "(" ++ commaJoin ee ++ ")"
  prettify' = prettify''

instance Prettify Literal where
  prettify (IntLit _ _ i)              = i
  prettify (FloatLit _ f)              = show f
  prettify (RuneLit _ c)               = "'" ++ [c] ++ "'"
  -- Quotes within string s
  prettify (StringLit _ Interpreted s) = s
  -- Quotes within string s
  prettify (StringLit _ Raw s)         = s
  prettify' = prettify''

instance Prettify BinaryOp where
  prettify Or         = "||"
  prettify And        = "||"
  prettify (Arithm o) = prettify o
  prettify Data.EQ    = "=="
  prettify NEQ        = "!="
  prettify Data.LT    = "<"
  prettify LEQ        = "<="
  prettify Data.GT    = ">"
  prettify GEQ        = ">="
  prettify' = prettify''

instance Prettify ArithmOp where
  prettify Add       = "+"
  prettify Subtract  = "-"
  prettify BitOr     = "|"
  prettify BitXor    = "^"
  prettify Multiply  = "*"
  prettify Divide    = "/"
  prettify Remainder = "%"
  prettify ShiftL    = "<<"
  prettify ShiftR    = ">>"
  prettify BitAnd    = "&"
  prettify BitClear  = "&^"
  prettify' = prettify''

instance Prettify UnaryOp where
  prettify Pos           = "+"
  prettify Neg           = "-"
  prettify Not           = "!"
  prettify BitComplement = "^"
  prettify' = prettify''

instance Prettify AssignOp where
  prettify (AssignOp op) = Maybe.maybe "" prettify op ++ "="
  prettify' = prettify''

instance Prettify IntType' where
  prettify' _ = []

instance Prettify StringType' where
  prettify' _ = []

instance Prettify Type' where
  prettify (_, t) = prettify t
  prettify' = prettify''

instance Prettify Type where
  prettify (ArrayType e t)    = "[" ++ prettify e ++ "]" ++ prettify t
  prettify (StructType [fdl]) = "struct {" ++ prettify fdl ++ "}"
  -- prettify' (StructType fdls) = "struct {" : tab (map prettify fdls) ++ "}"
  prettify (SliceType t)      = "[]" ++ prettify t
  prettify (PointerType t)    = "*" ++ prettify t
  prettify (FuncType s)       = "func" ++ prettify s
  prettify (Type id)          = prettify id
  prettify' = prettify''

instance Prettify FieldDecl where
  prettify (FieldDecl ids t)   = prettify ids ++ " " ++ prettify t
  prettify (EmbeddedField ids) = prettify ids
  prettify' = prettify''
