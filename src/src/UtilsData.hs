module UtilsData
  ( Type(..)
  , Field(..)
  , BaseType(..)
  , Category(..)
  ) where

data Type
  -- | Flattened array type
  -- With size for each depth
  = ArrayType BaseType
              [Int]
  -- | Flattened slice type
  -- With depth
  | SliceType BaseType
              Int
  | Base BaseType
  | StructType String
               [Field]
  deriving (Show, Eq)

-- | See https://golang.org/ref/spec#FieldDecl
-- Golite does not support embedded fields
-- Note that these fields aren't scope related
data Field =
  Field String
        Type
  deriving (Show, Eq)

data BaseType
  = Custom String
  | PInt
  | PFloat64
  | PBool
  | PRune
  | PString
  deriving (Show, Eq)

data Category = Category
  { baseType   :: BaseType
  , arrayDepth :: Int
  , sliceDepth :: Int
  }
  deriving (Show, Eq)
