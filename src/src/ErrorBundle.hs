{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE NamedFieldPuns       #-}
{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE StandaloneDeriving   #-}
{-# LANGUAGE TypeSynonymInstances #-}

module ErrorBundle
  ( ErrorMessage
  , ErrorMessage'
  , ErrorBreakpoint(..)
  , ErrorEntry(..)
  , Offset(..)
  , withPrefix
  , createError'
  , showErrorEntry
  , hasError
  ) where

import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Set           as Set
import           Data.Void
import           Text.Megaparsec

type ParseErrorBundle' = ParseErrorBundle String Void

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
  createError :: ErrorEntry e => a -> e -> String -> ErrorMessage
  createError breakpoint err input =
    ErrorBundle (offset breakpoint) err input emptyWrapper

data ErrorWrapper =
  ErrorWrapper String
               String
  deriving (Show, Eq)

emptyWrapper :: ErrorWrapper
emptyWrapper = ErrorWrapper "" ""

wrap :: ErrorWrapper -> String -> String
wrap (ErrorWrapper prefix suffix) msg = prefix ++ msg ++ suffix

createError' :: ErrorEntry e => e -> ErrorMessage
createError' e = ErrorMessage e emptyWrapper

data ErrorMessage where
  ErrorBundle
    :: ErrorEntry e => Offset -> e -> String -> ErrorWrapper -> ErrorMessage
  ErrorMessage :: ErrorEntry e => e -> ErrorWrapper -> ErrorMessage

type ErrorMessage' = String -> ErrorMessage

instance Eq ErrorMessage where
  e1 == e2 = show e1 == show e2

instance Show ErrorMessage where
  show e = "Error:  \n" ++ showInternal e

showInternal :: ErrorMessage -> String
showInternal (ErrorBundle (Offset o) err input wrapper) =
  let initialState =
        PosState
          { pstateInput = input
          , pstateOffset = 0
          , pstateSourcePos = initialPos ""
          , pstateTabWidth = defaultTabWidth
          , pstateLinePrefix = ""
          }
      bundle :: ParseErrorBundle' =
        ParseErrorBundle
          { bundleErrors =
              NonEmpty.fromList
                [FancyError o (Set.singleton $ ErrorFail (errorMessage err))]
          , bundlePosState = initialState
          }
   in wrap wrapper $ errorBundlePretty bundle
showInternal (ErrorMessage e wrapper) = wrap wrapper $ show e

withPrefix :: ErrorMessage -> String -> ErrorMessage
ErrorBundle o e i (ErrorWrapper p s) `withPrefix` p' =
  ErrorBundle o e i (ErrorWrapper (p' ++ p) s)
ErrorMessage e (ErrorWrapper p s) `withPrefix` p' =
  ErrorMessage e (ErrorWrapper (p' ++ p) s)

showErrorEntry :: ErrorMessage -> String
showErrorEntry (ErrorBundle _ e _ _) = show e
showErrorEntry (ErrorMessage e _)    = show e

hasError :: ErrorEntry e => ErrorMessage -> e -> Bool
(ErrorBundle _ err _ _) `hasError` e = errorMessage err == errorMessage e
(ErrorMessage err _) `hasError` e = errorMessage err == errorMessage e

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
