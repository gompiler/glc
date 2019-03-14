{-# LANGUAGE RankNTypes #-}

module SymbolTableCoreSpec
  ( spec
  ) where

import           Control.Monad           (foldM_)
import           Control.Monad.Primitive (PrimState)
import           Control.Monad.ST        (stToIO)
import           Prelude                 hiding (lookup)
import           SymbolTableCore
import           Test.Hspec

type TestSymbolTable = SymbolTable (PrimState IO) Int Int

data Action
  = Lookup Int
           (Maybe (Int, Int))
  | Insert Int
           Int
  | AddMessage Int
  | CompareMessage [Int]
  deriving (Show)

applyAction :: TestSymbolTable -> Action -> Expectation
applyAction s (Lookup key expect) =
  stToIO (lookup s (Ident $ show key)) >>=
  (`shouldBe` fmap (\(sc, v) -> (Scope sc, v)) expect)
applyAction s (Insert key value) = stToIO $ insert s (Ident $ show key) value
applyAction s (AddMessage msg) = stToIO $ addMessage s msg
applyAction s (CompareMessage msgs) =
  stToIO (getMessages s) >>= (`shouldBe` msgs)

testPass :: String -> [Action] -> SpecWith ()
testPass title actions =
  describe ("pass: " ++ title) $
  it "" $ do
    s <- stToIO new
    foldM_ (\t k -> applyAction t k >> return t) s actions

testError :: String -> [Action] -> SpecWith ()
testError title actions =
  describe ("pass: " ++ title) $
  it "" $ do
    s <- stToIO new
    foldM_ (\t k -> applyAction t k >> return t) s actions `shouldThrow`
      anyException

spec :: Spec
spec = do
  testPass "insert get" [Insert 0 0, Lookup 0 $ Just (0, 0)]
  testError "insert get" [Insert 0 0, Lookup 0 Nothing]
