module Cyclic
  ( CyclicContainer
  , Cyclic(..)
  , new
  , get
  , set
  , map
  ) where

import           Prelude hiding (map)

data CyclicContainer a =
  CyclicContainer a
                  a

instance Eq a => Eq (CyclicContainer a) where
  (CyclicContainer r1 c1) == (CyclicContainer r2 c2) = r1 == r2 && c1 == c2

instance Show a => Show (CyclicContainer a) where
  show (CyclicContainer _ c) = show c

new :: Cyclic a => a -> CyclicContainer a
new root = CyclicContainer root root

get :: Cyclic a => CyclicContainer a -> a
get (CyclicContainer root current) =
  if isRoot current
    then root
    else current

set :: Cyclic a => CyclicContainer a -> a -> CyclicContainer a
set (CyclicContainer root _) = CyclicContainer root

map :: Cyclic a => (a -> a) -> CyclicContainer a -> CyclicContainer a
map action c = set c $ action $ get c

class Cyclic a where
  isRoot :: a -> Bool
