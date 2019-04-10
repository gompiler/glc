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

arrayClassName :: BaseType -> Int -> String
arrayClassName baseType depth =
  "GlcArray$$" ++ className baseType ++ "$$" ++ show depth

sliceClassName :: BaseType -> Int -> String
sliceClassName baseType depth =
  "GlcSlice" ++ className baseType ++ "$$" ++ show depth

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
  deriving (Show, Eq)

data Category = Category
  { baseType   :: BaseType
  , arrayDepth :: Int
  , sliceDepth :: Int
  } deriving (Show, Eq)
