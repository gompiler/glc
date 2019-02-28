{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module Base
  ( SpecBuilder(..)
  , Data.Text.Text
  , Data.Text.unpack
  , NeatInterpolation.text
  , module ErrorBundle
  , specConvert
  , module Test.Hspec
  ) where

import           Data.Text         (Text, unpack)
import           ErrorBundle
import           NeatInterpolation
import           Test.Hspec

-- Offest placeholder
o = Offset 0

specConvert :: (b -> c) -> [(a, b)] -> [(a, c)]
specConvert f = map (\(i, o) -> (i, f o))

class SpecBuilder a b c where
  expectation :: a -> b -> SpecWith c
  specAll :: String -> [(a, b)] -> SpecWith c
  specAll name items = describe name $ mapM_ (uncurry expectation) items
--spec :: Spec
--spec =
--  describe "scanT" $ do
--    specWithScanT (";", Right ([TSemicolon]))
--    mapM_ specWithScanT expectScanT
--
---- | Generate a SpecWith using the scan function
--specWithScanT :: (String, Either String [InnerToken]) -> SpecWith ()
--specWithScanT (input, output) = it ("given \n" ++ input ++ "\nreturns " ++ show output) $ scanT input `shouldBe` output
