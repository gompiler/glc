-- | Data mapping for Java IR
-- Sources:
-- http://jasmin.sourceforge.net/instructions.html
-- https://en.wikibooks.org/wiki/Java_Programming/Byte_Code
-- https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html
-- https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings
-- https://www.guardsquare.com/en/blog/string-concatenation-java-9-untangling-invokedynamic
-- http://www.cs.sjsu.edu/~pearce/modules/lectures/co/jvm/jasmin/demos/demos.html
-- http://homepages.inf.ed.ac.uk/kwxm/JVM/fcmpg.html
-- https://stackoverflow.com/questions/43782187/why-does-go-have-a-bit-clear-and-not-operator
module IRData where

import           ResourceData (VarIndex)

type LabelName = String

data FieldAccess
  = FPublic
  | FPrivate
  | FProtected
  deriving (Eq)

instance Show FieldAccess where
  show FPublic    = "public"
  show FPrivate   = "private"
  show FProtected = "protected"

newtype MethodSpec =
  MethodSpec ([JType], JType)
  deriving (Show, Eq)

data Field = Field
  { access     :: FieldAccess
  , static     :: Bool
  , fname      :: String
  , descriptor :: JType
  -- , value :: LDCType TODO?
  } deriving (Show, Eq)

data Class = Class
  { cname   :: String
  , fields  :: [Field]
  , methods :: [Method]
  } deriving (Show, Eq)

data Method = Method
  { mname       :: String
  , stackLimit  :: Int
  , localsLimit :: Int
  , spec        :: MethodSpec
  , body        :: [IRItem]
  } deriving (Show, Eq)

newtype ClassRef =
  ClassRef String
  deriving (Show, Eq)

data ClassOrArrayRef
  = CRef ClassRef
  | ARef JType
  deriving (Show, Eq)

data FieldRef =
  FieldRef ClassRef
           String
  deriving (Show, Eq)

data MethodRef =
  MethodRef ClassOrArrayRef
            String
            MethodSpec
  deriving (Eq)

instance Show MethodRef where
  show (MethodRef (CRef (ClassRef cn)) mn (MethodSpec (tl, t))) =
    "Method " ++ cn ++ " " ++ mn ++ " (" ++ concatMap show tl ++ ")" ++ show t
  show (MethodRef (ARef jt) mn (MethodSpec (tl, t))) =
    "Method [" ++
    show jt ++ " " ++ mn ++ " (" ++ concatMap show tl ++ ")" ++ show t

data JType
  = JClass ClassRef -- Lwhatever;
  | JArray JType -- [ as a prefix, ex. [I
  | JChar -- C
  | JInt -- I
  | JDouble -- D
  | JBool -- Z
  | JVoid -- V
  deriving (Eq)

instance Show JType where
  show (JClass (ClassRef cn)) = "L" ++ cn ++ ";"
  show (JArray jt)            = "[" ++ show jt
  show JChar                  = "C"
  show JInt                   = "I"
  show JDouble                = "D"
  show JBool                  = "Z"
  show JVoid                  = "V"

data IRItem
  = IRInst Instruction
  | IRLabel LabelName
  deriving (Show, Eq)

data IRPrimitive
  = IRInt -- Integers, booleans, runes
  | IRDouble -- Float64s
  deriving (Show, Eq)

data IRType
  = Prim IRPrimitive -- Integer, boolean, rune, float64
  | Object -- String, array, struct, slice
  deriving (Show, Eq)

data IRCmp
  = LT
  | LE
  | GT
  | GE
  | EQ
  | NE
  deriving (Eq)

instance Show IRCmp where
  show IRData.LT = "lt"
  show LE        = "le"
  show IRData.GT = "gt"
  show GE        = "ge"
  show IRData.EQ = "eq"
  show NE        = "ne"

data LDCType
  = LDCInt Int -- Integers, booleans, runes
  | LDCDouble Float -- Float64s
  | LDCString String -- Strings
  | LDCClass ClassRef -- Class constants
  deriving (Show, Eq)

data Instruction
  = Load IRType
         VarIndex
  | ArrayLoad IRType -- consumes an object reference and an index
  | Store IRType
          VarIndex
  | ArrayStore IRType -- consumes an object reference and an index
  | Return (Maybe IRType)
  | Dup
  | Dup2 -- ..., v, w -> ..., v, w, v, w
  | DupX1
  | Dup2X2
  | Goto LabelName
  | Add IRPrimitive
  | Div IRPrimitive
  | Mul IRPrimitive
  | Neg IRPrimitive
  | Sub IRPrimitive
  | IRem
  | IShL
  | IShR
  | IAnd
  | IOr
  | IXOr
  | IntToDouble
  | If IRCmp
       LabelName
  | IfICmp IRCmp
           LabelName
  | LDC LDCType -- pushes an int/double/string value onto the stack
  | IConstM1 -- -1
  | IConst0 -- 0
  | IConst1 -- 1
  | DCmpG -- Same: 0, Second greater: 1, First greater: -1; 1 on NAN
  | New ClassRef -- class
  | CheckCast ClassOrArrayRef
  | ANewArray ClassRef
  | MultiANewArray JType
                   Int
  | NewArray IRPrimitive
  | NOp
  | Pop
  | Pop2
  | Swap
  | GetStatic FieldRef
              JType -- field spec, descriptor
  | GetField FieldRef
             JType
  | PutStatic FieldRef
              JType
  | PutField FieldRef
             JType
  | InvokeSpecial MethodRef -- method spec
  | InvokeVirtual MethodRef -- method spec
  | InvokeStatic MethodRef
  | Debug String -- TODO: remove
  deriving (Show, Eq)

-- Predefined Java language constructs to use in code generation
systemOut :: FieldRef
systemOut = FieldRef (ClassRef "java/lang/System") "out"

jString :: ClassRef
jString = ClassRef "java/lang/String"

jCharacter :: ClassRef
jCharacter = ClassRef "java/lang/Character"

jCharInit :: MethodRef
jCharInit = MethodRef (CRef jCharacter) "<init>" (MethodSpec ([JChar], JVoid))

jInteger :: ClassRef
jInteger = ClassRef "java/lang/Integer"

jIntInit :: MethodRef
jIntInit = MethodRef (CRef jInteger) "<init>" (MethodSpec ([JInt], JVoid))

jIntValue :: MethodRef
jIntValue = MethodRef (CRef jInteger) "intValue" (MethodSpec ([], JInt))

jValueOfChar :: MethodRef
jValueOfChar =
  MethodRef (CRef jString) "valueOf" (MethodSpec ([JChar], JClass jString))

jDouble :: ClassRef
jDouble = ClassRef "java/lang/Double"

jDoubleValue :: MethodRef
jDoubleValue = MethodRef (CRef jDouble) "doubleValue" (MethodSpec ([], JDouble))

jDoubleInit :: MethodRef
jDoubleInit = MethodRef (CRef jDouble) "<init>" (MethodSpec ([JDouble], JVoid))

jObject :: ClassRef
jObject = ClassRef "java/lang/Object"

jClass :: ClassRef
jClass = ClassRef "java/lang/Class"

stringEquals :: MethodRef
stringEquals =
  MethodRef (CRef jString) "equals" (MethodSpec ([JClass jObject], JBool))

stringCompare :: MethodRef
stringCompare =
  MethodRef (CRef jString) "compareTo" (MethodSpec ([JClass jString], JInt))

printStream :: ClassRef
printStream = ClassRef "java/io/PrintStream"

stringBuilder :: ClassRef
stringBuilder = ClassRef "java/lang/StringBuilder"

sbInit :: MethodRef
sbInit = MethodRef (CRef stringBuilder) "<init>" emptySpec

sbAppend :: MethodRef
sbAppend =
  MethodRef
    (CRef stringBuilder)
    "append"
    (MethodSpec ([JClass jString], JClass stringBuilder))

sbToString :: MethodRef
sbToString =
  MethodRef (CRef stringBuilder) "toString" (MethodSpec ([], JClass jString))

emptySpec :: MethodSpec
emptySpec = MethodSpec ([], JVoid)

cMain :: ClassRef
cMain = ClassRef "Main"

cGlcArray :: ClassRef
cGlcArray = ClassRef "glcutils/GlcArray"

glcArrayInit :: MethodRef
glcArrayInit =
  MethodRef
    (CRef cGlcArray)
    "<init>"
    (MethodSpec ([JClass jClass, JArray JInt], JVoid))

glcArrayAppendInt :: MethodRef
glcArrayAppendInt =
  MethodRef
    (CRef cGlcArray)
    "append"
    (MethodSpec ([JInt], JClass cGlcArray))

glcArrayAppendDouble :: MethodRef
glcArrayAppendDouble =
  MethodRef
    (CRef cGlcArray)
    "append"
    (MethodSpec ([JDouble], JClass cGlcArray))

glcArrayGetInt :: MethodRef
glcArrayGetInt =
  MethodRef
    (CRef cGlcArray)
    "getInt"
    (MethodSpec ([JInt], JInt))

glcArraySetInt :: MethodRef
glcArraySetInt =
  MethodRef
    (CRef cGlcArray)
    "set"
    (MethodSpec ([JInt, JInt], JVoid))

glcArrayGetDouble :: MethodRef
glcArrayGetDouble =
  MethodRef
    (CRef cGlcArray)
    "getDouble"
    (MethodSpec ([JInt], JDouble))

glcArraySetDouble :: MethodRef
glcArraySetDouble =
  MethodRef
    (CRef cGlcArray)
    "set"
    (MethodSpec ([JInt, JDouble], JVoid))

glcArrayGetArray :: MethodRef
glcArrayGetArray =
  MethodRef
    (CRef cGlcArray)
    "get"
    (MethodSpec ([JInt], JClass cGlcArray))

glcArrayCap :: MethodRef
glcArrayCap = MethodRef (CRef cGlcArray) "capacity" (MethodSpec ([], JInt))

glcArrayLength :: MethodRef
glcArrayLength = MethodRef (CRef cGlcArray) "length" (MethodSpec ([], JInt))

-- Custom-defined methods
glcUtils :: ClassRef
glcUtils = ClassRef "glcutils/Utils"
