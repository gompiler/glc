{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module Base
  ( SpecBuilder(..)
  , Data.Text.Text
  , Data.Text.unpack
  , NeatInterpolation.text
  , o
  , module ErrorBundle
  , sndConvert
  , fstConvert
  , pairConvert
  , strData
  , strData'
  , cartP
  , module Test.Hspec
  , module Test.QuickCheck
  , toRetL
  , qcGen
  , isLeft
  , isRight
  ) where

import           Control.Applicative
import           Data.Text           (Text, unpack)
import           ErrorBundle
import           NeatInterpolation
import           Test.Hspec
import           Test.QuickCheck

o :: Offset
o = Offset 0

pairConvert :: (a -> a') -> (b -> b') -> [(a, b)] -> [(a', b')]
pairConvert f1 f2 = map (\(a, b) -> (f1 a, f2 b))

fstConvert :: (a -> a') -> [(a, b')] -> [(a', b')]
fstConvert f = pairConvert f id

sndConvert :: (b -> b') -> [(a, b)] -> [(a, b')]
sndConvert = pairConvert id

class SpecBuilder a b c where
  expectation :: a -> b -> SpecWith c
  specAll :: String -> [(a, b)] -> SpecWith c
  specAll name items = describe name $ mapM_ (uncurry expectation) items
  specOne :: (a,b) -> SpecWith c
  specOne = uncurry expectation

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

-- | Returns true if the Either is Left
isLeft :: (Either a b) -> Bool
isLeft = either (const True) (const False)

isRight :: (Either a b) -> Bool
isRight = either (const False) (const True)
