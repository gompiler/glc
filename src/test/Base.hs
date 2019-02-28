{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Base
  ( SpecBuilder(..)
  , Data.Text.Text
  , Data.Text.unpack
  , NeatInterpolation.text
  , module ErrorBundle
  , specConvert
  , strData
  , strData'
  , cartP
  , module Test.Hspec
  , module Test.QuickCheck
  , toRetL
  , qcGen
  ) where

import           Control.Applicative
import           Data.Text           (Text, unpack)
import           ErrorBundle
import           NeatInterpolation
import           Test.Hspec
import           Test.QuickCheck

o = Offset 0

specConvert :: (b -> c) -> [(a, b)] -> [(a, c)]
specConvert f = map (\(i, o) -> (i, f o))

class SpecBuilder a b c where
  expectation :: a -> b -> SpecWith c
  specAll :: String -> [(a, b)] -> SpecWith c
  specAll name items = describe name $ mapM_ (uncurry expectation) items
  specOne :: (a,b) -> SpecWith c
  specOne item = uncurry expectation item

expectG ::
     (Show a, Eq a)
  => (String -> Either String a)
  -> (String, Either String a)
  -> Expectation
expectG f (inp, out) = f inp `shouldBe` out

-- | Generate Either given a string and feed this to constructor
strData :: String -> (String -> a) -> (String, a)
strData s constr = (s, constr s)

strData' :: (String -> a) -> String -> (String, a)
strData' constr s = (s, constr s)

-- | Cartesian product of two lists
cartP :: [a] -> [b] -> [(a, b)]
cartP = liftA2 (,)

toRetL :: Monad m => a -> m [a]
toRetL e = return [e]

qcGen :: (Show a, Testable prop) => String -> Bool -> Gen a -> (a -> prop) -> SpecWith (Arg Property)
qcGen desc verb g p = it desc $ property $ if verb then verbose (forAll g p)
                                           else forAll g p
