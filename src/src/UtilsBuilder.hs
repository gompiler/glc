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
generateUtils categories = map unpack $ (generateUtils' =<< categories) ++ [primitiveArrayTemplate "int", primitiveSliceTemplate "int"]

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

generateSlice :: String -> Int -> Text
generateSlice baseClass depth =
  generateSlice'
    (pack currClass)
    (pack parentClass)
    (pack constructorInfo)
    (pack constructorBody)
  where
    generateSlice' :: Text -> Text -> Text -> Text -> Text
    generateSlice' currClass' parentClass' constructorInfo' constructorBody' =
      [text|
      package glcutils;

      public static class $currClass' extends GlcArray<GlcSlice$String$1> {

          public $currClass'() {
              this(0, null);
          }

          public $currClass'(int length, GlcSlice$String$1[] array) {
              super(GlcSlice$String$1.class, length, array);
          }

          public $currClass' append(GlcSlice$String$1 s) {
              GlcSlice$String$1[] newArray = GlcSliceUtils.append(this.clazz, this.array, this.length, s);
              return new $currClass'(length + 1, newArray);
          }

      }
      |]
    currClass = sliceClass depth
    parentClass = sliceClass (depth - 1)
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

sliceClass :: Int -> String
sliceClass 0 = arrayClass 1
sliceClass i = "GlcSlice_" ++ baseClass ++ "_" ++ show i
