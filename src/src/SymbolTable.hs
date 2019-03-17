{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}

module SymbolTable where

import           Control.Applicative (Alternative)

-- import           Control.Monad           (join)
import           Control.Monad.ST
import           Data
import           Data.Either         (partitionEithers)
import           Data.Foldable       (asum)

-- import           Data.Functor.Compose    (Compose (..), getCompose)
-- import qualified Data.HashTable.Class    as H
-- import qualified Data.HashTable.ST.Basic as HT
import           Data.List.Extra     (concatUnzip)
import           Data.List.NonEmpty  (toList, NonEmpty(..), fromList)
import           Data.Maybe          (catMaybes)

-- import           Data.STRef
import           ErrorBundle
import           Numeric             (readOct)
-- import           Scanner             (putExit, putSucc)
-- import           Weeding             (weed)
import qualified CheckedData as C
import TypeInference

import           Symbol

-- import           Data.STRef
import qualified SymbolTableCore     as S

-- -- | For checking short declarations
-- type VarInfo = (Var, S.Scope)
-- | Insert n tabs
tabs :: Int -> String
tabs n = concat $ replicate n "\t"

-- | Initialize a symbol table with base types
new :: ST s (SymbolTable s)
new = do
  st <- S.new
  -- Base types
  mapM_
    (uncurry $ add st)
    [ ("int", Base)
    , ("float64", Base)
    , ("bool", Base)
    , ("rune", Base)
    , ("string", Base)
    , ("true", Constant)
    , ("false", Constant)
    ]
  return st

add :: SymbolTable s -> String -> Symbol -> ST s Bool -- Did we add successfully?
add st ident sym = do
  result <- S.lookupCurrent st ident -- We only need to check current scope for declarations
  case result of
    Just _ -> do
      _ <- S.addMessage st Nothing -- Found something, aka a conflict, so stop printing symbol table after this
      return False
    Nothing -> do
      scope <- S.insert' st ident sym
      _ <- S.addMessage st $ Just (ident, sym, scope) -- Add the symbol info of what we added
      return True

-- | lookupCurrent wrapper but insert message on if declared, because we want to declare something ourself
isNDefL :: SymbolTable s -> String -> ST s Bool
isNDefL st k = do
  res <- S.lookupCurrent st k
  case res of
    Nothing -> return True
    Just _ -> do
      _ <- S.addMessage st Nothing -- Signal error, key should not be defined
      return False

-- | S.isDef  wrapper but insert message if not declared
isDef :: SymbolTable s -> String -> ST s Bool
isDef st k = do
  res <- S.lookup st k
  case res of
    Just _ -> return True
    Nothing -> do
      _ <- S.addMessage st Nothing -- Signal error, key should be defined
      return False

-- data HAST =
--   forall a. Symbolize a =>
--             H a

-- | Alias for asum <$> mapM f l
am ::
     (Alternative f1, Traversable t, Monad f2)
  => (a1 -> f2 (f1 a2))
  -> t a1
  -> f2 (f1 a2)
am f l = fmap asum (mapM f l)

-- Class to generalize traverse function for each AST structure
-- also return the typechecked AST
class Symbolize a b where
  recurse :: SymbolTable s -> a -> ST s (Either ErrorMessage' b)

class Typify a
  -- Resolve AST types to SType, may return error message if type error
  where
  toType :: SymbolTable s -> a -> ST s (Either ErrorMessage' SType)

-- instance Symbolize HAST where
--   recurse st (H a) = recurse st a

seqRec st a = recurse st a >>= sequence

instance Symbolize Program C.Program where
  recurse st (Program pkg tdl) = wrap st $ (seqRec st tdl) >>= return . fmap (C.Program pkg)

instance Symbolize TopDecl C.TopDecl where
  recurse st (TopDecl d)      = seqRec st d >>= return . fmap C.TopDecl
  recurse st (TopFuncDecl fd) = seqRec st fd >>= return . fmap C.TopFuncDecl

instance Symbolize FuncDecl C.FuncDecl
  -- Check if function (ident) is declared in current scope (top scope)
  -- if not, we open new scope to symbolize body and then validate sig before declaring
                                                                                        where
  recurse st (FuncDecl ident@(Identifier _ vname) (Signature (Parameters pdl) t) (BlockStmt sl)) = do
    notdef <- isNDefL st vname -- Check if defined in symbol table
    if notdef
      then do
        _ <- S.enterScope st -- This is a dummy scope just to check that there are no duplicate parameters
        epl <- checkParams st pdl -- Either ErrorMessage' [Param]
      -- Either ErrorMessage' Symbol, want to get the corresponding Func symbol using our resolved params (if no errors in param declaration) and the type of the return of the signature, t, which is a Maybe Type'
        ef <-
          either
            (return . Left)
            (\(pl, sil) ->
               maybe
                 (return $ Right (Func pl Nothing, sil))
                 (\(_, t') -> do
                    et <- toType st t'
                    return $ fmap (\ret -> (Func pl (Just ret), sil)) et)
                 t)
            epl
      -- We then take the Either ErrorMessage' Symbol, if no error we exit dummy scope so we're at the right scope level, insert the Symbol (newly declared function) and then wrap the real scope of the function, adding all the parameters that are already resolved as symbols and recursing on statement list sl (from body of func) to declare things in body
        either
          (return . Left)
          (\(f, sil) -> do
              _ <- S.exitScope st
              scope <- S.insert' st vname f
              _ <- S.addMessage st (Just (vname, f, scope))
              wrap
                st
                (do mapM_ (\(k, sym, _) -> add st k sym) sil
                    (\sl' -> (C.FuncDecl (mkSIdStr scope vname) (func2sig f) . C.BlockStmt) <$> sequence sl') <$> (mapM (recurse st) sl)))
          ef
      else return $ Left $ createError ident (AlreadyDecl "Function " ident)
    where
      checkParams ::
           SymbolTable s
        -> [ParameterDecl]
        -> ST s (Either ErrorMessage' ([Param], [SymbolInfo]))
      checkParams st2 pdl' = do
        pl <- mapM (checkParam st2) pdl'
        return $ eitherL concatUnzip pl
      checkParam ::
           SymbolTable s
        -> ParameterDecl
        -> ST s (Either ErrorMessage' ([Param], [SymbolInfo]))
      checkParam st2 (ParameterDecl idl (_, t')) = do
        et <- toType st2 t' -- Remove ST
        either
          (return . Left)
          (\t2 -> do
             (err, pil) <- checkIds' st2 t2 idl
                                   -- Alternatively we can add messages at the checkId level instead of making the ParamInfo type
             case err of
               Just e -> do
                 _ <- S.addMessage st2 Nothing -- Signal error so we don't print symbols beyond this
                 return $ Left e
               Nothing -> return $ Right pil)
          et
      checkIds' ::
           SymbolTable s
        -> SType
        -> Identifiers
        -> ST s (Maybe ErrorMessage', ([Param], [SymbolInfo]))
      checkIds' st2 t' idl =
        (\(a, b) -> (a, unzip b)) . pEithers <$>
        mapM (checkId' st2 t') (toList idl)
      checkId' ::
           SymbolTable s
        -> SType
        -> Identifier
        -> ST s (Either ErrorMessage' (Param, SymbolInfo))
      checkId' st2 t' ident'@(Identifier _ vname') =
        let idv = vname'
         in do notdef <- isNDefL st2 idv -- Should not be declared
               if notdef
                 then do
                   scope <- S.insert' st2 vname' (Variable t')
                   return $ Right ((vname', t'), (vname', Variable t', scope))
                 else return $
                      Left $ createError ident (AlreadyDecl "Param " ident')
      p2pd :: Param -> C.ParameterDecl -- Params are only at scope 2, inside scope of function
      p2pd (s, t) = C.ParameterDecl (mkSIdStr (S.Scope 2) s) (toBase t)
      func2sig :: Symbol -> C.Signature
      func2sig (Func pl mt) = C.Signature (C.Parameters (map p2pd pl)) (toBase <$> mt)
      func2sig _ = error "Trying to convert a symbol that isn't a function to a signature" -- Should never happen
  recurse _ FuncDecl {} =
    error "Function declaration's body is not a block stmt"

-- This will never happen but we do this for exhaustive matching on the FuncBody of a FuncDecl even though it is always a block stmt
-- | checkId over a list of identifiers, keep first error or return nothing
checkIds ::
     SymbolTable s
  -> Symbol
  -> String
  -> Identifiers
  -> ST s (Maybe ErrorMessage')
checkIds st s pfix idl = maybeJ <$> mapM (checkId st s pfix) (toList idl)

-- | Check that we can declare this identifier
checkId ::
     SymbolTable s
  -> Symbol
  -> String -- Error prefix for AlreadyDecl, what are we checking? i.e. Param, Var, Type
  -> Identifier
  -> ST s (Maybe ErrorMessage')
checkId st s pfix ident@(Identifier _ vname) =
  let idv = vname
   in do success <- add st idv s -- Should not be declared
         return $
           if success
             then Nothing
             else Just $ createError ident (AlreadyDecl pfix ident)

instance Symbolize SimpleStmt C.SimpleStmt where
  recurse st (ShortDeclare idl el) =
    (checkDecl (toList idl) (toList el) st) >>= return . fmap C.ShortDeclare
    where
      checkDecl :: [Identifier] -> [Expr] -> SymbolTable s -> ST s (Either ErrorMessage' (NonEmpty(SIdent, C.Expr)))
      checkDecl idl el st = do
        eb <- mapM (\(ident, e) -> checkDec ident e st) (zip idl el)
        -- may want to add offsets to ShortDeclarations and create an error with those here for ShortDec
        return $ either Left (\l -> let (bl, decl) = unzip l in
                                        if True `elem` bl then Right (fromList decl) else Left $ createError (head idl) ShortDec) (sequence eb) 
      checkDec :: Identifier -> Expr -> SymbolTable s -> ST s (Either ErrorMessage' (Bool, (SIdent, C.Expr)))
      checkDec ident e st = do
        et <- infer st e-- Either ErrorMessage' SType
        (either (return . Left) (\t -> do
                                    et' <- recurse st e
                                    eb <- checkId ident t st
                                    either (return . Left)
                                      (\e' -> return $ either Left (\(b, sid) -> Right (b, (sid, e'))) eb) et'
                                ) et)
          where
            checkId :: Identifier -> SType -> SymbolTable s -> ST s (Either ErrorMessage' (Bool, SIdent)) -- Bool is to indicate whether the variable was already declared or not and also create scoped ident
      -- Note that short declarations require at least *one* new declaration
            checkId ident@(Identifier _ vname) t st =
                do val <- S.lookupCurrent st vname
                   case val of
                     Just (scope, (Variable t2)) -> return $
                       if t == t2
                       then Right $ (False, mkSIdStr scope vname)
                       -- if locally defined, check if type matches
                       else Left $ createError e (TypeMismatch1 ident t t2)
                     Just (_, s) -> return $ Left $ createError ident (NotLVal ident s)
                     Nothing -> do
                       msi <- add st vname (Variable t)
                       scope <- S.scopeLevel st
                       return $ Right $ (True, mkSIdStr scope vname)
  recurse _ EmptyStmt = return $ Right C.EmptyStmt
  recurse st (ExprStmt e) = seqRec st e >>= return . fmap C.ExprStmt -- Verify that expr only uses things that are defined
  recurse st (Increment _ e) = seqRec st e >>= return . fmap C.Increment
  recurse st (Decrement _ e) = seqRec st e >>= return . fmap C.Decrement
  recurse st (Assign _ aop@(AssignOp mop) el1 el2) = do
    l1 <- mapM (seqRec st) (toList el1)
    l2 <- mapM (seqRec st) (toList el2)
    case mop of
      Nothing -> do
        me <- mapM (sameType st) (zip (toList el1) (toList el2))
        maybe
          (either
             (return . Left)
             (\l1' ->
                either
                  (return . Left)
                  (\l2' ->
                     return $
                     Right $ C.Assign (C.AssignOp Nothing) $ fromList $ zip l1' l2')
                  (sequence l2))
             (sequence l1))
          (return . Left)
          (maybeJ me)
      Just op -> do
        el <-
          mapM (infer st) (map (aop2e $ Arithm op) (zip (toList el1) (toList el2)))
        either
          (return . Left)
          (const $
           (either
              (return . Left)
              (\l1' ->
                 either
                   (return . Left)
                   (\l2' ->
                      return $
                      Right $ C.Assign (aop2aop' aop) (fromList $ zip l1' l2'))
                   (sequence l2))
              (sequence l1)))
          (sequence el)
    where
      -- convert op and 2 expressions to binary op, infer type of this to make sure it makes sense
      aop2e :: BinaryOp -> (Expr, Expr) -> Expr
      aop2e op (e1,e2) = Binary (Offset 0) op e1 e2
      aop2aop' :: AssignOp -> C.AssignOp
      aop2aop' (AssignOp (Just aop)) = C.AssignOp $ Just $ case aop of
                                                           Add -> C.Add
                                                           Subtract -> C.Subtract
                                                           BitOr -> C.BitOr
                                                           BitXor -> C.BitXor
                                                           Multiply -> C.Multiply
                                                           Divide -> C.Divide
                                                           Remainder -> C.Remainder
                                                           ShiftL -> C.ShiftL
                                                           ShiftR -> C.ShiftR
                                                           BitAnd -> C.BitAnd
                                                           BitClear -> C.BitClear
                                                     
                                                    -- (\bl -> if False `elem` bl then ) <$> sequence el
    -- am (recurse st) (toList el)

-- | Check if two expressions have the same type
sameType :: SymbolTable s -> (Expr, Expr) -> ST s (Maybe ErrorMessage')
sameType st (e1,e2) = do
  et1 <- infer st e1
  et2 <- infer st e2
  return $ either Just (\t1 -> either Just (\t2 -> if t1 == t2 then Nothing else
                                               Just $ createError e1 (TypeMismatch2 e1 e2)) et2) et1
                                                     
instance Symbolize Stmt C.Stmt where
  recurse st (BlockStmt sl) = undefined -- wrap st $ am (recurse st) sl
  recurse st (SimpleStmt s) = undefined -- recurse st s
  recurse st (If (ss, e) s1 s2) = undefined
--    wrap st $ am (recurse st) [H ss, H e, H s1, H s2]
  recurse st (Switch ss me scs) = undefined
    -- wrap st $ do
    --   r1 <-
    --     case me of
    --       Just e  -> am (recurse st) [H ss, H e]
    --       Nothing -> recurse st ss
    --   r2 <- am (recurse st) scs
    --   return $ maybeJ [r1, r2]
  recurse st (For (ForClause ss1 me ss2) s) = undefined
    -- wrap st $ do
    --   r1 <-
    --     am (recurse st) $
    --     case me of
    --       Just e  -> [H ss1, H e, H ss2]
    --       Nothing -> [H ss1, H ss2]
    --   r2 <- recurse st s
    --   return $ maybeJ [r1, r2]
  recurse _ (Break _) = undefined -- return Nothing
  recurse _ (Continue _) = undefined -- return Nothing
  recurse st (Declare d) = undefined -- recurse st d
  recurse st (Print el) = undefined -- am (recurse st) el
  recurse st (Println el) = undefined -- am (recurse st) el
  recurse st (Return (Just e)) = undefined -- recurse st e
  recurse _ (Return Nothing) = undefined -- return Nothing

instance Symbolize Decl C.Decl where
  recurse st (VarDecl vdl) = undefined -- am (recurse st) vdl
  recurse st (TypeDef tdl) = undefined -- am (recurse st) tdl

instance Symbolize VarDecl' C.VarDecl' where
  recurse st (VarDecl' neIdl edef) = undefined
    -- case edef of
    --   Left ((_, t), _) -> do
    --     et <- toType st t
    --     either
    --       (return . Just)
    --       (\t' -> checkIds st (Variable t') "Variable " neIdl)
    --       et
    --   Right _ -> checkIds st (Variable Infer) "Variable " neIdl

instance Symbolize TypeDef' C.TypeDef' where
  recurse st (TypeDef' ident (_, t)) = undefined
    -- do
    -- et <- toType st t
    -- either (return . Just) (\t' -> checkId st (SType t') "Type " ident) et

instance Symbolize Expr C.Expr where
  recurse st (Unary _ _ e) = undefined -- recurse st e
  recurse st (Binary _ _ e1 e2) = undefined -- am (recurse st) [e1, e2]
  recurse _ (Lit _) = undefined -- return Nothing -- No identifiers to check here
  recurse st (Var ident@(Identifier _ vname)) -- Should be defined, otherwise we're trying to use undefined variable
   = undefined
    -- do
    -- isdef <- isDef st vname
    -- if isdef
    --   then return Nothing
    --   else return $ Just $ createError ident (NotDecl "Variable " ident)
  recurse st (AppendExpr _ e1 e2) = undefined -- am (recurse st) [e1, e2]
  recurse st (LenExpr _ e) = undefined -- recurse st e
  recurse st (CapExpr _ e) = undefined -- recurse st e
  recurse st (Selector _ e _) = undefined -- recurse st e
  recurse st (Index _ e1 e2) = undefined -- am (recurse st) [e1, e2]
  recurse st (Arguments _ e el) = undefined -- am (recurse st) (e : el)

instance Symbolize SwitchCase C.SwitchCase where
  recurse st (Case _ nEl s) = undefined -- am (recurse st) $ map H (toList nEl) ++ [H s]
  recurse st (Default _ s)  = undefined -- recurse st s

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

-- | List of maybes, return first Just or nothing if all nothing
maybeJ :: [Maybe b] -> Maybe b
maybeJ l =
  if null (catMaybes l)
    then Nothing
    else Just $ head $ catMaybes l

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
      checkFields st' fdl' = eitherL concat <$> mapM (checkField st') fdl'
      checkField ::
           SymbolTable s -> FieldDecl -> ST s (Either ErrorMessage' [Field])
      checkField st' (FieldDecl idl (_, t)) = do
        et <- toType st' t
        return $
          either
            Left
            (\t' ->
               case getFirstDuplicate (toList idl) of
                 Nothing ->
                   Right $
                   map (\(Identifier _ vname) -> (vname, t')) (toList idl)
                 Just ident ->
                   Left $ createError ident (AlreadyDecl "Field " ident))
            et
  toType st (Type ident) =
    resolve
      ident
      st
      (createError ident (NotDecl "Type " ident))
      (createError ident (VoidFunc ident))
  -- This should never happen, this is here for exhaustive pattern matching
  -- if we want to remove this then we have to change ArrayType to only take in literal ints in the AST
  -- if we expand to support Go later, then we'll change this to support actual expressions
  toType _ (ArrayType _ _) =
    error
      "Trying to convert type of an ArrayType with non literal int as length"

data SymbolError
  = AlreadyDecl String
                Identifier
  | NotDecl String
            Identifier
  | VoidFunc Identifier
  | NotLVal Identifier
            Symbol
  | ShortDec
  deriving (Show, Eq)

data TypeCheckError
  = TypeMismatch2 Expr Expr
  | TypeMismatch1 Identifier
                  SType
                  SType

instance ErrorEntry SymbolError where
  errorMessage c =
    case c of
      AlreadyDecl s (Identifier _ vname) -> s ++ vname ++ " already declared"
      NotDecl s (Identifier _ vname) -> s ++ vname ++ " not declared"
      VoidFunc (Identifier _ vname) -> vname ++ " resolves to a void function"
      NotLVal (Identifier _ vname) s ->
        vname ++ " resolves to " ++ show s ++ " and is not an lvalue"
      ShortDec -> "Short declaration list contains no new variables"
  
instance ErrorEntry TypeCheckError where
  errorMessage c =
    case c of
      TypeMismatch2 e1 e2 ->
        "Expression " ++
        show e1 ++ " resolves to different type than " ++ show e2 ++ " in assignment"
      TypeMismatch1 (Identifier _ vname) t1 t2 ->
        "Expression resolves to type " ++
        show t1 ++ " in assignment to " ++ vname ++ " of type " ++ show t2

-- | Extract top most scope from symbol table
topScope :: ST s (SymbolTable s) -> ST s (S.SymbolScope s Symbol)
topScope st = st >>= topScope'

topScope' :: SymbolTable s -> ST s (S.SymbolScope s Symbol)
topScope' = S.topScope

-- | Wrap a result of recurse inside a new scope
wrap ::
     SymbolTable s -> ST s (Either ErrorMessage' a) -> ST s (Either ErrorMessage' a)
wrap st stres = do
  S.enterScope st
  res <- stres
  S.exitScope st
  return res

-- | Get the first duplicate in a list, for checking if fields of a struct are all unique
getFirstDuplicate :: Eq a => [a] -> Maybe a
getFirstDuplicate [] = Nothing
getFirstDuplicate (x:xs) =
  if x `elem` xs
    then Just x
    else getFirstDuplicate xs

-- | Convert SType to base type, aka Type from CheckedData
toBase :: SType -> C.Type
toBase (Array i t) = C.ArrayType i (toBase t)
toBase (Slice t) = C.SliceType (toBase t)
toBase (Struct fls) = C.StructType (map f2fd fls)
  where
    f2fd :: Field -> C.FieldDecl
    f2fd (s, t) = C.FieldDecl s (toBase t)
toBase (TypeMap _ t) = toBase t
toBase t = case t of
             PInt -> C.Type "int"
             PFloat64 -> C.Type "float64"
             PBool -> C.Type "bool"
             PRune -> C.Type "rune"
             PString -> C.Type "string"
             _ -> error "Infer has no base type" -- Should not happen



-- | Convert SymbolInfo list to String (pass through show) to get string representation of symbol table
-- ignore error if not a symbol table error (i.e. typecheck error)
sl2str ::
     (Maybe ErrorMessage', [Maybe SymbolInfo]) -> (Maybe ErrorMessage', String)
sl2str (em, sl) =
  let (pt, b) = sl2str' sl (S.Scope 0) ""
   in if b
        then (Nothing, pt) -- Ignore error as we fully printed the symbol table
        else (em, pt)

-- | Recursive helper for sl2str with accumulator
sl2str' ::
     [Maybe SymbolInfo]
  -> S.Scope -- Previous scope
  -> String -- Accumulated string
  -> (String, Bool) -- Result, bool is to determine whether we finished printing the whole list or not to differentiate between symbol table errors and typecheck errors
-- Base case, no more scopes to close and nothing to convert, just return accumulator
sl2str' [] (S.Scope 0) acc = (acc, True)
-- Close each scope's brace at end
sl2str' [] (S.Scope scope) acc =
  sl2str' [] (S.Scope (scope - 1)) (acc ++ tabs (scope - 1) ++ "}\n")
sl2str' (mh:mt) (S.Scope pScope) acc =
  maybe
    (acc, False)
    (\(key, sym, S.Scope scope) ->
       sl2str' mt (S.Scope scope) $
       acc ++
       br pScope scope ++
       tabs scope ++
       key ++
       (case sym of
          Base     -> " [type] = " ++ key
          Constant -> " [constant] = bool"
          _        -> show sym) ++
       "\n")
    mh

-- | Account for braces given previous scope and current scope
br :: Int -> Int -> String
br prev cur
  | prev > cur = tabs (prev - 1) ++ "}\n" ++ br (prev - 1) cur
  | cur > prev = tabs prev ++ "{\n" ++ br (prev + 1) cur
  | otherwise = ""

-- | Top level function for cli
symbol :: String -> IO ()
symbol s =
  either
    putExit
    (\(me, s') -> do
       _ <- putStrLn s'
       maybe (putSucc "") putExit me)
    (pTable s)

-- | String that goes through weeding
-- Get either an error message from weeding or success/error message with string of symbol table
-- Note this isn't an either because if the left side checks, we always want the string/partial symbol table even on error so we can print it out
pTable :: String -> Either ErrorMessage (Maybe ErrorMessage, String)
pTable code =
  fmap
    (\p ->
       let (me, syml) = pTable' p
        in ( me >>= (\e -> Just $ e code `withPrefix` "Symbol table error at ")
           , syml))
    (weed code)

pTable' :: Program -> (Maybe ErrorMessage', String)
pTable' p =
  sl2str $
  runST $ do
    st <- new
    res <- recurse st p
    syml <- S.getMessages st
    return (res, syml)
