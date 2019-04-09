module UtilsBuilderSpec
  ( spec
  ) where

import           Data.List    (intercalate)
import           TestBase
import           UtilsBuilder

spec :: Spec
spec =
  describe "Utils Builder" $
  it "test" $
  expectationFailure $
  intercalate "\n\n" $
  generateUtils [Category {baseType = Custom "Asdf", arrayDepth = 1, sliceDepth = 0}]
