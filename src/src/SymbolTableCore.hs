{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs                     #-}

module SymbolTableCore
  (
  ) where

import           Control.Applicative     (Alternative)
import           Control.Monad.ST
import           Data
import           Data.Either             (partitionEithers)
import           Data.Foldable           (asum)
import           Data.Functor.Compose    (Compose (..), getCompose)
import           Data.Hashable           (Hashable (..))
import qualified Data.HashTable.Class    as H
import qualified Data.HashTable.ST.Basic as HT
import           Data.List.NonEmpty      (NonEmpty (..), fromList, toList, (<|))
import           Data.STRef
import           ErrorBundle
import           GHC.Base                (liftM)

-- | SymbolTable, cactus stack of SymbolScope
-- * s - st monad state?
-- * k - key type for hashtable
-- * v - value type for hashtable
-- * l - type for list data
newtype SymbolTable s v l =
  SyT (STRef s (SymbolTable_ s v l))

data SymbolTable_ s v l =
  SymbolTable (NonEmpty (SymbolScope s v))
              [l]

--STRef s {scopes :: NonEmpty (SymbolScope s k v), list :: [l]}
newtype Scope =
  Scope Int -- Depth

newtype Ident =
  Ident String
  deriving (Eq)

instance Hashable Ident where
  hashWithSalt i (Ident s) = hashWithSalt i s

type HashTable s v = HT.HashTable s Ident v

--instance Hashable Ident where
--  hashWithSalt :: Int -> Ident -> Int
--  hashWithSalt a (Ident s) = hashWithSalt a s
-- | SymbolScope type, one scope for our SymbolTable.
-- * s - st monad state?
-- * k - key type for hashtable
-- * v - value type for hashtable
type SymbolScope s v = (Scope, HashTable s v)

-- | SymbolInfo: Extraction of a single value from the hashtable
type SymbolInfo v = (Scope, Ident, v)

newRef :: SymbolTable_ s v l -> ST s (SymbolTable s v l)
newRef = fmap SyT . newSTRef

{-# INLINE newRef #-}
writeRef :: SymbolTable s v l -> SymbolTable_ s v l -> ST s ()
writeRef (SyT ref) = writeSTRef ref

{-# INLINE writeRef #-}
readRef :: SymbolTable s v l -> ST s (SymbolTable_ s v l)
readRef (SyT ref) = readSTRef ref

{-# INLINE readRef #-}
-- | Initialize a symbol table with base types
new :: ST s (SymbolTable s v l)
new = do
  ht <- HT.new
  newRef $ SymbolTable (fromList [(Scope 0, ht)]) [] -- Depth 0

data Three a b
  = Error a
  | Succeed b
  | SucceedBlank

-- | Check if we can add provided key and value
-- We can either error, add something to the list, or proceed without further action
canAdd :: NonEmpty (SymbolScope s v) -> Ident -> v -> ST s (Three e l)
canAdd = undefined

insert :: SymbolTable s v l -> Ident -> v -> ST s ()
insert st k v = do
  SymbolTable ss@((scope, ht) :| _) list <- readRef st
  HT.insert ht k v

newScope :: SymbolTable s v l -> ST s ()
newScope st = do
  SymbolTable st'@((Scope scope, _) :| _) list <- readRef st
  ht <- HT.new
  writeRef st $ SymbolTable ((Scope (scope + 1), ht) <| st') list

topScope :: SymbolTable s v l -> ST s (HashTable s v)
topScope st = do
  SymbolTable st'@((_, ht) :| _) list <- readRef st
  return ht
