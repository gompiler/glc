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
  , allCategories
  , registerType
  ) where

import           Base
import qualified CheckedData             as C
import           Control.Monad.ST
import           Data.Hashable
import qualified Data.HashTable.Class    as HC (toList)
import qualified Data.HashTable.ST.Basic as HT
import           Data.Maybe              (catMaybes, listToMaybe)
import           Data.STRef
import           Prelude                 hiding (lookup)
import           ResourceData
import qualified UtilsData               as U

newtype ResourceContext s =
  ResourceContext (STRef s (ResourceContext_ s))

-- | Context required to generate the resource AST
-- While we only need to store a counter,
-- this makes it easier to fetch the ordered struct list
data ResourceContext_ s = RC
  { structTypes   :: [StructType]
  , structMap     :: StructTable s
  , categoryMap   :: CategoryTable s
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

newtype CatKey =
  CatKey U.BaseType
  deriving (Show, Eq)

instance Hashable CatKey where
  hashWithSalt salt (CatKey c) =
    case c of
      U.Custom s -> hashWithSalt salt s
      U.PInt     -> 7
      U.PBool    -> 11
      U.PFloat64 -> 13
      U.PRune    -> 17
      U.PString  -> 19

type CategoryTable s = HT.HashTable s CatKey U.Category

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
  categoryMap' <- HT.new
  structMap' <- HT.new
  newRef $
    RC
      { structTypes = []
      , varScopes = []
      , structMap = structMap'
      , categoryMap = categoryMap'
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
varIndex :: forall s. ResourceContext s -> C.ScopedIdent -> ST s VarIndex
varIndex st si = do
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
          (value, rs {varCounter = varCounter + 1})
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

registerType :: forall s. ResourceContext s -> Type -> ST s ()
registerType st t = registerType' $ flattenType t
  where
    registerType' :: U.Type -> ST s ()
    registerType' baseType =
      case baseType of
        U.ArrayType t' l ->
          registerArray (U.toBase t') (length l) *> registerType' t'
        U.SliceType t' i -> registerSlice (U.toBase t') i *> registerType' t'
        _ -> return ()
    registerArray = registerElement (\i c -> c {U.arrayDepth = i})
    registerSlice = registerElement (\i c -> c {U.sliceDepth = i})
    registerElement ::
         (Int -> U.Category -> U.Category) -> U.BaseType -> Int -> ST s ()
    registerElement build baseType depth = do
      let key = CatKey baseType
      rc <- readRef st
      let c = categoryMap rc
      prev <- HT.lookup c key
      let value =
            case prev of
              Just prev' -> build (max depth (U.arrayDepth prev')) prev'
              Nothing ->
                build
                  depth
                  U.Category
                    {U.baseType = baseType, U.arrayDepth = 0, U.sliceDepth = 0}
      HT.insert c key value

flattenType :: Type -> U.Type
flattenType t =
  case t of
    ArrayType _ _        -> uncurry U.ArrayType $ flattenArrayType t
    SliceType _          -> uncurry U.SliceType $ flattenSliceType t
    PInt                 -> U.Base U.PInt
    PFloat64             -> U.Base U.PFloat64
    PBool                -> U.Base U.PBool
    PRune                -> U.Base U.PRune
    PString              -> U.Base U.PString
    StructType (Ident i) -> U.Base $ U.Custom i
  where
    flattenSliceType :: Type -> (U.Type, Int)
    flattenSliceType (SliceType t') =
      let (base, i) = flattenSliceType t'
       in (base, i + 1)
    flattenSliceType t' = (flattenType t', 0)
    flattenArrayType :: Type -> (U.Type, [Int])
    flattenArrayType (ArrayType i t') =
      let (base, ii) = flattenArrayType t'
       in (base, i : ii)
    flattenArrayType t' = (flattenType t', [])

registerField :: forall s. ResourceContext s -> FieldDecl -> ST s ()
registerField st (FieldDecl _ t) = registerType st t

-- | Gets the associated struct type from a list of fields
-- Note that field order matters, though two structs with the same keys and type
-- But in different orders are technically the same
structName :: forall s. ResourceContext s -> [FieldDecl] -> ST s C.Ident
structName st fields = do
  let key = StructKey fields
  mapM_ (registerField st) fields
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

allCategories :: ResourceContext s -> ST s [U.Category]
allCategories st =
  let items = HC.toList =<< categoryMap <$> readRef st
   in map snd <$> items
