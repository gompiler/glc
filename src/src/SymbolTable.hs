{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE ExistentialQuantification #-}

module SymbolTable
  (
  ) where

import           Control.Applicative     (Alternative)
import           Control.Monad           (join)
import           Control.Monad.ST
import           Data
import           Data.Either             (partitionEithers)
import           Data.Foldable           (asum)
import           Data.Functor.Compose    (Compose (..), getCompose)
import qualified Data.HashTable.Class    as H
import qualified Data.HashTable.ST.Basic as HT
import           Data.List.NonEmpty      (NonEmpty (..), fromList, toList, (<|))
import           Data.Maybe              (isJust)
import           Data.STRef
import qualified SymbolTableCore as S
import           ErrorBundle
import           Numeric                 (readOct)

-- import Weeding (weed)
-- We define new types for symbols and types here
-- we largely base ourselves off types in the AST, however we do not need offsets for the symbol table
type Param = (S.Ident, SType)

type Field = (S.Ident, SType)

data Symbol
  = Base -- Base type, resolve to themselves, i.e. int
  | Constant -- For bools only
  | Func [Param] (Maybe SType)
  | Variable SType
  | SType SType -- Declared types
  deriving (Show, Eq)

data SType
  = Array Int
          SType
  | Slice SType
  | Struct [Field] -- List of fields
  | TypeMap S.Ident SType
  | BaseMap S.Ident
  -- | Infer -- Infer the type at typechecking, not at symbol table generation
  deriving (Show, Eq)

-- | SymbolTable, cactus stack of SymbolScope
-- specific instantiation for our uses
type SymbolTable s = S.SymbolTable s Symbol SymbolInfo

-- | StructTable is a version of SymbolTable for struct fields
type StructTable s = S.SymbolTable s Field ()

-- | SymbolInfo: symbol name, corresponding symbol, scope depth
type SymbolInfo = (S.Ident, Symbol, S.Scope)

-- | Insert n tabs
tabs :: Int -> String
tabs n = concat $ replicate n "\t"

-- | Initialize a symbol table with base types
new :: ST s (SymbolTable s)
new = do
  ht <- S.new
  -- Base types
  S.insert ht (S.Ident "int") Base
  S.insert ht (S.Ident "float64") Base
  S.insert ht (S.Ident "bool") Base
  S.insert ht (S.Ident "rune") Base
  S.insert ht (S.Ident "string") Base
  S.insert ht (S.Ident "true") Constant
  S.insert ht (S.Ident "false") Constant
  return ht

add :: SymbolTable s -> S.Ident -> Symbol -> ST s (Maybe SymbolInfo)
add st ident sym = do
  result <- S.lookupCurrent st ident -- We only need to check current scope for declarations
  case result of
    Just _ -> return Nothing -- If we found a result, don't insert anything
    Nothing -> do
      scope <- S.insert' st ident sym
      return $ Just (ident, sym, scope)

-- | Insert field to struct table
add' :: StructTable s -> S.Ident -> Field -> ST s Bool
add' st ident fld = do
  result <- S.lookup st ident -- We only need to check current scope for declarations
  case result of
    Just _ -> return False -- If we found a result, don't insert anything
    Nothing -> do
      S.insert st ident fld
      return True

-- Heterogeneous type, can represent everything that has an instance of Symbolize
-- We use this so we can map over different types using recurse
data HAST =
  forall a. Symbolize a =>
            H a

-- | Alias for asum <$> mapM f l
am ::
     (Alternative f1, Traversable t, Monad f2)
  => (a1 -> f2 (f1 a2))
  -> t a1
  -> f2 (f1 a2)
am f l = fmap asum (mapM f l)

-- Class to generalize traverse function for each AST structure
class Symbolize a where
  recurse :: a -> SymbolTable s -> ST s (Maybe ErrorMessage')
  -- Recurse with arguments reversed
  recurse' :: SymbolTable s -> a -> ST s (Maybe ErrorMessage')
  recurse' = flip recurse
  -- Resolve AST types to SType, may return error message if type error
  toType :: a -> SymbolTable s -> ST s (Either ErrorMessage' SType)
  toType' :: SymbolTable s -> a -> ST s (Either ErrorMessage' SType)
  toType' = flip toType

instance Symbolize HAST where
  recurse (H a) = recurse a

-- instance Symbolize TopDecl where
--   recurse (TopDecl d) = recurse d
--   recurse (TopFuncDecl fd) = recurse fd
-- hlist = [H $ TopDecl $ VarDecl []]
-- instance Symbolize FuncDecl where
--   recurse (FuncDecl ident sig body) st =
--     am (recurse' st) [H id, H sig, H body]
-- instance Symbolize Decl where
--   recurse (VarDecl vdl) st =
--     am (recurse' st) vdl
--   recurse (TypeDef tdl) st =
--     am (recurse' st) tdl
-- instance Symbolize VarDecl' where
--   recurse (VarDecl' neIdl (Left (t, el))) st =
--     am (recurse' st) ((H t):(map H $ toList neIdl) ++ (map H el))
-- instance Symbolize TypeDef' where
--   recurse (TypeDef' ident t) st =
--     am (recurse' st) [H ident, H t]
intTypeToInt :: Literal -> Int
intTypeToInt (IntLit _ t s) =
  case t of
    Decimal     -> read s
    Hexadecimal -> read s
    Octal       -> fst $ head $ readOct s

-- | either for a list, if any Left, take first Left, otherwise use lists of Rights
eitherL :: ([b] -> c) -> [Either a b] -> Either a c
eitherL f eil =
  let (err, l) = partitionEithers eil
   in if null err
        then Right $ f l
        else Left $ head err -- Return first error

instance Symbolize Type where
  toType (ArrayType (Lit l) t) st = do
    sym <- toType t st
    return $ sym >>= Right . Array (intTypeToInt l)
  toType (SliceType t) st = do
    sym <- toType t st
    return $ sym >>= Right . Slice
  toType (StructType fdl) st = do
    fl <- checkFields st fdl
    return $ fl >>= Right . Struct
    where
      checkFields ::
        SymbolTable s -> [FieldDecl] -> ST s (Either ErrorMessage' [Field])
      checkFields st2 fdl' = do
        structTab <- S.new
        sfl <- mapM (checkField st2 structTab) fdl'
        fl <- sequence sfl
        return $ eitherL concat fl
  
      checkField ::
        SymbolTable s1
        -> StructTable s2
        -> FieldDecl
        -> ST s1 (ST s2 (Either ErrorMessage' [Field]))
      checkField st2 structTab (FieldDecl idl (_, t)) = do
        et <- toType t st2
        return $ either (return . Left) (\t' -> checkIds structTab t' idl) et
  
      checkIds ::
        StructTable s
        -> SType
        -> Identifiers
        -> ST s (Either ErrorMessage' [Field])
      checkIds st2 t idl = eConcat <$> mapM (checkId st2 t) (toList idl)
  
      checkId ::
        StructTable s -> SType -> Identifier -> ST s (Either ErrorMessage' Field)
      checkId structTab' t ident@(Identifier _ vname) =
        let idv = S.Ident vname in
          do
            res <- add' structTab' idv (idv, t) -- Should not be declared
            return $
              if not res
              then Left (createError ident (AlreadyDecl ident))
              else Right (idv, t)
  toType (Type ident) st = resolve ident st

-- instance Symbolize Signature where
  -- toType (Signature (Parameters pdl) (Just t)) st = do
    -- t' <- toType t st
    -- (eConcat <$> mapM (toType' st) pdl) >>= (\e -> either Left (\tl -> Func tl t'))
    -- (do
    --     tl <- eConcat etl
    --     Right $ Func tl t
    --   )
-- instance Symbolize ParameterDecl where
--   -- toType (ParameterDecl)

resolve :: Identifier -> SymbolTable s -> ST s (Either ErrorMessage' SType)
resolve ident@(Identifier _ vname) st = let idv = S.Ident vname in
                                          do res <- S.lookup st idv
                                             case res of
                                               Nothing -> return $ Left $ createError ident (TNotDecl ident)
                                               Just (_, t) ->
                                                 return $ Right $ resolve' t idv
                                                 where resolve' Base ident' = BaseMap ident'
                                                       resolve' Constant _ = BaseMap (S.Ident "bool") -- Constants reserved for bools only
                                                       resolve' (Variable t') _ = t'
                                                       resolve' (SType t') _ = t'

-- instance TypeInfer String where
--   resolve :: String -> SymbolTable s -> ST s (Either ErrorMessage' SType)
--   resolve s st = 

  
eConcat :: [Either ErrorMessage' a] -> Either ErrorMessage' [a]
eConcat = eitherL id


-- | Check if a symbol is valid
-- isValid :: SymbolTable s -> Symbol -> ST s (Bool)
-- isValid st s = case s of
--                  | Struct fdl ->
-- | Check if a given key is defined in the symbol table
-- isDef :: STRef s (NonEmpty (Scope, HashTable s a)) -> S.Ident -> ST s Bool
-- isDef st ident = do
--   rSt <- readSTRef st
--   lookup rSt
--   where
--     lookup :: NonEmpty (Scope, HashTable s a) -> ST s Bool
--     lookup st' =
--       case st' of
--         ((_, ht) :| []) -> do
--           result <- HT.lookup ht ident
--           return $ Data.Maybe.isJust result -- if lookup is Nothing, return False, else True since found
--                    -- Non empty tail case
--         ((_, ht) :| st2) -> do
--           result <- HT.lookup ht ident
--           maybe (lookup $ fromList st2) (const $ return True) result -- True on first result we see, else check parent scopes

-- -- | isDef but only current scope, to verify that we can declare
-- isDefL :: STRef s (NonEmpty (Scope, HashTable s a)) -> S.Ident -> ST s Bool
-- isDefL st ident = do
--   ((_, ht) :| _) <- readSTRef st
--   result <- HT.lookup ht ident
--   return $ Data.Maybe.isJust result
  -- print (runST $ htIs k =<< stToScope new)
  -- return $ maybe ("err") (const $ "found") (HT.lookup ht "test")
  -- if HT.lookup st "test" then return "empty" else return "not empty"

-- -- pSymbolTable prog =
-- -- | print key value pairs for one hash table
-- pht ht =
--   H.foldM f "" ht
--   -- return s
--   where
--     f s (k,v) = return (s ++ k ++ ": " ++ show v ++ "\n")
-- htIs k ht = do
--   val <- HT.lookup ht k
--   case val of
--     Nothing -> return "not found"
--     Just i -> return $ "found " ++ k ++ ": " ++ show i
-- basic = weed "package main;"
-- toString :: SymbolTable s -> String
-- toString k =
data SymbolError =
  AlreadyDecl Identifier
  | TNotDecl Identifier
  | VoidFunc Identifier
  deriving (Show, Eq)

instance ErrorEntry SymbolError where
  errorMessage c =
    case c of
      AlreadyDecl (Identifier _ vname) ->
        "Variable " ++ vname ++ " already declared"
      TNotDecl (Identifier _ vname) ->
        "Type " ++ vname ++ " not declared"
      VoidFunc (Identifier _ vname) ->
        vname ++ " resolves to a void function"

-- | Extract top most scope from symbol table
topScope :: ST s (SymbolTable s) -> ST s (S.SymbolScope s Symbol)
topScope st = st >>= topScope'

topScope' :: SymbolTable s -> ST s (S.SymbolScope s Symbol)
topScope' = S.topScope

-- testing stuff
z = S.Ident "test"

zk = SType (TypeMap (S.Ident "test") (BaseMap (S.Ident "int")))

-- t = runST $ (topScope new) >>= H.toList
-- -- t2 = runST $ topScope ((new >>= (\st -> add st z zk))) >>= H.toList
-- t2' = runST $ do
--   st <- new
--   _ <- add st z zk
--   topScope' st >>= H.toList
-- t3 = runST $ do
--   st <- new
--   enterScope st
--   _ <- add st z zk
--   topScope' st >>= H.toList
-- st' = StructType [FieldDecl (Identifier (Offset 0) "aaaaa" :| [Identifier (Offset 0) "ggggg"]) (Offset 0, Type (Identifier (Offset 0) "aaaaaaaaa"))]
st' =
  StructType
    [ FieldDecl
        (Identifier (Offset 0) "aaaaa" :| [])
        (Offset 0, Type (Identifier (Offset 0) "aaaaaaaaa"))
    ]

-- st2 = Type (Identifier (Offset 0) "a")
t3 =
  runST $ do
    st <- new
    S.enterScope st
    t <- toType st' st
    _ <- either (const $ add st z zk) (add st z . SType) t
    (_, ht) <- topScope' st
    H.toList ht -- Base hash table as list
-- runST $ ((new >>= readSTRef) >>= return . snd . head . toList) >>= H.toList
