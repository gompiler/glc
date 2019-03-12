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
  createError :: a -> ErrorEntry -> String -> String
  createError breakpoint msg initialState =
    let (Offset o) = offset breakpoint
        bundle :: ErrorBundle =
          ParseErrorBundle
            { bundleErrors =
                NonEmpty.fromList
                  [FancyError o (Set.singleton $ ErrorFail (errorMessage msg))]
            , bundlePosState = createInitialState initialState
            }
     in errorBundlePretty bundle
  createError'' :: a -> String -> String -> String
  createError'' breakpoint msg = createError breakpoint (GenericError msg)

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

instance ErrorBreakpoint Offset where
  offset = id

data ErrorEntry
  = GenericError String
  | ListSizeMismatch
  | ExprStmtNotFunction
  | DuplicateDefault
  | ForPostDecl
  | InvalidBlankId
  | ContinueScope
  | BreakScope
  | TODO
  deriving (Show, Eq)

errorMessage :: ErrorEntry -> String
errorMessage err =
  case err of
    GenericError s   -> s
    ListSizeMismatch -> "LHS and RHS of assignments must be equal in length"
    ExprStmtNotFunction -> "Expression statements must be function calls"
    DuplicateDefault -> "Duplicate default found"
    InvalidBlankId -> "Invalid use of blank identifier"
    ForPostDecl -> "For post-statement cannot be declaration"
    ContinueScope -> "Continue statement must occur in for loop"
    BreakScope -> "Break statement must occur in for loop or switch statement"
    TODO             -> "todo"

-- | Given two lists, check if the sizes are equal, if not, output a corresponding error
checkListSize ::
     (ErrorBreakpoint a, ErrorBreakpoint b) => [a] -> [b] -> Maybe ErrorBundle'
checkListSize (_:t1) (_:t2) = checkListSize t1 t2
checkListSize [] (h2:_)     = Just $ createError h2 ListSizeMismatch
checkListSize (h1:_) []     = Just $ createError h1 ListSizeMismatch
checkListSize [] []         = Nothing
