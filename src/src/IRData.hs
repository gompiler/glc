-- | Data mapping for Java IR
-- Sources:
-- http://jasmin.sourceforge.net/instructions.html
-- https://en.wikibooks.org/wiki/Java_Programming/Byte_Code
-- https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html
-- https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings
-- https://www.guardsquare.com/en/blog/string-concatenation-java-9-untangling-invokedynamic
-- http://www.cs.sjsu.edu/~pearce/modules/lectures/co/jvm/jasmin/demos/demos.html
-- http://homepages.inf.ed.ac.uk/kwxm/JVM/fcmpg.html
module IRData where

import           ResourceData (VarIndex)

type LabelName = String

data FieldAccess
  = FPublic
  | FPrivate
  | FProtected
  | FStatic
  | FFinal
  | FVolatile
  | FTransient
  deriving (Eq)

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
            [JType]
            JType
  deriving (Eq)

instance Show MethodRef where
  show (MethodRef (CRef (ClassRef cn)) mn tl t) =
    "Method " ++ cn ++ " " ++ mn ++ " (" ++ concatMap show tl ++ ")" ++ show t
  show (MethodRef (ARef jt) mn tl t) =
    "Method [" ++
    show jt ++ " " ++ mn ++ " (" ++ concatMap show tl ++ ")" ++ show t

data JType
  = JClass ClassRef -- Lwhatever;
  | JArray JType -- [ as a prefix, ex. [I
  | JInt -- I
  | JDouble -- D
  | JBool -- Z
  | JVoid -- V
  deriving (Eq)

instance Show JType where
  show (JClass (ClassRef cn)) = "L" ++ cn ++ ";"
  show (JArray jt)            = "[" ++ show jt
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
  show LE = "le"
  show IRData.GT = "gt"
  show GE = "ge"
  show IRData.EQ = "eq"
  show NE = "ne"

data LDCType
  = LDCInt Int -- Integers, booleans, runes
  | LDCDouble Float -- Float64s
  | LDCString String -- Strings
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
  | ANewArray ClassRef
  | NewArray IRPrimitive
  | NOp
  | Pop
  | Swap
  | GetStatic FieldRef
              JType -- field spec, descriptor
  | GetField FieldRef
             JType
  | PutField FieldRef
             JType
  | InvokeSpecial MethodRef -- method spec
  | InvokeVirtual MethodRef -- method spec
  | Debug String -- TODO: remove
  deriving (Show, Eq)

-- Predefined Java language constructs to use in code generation
systemOut :: FieldRef
systemOut = FieldRef (ClassRef "java/lang/System") "out"

printStream :: ClassRef
printStream = ClassRef "java/io/PrintStream"

stringBuilder :: ClassRef
stringBuilder = ClassRef "java/lang/StringBuilder"

jString :: ClassRef
jString = ClassRef "java/lang/String"

jObject :: ClassRef
jObject = ClassRef "java/lang/Object"

-- Custom-defined methods
glcUtils :: ClassRef
glcUtils = ClassRef "glcgutils/Utils"
