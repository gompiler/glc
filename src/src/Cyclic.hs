{-# LANGUAGE GADTs #-}

-- | Allows cyclic data to be stored without cyclic structures
-- The data must contain some key to represent a cycle.
-- We then store both the root structure as well as the current structure.
-- When the current structure is the cycle, we return the root structure instead.
-- Modification of the current structure simply involves map or set,
-- where we return the original root structure.
-- Eq and Show are both implemented with this in mind.
-- For instance, eq will compare the current structure, and only compare the root
-- if a cycle is detected
module Cyclic
  ( CyclicContainer(..)
  , Cyclic(..)
  , new
  , get
  , mapContainer
  , fmapContainer
  , flipC
  , getRoot
  , mapEither
  , set
  , map
  , getActual
  ) where

import           Prelude hiding (map)

data CyclicContainer a where
  CyclicContainer :: Cyclic a => a -> a -> CyclicContainer a

instance Eq a => Eq (CyclicContainer a)
  -- | Compares current item, and compares root if a cycle is found
                                                                    where
  (CyclicContainer r1 c1) == (CyclicContainer r2 c2) =
    c1 == c2 && (not (hasRoot c1) || r1 == r2)

instance Show a => Show (CyclicContainer a) where
  show (CyclicContainer root current) =
    show $
    if isRoot current
      then root
      else current

-- | Create a new container, where the provided data
-- is both the current structure and root structure
new :: Cyclic a => a -> CyclicContainer a
new root = CyclicContainer root root

-- | Gets the current value, or the root if it's a cycle
get :: CyclicContainer a -> a
get (CyclicContainer root current) =
  if isRoot current
    then root
    else current

-- | Gets the root value
getRoot :: CyclicContainer a -> a
getRoot (CyclicContainer root _) = root

-- | Gets the current value without any conversion
getActual :: CyclicContainer a -> a
getActual (CyclicContainer _ current) = current

-- | Sets current value
set :: CyclicContainer a -> a -> CyclicContainer a
set (CyclicContainer root _) = CyclicContainer root

-- | Map current value, retaining root
map :: (a -> a) -> CyclicContainer a -> CyclicContainer a
map action c = set c $ action $ get c

-- | Map against both root and current
mapContainer ::
     (Cyclic a, Cyclic b) => (a -> b) -> CyclicContainer a -> CyclicContainer b
mapContainer action (CyclicContainer root current) =
  CyclicContainer (action root) (action current)

-- | Map container with an Either output
-- Result is Left if any part of the cyclic container is Left
mapEither ::
     (Cyclic a, Cyclic b)
  => (a -> Either e b)
  -> CyclicContainer a
  -> Either e (CyclicContainer b)
mapEither action (CyclicContainer root current) =
  case (action root, action current) of
    (Left err, _)                 -> Left err
    (_, Left err)                 -> Left err
    (Right root', Right current') -> Right $ CyclicContainer root' current'

fmapContainer ::
     (Cyclic a, Monad m)
  => (a -> m a)
  -> CyclicContainer a
  -> m (CyclicContainer a)
fmapContainer action (CyclicContainer root current) =
  CyclicContainer <$> action root <*> action current

-- | Flip order of monads
flipC :: (Cyclic a, Monad m) => CyclicContainer (m a) -> m (CyclicContainer a)
flipC (CyclicContainer mRoot mCurrent) = CyclicContainer <$> mRoot <*> mCurrent

class Cyclic a where
  isRoot :: a -> Bool
  hasRoot :: a -> Bool

instance Cyclic a => Cyclic (CyclicContainer a) where
  isRoot = isRoot . get
  hasRoot = hasRoot . get
