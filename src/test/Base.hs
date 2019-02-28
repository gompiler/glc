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
  , specWithG
  , strData
  , strData'
  , cartP
  , module Test.Hspec
  ) where

import           Data.Text         (Text, unpack)
import           ErrorBundle
import           NeatInterpolation
import           Test.Hspec
import           Control.Applicative

o = Offset 0

specConvert :: (b -> c) -> [(a, b)] -> [(a, c)]
specConvert f = map (\(i, o) -> (i, f o))

class SpecBuilder a b c where
  expectation :: a -> b -> SpecWith c
  specAll :: String -> [(a, b)] -> SpecWith c
  specAll name items = describe name $ mapM_ (uncurry expectation) items

-- | specWith generator for any arbitrary function, not verbose
specWithG :: (Show a, Eq a) => (String -> Either String a) -> (String, Either String a) -> SpecWith ()
specWithG f (inp, out) = parallel $ it inp $ f inp `shouldBe` out

expectG :: (Show a, Eq a) => (String -> Either String a) -> (String, Either String a) -> Expectation
expectG f (inp, out) = f inp `shouldBe` out

-- | Generate Either given a string and feed this to constructor
strData :: String -> (String -> Either String a) -> (String, Either String a)
strData s constr = (s, constr s)
  
strData' :: (String -> Either String a) -> String -> (String, Either String a)
strData' constr s = (s, constr s)

-- | Cartesian product of two lists
cartP :: [a] -> [b] -> [(a,b)]
cartP = liftA2(,)
