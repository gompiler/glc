{-# LANGUAGE BangPatterns  #-}
{-# LANGUAGE GADTs         #-}
{-# LANGUAGE TupleSections #-}

-- | State based eager symbol table
-- Heavily modeled around https://hackage.haskell.org/package/hashtables-1.2.3.1/docs/src/Data-HashTable-ST-Basic.html#HashTable
module SymbolTableCore
  ( SymbolTable
  , SymbolScope
  , Scope(..)
  , new
  , insert
  , insert'
  , lookup
  , lookupCurrent
  , enterScope
  , exitScope
  , currentScope
  , scopeLevel
  , topScope
  , addMessage
  , getMessages
  ) where

import           Control.Monad.ST
import           Data.Foldable           (asum)
import qualified Data.HashTable.ST.Basic as HT
import           Data.List.NonEmpty      (NonEmpty (..), fromList, toList, (<|))
import qualified Data.List.NonEmpty      as NonEmpty (last)
import           Data.STRef
import           Prelude                 hiding (lookup)

-- | SymbolTable, cactus stack of SymbolScope
-- * s - st monad state
-- * k - the hashtable key type is hardcoded to String
-- * v - value type for hashtable
-- * l - type for list data
newtype SymbolTable s v l =
  SyT (STRef s (SymbolTable_ s v l))

-- | Underlying symbol table type
data SymbolTable_ s v l =
  SymbolTable (NonEmpty (SymbolScope s v))
              [l]

-- | Symbol table level
-- Scope starts at 0 and increases as you enter new scopes
newtype Scope =
  Scope Int
  deriving (Show, Eq)

type HashTable s v = HT.HashTable s String v

-- | SymbolScope type; scope + hashtable
type SymbolScope s v = (Scope, HashTable s v)

{-# INLINE newRef #-}
newRef :: SymbolTable_ s v l -> ST s (SymbolTable s v l)
newRef = fmap SyT . newSTRef

{-# INLINE writeRef #-}
writeRef :: SymbolTable s v l -> SymbolTable_ s v l -> ST s ()
writeRef (SyT ref) = writeSTRef ref

{-# INLINE readRef #-}
readRef :: SymbolTable s v l -> ST s (SymbolTable_ s v l)
readRef (SyT ref) = readSTRef ref

-- | Initialize a symbol table with a single top level scope
new :: ST s (SymbolTable s v l)
new = do
  ht <- HT.new
  newRef $ SymbolTable (fromList [(Scope 0, ht)]) []

-- | Inserts a key value pair at the upper most scope
insert :: SymbolTable s v l -> String -> v -> ST s ()
insert st !k !v = do
  SymbolTable ((_, ht) :| _) _ <- readRef st
  HT.insert ht k v

-- | Inserts a key value pair at the upper most scope and return scope level
insert' :: SymbolTable s v l -> String -> v -> ST s Scope
insert' st k v = do
  SymbolTable ((Scope s, ht) :| _) _ <- readRef st
  HT.insert ht k v
  return (Scope $ s + 1)

-- | Look up provided key across all scopes, starting with the top
lookup :: SymbolTable s v l -> String -> ST s (Maybe (Scope, v))
lookup st !k = do
  SymbolTable scopes _ <- readRef st
  asum <$> mapM lookup' (toList scopes)
  where
    lookup' :: SymbolScope s v -> ST s (Maybe (Scope, v))
    lookup' (scope, ht) = do
      v <- HT.lookup ht k
      return $ fmap (scope, ) v

-- | Look up provided key at current scope only
lookupCurrent :: SymbolTable s v l -> String -> ST s (Maybe (Scope, v))
lookupCurrent st !k = do
  (scope, ht) <- currentScope st
  v <- HT.lookup ht k
  return $ fmap (scope, ) v

-- | Create new scope
enterScope :: SymbolTable s v l -> ST s ()
enterScope st = do
  SymbolTable st'@((Scope scope, _) :| _) list <- readRef st
  ht <- HT.new
  writeRef st $ SymbolTable ((Scope (scope + 1), ht) <| st') list

-- | Discard current scope
-- Note that if the current scope is the last scope,
-- A crash will occur
exitScope :: SymbolTable s v l -> ST s ()
exitScope st = do
  SymbolTable (_ :| scopes) list <- readRef st
  writeRef st $ SymbolTable (fromList scopes) list

-- | Retrieve current scope level
scopeLevel :: SymbolTable s v l -> ST s Scope
scopeLevel st = do
  SymbolTable ((scope, _) :| _) _ <- readRef st
  return scope

-- | Retrieve the current symbol scope
currentScope :: SymbolTable s v l -> ST s (SymbolScope s v)
currentScope st = do
  SymbolTable (s :| _) _ <- readRef st
  return s

-- | Retrieve top level scope (scope 0)
topScope :: SymbolTable s v l -> ST s (SymbolScope s v)
topScope st = do
  SymbolTable scopes _ <- readRef st
  return $ NonEmpty.last scopes

-- | Add a new message
addMessage :: SymbolTable s v l -> l -> ST s ()
addMessage st !msg = do
  SymbolTable scopes list <- readRef st
  writeRef st $ SymbolTable scopes (msg : list)

-- | Retrieve list of messages in the order they were stored
getMessages :: SymbolTable s v l -> ST s [l]
getMessages st = do
  SymbolTable _ list <- readRef st
  return $ reverse list