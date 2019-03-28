{-# LANGUAGE RankNTypes #-}

module ResourceContext
  ( ResourceContext
  , new
  , enterScope
  , exitScope
  , getStructType
  , getVarIndex
  , getAllStructs
  ) where

import           Base
import qualified CheckedData             as C

--import           Control.Monad           (unless)
import           Control.Monad.ST
import           Data.Either             (partitionEithers)

import qualified Data.HashTable.ST.Basic as HT

--import           Data.Foldable           (asum)
import           Data.Hashable

--import           Data.List.NonEmpty      (NonEmpty (..), fromList, toList, (<|))
--import qualified Data.List.NonEmpty      as NonEmpty (last)
import           Data.STRef
import           Prelude                 hiding (lookup)
import           ResourceData

newtype ResourceContext s =
  ResourceContext (STRef s (ResourceContext_ s))

-- | Context required to generate the resource AST
-- While we only need to store a counter,
-- this makes it easier to fetch the ordered struct list
data ResourceContext_ s = RC
  { allStructs :: [StructType]
  , structMap  :: StructTable s
  , varScopes  :: [ResourceScope s]
  }

data ResourceScope s =
  RS (VarTable s)
     Int

newtype VarKey =
  VarKey C.ScopedIdent
  deriving (Show, Eq)

instance Hashable VarKey where
  hashWithSalt salt (VarKey (C.ScopedIdent (C.Scope s) (C.Ident ident))) =
    hashWithSalt salt s * 13 + hashWithSalt salt ident

type VarTable s = HT.HashTable s VarKey VarIndex

newtype StructKey =
  StructKey [C.FieldDecl]
  deriving (Show, Eq)

instance Hashable StructKey where
  hashWithSalt salt (StructKey fields) =
    foldl (\a b -> a * 3 + b) 0 (map hashField fields)
    where
      hashField :: C.FieldDecl -> Int
      hashField (C.FieldDecl (C.Ident i) _) = hashWithSalt salt i

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
  newRef $ RC {allStructs = [], varScopes = [], structMap = structMap'}

-- | Create a new resource scope
newScope :: ST s (ResourceScope s)
newScope = do
  m <- HT.new
  return $ RS m 0

-- | Create a new scope level
enterScope :: ResourceContext s -> ST s ()
enterScope st = do
  rc <- readRef st
  scope <- newScope
  let vars = scope : varScopes rc
  writeRef st $ rc {varScopes = vars}

-- | Exit current scope level
-- This allows us to reuse offsets for all variables created in the current scope
-- Note that there's no catch if we attempt to exit the global scope
exitScope :: ResourceContext s -> ST s ()
exitScope st = do
  rc <- readRef st
  let (_:vars) = varScopes rc
  writeRef st $ rc {varScopes = vars}

-- | Get the index of the provided scope ident
-- If it already exists, output will be existing index
-- Otherwise, we will output 1 greater than the biggest index to date
getVarIndex :: forall s. ResourceContext s -> C.ScopedIdent -> ST s VarIndex
getVarIndex st si = do
  let key = VarKey si
  rc <- readRef st
  candidates <- mapM (getVarIndex' key) $ varScopes rc
  let (counts, indices) = partitionEithers candidates
  if null indices
    -- Not found; add the new var index and return it
    then let value = (VarIndex $ sum counts + 1)
             (v:vars) = varScopes rc
          in do v' <- setVarIndex' v key value
                writeRef st $! rc {varScopes = v' : vars} -- Replace current scope
                return value
    else return $! head indices
  where
    setVarIndex' ::
         ResourceScope s -> VarKey -> VarIndex -> ST s (ResourceScope s)
    setVarIndex' (RS varTable size) key value =
      HT.insert varTable key value $> RS varTable (size + 1)
    getVarIndex' :: VarKey -> ResourceScope s -> ST s (Either Int VarIndex)
    getVarIndex' key (RS varTable size) = do
      index <- HT.lookup varTable key
      return $! index <?> size

-- | Gets the associated struct type from a list of fields
-- Note that field order matters, though two structs with the same keys and type
-- But in different orders are technically the same
getStructType :: forall s. ResourceContext s -> [C.FieldDecl] -> ST s StructType
getStructType st fields = do
  let key = StructKey fields
  rc <- readRef st
  let m = structMap rc
  candidate <- HT.lookup m key
  case candidate of
    Just structType -> return structType
    Nothing
      -- Create the new StructType, save it in the hashmap,
      -- and update our struct list
     -> do
      let name = structName $ length (allStructs rc) + 1
          value = Struct name fields
          allStructs' = value : allStructs rc
      _ <- HT.insert m key value
      writeRef st $! rc {allStructs = allStructs'}
      return $! value
  where
    structName :: Int -> C.Ident
    structName i = C.Ident $ "GlcStruct" ++ show i

-- | Returns a list of unique structs, ordered by creation
getAllStructs :: ResourceContext s -> ST s [StructType]
getAllStructs st = reverse . allStructs <$> readRef st
