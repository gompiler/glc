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
  toBC _ = undefined

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
