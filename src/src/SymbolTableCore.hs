{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs                     #-}
{-# LANGUAGE TupleSections             #-}

-- Heavily modeled around https://hackage.haskell.org/package/hashtables-1.2.3.1/docs/src/Data-HashTable-ST-Basic.html#HashTable
module SymbolTableCore
  ( SymbolTable
  , Scope(..)
  , Ident(..)
  , new
  , insert
  , lookup
  , lookupCurrent
  , enterScope
  , exitScope
  , currentScope
  , topScope
  , addMessage
  , getMessages
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
import qualified Data.List.NonEmpty      as NonEmpty (last)
import           Data.STRef
import           ErrorBundle
import           GHC.Base                (liftM)
import           Prelude                 hiding (lookup)

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

-- | SymbolScope type, one scope for our SymbolTable.
-- * s - st monad state?
-- * k - key type for hashtable
-- * v - value type for hashtable
type SymbolScope s v = (Scope, HashTable s v)

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

-- | Inserts a key value pair at the upper most scope
insert :: SymbolTable s v l -> Ident -> v -> ST s ()
insert st k v = do
  SymbolTable ss@((scope, ht) :| _) list <- readRef st
  HT.insert ht k v

-- | Look up provided key across all scopes, starting with the top
lookup :: SymbolTable s v l -> Ident -> ST s (Maybe (Scope, v))
lookup st k = do
  SymbolTable scopes _ <- readRef st
  asum <$> mapM lookup' (toList scopes)
  where
    lookup' :: SymbolScope s v -> ST s (Maybe (Scope, v))
    lookup' (scope, ht) = do
      v <- HT.lookup ht k
      return $ fmap (scope, ) v

-- | Look up provided key at current scope only
lookupCurrent :: SymbolTable s v l -> Ident -> ST s (Maybe (Scope, v))
lookupCurrent st k = do
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
exitScope :: SymbolTable s v l -> ST s ()
exitScope st = do
  SymbolTable st'@(_ :| scopes) list <- readRef st
  writeRef st $ SymbolTable (fromList scopes) list

-- | Retrieve the current symbol scope
currentScope :: SymbolTable s v l -> ST s (SymbolScope s v)
currentScope st = do
  SymbolTable st'@(s :| _) list <- readRef st
  return s

-- | Retrieve top level scope (scope 0)
topScope :: SymbolTable s v l -> ST s (SymbolScope s v)
topScope st = do
  SymbolTable scopes list <- readRef st
  return $ NonEmpty.last scopes

-- | Add a new message
addMessage :: SymbolTable s v l -> l -> ST s ()
addMessage st msg = do
  SymbolTable scopes list <- readRef st
  writeRef st $ SymbolTable scopes (msg : list)

-- | Retrieve list of messages in the order they were stored
getMessages :: SymbolTable s v l -> ST s [l]
getMessages st = do
  SymbolTable _ list <- readRef st
  return $ reverse list
