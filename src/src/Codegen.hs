module Codegen where

import           Data.ByteString.Builder (Builder, string7, toLazyByteString)
import           Data.ByteString.Lazy    (ByteString)
import           IR                      (genIR)
import           Scanner                 (putExit, putSucc)
import           System.FilePath         (dropExtension)

-- class Bytecodify a where
--   toBC :: a -> [String]
test :: Builder
test = string7 "ayy"

get :: Builder -> ByteString
get = toLazyByteString

-- | Remove the extension of filename and add .j instead
fileJ :: String -> String
fileJ file = dropExtension file ++ ".j"

codegen :: String -> IO ()
codegen file =
  readFile file >>=
  either putExit (const $ writeFile (fileJ file) "" >> putSucc "OK") . genIR
