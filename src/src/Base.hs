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
  , (<$->)
  , mapS
  ) where

import           Data.Functor (($>), (<&>))

import qualified Data.Maybe   as Maybe

import           ErrorBundle

type Glc a = Either ErrorMessage a

type Glc' a = Either ErrorMessage' a

type GlcConstraint a = a -> Maybe ErrorMessage'

infixl 4 <?>, <$->, <*->, <$$>

-- | Converts maybe to either, where input represents left side
{-# INLINE (<?>) #-}
(<?>) :: Maybe b -> a -> Either a b
val <?> m = Maybe.maybe (Left m) Right val

-- | Handles nested monads
{-# INLINE (<$$>) #-}
(<$$>) :: (Functor f, Functor g) => (a -> b) -> f (g a) -> f (g b)
h <$$> m = fmap h <$> m

-- | Variant of <$> where the application is pure
{-# INLINE (<$->) #-}
(<$->) :: Applicative f => (a -> b) -> a -> f b
f <$-> x = f <$> pure x

-- | Variant of <*> where the application is pure
{-# INLINE (<*->) #-}
(<*->) :: Applicative f => f (a -> b) -> a -> f b
f <*-> x = f <*> pure x

-- | Applies map to a traversable monad
mapS ::
     (Traversable t, Monad m, Monad f) => (a -> f (m b)) -> t a -> f (m (t b))
mapS f x = sequence <$> mapM f x
