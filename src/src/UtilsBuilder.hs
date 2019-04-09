{-# LANGUAGE NamedFieldPuns #-}

module UtilsBuilder
  ( generateUtils
  , Type(..)
  , Category(..)
  ) where

import           Data.List (intercalate)
import           IRConv
import           IRData

data Type
  = Custom String
  | PInt

data Category = Category
  { baseType   :: Type
  , arrayDepth :: Int
  , sliceDepth :: Int
  }

generateUtils :: [Category] -> [Class]
generateUtils categories = generateUtils' =<< categories

generateUtils' :: Category -> [Class]
generateUtils' Category {baseType = Custom baseClass, arrayDepth, sliceDepth} =
  undefined
generateUtils' _ = undefined
