{-# LANGUAGE FlexibleInstances #-}

module Codegen where

import           Data.ByteString.Builder (string7, toLazyByteString)
import           Data.ByteString.Lazy    (ByteString, append)
import qualified Data.ByteString.Lazy    as B (concat, writeFile)
import           IRConv
import           IRData
import qualified ResourceData            as T
import           Scanner                 (putExit, putSucc)
import           System.FilePath         (dropExtension)

-- Class for converting IR to ByteString representing Bytecode source
class Bytecode a where
  toBC :: a -> ByteString

instance Bytecode Class where
  toBC (Class cn fls mts) =
    B.concat
      [ bstrM [".class public ", cn, "\n", ".super java/lang/Object", "\n\n"]
      , B.concat $ map toBC fls
      , B.concat $ map toBC mts
      ]

instance Bytecode [Class] where
  toBC cls = B.concat (map toBC cls)

instance Bytecode Field where
  toBC (Field acc fn desc)
    -- .field $(access) $(fieldname) $(signature)
    -- ex.
    -- public int thing; ->
    -- .field public thing I
   = bstrM [".field ", show acc, " ", fn, " ", show desc, "\n"]

instance Bytecode Method where
  toBC (Method mn sl ll (MethodSpec (jtl, jt)) bod)
    -- .method public $(methodname)$(signature)
    -- ex.
    -- public int main() ->
    -- .method public main()I
   =
    B.concat
      [ bstrM
          [ ".method "
          , "public static "
          , mn
          , " : ("
          ]
      , bstrM (map show jtl)
      ,  bstrM
         [ ")"
          , show jt
          , "\n"
          , "\t.limit stack "
          , show sl
          , "\n"
          , "\t.limit locals "
          , show ll
          , "\n\n"
          ]
      , B.concat $ map (tab . toBC) bod
      , bstr ".end method\n"
      ]

instance Bytecode IRItem where
  toBC (IRInst inst)   = toBC inst
  toBC (IRLabel label) = bstrM [label, ":\n"]

instance Bytecode Instruction where
  toBC (Load t (T.VarIndex i)) = bstrM [typePrefix t, "load ", show i, "\n"]
  toBC (ArrayLoad t) = bstrM [typePrefix t, "aload\n"]
  toBC (Store t (T.VarIndex i)) = bstrM [typePrefix t, "store ", show i, "\n"]
  toBC (ArrayStore t) = bstrM [typePrefix t, "astore\n"]
  toBC (Return (Just t)) = bstrM [typePrefix t, "return\n"]
  toBC (Return Nothing) = bstr "return\n"
  toBC Dup = bstr "dup\n"
  toBC Dup2 = bstr "dup2\n"
  toBC (Goto label) = bstrM ["goto ", label, "\n"]
  toBC (Add t) = bstrM [typePrefix' t, "add\n"]
  toBC (Div t) = bstrM [typePrefix' t, "div\n"]
  toBC (Mul t) = bstrM [typePrefix' t, "mul\n"]
  toBC (Neg t) = bstrM [typePrefix' t, "neg\n"]
  toBC (Sub t) = bstrM [typePrefix' t, "sub\n"]
  toBC IRem = bstr "irem\n"
  toBC IShL = bstr "ishl\n"
  toBC IShR = bstr "ishr\n"
  toBC IAnd = bstr "iand\n"
  toBC (If cmp label) = bstrM ["if", show cmp, " ", label, "\n"]
  toBC (IfICmp cmp label) = bstrM ["if_icmp", show cmp, " ", label, "\n"]
  toBC IOr = bstr "ior\n"
  toBC IXOr = bstr "ixor\n"
  toBC (LDC lt) = B.concat [bstr "ldc", suffix lt, nl]
    where
      suffix :: LDCType -> ByteString
      suffix lt' =
        bstrM $
        case lt' of
          LDCInt i    -> [" ", show i]
          LDCDouble f -> ["2_w ", show f] -- Check if this is in the right format
          LDCString s -> ["_w ", show s]
  toBC IConstM1 = bstr "iconst_m1\n"
  toBC IConst0 = bstr "iconst_0\n"
  toBC IConst1 = bstr "iconst_1\n"
  toBC DCmpG = bstr "dcmpg\n"
  toBC (ANewArray (ClassRef cn)) = bstrM ["anewarray ", cn, "\n"]
  toBC (NewArray prim) = bstrM ["newarray ", typename prim, "\n"]
    where
      typename :: IRPrimitive -> String
      typename IRInt    = "int"
      typename IRDouble = "double"
  toBC (New (ClassRef cn)) = bstrM ["new ", cn, "\n"]
  toBC NOp = bstr "nop\n"
  toBC Pop = bstr "pop\n"
  toBC Swap = bstr "swap\n"
  toBC (GetStatic (FieldRef (ClassRef cn) fn) jt) =
    bstrM ["getstatic Field ", cn, " ", fn, " ", show jt, "\n"]
  toBC (PutStatic (FieldRef (ClassRef cn) fn) jt) =
    bstrM ["putstatic Field ", cn, " ", fn, " ", show jt, "\n"]
  toBC (GetField (FieldRef (ClassRef cn) fn) jt) =
    bstrM ["getfield Field ", cn, " ", fn, " ", show jt, "\n"]
  toBC (PutField (FieldRef (ClassRef cn) fn) jt) =
    bstrM ["putfield Field ", cn, " ", fn, " ", show jt, "\n"]
  toBC (InvokeSpecial mr) = bstrM ["invokespecial ", show mr, "\n"]
  toBC (InvokeVirtual mr) = bstrM ["invokevirtual ", show mr, "\n"]
  toBC (InvokeStatic mr) = bstrM ["invokestatic ", show mr, "\n"]
  toBC (Debug _) = undefined

-- | Get type prefix for things like load
typePrefix :: IRType -> String
typePrefix t =
  case t of
    Prim IRInt    -> "i"
    Prim IRDouble -> "d" -- double
    Object        -> "a"

typePrefix' :: IRPrimitive -> String
typePrefix' t =
  case t of
    IRInt    -> "i"
    IRDouble -> "d"

-- | Helper to convert a string to ASCII lazy ByteString
bstr :: String -> ByteString
bstr = toLazyByteString . string7

-- | Helper to map bstr over a list of Strings
bstrM :: [String] -> ByteString
bstrM sl = B.concat (map bstr sl)

-- | newline
nl :: ByteString
nl = bstr "\n"

-- | Prefix bytestring with tab
tab :: ByteString -> ByteString
tab s = bstr "\t" `app` s

infixl 4 `app`

-- | Function alias
app :: ByteString -> ByteString -> ByteString
b1 `app` b2 = append b1 b2

infixl 4 `bappL`

-- | Append two literal strings
bappL :: String -> String -> ByteString
s1 `bappL` s2 = append (bstr s1) (bstr s2)

-- | Remove the extension of filename and add .j instead
fileJ :: String -> String
fileJ file = dropExtension file ++ ".j"

codegen :: String -> IO ()
codegen file =
  readFile file >>=
  either putExit (\ir -> B.writeFile (fileJ file) (toBC ir) >> putSucc "OK") .
  genIR
