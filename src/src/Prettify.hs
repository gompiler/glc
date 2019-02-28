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

instance Prettify ParameterDecl

instance Prettify Parameters where
  prettify (Parameters params) = intercalate ", " $ map prettify params

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

instance Prettify Stmt

instance Prettify SwitchCase

instance Prettify ForClause

instance Prettify (NonEmpty Expr)

instance Prettify Expr

instance Prettify Literal where
  prettify (IntLit _ i)              = i
  prettify (FloatLit f)              = show f
  prettify (RuneLit c)               = "'" ++ [c] ++ "'"
  prettify (StringLit Interpreted s) = "\"" ++ s ++ "\""
  prettify (StringLit Raw s)         = "`" ++ s ++ "`"
  prettify' = prettify''

--  prettify' (FuncLit sig body)         = ["func" ++ prettify sig]
instance Prettify BinaryOp

instance Prettify ArithmOp

instance Prettify UnaryOp

instance Prettify AssignOp

instance Prettify IntType'

instance Prettify StringType'

instance Prettify Type'

instance Prettify Type

instance Prettify StringLiteral

instance Prettify FieldDecl
--  prettify'
