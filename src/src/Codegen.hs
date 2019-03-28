module Codegen where

import           Data.ByteString.Builder (string7, toLazyByteString)
import           Data.ByteString.Lazy    (ByteString, append)
import qualified Data.ByteString.Lazy    as B (concat, writeFile)
import           IR
import           Scanner                 (putExit, putSucc)
import           System.FilePath         (dropExtension)

-- Class for converting IR to ByteString representing Bytecode source
class Bytecode a where
  toBC :: a -> ByteString

instance Bytecode Class where
  toBC (Class cn fls mts) =
    B.concat
      [ bstr ".class public "
      , bstr cn
      , nl
      , bstr ".super java/lang/Object"
      , nl
      , nl
      , B.concat $ map toBC fls
      , B.concat $ map toBC mts
      ]

instance Bytecode Field where
  toBC _ = undefined -- bstr ""

instance Bytecode Method where
  toBC _ = undefined -- bstr ""

-- | Helper to convert a string to ASCII lazy ByteString
bstr :: String -> ByteString
bstr = toLazyByteString . string7

-- | newline
nl :: ByteString
nl = bstr "\n"

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
