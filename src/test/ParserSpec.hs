module ParserSpec
  ( spec
  ) where

import           Test.Hspec

{-# ANN module "HLint: ignore Redundant do" #-}

-- | Spec template listing some expected tests; not yet implemented
spec :: Spec
spec = do
  describe "hello" $ do it "world" $ do "world" `shouldBe` "world"

intExamples = ["0", "1", "-123", "1234567890", "42", "0600", "0xBadFace", "170141183460469231731687303715884105727"]

floatExamples = [".1234567890", "0.", "72.40", "072.40", "2.71828", "1.e+0", "6.67428e-11", "1E6", ".25", ".12345E+5"]

runeExamples = ['a', 'b', 'c', '\a', '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'', '\"']
