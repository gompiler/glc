{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
module Prettify where

import           Data
import           Data.List          (intercalate)
import           Data.List.NonEmpty (NonEmpty (..))

class Prettify a where
  prettify :: a -> String
  prettify = unlines . prettify'
  prettify' :: a -> [String]

instance Prettify Identifier where
  prettify' (Identifier _ id) = [id]

instance Prettify Identifiers where
  prettify' ids = [intercalate ", " $ map prettify ids]

instance Prettify Program where
  prettify' Program {package = package, topLevels = topLevels} = ("package " ++ package ++ "\n") : prettify' topLevels

instance Prettify TopDecl where
  prettify' (TopDecl decl)     = prettify' decl
  prettify' (TopFuncDecl decl) = prettify' decl

instance Prettify Decl where
  prettify' (VarDecl [decl]) = ["var " ++ prettify decl]
  prettify' (VarDecl decls)  = "var (" : tab (map prettify decls) ++ [")"]

--  prettify' (TypeDef defs) = [intercalate ", " $ map prettify decls]
--instance Prettify VarDecl' where
--  prettify' (VarDecl' ids) (Left (t, exprs)) = []

tab :: [String] -> [String]
tab = map ("\t" ++)
