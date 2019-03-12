{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE TypeSynonymInstances #-}

module ErrorBundle
  ( ErrorBundle
  , ErrorBundle'
  , ErrorBreakpoint(..)
  , ErrorEntry(..)
  , Offset(..)
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
class (Show a, Eq a) =>
      ErrorBreakpoint a
  where
  offset :: a -> Offset
  createError :: ErrorEntry e => a -> e -> String -> String
  createError breakpoint msg input =
    let (Offset o) = offset breakpoint
        initialState =
          PosState
            { pstateInput = input
            , pstateOffset = 0
            , pstateSourcePos = initialPos ""
            , pstateTabWidth = defaultTabWidth
            , pstateLinePrefix = ""
            }
        bundle :: ErrorBundle =
          ParseErrorBundle
            { bundleErrors =
                NonEmpty.fromList
                  [FancyError o (Set.singleton $ ErrorFail (errorMessage msg))]
            , bundlePosState = initialState
            }
     in errorBundlePretty bundle

instance ErrorBreakpoint Offset where
  offset = id

class (Show a, Eq a) =>
      ErrorEntry a
  where
  errorMessage :: a -> String

-- | Helper to allow for string error comparisons
-- However, you should really implement a new type that allows
instance ErrorEntry String where
  errorMessage = id
