{-# LANGUAGE QuasiQuotes       #-}
module SymbolTableSpec
  ( spec
  ) where

import           SymbolTable (pTable)
import Base (expectBase, toString, Stringable(..), text)
import           Test.Hspec

expectPass :: Stringable s => [s] -> SpecWith ()
expectPass = expectBase
             "success"
             (\s ->
                let c =
                      "package main\n\n" ++ toString s in
                 case pTable c of
                   Left err ->            expectationFailure $
                     "Expected symbol success on:\n\n" ++
                     toString s ++ "\n\nbut failed with\n\n" ++ show err
                   Right (Just e, _) -> expectationFailure $
                     "Expected symbol success on:\n\n" ++
                     toString s ++ "\n\nbut failed with\n\n" ++ show e
                   _ -> return ())
             toString
             "symbol"
             
expectFail :: Stringable s => [s] -> SpecWith ()
expectFail = expectBase
             "fail"
             (\s ->
                let c =
                      "package main\n\n" ++ toString s in
                 case pTable c of
                   Right (Nothing, str) ->            expectationFailure $
                     "Expected symbol failure on:\n\n" ++
                     toString s ++ "\n\nbut succeeded with\n\n" ++ str
                   _ -> return ())
             toString
             "symbol"

spec :: Spec
spec = do
  expectPass
    [""]
  -- expectFail
  --   ["var a = b"]
  expectFail
    [[text|
          var a = 5
          var a = 6
          |]]
