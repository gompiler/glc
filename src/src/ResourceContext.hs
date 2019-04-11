{-# LANGUAGE NamedFieldPuns      #-}
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}

module ResourceContext
  ( ResourceContext
  , new
  , wrap
  , structName
  , varIndex
  , paramIndex
  , allStructs
  , newLabel
  , newLabel'
  , breakParent
  , continueParent
  , breakParentLabel
  , continueParentLabel
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
  { _structTypes          :: [StructType]
  , _structMap            :: StructTable s
  , _varScopes            :: [ResourceScope s]
  , _labelCounter         :: Int
  , _breakParentLabel    :: Int
  , _continueParentLabel :: Int
  }

-- | Scope, with its own set of declared variables and offset values
data ResourceScope s = RS
  { _varTable   :: VarTable s
  -- | Scope's counter size
  -- Each varCounter starts at the value of the previous scope,
  -- or 0 if the scope is global.
  -- To create a new index, we use the current counter, then increment the value
  , _varCounter :: Int
  -- | Max varCounter within current scope
  -- This is propagated from all children's varCounters, where only
  -- the max value is kept
  , _varLimit   :: Int
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
  structMap <- HT.new
  newRef $
    RC
      { _structTypes = []
      , _varScopes = []
      , _structMap = structMap
      , _labelCounter = 0
      , _breakParentLabel = 0
      , _continueParentLabel = 0
      }

-- | Create a new resource scope
newScope :: [ResourceScope s] -> ST s (ResourceScope s)
newScope scopes = do
  m <- HT.new
  return $ RS {_varTable = m, _varCounter = varCounter scopes, _varLimit = 0}
  where
    varCounter :: [ResourceScope s] -> Int
    varCounter []                  = 0
    varCounter (RS {_varCounter}:_) = _varCounter

wrap :: ResourceContext s -> ST s a -> ST s a
wrap rc action = do
  enterScope rc
  a <- action
  exitScope rc
  return a

localLimit :: ResourceContext s -> ST s LocalLimit
localLimit st = do
  rc <- readRef st
  let scope = head $! _varScopes rc
  return $! LocalLimit $! max (_varLimit scope) (_varCounter scope)

-- | Create a new scope level
enterScope :: ResourceContext s -> ST s ()
enterScope st = do
  rc <- readRef st
  scope <- newScope $ _varScopes rc
  let vars = scope : _varScopes rc
  writeRef st $! rc {_varScopes = vars}

-- | Exit current scope level
-- This allows us to reuse offsets for all variables created in the current scope
-- Note that there's no catch if we attempt to exit the global scope
exitScope :: ResourceContext s -> ST s ()
exitScope st = do
  rc <- readRef st
  let varScopes = exitScope' $ _varScopes rc
  writeRef st $! rc {_varScopes = varScopes}
    -- | Remove current scope, and update parent's limit with current counter
    -- if it exists
  where
    exitScope' :: [ResourceScope s] -> [ResourceScope s]
    exitScope' (curr:parent:vars) =
      let varLimit = maximum [_varLimit curr, _varCounter curr, _varLimit parent]
       in parent {_varLimit = varLimit} : vars
    exitScope' (_:vars) = vars
    -- Note that this should never happen, given that we
    -- don't expose enter and exit for public use.
    -- Each exit only occurs with an enter
    exitScope' [] = []

type VarIndexFunc s
   = ResourceContext s -> C.ScopedIdent -> Type -> ST s VarIndex

paramIndex :: forall s. VarIndexFunc s
paramIndex = varIndexBase True

varIndex :: forall s. VarIndexFunc s
varIndex = varIndexBase False

-- | Get the index of the provided scope ident
-- If it already exists, output will be existing index
-- Otherwise, we will output 1 greater than the biggest index to date
varIndexBase :: forall s. Bool -> VarIndexFunc s
varIndexBase requiresNew st si vt = do
  let key = VarKey si
  rc <- readRef st
  candidates <-
    if requiresNew
      then pure []
      else mapM (varIndex' key) $ _varScopes rc
  case listToMaybe $ catMaybes candidates of
    Just index -> return index
    Nothing -> do
      let (v:vars) = _varScopes rc
      (value, v') <- setVarIndex' v key
      writeRef st $! rc {_varScopes = v' : vars} -- Replace current scope
      return value
  where
    setVarIndex' ::
         ResourceScope s -> VarKey -> ST s (VarIndex, ResourceScope s)
    setVarIndex' rs@RS {_varTable, _varCounter} key =
      let value = VarIndex _varCounter
       in HT.insert _varTable key value $>
          (value, rs {_varCounter = _varCounter + increment})
        -- | Not all types have the same size
      where
        increment :: Int
        increment =
          case (vt, si) of
            (PFloat64, _)                    -> 2
            (_, C.ScopedIdent _ (Ident "_")) -> 2 -- Holes are re-usable, so should always be double-width
            _                                -> 1
    -- | Get the index of the provided key, or return the size of the current scope
    varIndex' :: VarKey -> ResourceScope s -> ST s (Maybe VarIndex)
    varIndex' key RS {_varTable} = HT.lookup _varTable key

data LabelContext = LabelContext
  -- Label used for break statement
  { _breakParent    :: Bool
  -- Label used for continue statement
  , _continueParent :: Bool
  }

defaultLabelContext :: LabelContext
defaultLabelContext =
  LabelContext {_breakParent = False, _continueParent = False}

-- | Marks label context as break parent
breakParent :: LabelContext -> LabelContext
breakParent c = c {_breakParent = True}

-- | Marks label context as continue parent
continueParent :: LabelContext -> LabelContext
continueParent c = c {_continueParent = True}

-- | Returns a label id that is unique across the entire program
-- Label parents are also updated depending on the context
newLabel :: ResourceContext s -> ST s LabelIndex
newLabel = newLabel' id

newLabel' ::
     (LabelContext -> LabelContext) -> ResourceContext s -> ST s LabelIndex
newLabel' context st = do
  let c = context defaultLabelContext
  rc <- readRef st
  let i = _labelCounter rc
  writeRef st $!
    rc
      { _labelCounter = i + 1
      , _breakParentLabel =
          if _breakParent c
            then i
            else _breakParentLabel rc
      , _continueParentLabel =
          if _continueParent c
            then i
            else _continueParentLabel rc
      }
  return $! LabelIndex i

-- | Return the destination label of a break statement
breakParentLabel :: ResourceContext s -> ST s LabelIndex
breakParentLabel st = LabelIndex . _breakParentLabel <$> readRef st

-- | Return the destination label of a break statement
continueParentLabel :: ResourceContext s -> ST s LabelIndex
continueParentLabel st = LabelIndex . _continueParentLabel <$> readRef st

-- | Gets the associated struct type from a list of fields
-- Note that field order matters, though two structs with the same keys and type
-- But in different orders are technically the same
structName :: forall s. ResourceContext s -> [FieldDecl] -> ST s C.Ident
structName st fields = do
  let key = StructKey fields
  rc <- readRef st
  let m = _structMap rc
  candidate <- HT.lookup m key
  case candidate of
    Just (Struct name _) -> return name
    Nothing
      -- Create the new StructType, save it in the hashmap,
      -- and update our struct list
     -> do
      let name = structName' $ length (_structTypes rc) + 1
          value = Struct name fields
          structTypes = value : _structTypes rc
      _ <- HT.insert m key value
      writeRef st $! rc {_structTypes = structTypes}
      return $! name
  where
    structName' :: Int -> C.Ident
    structName' i = C.Ident $ "GlcStruct" ++ show i

-- | Returns a list of unique structs, ordered by creation
allStructs :: ResourceContext s -> ST s [StructType]
allStructs st = reverse . _structTypes <$> readRef st
