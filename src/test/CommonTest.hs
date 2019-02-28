module CommonTest where

import Test.Hspec
import Control.Applicative

-- | To format what input we give and what we expect for it in SpecWith()
expectStr :: String -> String -> String
expectStr inp out = "given \n" ++ inp ++ "\nreturns " ++ out

-- | specWith generator for any arbitrary function, verbose
specWithGV :: (Show a, Eq a) => (String -> Either String a) -> (String, Either String a) -> SpecWith ()
specWithGV f (inp, out) = parallel $ it (expectStr inp $ show out) $ f inp `shouldBe` out
  
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
