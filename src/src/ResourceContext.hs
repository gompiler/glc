{-# LANGUAGE NamedFieldPuns      #-}
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}

module ResourceContext
  ( ResourceContext
  , new
  , wrap
  , structName
  , varIndex
  , allStructs
  , newLabel
  , newLoopLabel
  , currentLoopLabel
  , localLimit
  ) where

import           Base
import qualified CheckedData             as C
import           Control.Monad.ST
import           Data.Hashable
import qualified Data.HashTable.ST.Basic as HT
import           Data.Maybe              (catMaybes, listToMaybe)
import           Data.STRef
import           Prelude                 hiding (lookup)
import           ResourceData

newtype ResourceContext s =
  ResourceContext (STRef s (ResourceContext_ s))

-- | Context required to generate the resource AST
-- While we only need to store a counter,
-- this makes it easier to fetch the ordered struct list
data ResourceContext_ s = RC
  { structTypes   :: [StructType]
  , structMap     :: StructTable s
  , varScopes     :: [ResourceScope s]
  , labelCounter  :: Int
  , lastLoopLabel :: Int
  }

-- | Scope, with its own set of declared variables and offset values
data ResourceScope s = RS
  { varTable   :: VarTable s
  -- | Scope's counter size
  -- Each varCounter starts at the value of the previous scope,
  -- or 0 if the scope is global.
  -- To create a new index, we use the current counter, then increment the value
  , varCounter :: Int
  -- | Max varCounter within current scope
  -- This is propagated from all children's varCounters, where only
  -- the max value is kept
  , varLimit   :: Int
  }

newtype VarKey =
  VarKey C.ScopedIdent
  deriving (Show, Eq)

instance Hashable VarKey where
  hashWithSalt salt (VarKey (C.ScopedIdent (C.Scope s) (C.Ident ident))) =
    hashWithSalt salt s * 13 + hashWithSalt salt ident

type VarTable s = HT.HashTable s VarKey VarIndex

newtype StructKey =
  StructKey [FieldDecl]
  deriving (Show, Eq)

instance Hashable StructKey where
  hashWithSalt salt (StructKey fields) =
    foldl (\a b -> a * 3 + b) 0 (map hashField fields)
    where
      hashField :: FieldDecl -> Int
      hashField (FieldDecl (C.Ident i) _) = hashWithSalt salt i

type StructTable s = HT.HashTable s StructKey StructType

{-# INLINE newRef #-}
newRef :: ResourceContext_ s -> ST s (ResourceContext s)
newRef = fmap ResourceContext . newSTRef

{-# INLINE writeRef #-}
writeRef :: ResourceContext s -> ResourceContext_ s -> ST s ()
writeRef (ResourceContext ref) = writeSTRef ref

{-# INLINE readRef #-}
readRef :: ResourceContext s -> ST s (ResourceContext_ s)
readRef (ResourceContext ref) = readSTRef ref

new :: ST s (ResourceContext s)
new = do
  structMap' <- HT.new
  newRef $
    RC
      { structTypes = []
      , varScopes = []
      , structMap = structMap'
      , labelCounter = 0
      , lastLoopLabel = 0
      }

-- | Create a new resource scope
newScope :: [ResourceScope s] -> ST s (ResourceScope s)
newScope scopes = do
  m <- HT.new
  return $ RS {varTable = m, varCounter = varCounter' scopes, varLimit = 0}
  where
    varCounter' :: [ResourceScope s] -> Int
    varCounter' []                  = 0
    varCounter' (RS {varCounter}:_) = varCounter

wrap :: ResourceContext s -> ST s a -> ST s a
wrap rc action = do
  enterScope rc
  a <- action
  exitScope rc
  return a

localLimit :: ResourceContext s -> ST s LocalLimit
localLimit st = do
  rc <- readRef st
  let scope = head $! varScopes rc
  return $! LocalLimit $! max (varLimit scope) (varCounter scope)

-- | Create a new scope level
enterScope :: ResourceContext s -> ST s ()
enterScope st = do
  rc <- readRef st
  scope <- newScope $ varScopes rc
  let vars = scope : varScopes rc
  writeRef st $! rc {varScopes = vars}

-- | Exit current scope level
-- This allows us to reuse offsets for all variables created in the current scope
-- Note that there's no catch if we attempt to exit the global scope
exitScope :: ResourceContext s -> ST s ()
exitScope st = do
  rc <- readRef st
  let varScopes' = exitScope' $ varScopes rc
  writeRef st $! rc {varScopes = varScopes'}
    -- | Remove current scope, and update parent's limit with current counter
    -- if it exists
  where
    exitScope' :: [ResourceScope s] -> [ResourceScope s]
    exitScope' (curr:parent:vars) =
      let varLimit' = maximum [varLimit curr, varCounter curr, varLimit parent]
       in parent {varLimit = varLimit'} : vars
    exitScope' (_:vars) = vars
    -- Note that this should never happen, given that we
    -- don't expose enter and exit for public use.
    -- Each exit only occurs with an enter
    exitScope' [] = []

-- | Get the index of the provided scope ident
-- If it already exists, output will be existing index
-- Otherwise, we will output 1 greater than the biggest index to date
varIndex :: forall s. ResourceContext s -> C.ScopedIdent -> Type -> ST s VarIndex
varIndex st si vt = do
  let key = VarKey si
  rc <- readRef st
  candidates <- mapM (varIndex' key) $ varScopes rc
  case listToMaybe $ catMaybes candidates of
    Just index -> return index
    Nothing -> do
      let (v:vars) = varScopes rc
      (value, v') <- setVarIndex' v key
      writeRef st $! rc {varScopes = v' : vars} -- Replace current scope
      return value
  where
    setVarIndex' ::
         ResourceScope s -> VarKey -> ST s (VarIndex, ResourceScope s)
    setVarIndex' rs@RS {varTable, varCounter} key =
      let value = VarIndex varCounter
       in HT.insert varTable key value $>
          (value, rs {varCounter = varCounter + increment})
      where
        increment :: Int
        increment =
          case vt of
            PFloat64 -> 2
            _        -> 1
    -- | Get the index of the provided key, or return the size of the current scope
    varIndex' :: VarKey -> ResourceScope s -> ST s (Maybe VarIndex)
    varIndex' key RS {varTable} = HT.lookup varTable key

-- | Returns a label id that is unique across the entire program
newLabel :: ResourceContext s -> ST s LabelIndex
newLabel st = do
  rc <- readRef st
  let i = labelCounter rc
  writeRef st $! rc {labelCounter = i + 1}
  return $ LabelIndex i

-- | Returns a label id that is unique across the entire program
-- We will also store it as the last loop label,
-- as it will be used for things like 'break' and 'continue'
newLoopLabel :: ResourceContext s -> ST s LabelIndex
newLoopLabel st = do
  rc <- readRef st
  let i = labelCounter rc
  writeRef st $! rc {labelCounter = i + 1, lastLoopLabel = i}
  return $ LabelIndex i

-- | Returns the last label created
currentLoopLabel :: ResourceContext s -> ST s LabelIndex
currentLoopLabel st = LabelIndex . lastLoopLabel <$> readRef st

-- | Gets the associated struct type from a list of fields
-- Note that field order matters, though two structs with the same keys and type
-- But in different orders are technically the same
structName :: forall s. ResourceContext s -> [FieldDecl] -> ST s C.Ident
structName st fields = do
  let key = StructKey fields
  rc <- readRef st
  let m = structMap rc
  candidate <- HT.lookup m key
  case candidate of
    Just (Struct name _) -> return name
    Nothing
      -- Create the new StructType, save it in the hashmap,
      -- and update our struct list
     -> do
      let name = structName' $ length (structTypes rc) + 1
          value = Struct name fields
          structTypes' = value : structTypes rc
      _ <- HT.insert m key value
      writeRef st $! rc {structTypes = structTypes'}
      return $! name
  where
    structName' :: Int -> C.Ident
    structName' i = C.Ident $ "GlcStruct" ++ show i

-- | Returns a list of unique structs, ordered by creation
allStructs :: ResourceContext s -> ST s [StructType]
allStructs st = reverse . structTypes <$> readRef st