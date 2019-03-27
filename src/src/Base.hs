module Base
  ( Glc
  , Glc'
  , GlcConstraint
  , module ErrorBundle
  , (<?>)
  , (<&>)
  , ($>)
  ) where

import           Data.Functor (($>), (<&>))

import qualified Data.Maybe   as Maybe

import           ErrorBundle

type Glc a = Either ErrorMessage a

type Glc' a = Either ErrorMessage' a

type GlcConstraint a = a -> Maybe ErrorMessage'

infixl 4 <?>

(<?>) :: Maybe b -> a -> Either a b
val <?> m = Maybe.maybe (Left m) Right val
