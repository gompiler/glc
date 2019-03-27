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
  , lookup
  , lookupCurrent
  , enterScope
  , enterScopeCtx
  , exitScope
  , currentScope
  , scopeLevel
  , topScope
  , getCtx
  , addMessage
  , getMessages
  , disableMessages
  , getMsgStatus
  ) where

import           Control.Monad           (unless)
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
newtype SymbolTable s v l c =
  SyT (STRef s (SymbolTable_ s v l c))

-- | Underlying symbol table type
data SymbolTable_ s v l c =
  SymbolTable (NonEmpty (SymbolScope s v c))
              [l] -- List for messages
              Bool -- Are messages disabled or not

-- | Symbol table level
-- Scope starts at 0 and increases as you enter new scopes
newtype Scope =
  Scope Int
  deriving (Show, Eq)

type HashTable s v = HT.HashTable s String v

-- | SymbolScope type; scope + hashtable
type SymbolScope s v c = (Scope, HashTable s v, Maybe c)

{-# INLINE newRef #-}
newRef :: SymbolTable_ s v l c -> ST s (SymbolTable s v l c)
newRef = fmap SyT . newSTRef

{-# INLINE writeRef #-}
writeRef :: SymbolTable s v l c -> SymbolTable_ s v l c -> ST s ()
writeRef (SyT ref) = writeSTRef ref

{-# INLINE readRef #-}
readRef :: SymbolTable s v l c -> ST s (SymbolTable_ s v l c)
readRef (SyT ref) = readSTRef ref

-- | Initialize a symbol table with a single top level scope
new :: ST s (SymbolTable s v l c)
new = do
  ht <- HT.new
  newRef $ SymbolTable (fromList [(Scope 1, ht, Nothing)]) [] False

-- | Inserts a key value pair at the upper most scope and return scope level
insert :: SymbolTable s v l c -> String -> v -> ST s Scope
insert st k v = do
  SymbolTable ((Scope s, ht, _) :| _) _ _ <- readRef st
  HT.insert ht k v
  return (Scope s)

-- | Look up provided key across all scopes, starting with the top
lookup :: SymbolTable s v l c -> String -> ST s (Maybe (Scope, v))
lookup st !k = do
  SymbolTable scopes _ _ <- readRef st
  asum <$> mapM lookup' (toList scopes)
  where
    lookup' :: SymbolScope s v c -> ST s (Maybe (Scope, v))
    lookup' (scope, ht, _) = do
      v <- HT.lookup ht k
      return $! fmap (scope, ) v

-- | Look up provided key at current scope only
lookupCurrent :: SymbolTable s v l c -> String -> ST s (Maybe (Scope, v))
lookupCurrent st !k = do
  (scope, ht, _) <- currentScope st
  v <- HT.lookup ht k
  return $! fmap (scope, ) v

-- | Create new scope
enterScope :: SymbolTable s v l c -> ST s ()
enterScope st = do
  SymbolTable st'@((Scope scope, _, ctx) :| _) list msgStatus <- readRef st
  ht <- HT.new
  writeRef st $!
    SymbolTable ((Scope (scope + 1), ht, ctx) <| st') list msgStatus

-- | Create new scope with new context
enterScopeCtx :: SymbolTable s v l c -> c -> ST s ()
enterScopeCtx st ctx = do
  SymbolTable st'@((Scope scope, _, _) :| _) list msgStatus <- readRef st
  ht <- HT.new
  writeRef st $!
    SymbolTable ((Scope (scope + 1), ht, Just ctx) <| st') list msgStatus

-- | Discard current scope
-- Note that if the current scope is the last scope,
-- A crash will occur
exitScope :: SymbolTable s v l c -> ST s ()
exitScope st = do
  SymbolTable (_ :| scopes) list msgStatus <- readRef st
  writeRef st $! SymbolTable (fromList scopes) list msgStatus

-- | Retrieve current scope level
scopeLevel :: SymbolTable s v l c -> ST s Scope
scopeLevel st = do
  SymbolTable ((scope, _, _) :| _) _ _ <- readRef st
  return scope

-- | Retrieve the current symbol scope
currentScope :: SymbolTable s v l c -> ST s (SymbolScope s v c)
currentScope st = do
  SymbolTable (s :| _) _ _ <- readRef st
  return s

-- | Retrieve top level scope (scope 0)
topScope :: SymbolTable s v l c -> ST s (SymbolScope s v c)
topScope st = do
  SymbolTable scopes _ _ <- readRef st
  return $! NonEmpty.last scopes

-- | Get context
getCtx :: SymbolTable s v l c -> ST s (Maybe c)
getCtx st = do
  SymbolTable ((_, _, ctx) :| _) _ _ <- readRef st
  return ctx

-- | Add a new message
addMessage :: SymbolTable s v l c -> l -> ST s ()
addMessage st !msg = do
  SymbolTable scopes list msgDisabled <- readRef st
  -- Only add messages if messages are enabled
  unless msgDisabled $!
    writeRef st $! SymbolTable scopes (msg : list) msgDisabled

-- | Retrieve list of messages in the order they were stored
getMessages :: SymbolTable s v l c -> ST s [l]
getMessages st = do
  SymbolTable _ list _ <- readRef st
  return $! reverse list

disableMessages :: SymbolTable s v l c -> ST s ()
disableMessages st = do
  SymbolTable scopes list _ <- readRef st
  writeRef st $ SymbolTable scopes list True

getMsgStatus :: SymbolTable s v l c -> ST s Bool
getMsgStatus st = do
  SymbolTable _ _ msgStatus <- readRef st
  return msgStatus
