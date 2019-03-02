module ErrorBundle where

import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Set           as Set
import           Data.Void
import           Text.Megaparsec
import qualified Tokens as T 

type ErrorBundle = ParseErrorBundle String Void

type ErrorBundle' = PosState String -> ErrorBundle

newtype Offset =
  Offset Int

instance Show Offset where
  show _ = "o"

instance Eq Offset where
  (==) _ _ = True

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

instance ErrorBreakpoint Offset where
  offset = id

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

posToOffset :: T.AlexPosn -> Offset
posToOffset (T.AlexPn _ _ o) = Offset o

instance ErrorBreakpoint Int where
  offset = Offset

-- | errorBundlePretty from offset and String
errorPos :: Int -> String -> String -> String
errorPos o inp err = errorString $ createError o err (createInitialState inp)
