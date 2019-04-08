{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell #-}

module Codegen
  ( codegen
  ) where

import           Data.ByteString.Builder (string7, toLazyByteString)
import           Data.ByteString.Lazy    (ByteString, append)
import qualified Data.ByteString.Lazy    as B (concat, writeFile, fromStrict)
import           Data.FileEmbed          (embedFile)
import           IRConv
import           IRData
import qualified ResourceData            as T
import           Scanner                 (putExit, putSucc)
import           System.FilePath         (dropExtension)

-- Class for converting IR to ByteString representing Bytecode source
class Bytecode a
  -- Automatically add a newline at the end of each conversion
  where
  toBC :: a -> ByteString
  toBC arg = B.concat [toBC' arg, nl]
  toBC' :: a -> ByteString

instance Bytecode Class where
  toBC' (Class cn fls mts) =
    B.concat
      [ bstrM [".class public ", cn, "\n", ".super java/lang/Object", "\n\n"]
      , B.concat $ map toBC fls
      , B.concat $ map toBC mts
      ]

instance Bytecode [Class] where
  toBC' cls = B.concat (map toBC cls)

instance Bytecode Field where
  toBC' (Field acc static' fn desc)
    -- .field $(access) $(fieldname) $(signature)
    -- ex.
    -- public int thing; ->
    -- .field public thing I
   =
    bstrM
      [ ".field "
      , show acc
      , " "
      , if static'
          then "static "
          else ""
      , fn
      , " "
      , show desc
      ]

instance Bytecode Method where
  toBC' (Method mn sl ll (MethodSpec (jtl, jt)) bod)
    -- .method public $(methodname)$(signature)
    -- ex.
    -- public int main() ->
    -- .method public main()I
   =
    B.concat
      [ bstrM [".method ", "public static ", mn, " : ("]
      , bstrM (map show jtl)
      , bstrM
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
      , B.concat $ map (tab . toBC') bod
      , bstr ".end method"
      ]

instance Bytecode IRItem where
  toBC' (IRInst inst)   = toBC inst
  toBC' (IRLabel label) = bstrM [label, ":"]

instance Bytecode Instruction where
  toBC' ins = bstrM (toBCStr ins)
    where
      toBCStr :: Instruction -> [String]
      toBCStr (Load t (T.VarIndex i)) = [typePrefix t, "load ", show i]
      toBCStr (ArrayLoad t) = [typePrefix t, "aload"]
      toBCStr (Store t (T.VarIndex i)) = [typePrefix t, "store ", show i]
      toBCStr (ArrayStore t) = [typePrefix t, "astore"]
      toBCStr (Return (Just t)) = [typePrefix t, "return"]
      toBCStr (Return Nothing) = ["return"]
      toBCStr Dup = ["dup"]
      toBCStr Dup2 = ["dup2"]
      toBCStr (Goto label) = ["goto ", label]
      toBCStr (Add t) = [typePrefix' t, "add"]
      toBCStr (Div t) = [typePrefix' t, "div"]
      toBCStr (Mul t) = [typePrefix' t, "mul"]
      toBCStr (Neg t) = [typePrefix' t, "neg"]
      toBCStr (Sub t) = [typePrefix' t, "sub"]
      toBCStr IRem = ["irem"]
      toBCStr IShL = ["ishl"]
      toBCStr IShR = ["ishr"]
      toBCStr IAnd = ["iand"]
      toBCStr (If cmp label) = ["if", show cmp, " ", label]
      toBCStr (IfICmp cmp label) = ["if_icmp", show cmp, " ", label]
      toBCStr IOr = ["ior"]
      toBCStr IXOr = ["ixor"]
      toBCStr (LDC lt) = "ldc" : suffix lt
        where
          suffix :: LDCType -> [String]
          suffix lt' =
            case lt' of
              LDCInt i    -> [" ", show i]
              LDCDouble f -> ["2_w ", show f] -- Check if this is in the right format
              LDCString s -> ["_w ", show s]
      toBCStr IConstM1 = ["iconst_m1"]
      toBCStr IConst0 = ["iconst_0"]
      toBCStr IConst1 = ["iconst_1"]
      toBCStr DCmpG = ["dcmpg"]
      toBCStr (ANewArray (ClassRef cn)) = ["anewarray ", cn]
      toBCStr (NewArray prim) = ["newarray ", typename prim]
        where
          typename :: IRPrimitive -> String
          typename IRInt    = "int"
          typename IRDouble = "double"
      toBCStr (New (ClassRef cn)) = ["new ", cn]
      toBCStr NOp = ["nop"]
      toBCStr Pop = ["pop"]
      toBCStr Swap = ["swap"]
      toBCStr (GetStatic (FieldRef (ClassRef cn) fn) jt) =
        ["getstatic Field ", cn, " ", fn, " ", show jt]
      toBCStr (PutStatic (FieldRef (ClassRef cn) fn) jt) =
        ["putstatic Field ", cn, " ", fn, " ", show jt]
      toBCStr (GetField (FieldRef (ClassRef cn) fn) jt) =
        ["getfield Field ", cn, " ", fn, " ", show jt]
      toBCStr (PutField (FieldRef (ClassRef cn) fn) jt) =
        ["putfield Field ", cn, " ", fn, " ", show jt]
      toBCStr (InvokeSpecial mr) = ["invokespecial ", show mr]
      toBCStr (InvokeVirtual mr) = ["invokevirtual ", show mr]
      toBCStr (InvokeStatic mr) = ["invokestatic ", show mr]
      toBCStr (Debug _) = undefined

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

-- | Remove the extension of filename and add .j instead
fileJ :: String -> String
fileJ file = dropExtension file ++ ".j"

utils :: ByteString
utils = B.fromStrict $(embedFile "glcgutils/Utils.j")

codegen :: String -> IO ()
codegen file =
  readFile file >>=
  either putExit (\ir -> B.writeFile (fileJ file) (B.concat [utils, nl, toBC ir]) >> putSucc "OK") .
  genIR
