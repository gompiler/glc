{-# LANGUAGE ScopedTypeVariables #-}

module ErrorBundle
  ( ErrorBundle
  , ErrorBundle'
  , ErrorBreakpoint(..)
  , ErrorEntry(..)
  , Offset(..)
  , createInitialState
  , checkListSize
  ) where

import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Set           as Set
import           Data.Void
import           Text.Megaparsec

type ErrorBundle = ParseErrorBundle String Void

type ErrorBundle' = String -> String

newtype Offset =
  Offset Int

instance Show Offset where
  show _ = "o"

instance Eq Offset where
  (==) _ _ = True

-- | Class containing an offset, which is used to create error messages
class ErrorBreakpoint a where
  offset :: a -> Offset
  createError :: a -> ErrorEntry -> PosState String -> String
  createError breakpoint msg initialState =
    let (Offset o) = offset breakpoint
        bundle :: ErrorBundle =
          ParseErrorBundle
            { bundleErrors =
                NonEmpty.fromList
                  [FancyError o (Set.singleton $ ErrorFail (errorMessage msg))]
            , bundlePosState = initialState
            }
     in errorBundlePretty bundle
  createError' :: a -> String -> String -> String
  createError' breakpoint msg initialState =
    createError breakpoint (GenericError msg) (createInitialState initialState)

instance ErrorBreakpoint Offset where
  offset = id

data ErrorEntry
  = GenericError String
  | TODO
  deriving (Show, Eq)

errorMessage :: ErrorEntry -> String
errorMessage (GenericError s) = s
errorMessage TODO             = "todo"

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

instance ErrorBreakpoint Int where
  offset = Offset

-- | Given two lists, check if the sizes are equal, if not, output a corresponding error
checkListSize ::
     (ErrorBreakpoint a, ErrorBreakpoint b) => [a] -> [b] -> Maybe ErrorBundle'
checkListSize (_:t1) (_:t2) = checkListSize t1 t2
checkListSize [] (h2:_) =
  Just $ createError' h2 "LHS and RHS of assignments must be equal in length"
checkListSize (h1:_) [] =
  Just $ createError' h1 "LHS and RHS of assignments must be equal in length"
checkListSize [] [] = Nothing
