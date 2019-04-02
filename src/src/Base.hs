module Base
  ( Glc
  , Glc'
  , GlcConstraint
  , module ErrorBundle
  , (<?>)
  , (<&>)
  , ($>)
  , (<$$>)
  , (<*->)
  ) where

import           Data.Functor (($>), (<&>))

import qualified Data.Maybe   as Maybe

import           ErrorBundle

type Glc a = Either ErrorMessage a

type Glc' a = Either ErrorMessage' a

type GlcConstraint a = a -> Maybe ErrorMessage'

infixl 4 <?>, <*->, <$$>

-- | Converts maybe to either, where input represents left side
{-# INLINE (<?>) #-}
(<?>) :: Maybe b -> a -> Either a b
val <?> m = Maybe.maybe (Left m) Right val

-- | Handles nested monads
{-# INLINE (<$$>) #-}
(<$$>) :: (Functor f, Functor g) => (a -> b) -> f (g a) -> f (g b)
h <$$> m = fmap h <$> m

-- | Variant of <*> where the application is pure
{-# INLINE (<*->) #-}
(<*->) :: Applicative f => f (a -> b) -> a -> f b
f <*-> x = f <*> pure x
