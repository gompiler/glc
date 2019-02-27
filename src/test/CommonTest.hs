module CommonTest where

import Test.Hspec
import Control.Applicative

-- | To format what input we give and what we expect for it in SpecWith()
expectStr :: String -> String -> String
expectStr inp out = "given \n" ++ inp ++ "\nreturns " ++ out

-- | specWith generator for any arbitrary function
specWithG :: (Show a, Eq a) => (String -> Either String a) -> (String, Either String a) -> SpecWith ()
specWithG f (inp, out) = it (expectStr inp $ show out) $ f inp `shouldBe` out

-- | Generate Either given a string and feed this to constructor
strData :: String -> (String -> Either String a) -> (String, Either String a)
strData s constr = (s, constr s)

-- | Cartesian product of two lists
cartP :: [a] -> [b] -> [(a,b)]
cartP = liftA2(,)
