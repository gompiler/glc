module UtilsData
  ( Type(..)
  , Field(..)
  , BaseType(..)
  , Category(..)
  , toBase
  ) where

data Type
  -- | Flattened array type
  -- With size for each depth
  = ArrayType Type
              [Int]
  -- | Flattened slice type
  -- With depth
  | SliceType Type
              Int
  | Base BaseType
  | StructType String
               [Field]
  deriving (Show, Eq)

toBase :: Type -> BaseType
toBase = undefined

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
