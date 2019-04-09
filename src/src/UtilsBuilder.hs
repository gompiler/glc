{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE QuasiQuotes    #-}

module UtilsBuilder
  ( generateUtils
  , Type(..)
  , Category(..)
  ) where

import           Data.List         (intercalate)
import           Data.Maybe        (catMaybes, fromMaybe)
import           Data.Text         (Text, pack, unpack)
import           NeatInterpolation

data Type
  = Custom String
  | PInt

data Category = Category
  { baseType   :: Type
  , arrayDepth :: Int
  , sliceDepth :: Int
  }

generateUtils :: [Category] -> [String]
generateUtils categories = map unpack $ generateUtils' =<< categories

generateUtils' :: Category -> [Text]
generateUtils' Category {baseType = Custom baseClass, arrayDepth, sliceDepth} =
  map (generateArray baseClass) [arrayDepth]
generateUtils' _ = undefined

generateArray :: String -> Int -> Text
generateArray baseClass depth =
  generateArray'
    (pack currClass)
    (pack parentClass)
    (pack constructorInfo)
    (pack constructorBody)
  where
    generateArray' :: Text -> Text -> Text -> Text -> Text
    generateArray' currClass' parentClass' constructorInfo' constructorBody' =
      [text|
      package glcutils;

      public class $currClass' extends GlcArray<$parentClass'> {

          public $currClass'($constructorInfo') {
              super($constructorBody');
          }

      }
      |]
    currClass = arrayClass depth
    parentClass = arrayClass (depth - 1)
    constructorInfo :: String
    constructorInfo =
      intercalate ", " $ map (\i -> "int length" ++ show i) [1 .. depth]
    constructorBody :: String
    constructorBody =
      intercalate ", " $
      catMaybes [supplier] ++ [parentClass ++ ".class", "length" ++ show depth]
    supplier :: Maybe String
    supplier =
      case (baseClass, depth) of
        ("String", 1) -> Just "() -> null"
        (_, 1) -> Nothing
        _ ->
          Just $
          "() -> new " ++
          parentClass ++
          "(" ++
          intercalate ", " (map (\i -> "length" ++ show i) [1 .. depth - 1]) ++
          ")"
    arrayClass :: Int -> String
    arrayClass 0 = baseClass
    arrayClass i = "GlcArray_" ++ baseClass ++ "_" ++ show i
