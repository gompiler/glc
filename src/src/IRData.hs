-- | Data mapping for Java IR
-- Sources:
-- http://jasmin.sourceforge.net/instructions.html
-- https://en.wikibooks.org/wiki/Java_Programming/Byte_Code
-- https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html
-- https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings
-- https://www.guardsquare.com/en/blog/string-concatenation-java-9-untangling-invokedynamic
module IRData where

type LabelName = String

data FieldAccess
  = FPublic
  | FPrivate
  | FProtected
  | FStatic
  | FFinal
  | FVolatile
  | FTransient

instance Show FieldAccess where
  show FPublic    = "public"
  show FPrivate   = "private"
  show FProtected = "protected"
  show FStatic    = "static"
  show FFinal     = "final"
  show FVolatile  = "volatile"
  show FTransient = "transient"

data Field = Field
  { access     :: FieldAccess
  , fname      :: String
  , descriptor :: String
  -- , value :: LDCType TODO?
  } deriving (Show)

data Class = Class
  { cname   :: String
  , fields  :: [Field]
  , methods :: [Method]
  } deriving (Show)

data Method = Method
  { mname       :: String
  , stackLimit  :: Int
  , localsLimit :: Int
  , body        :: [IRItem]
  } deriving (Show)

newtype ClassRef =
  ClassRef String
  deriving (Show)

data FieldRef =
  FieldRef ClassRef
           String
  deriving (Show)

data MethodRef =
  MethodRef ClassRef
            String
            [JType]
            JType

instance Show MethodRef where
  show (MethodRef (ClassRef cn) mn tl t) =
    "Method " ++
    cn ++ " " ++ mn ++ " (" ++ concat (map show tl) ++ ")" ++ show t

data JType
  = JClass ClassRef -- Lwhatever;
  | JInt -- I
  | JFloat -- F
  | JBool -- Z
  | JVoid -- V

instance Show JType where
  show (JClass (ClassRef cn)) = "L" ++ cn ++ ";"
  show JInt                   = "I"
  show JFloat                 = "F"
  show JBool                  = "Z"
  show JVoid                  = "V"

data IRItem
  = IRInst Instruction
  | IRLabel LabelName
  deriving (Show)

data IRPrimitive
  = IRInt -- Integers, booleans, runes
  | IRFloat -- Float64s
  deriving (Show)

data IRType
  = Prim IRPrimitive -- Integer, boolean, rune, float64
  | Object -- String, array, struct, slice
  deriving (Show)

data LDCType
  = LDCInt Int -- Integers, booleans, runes
  | LDCFloat Float -- Float64s
  | LDCString String -- Strings
  deriving (Show)

data Instruction
  = Load IRType
         Int
  | Store IRType
          Int
  | Return (Maybe IRType)
  | Dup
  | Goto LabelName
  | Add IRPrimitive
  | Div IRPrimitive -- TODO: Turn into Op instruction?
  | Mul IRPrimitive
  | Neg IRPrimitive
  | Sub IRPrimitive
  | IRem
  | IShL
  | IShR
  | IALoad
  | IAnd
  | IAStore
  | IfEq LabelName
  | IOr
  | IXOr
  | LDC LDCType -- pushes an int/float/string value onto the stack
  | New ClassRef -- class
  | NOp
  | Pop
  | Swap
  | GetStatic FieldRef
              ClassRef -- field spec, descriptor
  | InvokeSpecial MethodRef -- method spec
  | InvokeVirtual MethodRef -- method spec
  | Debug String -- TODO: remove
  deriving (Show)

-- Predefined Java language constructs to use in code generation
systemOut :: FieldRef
systemOut = FieldRef (ClassRef "java/lang/System") "out"

printStream :: ClassRef
printStream = ClassRef "java/io/PrintStream"

stringBuilder :: ClassRef
stringBuilder = ClassRef "java/lang/StringBuilder"

jString :: ClassRef
jString = ClassRef "java/lang/String"
