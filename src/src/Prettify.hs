{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Prettify
  ( Prettify(..)
  ) where

import           Data
import           Data.List          (intercalate, intersperse, null)
import           Data.List.NonEmpty (NonEmpty (..), toList)
import qualified Data.Maybe         as Maybe

tab :: [String] -> [String]
tab = map ("\t" ++)

tabP :: Prettify a => a -> String
tabP a = "\t" ++ prettify a

-- Prettify, but enforces a single line
prettify1 :: Prettify a => a -> String
prettify1 = unwords . prettify'

-- | Some prettified components span a single line
-- In that case, we can implement prettify by default
-- And use this function to derive the list format from the string format
prettify'' :: Prettify a => a -> [String]
prettify'' item = [prettify item]

class Prettify a where
  prettify :: a -> String
  prettify = intercalate "\n" . prettify'
  prettify' :: a -> [String]

instance Prettify Identifier where
  prettify (Identifier _ id) = id
  prettify' = prettify''

instance Prettify Identifiers where
  prettify ids = intercalate ", " $ map prettify $ toList ids
  prettify' = prettify''

instance Prettify Program where
  prettify' Program {package = package, topLevels = topLevels} =
    ("package " ++ package ++ "\n") : intersperse "\n" (topLevels >>= prettify')

instance Prettify TopDecl where
  prettify' (TopDecl decl)     = prettify' decl
  prettify' (TopFuncDecl decl) = prettify' decl

instance Prettify Decl where
  prettify' (VarDecl [decl]) = ["var " ++ prettify decl]
  prettify' (VarDecl decls)  = "var (" : tab (map prettify decls) ++ [")"]

--  prettify' (TypeDef defs) = [intercalate ", " $ map prettify decls]
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

instance Prettify FuncDecl
  -- TODO move brace onto same line as signature
                                                 where
  prettify' (FuncDecl id sig body) = ("func " ++ prettify id) : prettify' sig ++ ["{"] ++ tab (prettify' body) ++ ["}"]

instance Prettify ParameterDecl where
  prettify (ParameterDecl ids t) = prettify ids ++ " " ++ prettify t
  prettify' = prettify''

instance Prettify Parameters where
  prettify (Parameters params) = intercalate ", " $ map prettify params
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
  prettify' (If (cs, ce) i e) = ("if " ++ cs' ++ ce' ++ "{") : i' ++ e'
    where
      cs' =
        if cs == EmptyStmt
          then ""
          else prettify cs ++ "; "
      ce' = prettify ce
      i' = tab $ prettify' i
      e' =
        case e
          -- todo put if on same line
              of
          If {} -> "} else" : prettify' e ++ ["}"]
          _     -> "} else {" : tab (prettify' e) ++ ["}"]
  prettify' (Switch ss se cases) = ("switch " ++ ss' ++ "{") : tab (cases >>= prettify') ++ ["}"]
    where
      ss' =
        case (ss, se) of
          (EmptyStmt, _) -> Maybe.maybe "" prettify se ++ " "
          (_, Nothing)   -> prettify ss ++ " "
          (_, Just se')  -> prettify ss ++ "; " ++ prettify se' ++ " "

instance Prettify SwitchCase

instance Prettify ForClause

instance Prettify (NonEmpty Expr)

instance Prettify Expr

instance Prettify Literal where
  prettify (IntLit _ _ i) = i
  prettify (FloatLit _ f) = show f
  prettify (RuneLit _ c)  = "'" ++ [c] ++ "'"
  prettify (StringLit s)  = prettify s
  prettify' = prettify''

--  prettify' (FuncLit sig body)         = ["func" ++ prettify sig]
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
  prettify (ArrayType e t) = "[" ++ prettify e ++ "]" ++ prettify t
  prettify (SliceType t)   = "[]" ++ prettify t
  prettify (PointerType t) = "*" ++ prettify t
  prettify (FuncType s)    = "func" ++ prettify s
  prettify (Type id)       = prettify id
  prettify' = prettify''

instance Prettify StringLiteral where
  prettify (StringLiteral _ Interpreted s) = "\"" ++ s ++ "\""
  prettify (StringLiteral _ Raw s)         = "`" ++ s ++ "`"
  prettify' = prettify''

instance Prettify FieldDecl where
  prettify (FieldDecl ids t)   = prettify ids ++ " " ++ prettify t
  prettify (EmbeddedField ids) = prettify ids
  prettify' = prettify''
