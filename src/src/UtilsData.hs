module UtilsData
  ( Type(..)
  , Field(..)
  , BaseType(..)
  , Category(..)
  , toBase
  , arrayClassName
  , sliceClassName
  , className
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
toBase type' =
  case type' of
    ArrayType t l  -> Custom $ arrayClassName (toBase t) (length l)
    SliceType t i  -> Custom $ sliceClassName (toBase t) i
    Base t         -> t
    StructType i _ -> Custom i

-- | Generate the name of the array class
-- Note that the depth should start at 1 to represent 1D array
-- For convenience, depth 0 returns the base class, as that will be the generic type
arrayClassName :: BaseType -> Int -> String
arrayClassName t depth =
  if depth == 0
    then className t
    else "GlcArray$" ++ className t ++ "_" ++ show depth

-- | Generate the name of the slice class
-- Note that the depth should start at 1 to represent 1D slice
-- For convenience, depth 0 returns the base class, as that will be the generic type
sliceClassName :: BaseType -> Int -> String
sliceClassName t depth =
  if depth == 0
    then className t
    else "GlcSlice$" ++ className t ++ "_" ++ show depth

-- | Class name of base types
-- Keep in sync with generated java files
className :: BaseType -> String
className (Custom s) = s
className PInt       = "Int"
className PFloat64   = "Float"
className PBool      = "Bool"
className PRune      = "Char"
className PString    = "String"

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
  deriving (Show, Eq, Ord)

data Category = Category
  { baseType   :: BaseType
  , arrayDepth :: Int
  , sliceDepth :: Int
  } deriving (Show, Eq, Ord)
