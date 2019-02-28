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
spec = specAll "IntLit" intlit

intlit = [(IntLit Decimal "12", "12")]