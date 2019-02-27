module ParserSpec
  ( spec
  ) where

import           Test.Hspec
import CommonTest
import Parser
import Data

{-# ANN module "HLint: ignore Redundant do" #-}

-- | Spec template listing some expected tests; not yet implemented
spec :: Spec
spec = do
  describe "parseId" $ do
    mapM_ specWithId expectId
    mapM_ specWithE expectE

specWithId :: (String, Either String [Identifier]) -> SpecWith ()
specWithId (inp, out) = it (expectStr inp $ show out) $ runAlex inp pId `shouldBe` out

expectId :: [(String, Either String [Identifier])]
expectId =
  [ ("testid", Right ["testid"])
  , ("identttt", Right["identttt"])
  , ("_", Right["_"])
  , ("a, b, dddd", Right["a", "b", "dddd"])
  , ("_, _,_", Right["_", "_", "_"])
  , ("weirdsp, _   ,aacing", Right["weirdsp", "_", "aacing"])
  ]

specWithE :: (String, Either String Expr) -> SpecWith ()
specWithE (inp, out) = it (expectStr inp $ show out) $ runAlex inp pE `shouldBe` out

expectE :: [(String, Either String Expr)]
expectE =
  [ ("01249148", Right $ Lit $ IntLit Decimal "01249148")
  , ("000123022", Right $ Lit $ IntLit Octal "000123022")
  , ("0xfffff", Right $ Lit $ IntLit Hexadecimal "0xfffff")
  , ("0XffFf12", Right $ Lit $ IntLit Hexadecimal "0XffFf12")
  , ("123", Right $ Lit $ IntLit Decimal "123")
  , ("000000123", Right $ Lit $ IntLit Octal "000000123")
  , ("000000124", Right $ Lit (IntLit Octal "000000124"))
  , ("00.00124", Right $ Lit (FloatLit 1.24e-3))
  , ("1.00124", Right $ Lit (FloatLit 1.00124))
  , ("1.1", Right $ Lit (FloatLit 1.1))
  -- , ("1.", Right $ Lit (FloatLit 1))
  , ("1.0", Right $ Lit (FloatLit 1.0))
  -- , (".0", Right $ Lit (FloatLit 0.0))
  , ("'D'", Right $ Lit $ RuneLit 'D')
  -- , ("'\\n'", Right $ Lit $ RuneLit '\n')
  , ("\"aaaaaaaaax\"", Right $ Lit (StringLit Interpreted "\"aaaaaaaaax\""))
  , ("`aaaaaaaaax`", Right $ Lit (StringLit Raw "`aaaaaaaaax`"))
  ]
  
intExamples = ["0", "1", "-123", "1234567890", "42", "0600", "0xBadFace", "170141183460469231731687303715884105727"]

floatExamples = [".1234567890", "0.", "72.40", "072.40", "2.71828", "1.e+0", "6.67428e-11", "1E6", ".25", ".12345E+5"]

runeExamples = ['a', 'b', 'c', '\a', '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'', '\"']
  
