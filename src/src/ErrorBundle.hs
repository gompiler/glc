module ErrorBundle where

import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Set           as Set
import           Data.Void
import           Text.Megaparsec

type ErrorBundle = ParseErrorBundle String Void

newtype Offset =
  Offset Int

-- | Class containing an offset, which is used to create error messages
class ErrorBreakpoint a where
  offset :: a -> Offset
  createError :: a -> String -> PosState String -> ErrorBundle
  createError breakpoint msg initialState =
    let (Offset o) = offset breakpoint
     in ParseErrorBundle
          { bundleErrors = NonEmpty.fromList [FancyError o (Set.singleton $ ErrorFail msg)]
          , bundlePosState = initialState
          }

-- | Pass string, where first character marks offset 1
createInitialState :: String -> PosState String
createInitialState input =
  PosState
    { pstateInput = input
    , pstateOffset = 0
    , pstateSourcePos = initialPos ""
    , pstateTabWidth = defaultTabWidth
    , pstateLinePrefix = ""
    }

-- | Convert error bundle to string
errorString :: ErrorBundle -> String
errorString = errorBundlePretty
