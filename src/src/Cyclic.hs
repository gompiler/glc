{-# LANGUAGE GADTs #-}

module Cyclic
  ( CyclicContainer
  , Cyclic(..)
  , new
  , get
  , mapContainer
  , getRoot
  , set
  , map
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

new :: Cyclic a => a -> CyclicContainer a
new root = CyclicContainer root root

get :: CyclicContainer a -> a
get (CyclicContainer root current) =
  if isRoot current
    then root
    else current

getRoot :: CyclicContainer a -> a
getRoot (CyclicContainer root _) = root

set :: CyclicContainer a -> a -> CyclicContainer a
set (CyclicContainer root _) = CyclicContainer root

map :: (a -> a) -> CyclicContainer a -> CyclicContainer a
map action c = set c $ action $ get c

mapContainer ::
     (Cyclic a, Cyclic b) => (a -> b) -> CyclicContainer a -> CyclicContainer b
mapContainer action (CyclicContainer root current) =
  CyclicContainer (action root) (action current)

class Cyclic a where
  isRoot :: a -> Bool
  hasRoot :: a -> Bool
