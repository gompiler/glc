{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module PrettifySpec
  ( spec
  ) where

import NeatInterpolation

import Base
import Data
import Prettify

instance (Prettify a, Show a) => SpecBuilder a String () where
  expectation ast s = it (show ast) $ prettify ast `shouldBe` s

shouldPrettifyTo' :: (HasCallStack, Prettify a) => a -> Text -> Expectation
ast `shouldPrettifyTo'` s = prettify ast `shouldBe` unpack s

spec :: Spec
spec =
  describe "Literals" $ do
    specAll "IntLit" intLit
    specAll "FloatLit" floatLit

intLit = map (\(i, o) -> (IntLit i o, o)) [(Decimal, "12"), (Hexadecimal, "0xCAFEBABE"), (Octal, "01001")]

floatLit = [(FloatLit 0.123, "0.123")]