{-# LANGUAGE RankNTypes #-}

module ResourceContext where

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

data ResourceContext_ s = RC
  { allStructs :: [StructType]
  , varScopes  :: [ResourceScope s]
  , structMap  :: StructTable s
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
  StructKey StructType
  deriving (Show, Eq)

instance Hashable StructKey where
  hashWithSalt salt (StructKey (Struct (C.Ident ident) fields)) =
    hashWithSalt salt ident * 13 +
    -- Hash each field and multiple by prime number
    foldl (\a b -> a * 3 + b) 0 (map hashField fields)
    where
      hashField :: FieldDecl -> Int
      hashField (FieldDecl (C.Ident i) _) = hashWithSalt salt i

type StructTable s = HT.HashTable s StructType C.Ident

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

newScope :: ST s (ResourceScope s)
newScope = undefined

enterScope :: ResourceContext s -> ST s ()
enterScope st = do
  rc <- readRef st
  scope <- newScope
  let vars = scope : varScopes rc
  writeRef st $ rc {varScopes = vars}

exitScope :: ResourceContext s -> ST s ()
exitScope st = do
  rc <- readRef st
  let (_:vars) = varScopes rc
  writeRef st $ rc {varScopes = vars}

-- Writes the provided var data to the first scope
setVarIndex :: ResourceContext s -> VarKey -> VarIndex -> ST s ()
setVarIndex st key value = do
  rc <- readRef st
  let (v:vars) = varScopes rc
  v' <- setVarIndex' v
  writeRef st $ rc {varScopes = v' : vars}
  where
    setVarIndex' :: ResourceScope s -> ST s (ResourceScope s)
    setVarIndex' (RS varTable size) =
      HT.insert varTable key value $> RS varTable (size + 1)

getVarIndex :: forall s. ResourceContext s -> C.ScopedIdent -> ST s VarIndex
getVarIndex st si = do
  let key = VarKey si
  rc <- readRef st
  candidates <- mapM (getVarIndex' key) $ varScopes rc
  let (counts, indices) = partitionEithers candidates
  if null indices
    -- Not found; add the new var index and return it
    then let index = (VarIndex $ sum counts + 1)
          in setVarIndex st key index $> index
    else return $ head indices
  where
    getVarIndex' :: VarKey -> ResourceScope s -> ST s (Either Int VarIndex)
    getVarIndex' key (RS varTable size) = do
      index <- HT.lookup varTable key
      return $ index <?> size
