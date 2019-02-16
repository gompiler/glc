module TokensSpec
  ( spec
  ) where

import           Test.Hspec

{-# ANN module "HLint: ignore Redundant do" #-}

spec :: Spec
spec = do
  describe "hello" $ do it "world" $ do "world" `shouldBe` "world"
