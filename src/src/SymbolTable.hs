{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE ExistentialQuantification #-}

module SymbolTable
where

import           Control.Applicative     (Alternative)
-- import           Control.Monad           (join)
import           Control.Monad.ST
import           Data
import           Data.Either             (partitionEithers)
import           Data.Foldable           (asum)
-- import           Data.Functor.Compose    (Compose (..), getCompose)
-- import qualified Data.HashTable.Class    as H
-- import qualified Data.HashTable.ST.Basic as HT
import           Data.List.NonEmpty      (toList)
import           Data.Maybe              (catMaybes)
-- import           Data.STRef
import qualified SymbolTableCore as S
import           ErrorBundle
import           Numeric                 (readOct)

-- import Weeding (weed)
-- We define new types for symbols and types here
-- we largely base ourselves off types in the AST, however we do not need offsets for the symbol table
type Param = (S.Ident, SType)
type Field = (S.Ident, SType)
type Var = (S.Ident, SType)

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
  | Primitive S.Ident
  | Infer -- Infer the type at typechecking, not at symbol table generation
  deriving (Show, Eq)

-- | SymbolTable, cactus stack of SymbolScope
-- specific instantiation for our uses
type SymbolTable s = S.SymbolTable s Symbol (Maybe SymbolInfo)

-- | StructTable is a version of SymbolTable for struct fields
type StructTable s = S.SymbolTable s Field ()

-- | SymbolInfo: symbol name, corresponding symbol, scope depth
type SymbolInfo = (S.Ident, Symbol, S.Scope)

-- | Params with their respective scopes, for check FuncDecl
type ParamInfo = (Param, S.Scope)
-- | For checking short declarations
type VarInfo = (Var, S.Scope)

-- | Insert n tabs
tabs :: Int -> String
tabs n = concat $ replicate n "\t"

-- | Initialize a symbol table with base types
new :: ST s (SymbolTable s)
new = do
  st <- S.new
  -- Base types
  S.insert st (S.Ident "int") Base
  S.insert st (S.Ident "float64") Base
  S.insert st (S.Ident "bool") Base
  S.insert st (S.Ident "rune") Base
  S.insert st (S.Ident "string") Base
  S.insert st (S.Ident "true") Constant
  S.insert st (S.Ident "false") Constant
  return st

add :: SymbolTable s -> S.Ident -> Symbol -> ST s (Maybe SymbolInfo)
add st ident sym = do
  result <- S.lookupCurrent st ident -- We only need to check current scope for declarations
  case result of
    Just _ -> return Nothing -- If we found a result, don't insert anything
    Nothing -> do
      scope <- S.insert' st ident sym
      return $ Just (ident, sym, scope)

-- | Insert field to struct table and return success or fail
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
  recurse :: SymbolTable s -> a -> ST s (Maybe ErrorMessage')
class Typify a where
  -- Resolve AST types to SType, may return error message if type error
  toType :: SymbolTable s -> a -> ST s (Either ErrorMessage' SType)

-- instance Symbolize HAST where
--   recurse (H a) = recurse a

instance Symbolize TopDecl where
  recurse st (TopDecl d) = recurse st d
  recurse st (TopFuncDecl fd) = recurse st fd
instance Symbolize FuncDecl where
  -- Check if function (ident) is declared in current scope (top scope)
  -- if not, we open new scope to symbolize body and then validate sig before declaring
  recurse st (FuncDecl ident@(Identifier _ vname) (Signature (Parameters pdl) t) (BlockStmt sl)) = do
    res <- S.isDef st (S.Ident vname) -- Check if defined in symbol table
    if res then return $ Just $ createError ident (AlreadyDecl "Function " ident)
      else do
      S.enterScope st
      epl <- checkParams st pdl -- Either ErrorMessage' [Param]
      -- Either ErrorMessage' Symbol, want to get the corresponding Func symbol using our resolved params (if no errors in param declaration) and the type of the return of the signature, t, which is a Maybe Type'
      ef <- either (return . Left) (\pl ->
                                 maybe (return $ Right $ Func pl Nothing) (\(_, t') -> do
                                                   et <- toType st t'
                                                   return $ either Left (\tt -> Right $ Func pl (Just tt)
                                                                          ) et
                                               ) t
                                 ) epl 
      -- We then take the Either ErrorMessage' Symbol, if no error we insert the Symbol (newly declared function) and recurse on statement list sl (from body of func) to declare things in body
      either (return . Just) (\f -> do
                                 _ <- S.insert st (S.Ident vname) f
                                 am (recurse st) sl
                             ) ef
      where
      checkParams ::
        SymbolTable s -> [ParameterDecl] -> ST s (Either ErrorMessage' [Param])
      checkParams st2 pdl' = do
        pl <- mapM (checkParam st2) pdl'
        return $ eitherL concat pl
      checkParam ::
        SymbolTable s
        -> ParameterDecl
        -> ST s (Either ErrorMessage' [Param])
      checkParam st2 (ParameterDecl idl (_, t')) = do
        et <- toType st2 t'-- Remove ST
        either (return . Left) (\t2 -> do
                                   (err, pil) <- checkIds st2 t2 idl
                                   -- Alternatively we can add messages at the checkId level instead of making the ParamInfo type
                                   _ <- mapM (S.addMessage st2) (map Just (map parToVar pil)) -- Add list of SymbolInfo to messages
                                   case err of
                                     Just e -> do
                                       _ <- S.addMessage st2 Nothing -- Signal error so we don't print symbols beyond this
                                       return $ Left e
                                     Nothing ->
                                       return $ Right $ map pInfo2p pil
                                   ) et
      parToVar :: ParamInfo -> SymbolInfo
      parToVar ((ident', t'), scope) = (ident', (SType t'), scope)
      pInfo2p :: ParamInfo -> Param
      pInfo2p (p, _) = p
      checkIds ::
        SymbolTable s
        -> SType
        -> Identifiers
        -> ST s (Maybe ErrorMessage', [ParamInfo])
      checkIds st2 t' idl = pEithers <$> mapM (checkId st2 t') (toList idl)
  
      checkId ::
        SymbolTable s -> SType -> Identifier -> ST s (Either ErrorMessage' ParamInfo)
      checkId st2 t' ident'@(Identifier _ vname') =
        let idv = S.Ident vname' in
          do
            res <- add st2 idv (Variable t') -- Should not be declared
            return $ case res of
                       Nothing -> Left $ createError ident (AlreadyDecl "Param " ident')
                       Just (_, _, scope) -> Right ((idv, t'), scope)
  -- This will never happen but we do this for exhaustive matching on the FuncBody of a FuncDecl even though it is always a block stmt
  recurse _ FuncDecl {} = error "Function declaration's body is not a block stmt"

instance Symbolize SimpleStmt where
  recurse st (ShortDeclare idl el) = checkDecl (toList idl) (toList el) st
    where
      checkDecl :: [Identifier] -> [Expr] -> SymbolTable s -> ST s (Maybe ErrorMessage')
      checkDecl idl' _ st' = do
        bl <- mapM (isNewDec st') idl'
        -- may want to add offsets to ShortDeclarations and create an error with those here for ShortDec
        return $ if True `elem` bl then Nothing else Just $ createError (head idl') ShortDec
      isNewDec :: SymbolTable s -> Identifier -> ST s Bool
      isNewDec st2 (Identifier _ vname) = let idv = S.Ident vname in
                                                 do val <- S.lookupCurrent st2 idv
                                                    case val of
                                                      Just _ -> return False
                                                      Nothing -> do
                                                        msi <- add st2 idv (Variable Infer) 
                                                        -- This cannot be Nothing, add will always succeed here because lookup returned Nothing, so there is no conflict
                                                        _ <- S.addMessage st2 msi -- Add new symbol
                                                        return True
  -- recurse st 
  recurse _ _ = return Nothing

instance Symbolize Stmt where
  recurse _ _ = undefined
  
instance Symbolize Decl where
  recurse st (VarDecl vdl) =
    am (recurse st) vdl
  recurse st (TypeDef tdl) =
    am (recurse st) tdl
instance Symbolize VarDecl' where
  -- recurse st (VarDecl' neIdl (Left (t, el))) = undefined
  recurse _ _ = undefined
instance Symbolize TypeDef' where
  recurse _ _ = undefined
  -- recurse st (TypeDef' ident t) = undefined
    
intTypeToInt :: Literal -> Int
intTypeToInt (IntLit _ t s) =
  case t of
    Decimal     -> read s
    Hexadecimal -> read s
    Octal       -> fst $ head $ readOct s
intTypeToInt _ = error "Trying to convert a literal that isn't an int to an int"
                 -- This should never happen because we only use this for ArrayType
                 -- just here for exhaustive pattern matching
                 -- if we want to remove this we must change ArrayType as mentioned below

-- | either for a list, if any Left, take first Left, otherwise use lists of Rights
eitherL :: ([b] -> c) -> [Either a b] -> Either a c
eitherL f eil =
  let (err, l) = partitionEithers eil
   in if null err
        then Right $ f l
        else Left $ head err -- Return first error

-- | Partition either but only keep first error
pEithers :: [Either a b] -> (Maybe a, [b])
pEithers eil =
  let (err, l) = partitionEithers eil
  in if null err
     then (Nothing, l)
     else (Just $ head err, l)

-- | maybe for a list, if any Nothing, take first Nothing, otherwise Just list
maybeL :: ([b] -> c) -> [Maybe b] -> Maybe c
maybeL f ml = if length (catMaybes ml) == length ml then -- All values are Just values
                Just $ f $ catMaybes ml
              else
                Nothing

instance Typify Type where
  toType st (ArrayType (Lit l) t) = do
    sym <- toType st t
    return $ sym >>= Right . Array (intTypeToInt l) -- Negative indices are not possible because we only accept int lits, no unary ops, no need to check
  toType st (SliceType t) = do
    sym <- toType st t
    return $ sym >>= Right . Slice
  toType st (StructType fdl) = do
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
        et <- toType st2 t
        return $ either (return . Left) (\t' -> checkIds structTab t' idl) et
  
      checkIds ::
        StructTable s
        -> SType
        -> Identifiers
        -> ST s (Either ErrorMessage' [Field])
      checkIds st2 t idl = sequence <$> mapM (checkId st2 t) (toList idl)
  
      checkId ::
        StructTable s -> SType -> Identifier -> ST s (Either ErrorMessage' Field)
      checkId structTab' t ident@(Identifier _ vname) =
        let idv = S.Ident vname in
          do
            res <- add' structTab' idv (idv, t) -- Should not be declared
            return $
              if not res
              then Left (createError ident (AlreadyDecl "Field " ident))
              else Right (idv, t)
  toType st (Type ident) = resolve ident st
  -- This should never happen, this is here for exhaustive pattern matching
  -- if we want to remove this then we have to change ArrayType to only take in literal ints in the AST
  -- if we expand to support Go later, then we'll change this to support actual expressions
  toType _ (ArrayType _ _) = error "Trying to convert type of an ArrayType with non literal int as length"

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

-- | Resolve type of an Identifier
resolve :: Identifier -> SymbolTable s -> ST s (Either ErrorMessage' SType)
resolve ident@(Identifier _ vname) st = let idv = S.Ident vname in
                                          do res <- S.lookup st idv
                                             case res of
                                               Nothing -> return $ Left $ createError ident (NotDecl "Type " ident)
                                               Just (_, t) -> return $
                                                 case resolve' t idv of
                                                   Nothing -> Left $ createError ident (VoidFunc ident)
                                                   Just t' -> Right t'

-- | Resolve symbol to type
resolve' :: Symbol -> S.Ident -> Maybe SType
resolve' Base ident' = Just $ Primitive ident'
resolve' Constant _ = Just $ Primitive (S.Ident "bool") -- Constants reserved for bools only
resolve' (Variable t') _ = Just $ t'
resolve' (SType t') _ = Just $ t'
resolve' (Func _ mt) _ = mt

-- instance TypeInfer String where
--   resolve :: String -> SymbolTable s -> ST s (Either ErrorMessage' SType)
--   resolve s st = 

  
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
  AlreadyDecl String Identifier
  | NotDecl String Identifier
  | VoidFunc Identifier
  | TypeMismatch Identifier SType SType
  | NotLVal Identifier Symbol
  | ShortDec
  deriving (Show, Eq)

instance ErrorEntry SymbolError where
  errorMessage c =
    case c of
      AlreadyDecl s (Identifier _ vname) ->
        s ++ vname ++ " already declared"
      NotDecl s (Identifier _ vname) ->
        s ++ vname ++ " not declared"
      VoidFunc (Identifier _ vname) ->
        vname ++ " resolves to a void function"
      TypeMismatch (Identifier _ vname) t1 t2 ->
        "Expression resolves to type " ++ show t1 ++ " in assignment to " ++ vname ++ " of type " ++ show t2
      NotLVal (Identifier _ vname) s ->
        vname ++ " resolves to " ++ show s ++ " and is not an lvalue"
      ShortDec ->
        "Short declaration list contains no new variables"

-- | Extract top most scope from symbol table
topScope :: ST s (SymbolTable s) -> ST s (S.SymbolScope s Symbol)
topScope st = st >>= topScope'

topScope' :: SymbolTable s -> ST s (S.SymbolScope s Symbol)
topScope' = S.topScope

class TypeInfer a where
  infer :: a -> SymbolTable s -> ST s (Either ErrorMessage' SType)

-- testing stuff
-- z = S.Ident "test"

-- zk = SType (TypeMap (S.Ident "test") (Primitive (S.Ident "int")))

-- st' =
--   StructType
--     [ FieldDecl
--         (Identifier (Offset 0) "aaaaa" :| [])
--         (Offset 0, Type (Identifier (Offset 0) "aaaaaaaaa"))
--     ]

-- -- st2 = Type (Identifier (Offset 0) "a")
-- t3 =
--   runST $ do
--     st <- new
--     S.enterScope st
--     t <- toType st st'
--     _ <- either (const $ add st z zk) (add st z . SType) t
--     (_, ht) <- topScope' st
--     H.toList ht -- Base hash table as list
-- -- runST $ ((new >>= readSTRef) >>= return . snd . head . toList) >>= H.toList
