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
generateUtils categories = map unpack $ (generateUtils' =<< categories) ++ [primitiveArrayTemplate "int"]

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

primitiveArrayTemplate :: String -> Text
primitiveArrayTemplate className = primitiveArrayTemplate' (pack className)
  where
    primitiveArrayTemplate' :: Text -> Text
    primitiveArrayTemplate' baseClass =
      [text|
      package glcutils;

      import java.util.Arrays;

      public class Glc${baseClass}Array {
          int length;
          ${baseClass}[] array;

          public Glc${baseClass}Array(int length) {
              this(length, null);
          }

          Glc${baseClass}Array(int length, ${baseClass}[] array) {
              this.length = length;
              this.array = array;
          }

          /**
           * Ensures that array is nonnull
           */
          final void init() {
              if (array == null) {
                  array = new ${baseClass}[length];
              }
          }

          /**
           * Return nonnull struct if index is within bounds
           */
          public final ${baseClass} get(int i) {
              init();
              return array[i];
          }

          /**
           * Set new struct value at specified index if it is within bounds
           */
          public final void set(int i, ${baseClass} t) {
              init();
              array[i] = t;
          }

          /**
           * Gets the length of the array, representative of the number of elements
           * stored
           */
          public final int length() {
              return length;
          }

          /**
           * Gets the capacity of the array, representative of the number of elements
           * that can be stored
           */
          public final int capacity() {
              return array == null ? 0 : array.length;
          }

          @Override
          public boolean equals(Object obj) {
              if (this == obj) {
                  return true;
              }
              if (obj == null || obj.getClass() != getClass()) {
                  return false;
              }
              Glc${baseClass}Array other = (Glc${baseClass}Array) obj;
              if (length != other.length) {
                  return false;
              }
              if (array == other.array) {
                  return true;
              }
              init();
              other.init();
              return Arrays.equals(array, other.array);
          }

          @Override
          public int hashCode() {
              return Arrays.hashCode(array);
          }

          @Override
          public String toString() {
              return Arrays.toString(array);
          }
      }
      |]
