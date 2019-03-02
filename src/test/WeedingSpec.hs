{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TypeApplications     #-}
{-# LANGUAGE TypeSynonymInstances #-}

module WeedingSpec
  ( spec
  ) where

import           NeatInterpolation

import           Base
import           Data
import           Data.Functor      ((<&>))
import           Debug.Trace       (trace)
import           Prettify
import           Weeding

expectWeedPass :: Stringable s => [s] -> SpecWith ()
expectWeedPass =
  expectBase
    "weed success"
    (\s ->
       let program = "package main\n\nfunc main() {\n\n" ++ toString s ++ "\n\n}"
        in case parse @Program program >>= weed program of
             Left err -> expectationFailure $ "Expected success on:\n\n" ++ program ++ "\n\nbut got error\n\n" ++ err
             _ -> return ())
    toString
    "wrapped stmt"

expectWeedFail :: Stringable s => [s] -> SpecWith ()
expectWeedFail =
  expectBase
    "weed fail"
    (\s ->
       let program = "package main\n\nfunc main() {\n\n" ++ toString s ++ "\n\n}"
        in case parse @Program program >>= weed program of
             Right p ->
               expectationFailure $ "Expected failure on:\n\n" ++ program ++ "\n\nbut got program\n\n" ++ show p
             _ -> return ())
    toString
    "wrapped stmt"

spec :: Spec
spec = do
  expectWeedPass ["if true { }"]
  expectWeedFail ["break", "if t { break; }"]
