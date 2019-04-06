{-# LANGUAGE QuasiQuotes #-}

module ResourceDataSpec
  ( spec
  ) where

import           ResourceBuilder (resourceGen)
import           TestBase

spec :: Spec
spec = todoSpec
--spec = prettifySpec

prettifySpec :: Spec
prettifySpec =
  expectPrettyMatch
    "prettify resourcedata"
    resourceGen
    [ ( fullProgramExample
      , [text|
        TODO
        |])
    ]
