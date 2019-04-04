module Codegen where

import           Data.ByteString.Builder (string7, toLazyByteString)
import           Data.ByteString.Lazy    (ByteString, append)
import qualified Data.ByteString.Lazy    as B (concat, writeFile)
import           IRConv
import           IRData
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

instance Bytecode Field where
  toBC (Field acc fn desc)
    -- .field $(access) $(fieldname) $(signature)
    -- ex.
    -- public int thing; ->
    -- .field public thing I
   = bstrM [".field ", show acc, " ", fn, " ", desc, "\n"]

instance Bytecode Method where
  toBC (Method mn sl ll bod)
    -- .method public $(methodname)$(signature)
    -- ex.
    -- public int main() ->
    -- .method public main()I
   =
    B.concat
      [ bstrM
          [ ".method "
          , "public "
          , mn
          , "()V" -- No args and return is void until Method implements signature
          , "\n"
          , "\t.limit stack "
          , show sl
          , "\n"
          , "\t.limit locals "
          , show ll
          ]
      , B.concat $ map (tab . toBC) bod
      ]

instance Bytecode IRItem where
  toBC (IRInst inst) = toBC inst
  toBC (IRLabel label) = bstrM [label, ":\n"]

instance Bytecode Instruction where
  toBC (Load t i) = bstrM [typePrefix t, "load ", show i, "\n"]
  toBC (Store t i) = bstrM [typePrefix t, "istore ", show i, "\n"]
  toBC (Return (Just t)) = bstrM [typePrefix t, "return\n"]
  toBC (Return Nothing) = bstr "return\n"
  toBC Dup = bstr "dup\n"
  toBC (Goto label) = bstrM ["goto ", label, "\n"]
  toBC (Add t) = bstrM [typePrefix' t, "add\n"]
  toBC (Div t) = bstrM [typePrefix' t, "div\n"]
  toBC (Mul t) = bstrM [typePrefix' t, "mul\n"]
  toBC (Neg t) = bstrM [typePrefix' t, "neg\n"]
  toBC (Sub t) = bstrM [typePrefix' t, "sub\n"]
  toBC IRem = bstr "irem\n"
  toBC IShL = bstr "ishl\n"
  toBC IShR = bstr "ishr\n"
  toBC IALoad = bstr "iaload\n"
  toBC IAnd = bstr "iand\n"
  toBC IAStore = bstr "iastore\n"
  toBC (IfEq label) = bstrM ["ifeq ", label, "\n"]
  toBC IOr = bstr "ior\n"
  toBC IXOr = bstr "ixor\n"
  toBC (LDC lt) = B.concat [bstr "ldc", suffix lt, nl]
    where
      suffix :: LDCType -> ByteString
      suffix lt' = bstrM $ case lt' of
                            LDCInt i -> [" ", show i]
                            LDCFloat f -> ["2_w ", show f] -- Check if this is in the right format
                            LDCString s -> ["_w ", s]
  toBC (New (ClassRef cn)) = bstrM ["new ", cn, "\n"]
  toBC NOp = bstr "nop\n"
  toBC Pop = bstr "pop\n"
  toBC Swap = bstr "swap\n"
  toBC (GetStatic (FieldRef (ClassRef cn1) fn) (ClassRef cn2)) = bstrM ["getstatic Field ", cn1, " ", fn, " ", cn2, "\n"]
  toBC (InvokeSpecial mr) = bstrM ["invokespecial ", show mr, "\n"]
  toBC (InvokeVirtual mr) = bstrM ["invokevirtual ", show mr, "\n"]
  toBC _ = undefined


-- | Get type prefix for things like load
typePrefix :: IRType -> String
typePrefix t = case t of
                 Prim IRInt -> "i"
                 Prim IRFloat -> "d" -- double
                 Object -> "a"

typePrefix' :: IRPrimitive -> String
typePrefix' t = case t of
                  IRInt -> "i"
                  IRFloat -> "d"

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
