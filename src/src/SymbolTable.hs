{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE InstanceSigs          #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeApplications      #-}

module SymbolTable
  ( typecheckP
  , typecheckGen
  , symbol
  , pTable
  , new
  , add
  ) where

import           Control.Monad.ST
import           Data
import           Data.Either        (isLeft)
import           Data.Functor       (($>))

import           Data.List.NonEmpty (NonEmpty (..), fromList, toList)
import           Data.Maybe         (catMaybes)

import           Base
import qualified CheckedData        as C
import           Numeric            (readOct)
import           Prettify           (prettify)
import           Scanner            (putExit, putSucc)
import           TypeInference
import           WeedingTypes       (weedT)

import           Symbol

import           Control.Monad      (join, zipWithM)
import qualified SymbolTableCore    as S

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
    , ("true", ConstantBool)
    , ("false", ConstantBool)
    ]
  _ <- S.insert st "_" (Variable Infer) -- Dummy symbol so that we can lookup the blank identifier and just ignore the type
  return st

-- | Wrapper for insert from symbol table core, but returns a bool telling us whether we returned successfully instead of a Maybe
-- Also account for blank identifiers (we should never lookup _)
add :: SymbolTable s -> String -> Symbol -> ST s Bool -- Did we add successfully?
add st ident sym =
  if ident == "_"
    then return True -- Blank identifier can always be declared, but don't add
    else do
      result <- S.lookupCurrent st ident -- We only need to check current scope for declarations
      case result of
        Just _ -> do
          _ <- S.disableMessages st -- Found something, aka a conflict, so stop printing symbol table after this
          return False
        Nothing -> do
          scope <- S.insert st ident sym
          _ <- S.addMessage st (ident, sym, scope) -- Add the symbol info of what we added
          return True

-- | lookupCurrent wrapper but insert message on if declared, because we want to declare something ourself
isNDefL :: SymbolTable s -> String -> ST s Bool
isNDefL st k = do
  res <- S.lookupCurrent st k
  case res of
    Nothing -> return True
    Just _ -> do
      _ <- S.disableMessages st -- Signal error, key should not be defined
      return False

-- | S.isDef  wrapper but insert message if not declared
-- isDef :: SymbolTable s -> String -> ST s Bool
-- isDef st k = do
--   res <- S.lookup st k
--   case res of
--     Just _ -> return True
--     Nothing -> do
--       _ <- S.addMessage st Nothing -- Signal error, key should be defined
--       return False
-- | Class to generalize traverse function for each AST structure (symbol table generation + typecheck in one pass)
-- also return the typechecked AST
class Symbolize a b where
  recurse :: SymbolTable s -> a -> ST s (Glc' b)

-- | Class to convert AST types to SType, could possibly be just changed to a function
class Typify a
  -- Resolve AST types to SType, may return error message if type error
  where
  toType :: SymbolTable s -> Maybe SIdent -> a -> ST s (Glc' SType)
  toType st Nothing t = toType' st (Nothing, t) t False -- Do not allow recursive types by default
  toType st (Just rootIdent) t = do
    eitherSType <- toType' st (Just rootIdent, t) t False
    return $ do
      stype <- eitherSType
      let stype' = resolveType stype' stype
      return stype'
      -- Given root type and current subtype, recursively resolve all instances of
      -- `TypeMap rootIdent Infer` to `rootType`
    where
      resolveType :: SType -> SType -> SType
      resolveType rootType (Array i stype) =
        Array i $ resolveType rootType stype
      -- Only slices allow for recursive types
      resolveType rootType stype@(Slice (TypeMap ident Infer)) =
        if ident == rootIdent
          then Slice rootType
          else stype
      resolveType rootType (Slice stype) = Slice $ resolveType rootType stype
      resolveType rootType (Struct fields) =
        Struct $ map (resolveField rootType) fields
      resolveType rootType (TypeMap ident stype) =
        if ident == rootIdent && stype == Infer
          then TypeMap ident rootType
          else TypeMap ident $ resolveType rootType stype
      resolveType _ stype = stype
      resolveField :: SType -> Field -> Field
      resolveField rootType (ident, stype) = (ident, resolveType rootType stype)
  -- | Underlying type resolver.
  -- If SIdent is not Nothing, it represents the top most identity.
  -- If cyclic types are allowed, then it should be used to create a typemap with infer
  -- The `a` value within the tuple is the parent typify argument, which is used to check
  -- for constraints for cyclic types
  toType' ::
       SymbolTable s
    -> (Maybe SIdent, a)
    -> a
    -> Bool -- Is recursion allowed? Are we nested inside of a slice?
    -> ST s (Either ErrorMessage' SType)

-- | Returns matching id if current type is a reference,
-- and parent identity matches current type identity
getMatchingSIdent :: Maybe SIdent -> Type -> Maybe SIdent
getMatchingSIdent (Just sident@(C.ScopedIdent _ (C.Ident rootIdent))) (Type (Identifier _ ident)) =
  if rootIdent == ident
    then Just sident
    else Nothing
getMatchingSIdent _ _ = Nothing

instance Typify Type where
  toType' ::
       forall s.
       SymbolTable s
    -> (Maybe SIdent, Type)
    -> Type
    -> Bool -- Allow recursion? If the call is nested inside a slice
    -> ST s (Either ErrorMessage' SType)
  toType' st root (ArrayType (Lit l) t) brec = do
    sym <- toType' st root t brec
    return $ sym >>= Right . Array (intTypeToInt l) -- Negative indices are not possible because we only accept int lits, no unary ops, no need to check
  -- In golite, we can use a slice type x while creating type x
  toType' st root@(_, _) (SliceType t) _ = resolveType
      -- Default resolution method
    where
      resolveType :: ST s (Either ErrorMessage' SType)
      resolveType = do
        sym <- toType' st root t True -- Allow recursion since we're inside a slice
        return $ sym >>= Right . Slice
  toType' st root@(rootSIdent, rootType) (StructType fdl) brec = do
    fl <- checkFields
    return $ fl >>= Right . Struct
      -- Get all identifiers from field declarations
    where
      getAllIdents :: [Identifier]
      getAllIdents = concatMap (\(FieldDecl nidl _) -> toList nidl) fdl
      checkFields :: ST s (Either ErrorMessage' [Field]) -- Check for duplicates first
      checkFields =
        checkDup
          st
          getAllIdents
          (AlreadyDecl "Field ")
          (do fields <- mapM checkField fdl
              return $ concat <$> sequence fields)
      checkField :: FieldDecl -> ST s (Either ErrorMessage' [Field])
      checkField (FieldDecl idl (_, t)) = do
        ft <- fieldType' t
        return $ toField idl <$> ft
      -- | Checks first for cyclic type, then defaults to the generic type resolver
      fieldType' :: Type -> ST s (Either ErrorMessage' SType)
      fieldType' t =
        case (getMatchingSIdent rootSIdent t, isTypeStruct rootType)
                -- Cycles only permitted on matching root sident with a non struct root type
              of
          (Just sident, False) -> cyclicType sident
          _                    -> toType' st root t brec
      toField :: Identifiers -> SType -> [Field]
      toField idl t = map (\(Identifier _ vname) -> (vname, t)) (toList idl)
      isTypeStruct :: Type -> Bool
      isTypeStruct (StructType _) = True
      isTypeStruct _              = False
  toType' st (rootSIdent, _) t@(Type ident) brec =
    case getMatchingSIdent rootSIdent t of
      Just sident ->
        if brec
          then cyclicType sident
          else resolveId
      _ -> resolveId
    where
      resolveId :: ST s (Either ErrorMessage' SType)
      resolveId = resolve ident st (createError ident (NotDecl "Type " ident))
  -- This last array case should never happen, this is here for exhaustive pattern matching
  -- if we want to remove this then we have to change ArrayType to only take in literal ints in the AST
  -- if we expand to support Go later, then we'll change this to support actual expressions
  toType' _ _ (ArrayType _ _) _ =
    error
      "Trying to convert type of an ArrayType with non literal int as length"

-- | Placeholder to reference root type
cyclicType :: SIdent -> ST s (Either ErrorMessage' SType)
cyclicType rootScope = return $ Right $ TypeMap rootScope Infer

instance Symbolize Program C.Program where
  recurse st (Program (Identifier _ pkg) tdl)
    -- Recurse on the top level declarations of a program in a new scope
   = wrap st $ fmap (C.Program (C.Ident pkg)) <$> recurse st tdl

instance Symbolize TopDecl C.TopDecl
  -- Recurse on declarations
                             where
  recurse st (TopDecl d)      = fmap C.TopDecl <$> recurse st d
  recurse st (TopFuncDecl fd) = fmap C.TopFuncDecl <$> recurse st fd

-- | Helper for a list of top declarations, does the same thing as above except we use mapM and sequence the results (i.e. if we have a Left in any of the results, we'll just use that because we have an error)
instance Symbolize [TopDecl] [C.TopDecl] where
  recurse st vdl = do
    el <- mapM (recurse st) vdl
    return (sequence el)

instance Symbolize FuncDecl C.FuncDecl
  -- Check if function (ident) is declared in current scope (top scope)
  -- if not, we open new scope to symbolize body and then validate sig before declaring
                                                                                        where
  recurse :: forall s. SymbolTable s -> FuncDecl -> ST s (Glc' C.FuncDecl)
  recurse st (FuncDecl ident@(Identifier _ vname) (Signature (Parameters pdl) t) body@(BlockStmt sl)) =
    if vname == "init"
      then addInit
      else addFunc
      -- Get return type of function
    where
      retType :: ST s (Either ErrorMessage' SType)
      retType = maybe (return $ Right Void) (toType st Nothing . snd) t
      -- Insert dummy function before checking arguments, in case arguments refer to function name
      dummyFunc :: ST s (Maybe ErrorMessage')
      dummyFunc = do
        rtm <- retType
        either
          (return . Just)
          (\rt -> S.insert st vname (Func [] rt) $> Nothing)
          rtm
      -- Add any function that is not init to symbol table
      addFunc :: ST s (Either ErrorMessage' C.FuncDecl)
      addFunc = do
        notdef <- isNDefL st vname -- Check if defined in symbol table
        if notdef
          then do
            me <- dummyFunc
            maybe
              (do epl <- wrap st $ checkParams pdl -- Dummy scope to check params
                -- Glc' Symbol, want to get the corresponding
                -- Func symbol using our resolved params (if no errors in param
                -- declaration) and the type of the return of the signature, t,
                -- which is a Maybe Type'
                  ef <- either (return . Left) createFunc epl
                -- We then take the Either ErrorMessage' Symbol, if no error we
                -- exit dummy scope so we're at the right scope level, insert
                -- the Symbol (newly declared function) and then wrap the real
                -- scope of the function, adding all the parameters that are
                -- already resolved as symbols and recursing on statement list
                -- sl (from body of func) to declare things in body
                  either (return . Left) insertFunc ef)
              (return . Left)
              me
          else return $ Left $ createError ident (AlreadyDecl "Function " ident)
        where
          funcSym :: ([Param], SType) -> Symbol
          funcSym (pl, ret) = Func pl ret
          createFunc ::
               [(Param, SymbolInfo)]
            -> ST s (Either ErrorMessage' (([Param], SType), [SymbolInfo]))
          createFunc l
              -- TODO don't use toType here; resolve only type def types
           =
            let (pl, sil) = unzip l
             in do returnTypeEither <- retType
                   return $ (\ret -> ((pl, ret), sil)) <$> returnTypeEither
          insertFunc ::
               (([Param], SType), [SymbolInfo])
            -> ST s (Either ErrorMessage' C.FuncDecl)
          insertFunc (ftup, sil) =
            let f = funcSym ftup
             in do scope <- S.insert st vname f
                   _ <- S.addMessage st (vname, f, scope)
                   wrap'
                     st
                     f
                     (do mapM_ (\(k, sym, _) -> add st k sym) sil
                         recurseSl scope)
            where
              recurseSl :: S.Scope -> ST s (Either ErrorMessage' C.FuncDecl)
              recurseSl scope' =
                fmap
                  (C.FuncDecl (mkSIdStr scope' vname) (func2sig scope' ftup) .
                   C.BlockStmt) .
                sequence <$>
                mapM (recurse st) sl
      -- Adds the init function to message list
      addInit :: ST s (Either ErrorMessage' C.FuncDecl)
      addInit =
        maybe
          (do scope <- S.scopeLevel st -- Should be 1
              _ <- S.addMessage st (vname, Func [] Void, scope)
              recurseBody scope)
          (\(_, t') -> do
             et2 <- toType st Nothing t'
             _ <- S.disableMessages st
             return $ (Left . createError ident . InitNVoid) =<< et2)
          t
        where
          recurseBody :: S.Scope -> ST s (Either ErrorMessage' C.FuncDecl)
          recurseBody scope' =
            fmap
              (C.FuncDecl
                 (mkSIdStr scope' vname)
                 (C.Signature (C.Parameters []) Nothing)) <$>
            recurse st body
      getAllIdents :: [Identifier]
      getAllIdents = concatMap (\(ParameterDecl nidl _) -> toList nidl) pdl
      checkParams :: [ParameterDecl] -> ST s (Glc' [(Param, SymbolInfo)])
      checkParams pdl' = checkDup st getAllIdents DuplicateParam $
                         do
                           pl <- mapM checkParam pdl'
                           return $ concat <$> sequence pl
      checkParam :: ParameterDecl -> ST s (Glc' [(Param, SymbolInfo)])
      checkParam (ParameterDecl idl (_, t')) = do
        et <- toType st Nothing t' -- Remove ST
        either
          (return . Left)
          (\t2 -> do
             einfo <- checkIds' t2 idl
                                   -- Alternatively we can add messages at the checkId level instead of making the ParamInfo type
             either
               (\e -> do
                  _ <- S.disableMessages st
                  return $ Left e)
               (return . Right)
               einfo)
          et
      checkIds' :: SType -> Identifiers -> ST s (Glc' [(Param, SymbolInfo)])
      checkIds' t' idl = do
        scope <- S.scopeLevel st
        sequence <$> mapM (checkId' scope t') (toList idl)
      checkId' ::
           S.Scope -> SType -> Identifier -> ST s (Glc' (Param, SymbolInfo))
      checkId' scope t' ident'@(Identifier _ idv) = do
        notdef <- isNDefL st idv -- Should not be declared
        if notdef
          then return $ Right ((idv, t'), (idv, Variable t', scope))
          else return $ Left $ createError ident (AlreadyDecl "Param " ident')
      p2pd :: S.Scope -> Param -> C.ParameterDecl
      p2pd scope (s, t') = C.ParameterDecl (mkSIdStr scope s) (toBase t')
      func2sig :: S.Scope -> ([Param], SType) -> C.Signature
      func2sig scope (pl, t') =
        C.Signature
          (C.Parameters (map (p2pd scope) pl))
          (case toBase t' of
             C.Type (C.Ident "void") -> Nothing
             ct                      -> Just ct)
  recurse _ FuncDecl {} =
    error "Function declaration's body is not a block stmt"

--               do
--                 _ <- S.addMessage st2 Nothing -- Signal error so we don't print symbols beyond this
--                 return $ Left e
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
checkId st s pfix ident@(Identifier _ vname) = do
  success <- add st vname s -- Should not be declared
  if success
    then return Nothing
    else S.disableMessages st $>
         (Just $ createError ident (AlreadyDecl pfix ident))

instance Symbolize SimpleStmt C.SimpleStmt where
  recurse :: forall s. SymbolTable s -> SimpleStmt -> ST s (Glc' C.SimpleStmt)
  recurse st (ShortDeclare idl el) = do
    ets <- mapM (infer st) el' -- Check that everything on RHS can be inferred, otherwise we may be assigning to something on LHS
    either
      (return . Left)
      (const $ fmap C.ShortDeclare <$> checkDecl)
      (sequence ets)
    where
      idl' = toList idl
      el' = toList el
      checkDecl :: ST s (Glc' (NonEmpty (SIdent, C.Expr)))
      checkDecl =
        checkDup
          st
          idl'
          DuplicateShort
          (do eb <- zipWithM checkDec idl' el'
        -- may want to add offsets to ShortDeclarations and create an error with those here for ShortDec
              let eit = sequence eb >>= check
               in if isLeft eit
                    then S.disableMessages st $> eit
                    else return eit)
        where
          check ::
               [(Bool, (C.ScopedIdent, C.Expr))]
            -> Either (String -> ErrorMessage) (NonEmpty (C.ScopedIdent, C.Expr))
          check l =
            let (bl, decl) =
                  unzip
                    (filter (\(_, (sident, _)) -> not (isBlankIdent sident)) l)
             in if True `elem` bl
                  then Right (fromList decl)
                  else Left $ createError (head idl') ShortDec
      checkDec :: Identifier -> Expr -> ST s (Glc' (Bool, (SIdent, C.Expr)))
      checkDec ident e = do
        et <- infer st e -- Glc' SType
        either
          (return . Left)
          (\t -> do
             et' <- recurse st e
             eb <- checkId' ident t
             either (return . Left) (attachExpr eb) et')
          et
        where
          attachExpr ::
               Glc' (Bool, SIdent)
            -> C.Expr
            -> ST s (Glc' (Bool, (SIdent, C.Expr)))
          attachExpr eb e' = return $ (\(b, sid) -> (b, (sid, e'))) <$> eb
          checkId' ::
               Identifier
            -> SType
            -> ST s (Glc' (Bool, SIdent)) -- Bool is to indicate whether the variable was already declared or not and also create scoped ident
          -- Note that short declarations require at least *one* new declaration
          checkId' ident'@(Identifier _ vname) t = do
            val <- S.lookupCurrent st vname
            case val of
              Just (scope, Variable t2) ->
                return $
                if t2 == t || vname == "_" -- Don't check type of blank
                  then Right (False, mkSIdStr scope vname)
                            -- if locally defined, check if type matches
                  else Left $ createError e (TypeMismatch2 ident t t2)
              Just _ ->
                S.disableMessages st $>
                (Left $ createError ident' (NotVar ident'))
              Nothing -> do
                _ <- add st vname (Variable Infer) -- Add infer so that we don't print out the actual type
                scope <- S.insert st vname (Variable t) -- Overwrite infer with actual type so we can infer other variables
                return $ Right (True, mkSIdStr scope vname)
  recurse _ EmptyStmt = return $ Right C.EmptyStmt
  recurse st (ExprStmt e) = fmap C.ExprStmt <$> recurse st e -- Verify that expr only uses things that are defined
  recurse st (Increment _ e) = do
    et <- infer st e
    either
      (return . Left)
      (\t ->
         if isNumeric (resolveSType t) && isAddr e
           then fmap C.Increment <$> recurse st e
           else return $ Left $ createError e (NonNumeric e "incremented"))
      et
  recurse st (Decrement _ e) = do
    et <- infer st e
    either
      (return . Left)
      (\t ->
         if isNumeric (resolveSType t) && isAddr e
           then fmap C.Decrement <$> recurse st e
           else return $ Left $ createError e (NonNumeric e "decremented"))
      et
  recurse st (Assign _ aop@(AssignOp mop) el1 el2) = do
    ets <- mapM (infer st) (toList el2) -- Check that everything on RHS can be inferred, otherwise we may be assigning to something on LHS
    either
      (return . Left)
      (const $
       let errL = concatMap isAddrE (toList el1) -- Make sure everything is an lvalue
        in if null errL
             then do
               l1 <- mapM (recurse st) (toList el1)
               l2 <- mapM (recurse st) (toList el2)
               case mop of
                 Nothing -> do
                   me <- mapM sameType (zip (toList el1) (toList el2))
                   maybe
                     (either
                        (return . Left)
                        (\l1' ->
                           either
                             (return . Left)
                             (return .
                              Right .
                              C.Assign (C.AssignOp Nothing) . fromList . zip l1')
                             (sequence l2))
                        (sequence l1))
                     (return . Left)
                     (maybeJ me)
                 Just op -> do
                   el <-
                     mapM
                       (infer st . aop2e (Arithm op))
                       (zip (toList el1) (toList el2))
                   either
                     (return . Left)
                     (const
                        (either
                           (return . Left)
                           (\l1' ->
                              either
                                (return . Left)
                                (\l2' ->
                                   return $
                                   Right $
                                   C.Assign
                                     (aop2aop' aop)
                                     (fromList $ zip l1' l2'))
                                (sequence l2))
                           (sequence l1)))
                     (sequence el)
             else return $ Left $ head errL)
      (sequence ets)
      -- convert op and 2 expressions to binary op, infer type of this to make sure it makes sense
    where
      aop2e :: BinaryOp -> (Expr, Expr) -> Expr
      aop2e op (e1, e2) = Binary (offset e1) op e1 e2
      aop2aop' :: AssignOp -> C.AssignOp
      aop2aop' (AssignOp (Just aop')) = C.AssignOp $ Just $ aopConv aop'
      aop2aop' (AssignOp Nothing)     = C.AssignOp Nothing
      -- | Check if two expressions have the same type and if LHS is addressable, helper for assignments
      sameType :: (Expr, Expr) -> ST s (Maybe ErrorMessage')
      sameType (Var (Identifier _ "_"), _) = return Nothing -- Do not compare if LHS is "_"
      sameType (e1, e2) = do
        et1 <- infer st e1
        et2 <- infer st e2
        return $
          either
            Just
            (\t1 ->
               either
                 Just
                 (\t2 ->
                    if t1 /= t2
                      then Just (createError e1 (TypeMismatch1 t1 t2 e2))
                      else if isAddr e1
                             then Nothing
                             else Just $ createError e1 (NonLVal e1))
                 et2)
            et1

-- | Convert ArithmOp from original AST to new AST
aopConv :: ArithmOp -> C.ArithmOp
aopConv op =
  case op of
    Add       -> C.Add
    Subtract  -> C.Subtract
    BitOr     -> C.BitOr
    BitXor    -> C.BitXor
    Multiply  -> C.Multiply
    Divide    -> C.Divide
    Remainder -> C.Remainder
    ShiftL    -> C.ShiftL
    ShiftR    -> C.ShiftR
    BitAnd    -> C.BitAnd
    BitClear  -> C.BitClear

instance Symbolize Stmt C.Stmt where
  recurse :: forall s. SymbolTable s -> Stmt -> ST s (Glc' C.Stmt)
  recurse st (BlockStmt sl) =
    wrap st $ fmap C.BlockStmt . sequence <$> mapM (recurse st) sl
  recurse st (SimpleStmt s) = fmap C.SimpleStmt <$> recurse st s
  recurse st (If (ss, e) s1 s2) =
    wrap st $ do
      ess' <- recurse st ss
      et <- infer st e
      either
        (return . Left)
        (\t ->
           if resolveSType t == PBool
             then do
               ee' <- recurse st e
               es1' <- recurse st s1
               es2' <- recurse st s2
               return $
                 (\ss' ->
                    (\e' -> (\s1' -> C.If (ss', e') s1' <$> es2') =<< es1') =<<
                    ee') =<<
                 ess'
             else return $ Left $ createError e (CondBool e t))
        et
  recurse st (Switch ss me scs) =
    wrap st $ do
      ess' <- recurse st ss
      maybe
        (do escs' <- sequence <$> mapM (recurse' PBool) scs
            return $ (\ss' -> C.Switch ss' Nothing <$> escs') =<< ess')
        (\e -> do
           t <- infer st e
           ee' <- recurse st e
           either
             (return . Left)
             (\t' ->
                if isComparable t'
                  then do
                    escs' <- sequence <$> mapM (recurse' t') scs
                    return $
                      (\ss' ->
                         (\scs' -> (\e' -> C.Switch ss' (Just e') scs') <$> ee') =<<
                         escs') =<<
                      ess'
                  else return $ Left $ createError e (NotCompSw t'))
             t)
        me
    where
      recurse' :: SType -> SwitchCase -> ST s (Glc' C.SwitchCase)
      recurse' t (Case _ nEl s) = do
        eel <- sequence <$> mapM (isType t) (toList nEl)
        es' <- recurse st s
        return $ (\el -> C.Case (fromList el) <$> es') =<< eel
      recurse' _ (Default _ s) = fmap C.Default <$> recurse st s
          -- Also return new expr after check
      isType :: SType -> Expr -> ST s (Glc' C.Expr)
      isType t e = do
        et <- infer st e
        either
          (return . Left)
          (\t2 ->
             if t2 == t
               then recurse st e
               else return $ Left $ createError e (NotComp t2 t))
          et
  recurse st (For (ForClause ss1 me ss2) s) =
    wrap st $ do
      ess1' <- recurse st ss1
      ess2' <- recurse st ss2
      es' <- recurse st s
      maybe
        (return $
         (\ss1' ->
            (\ss2' -> (Right . C.For (C.ForClause ss1' Nothing ss2')) =<< es') =<<
            ess2') =<<
         ess1')
        (\e -> do
           et' <- infer st e
           either
             (return . Left)
             (\t' ->
                if resolveSType t' == PBool
                  then return $
                       (\ss1' ->
                          (\ss2' ->
                             (Right . C.For (C.ForClause ss1' Nothing ss2')) =<<
                             es') =<<
                          ess2') =<<
                       ess1'
                  else return $ Left $ createError e (CondBool e t'))
             et')
        me
  recurse _ (Break _) = return $ Right C.Break
  recurse _ (Continue _) = return $ Right C.Continue
  recurse st (Declare d) = fmap C.Declare <$> recurse st d
  recurse st (Print el) = fmap C.Print . sequence <$> mapM (recBaseE st) el
  recurse st (Println el) = fmap C.Println . sequence <$> mapM (recBaseE st) el
  recurse st (Return o (Just e)) = do
    et <- getRet o st
    et' <- infer st e
    ee' <- recurse st e
    return $
      join $
      (\t t' e' ->
         if t == Void
           then Left $ createError e VoidRet
           else if t == t'
                  then Right (C.Return $ Just e')
                  else Left $ createError e (RetMismatch t' t)) <$>
      et <*>
      et' <*>
      ee'
  recurse st (Return o Nothing) = do
    et <- getRet o st
    return $
      (\t ->
         if t == Void
           then Right $ C.Return Nothing
           else Left $ createError o $ RetMismatch Void t) =<<
      et

-- | recurse wrapper but guarantee that expression is a base type for printing
recBaseE :: SymbolTable s -> Expr -> ST s (Glc' C.Expr)
recBaseE st e = do
  et <- infer st e
  either
    (return . Left)
    (\t ->
       if isBase (resolveSType t)
         then recurse st e
         else return $ Left $ createError e (NonBaseP t))
    et

instance Symbolize Decl C.Decl where
  recurse st (VarDecl vdl) = fmap C.VarDecl <$> recurse st vdl
  recurse st (TypeDef tdl) = fmap C.TypeDef <$> recurse st tdl

instance Symbolize [VarDecl'] [C.VarDecl'] where
  recurse st vdl = do
    el <- mapM (recurse st) vdl
    return $ concat <$> sequence el

instance Symbolize VarDecl' [C.VarDecl'] where
  recurse :: forall s. SymbolTable s -> VarDecl' -> ST s (Glc' [C.VarDecl'])
  recurse st (VarDecl' neIdl edef) =
    case edef of
      Left ((_, t), el) -> do
        ets <- mapM (infer st) el -- Check that everything on RHS can be inferred, otherwise we may be assigning to something on LHS
        et <- toType st Nothing t
        either
          (return . Left)
          (const $
           either
             (return . Left)
             (\t' -> do
                me <- checkIds st (Variable t') "Variable " neIdl
                maybe (checkDecl t' (toList neIdl) el) (return . Left) me)
             et)
          (sequence ets)
      Right nel -> do
        ets <- mapM (infer st) (toList nel) -- Check that everything on RHS can be inferred, otherwise we may be assigning to something on LHS
        me <- checkIds st (Variable Infer) "Variable " neIdl
        either
          (return . Left)
          (const $
           maybe (checkDeclI (toList neIdl) (toList nel)) (return . Left) me)
          (sequence ets)
    where
      checkDecl :: SType -> [Identifier] -> [Expr] -> ST s (Glc' [C.VarDecl'])
      checkDecl t2 idl [] = do
        edl <- mapM (checkDec t2 Nothing) idl
        return $ sequence edl
      checkDecl t2 idl el' = do
        edl <- mapM (\(i, ex) -> checkDec t2 (Just ex) i) (zip idl el')
        return $ sequence edl
      checkDec :: SType -> Maybe Expr -> Identifier -> ST s (Glc' C.VarDecl')
      checkDec t2 me ident@(Identifier _ vname) = do
        scope <- S.scopeLevel st
        maybe
          (return $
           Right $ C.VarDecl' (mkSIdStr scope vname) (toBase t2) Nothing)
          (\e -> do
             et' <- infer st e
             either
               (return . Left)
               (\t' ->
                  if t2 == t'
                    then (do ee' <- recurse st e
                             return $
                               fmap
                                 (C.VarDecl' (mkSIdStr scope vname) (toBase t2) .
                                  Just)
                                 ee')
                    else return $
                         Left $ createError e (TypeMismatch2 ident t' t2))
               et')
          me
      checkDeclI :: [Identifier] -> [Expr] -> ST s (Glc' [C.VarDecl'])
      checkDeclI idl el' = do
        edl <- mapM (\(i, ex) -> checkDecI ex i) (zip idl el')
        return $ sequence edl
      checkDecI :: Expr -> Identifier -> ST s (Glc' C.VarDecl')
      checkDecI e (Identifier _ vname) = do
        et' <- infer st e
        either
          (return . Left)
          (\t' -> do
             scope <- S.insert st vname (Variable t') -- Update type of variable
             ee' <- recurse st e
             return $
               fmap (C.VarDecl' (mkSIdStr scope vname) (toBase t') . Just) ee')
          et'

instance Symbolize [TypeDef'] [C.TypeDef'] where
  recurse st vdl = do
    el <- mapM (recurse st) vdl
    return (sequence el)

instance Symbolize TypeDef' C.TypeDef' where
  recurse st (TypeDef' ident@(Identifier _ vname) (_, t)) = do
    scope <- S.scopeLevel st
    let sident = mkSIdStr scope vname
    et <- toType st (Just sident) t
    either
      (return . Left)
      (\t' -> do
         me <- checkId st (SType t') "Type " ident
         maybe
           (case t' -- Ignore all types except for structs, as structs will be the only types we will have to define
                  of
              Struct _ -> return $ Right $ C.TypeDef' sident (toBase t')
              _        -> return $ Right C.NoDef)
           (return . Left)
           me)
      et

instance Symbolize Expr C.Expr where
  recurse st eu@(Unary _ op e) = do
    et' <- infer st eu -- Use typecheck from type inference
    either
      (return . Left)
      (const $ fmap (C.Unary (convOp op)) <$> recurse st e)
      et'
    where
      convOp :: UnaryOp -> C.UnaryOp
      convOp op' =
        case op' of
          Pos           -> C.Pos
          Neg           -> C.Neg
          Not           -> C.Not
          BitComplement -> C.BitComplement
  recurse st e@(Binary _ op e1 e2) = do
    et' <- infer st e
    ee1' <- recurse st e1
    ee2' <- recurse st e2
    either
      (return . Left)
      (const $ return $ (\e1' -> C.Binary (convOp op) e1' <$> ee2') =<< ee1')
      et'
    where
      convOp :: BinaryOp -> C.BinaryOp
      convOp op' =
        case op' of
          Or         -> C.Or
          And        -> C.And
          Arithm aop -> C.Arithm $ aopConv aop
          Data.EQ    -> C.EQ
          NEQ        -> C.EQ
          Data.LT    -> C.LT
          LEQ        -> C.LEQ
          Data.GT    -> C.GT
          GEQ        -> C.GEQ
  recurse _ (Lit lit) =
    return $
    Right $
    case lit of
      IntLit {} -> C.Lit $ C.IntLit $ intTypeToInt lit
      FloatLit _ fs ->
        C.Lit $
        C.FloatLit $
        read $
        case break (== '.') fs -- Separate by String by . and check if any side is empty
              of
          (_, ['.'])  -> fs ++ "0" -- Append 0 because 1. is not a valid Float in Haskell
          ([], '.':_) -> '0' : fs -- Prepend 0 because .1 is not a valid Float
          (_, _)      -> fs
      RuneLit _ cs ->
        C.Lit $
        C.RuneLit $
        case cs !! 1 of
          '\\' ->
            case cs !! 2 of
              'a'  -> '\a'
              'b'  -> '\b'
              'f'  -> '\f'
              'n'  -> '\n'
              'r'  -> '\r'
              't'  -> '\t'
              'v'  -> '\v'
              '\'' -> '\''
              '\\' -> '\\'
              _    -> error "Invalid escape character in rune lit" -- Should never happen because scanner guarantees these escape characters
          c -> c
      StringLit _ _ s -> C.Lit $ C.StringLit s -- TODO: Resolve separate types of strings
  recurse st (Var ident@(Identifier _ vname)) -- Should be defined, otherwise we're trying to use undefined variable
   = do
    msi <- S.lookup st vname
    maybe
      (S.disableMessages st $>
       (Left $ createError ident (NotDecl "Variable " ident)))
      (\(scope, _) -> return $ Right $ C.Var (mkSIdStr scope vname))
      msi
  recurse st e@(AppendExpr _ e1 e2) = do
    et' <- infer st e
    ee1' <- recurse st e1
    ee2' <- recurse st e2
    either
      (return . Left)
      (const $ return $ (\e1' -> C.AppendExpr e1' <$> ee2') =<< ee1')
      et'
  recurse st ec@(LenExpr _ e) = do
    ect' <- infer st ec
    ee' <- recurse st e
    either (return . Left) (const $ return $ C.LenExpr <$> ee') ect'
  recurse st ec@(CapExpr _ e) = do
    ect' <- infer st ec
    ee' <- recurse st e
    either (return . Left) (const $ return $ C.CapExpr <$> ee') ect'
  recurse st ec@(Selector _ e (Identifier _ vname)) = do
    ect' <- infer st ec
    ee' <- recurse st e
    either
      (return . Left)
      (const $ return $ (\e' -> C.Selector e' (C.Ident vname)) <$> ee')
      ect'
  recurse st e@(Index _ e1 e2) = do
    et' <- infer st e
    ee1' <- recurse st e1
    ee2' <- recurse st e2
    either
      (return . Left)
      (const $ return $ (\e1' -> C.Index e1' <$> ee2') =<< ee1')
      et'
  recurse st ec@(Arguments _ e el) = do
    ect' <- infer st ec
    ee' <- recurse st e
    eel' <- mapM (recurse st) el
    either
      (return . Left)
      (const $ return $ (\e' -> C.Arguments e' <$> sequence eel') =<< ee')
      ect'

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

-- | List of maybes, return first Just or nothing if all nothing
maybeJ :: [Maybe b] -> Maybe b
maybeJ l =
  if null (catMaybes l)
    then Nothing
    else Just $ head $ catMaybes l

data SymbolError
  = AlreadyDecl String
                Identifier
  | NotDecl String
            Identifier
  | VoidFunc Identifier
  | NotVar Identifier
  | DuplicateShort Identifier
  | DuplicateParam Identifier
  | ShortDec
  | InitNVoid SType
  | InitParams
  deriving (Show, Eq)

data TypeCheckError
  = TypeMismatch1 SType
                  SType
                  Expr
  | TypeMismatch2 Identifier
                  SType
                  SType
  | CondBool Expr
             SType
  | NonNumeric Expr
               String
  | NotCompSw SType
  | NotComp SType
            SType
  | NonBaseP SType
  | VoidRet
  | RetMismatch SType
                SType
  | NonLVal Expr
  | RetOut -- Return outside of function, should never happen
  | NotFunc -- Trying to get the return value of a symbol that isn't a function, shouldn't happen
  deriving (Show, Eq)

instance ErrorEntry SymbolError where
  errorMessage c =
    case c of
      AlreadyDecl s (Identifier _ vname) -> s ++ vname ++ " already declared"
      NotDecl s (Identifier _ vname) -> s ++ vname ++ " not declared"
      VoidFunc (Identifier _ vname) -> vname ++ " resolves to a void function"
      NotVar (Identifier _ vname) ->
        vname ++ " is not a var and cannot be short declared"
      DuplicateShort (Identifier _ vname) ->
        "Repeated identifier " ++ vname ++ " on LHS of short declaration"
      DuplicateParam (Identifier _ vname) ->
        "Duplicate parameter " ++ vname ++ " in function declaration"
      ShortDec -> "Short declaration list contains no new variables"
      InitNVoid t -> "init has non void return type " ++ show t
      InitParams -> "init must not have any parameters"

instance ErrorEntry TypeCheckError where
  errorMessage c =
    case c of
      TypeMismatch1 t1 t2 e ->
        "Expression resolves to different type " ++
        show t1 ++
        " than type " ++ show t2 ++ " of " ++ prettify e ++ " in assignment"
      TypeMismatch2 (Identifier _ vname) t1 t2 ->
        "Expression resolves to type " ++
        show t1 ++ " in assignment to " ++ vname ++ " of type " ++ show t2
      CondBool e t ->
        "Condition " ++
        prettify e ++ " resolves to " ++ show t ++ ", expecting a bool"
      NonNumeric e s ->
        prettify e ++ " is a non numeric type and cannot be " ++ s
      NotCompSw t ->
        "Switch statement expression resolves to type " ++
        show t ++ " and is not comparable"
      NotComp t1 t2 ->
        "Cannot compare expression of type " ++
        show t1 ++ " with type " ++ show t2 ++ " (type of switch expression)"
      NonBaseP t ->
        "Expression resolves to non base type" ++
        show t ++ " and cannot be printed"
      VoidRet -> "Cannot return expression from void function"
      RetMismatch t1 t2 ->
        "Return expression resolves to type " ++
        show t1 ++ " but function return type is " ++ show t2
      NonLVal e -> prettify e ++ " is not an lvalue and cannot be assigned to"
      RetOut -> "Return expression outside of function context"
      NotFunc -> "Trying to get return value of a symbol that isn't a function"

-- | Wrap a result of recurse inside a new scope
wrap :: SymbolTable s -> ST s (Glc' a) -> ST s (Glc' a)
wrap st stres = do
  S.enterScope st
  res <- stres
  S.exitScope st
  return res

-- | Wrap but add a function context
wrap' ::
     SymbolTable s
  -> Symbol
  -> ST s (Either ErrorMessage' a)
  -> ST s (Either ErrorMessage' a)
wrap' st sym stres = do
  S.enterScopeCtx st sym
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

-- | Wrapper for check duplicate that will do an action if no duplicate found
checkDup ::
     (Eq a, ErrorBreakpoint a)
  => SymbolTable s
  -> [a]
  -> (a -> SymbolError)
  -> ST s (Glc' b)
  -> ST s (Glc' b)
checkDup st l err stres =
  case getFirstDuplicate l of
    Nothing  -> stres
    Just dup -> S.disableMessages st $> (Left $ createError dup $ err dup)

-- | Convert SType to base type, aka Type from CheckedData
toBase :: SType -> C.Type
toBase (Array i t) = C.ArrayType i (toBase t)
toBase (Slice t) = C.SliceType (toBase t)
toBase (Struct fls) = C.StructType (map f2fd fls)
  where
    f2fd :: Field -> C.FieldDecl
    f2fd (s, t) = C.FieldDecl (C.Ident s) (toBase t)
toBase (TypeMap _ t) = toBase t
toBase t = C.Type $ C.Ident $ show t -- The last ones are primitive types, void or infer

-- | Is the expression addressable, aka an lvalue that we can assign to?
isAddr :: Expr -> Bool
isAddr e =
  case e of
    Var _       -> True
    Selector {} -> True
    Index {}    -> True
    _           -> False

-- | Check if given expression is addressable, if not, return error message
isAddrE :: Expr -> [ErrorMessage']
isAddrE e =
  if isAddr e
    then []
    else [createError e (NonLVal e)]

-- | Get the return value of function we are currently declaring, aka latest declared function
getRet :: Offset -> SymbolTable s -> ST s (Either ErrorMessage' SType)
getRet o st = do
  fm <- S.getCtx st
  -- This error should never happen as our parser doesn't allow a return statement outside of a function body
  return $ maybe (Left $ createError o RetOut) getRet' fm
  where
    getRet' :: Symbol -> Either ErrorMessage' SType
    getRet' (Func _ t) = Right t
    getRet' _          = Left $ createError o NotFunc -- Also shouldn't happen and also can be Nothing, but once again, misleading

-- | Convert SymbolInfo list to String (pass through show) to get string representation of symbol table
-- ignore error if not a symbol table error (i.e. typecheck error)
sl2str :: (Maybe ErrorMessage', [SymbolInfo]) -> (Maybe ErrorMessage', String)
sl2str (em, sl) = (em, sl2str' sl (S.Scope 0) "")
    -- | Recursive helper for sl2str with accumulator
  where
    sl2str' ::
         [SymbolInfo]
      -> S.Scope -- Previous scope
      -> String -- Accumulated string
      -> String -- Result
    -- Base case, no more scopes to close and nothing to convert, just return accumulator
    sl2str' [] (S.Scope 0) acc = acc
    -- Close each scope's brace at end
    sl2str' [] (S.Scope scope) acc =
      sl2str' [] (S.Scope (scope - 1)) (acc ++ tabs (scope - 1) ++ "}\n")
    sl2str' ((key, sym, S.Scope scope):tl) (S.Scope pScope) acc =
      sl2str' tl (S.Scope scope) $
      acc ++
      br pScope scope ++
      tabs scope ++
      key ++
      (case sym of
         Base -> " [type] = " ++ key
         ConstantBool -> " [constant] = bool"
         Func {} ->
           if key == "init"
             then " [function] = <unmapped>"
             else show sym
         _ -> show sym) ++
      "\n"

-- | Account for braces given previous scope and current scope
br :: Int -> Int -> String
br prev cur
  | prev > cur = tabs (prev - 1) ++ "}\n" ++ br (prev - 1) cur
  | cur > prev = tabs prev ++ "{\n" ++ br (prev + 1) cur
  | otherwise = ""

-- | Top level function for cli to verify if program passes typecheck
typecheckP :: String -> IO ()
typecheckP s = either putExit (const $ putSucc "OK") (typecheckGen s)

typecheckGen :: String -> Either ErrorMessage C.Program
typecheckGen code =
  either
    Left
    (either (\e -> Left $ e code `withPrefix` "Typecheck error at ") Right .
     typecheckGen')
    (weedT code)

-- | Generate new AST from Program
typecheckGen' :: Program -> Glc' C.Program
typecheckGen' p =
  runST $ do
    st <- new
    recurse @Program @C.Program st p

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
    (weedT code)

pTable' :: Program -> (Maybe ErrorMessage', String)
pTable' p =
  sl2str $
  runST $ do
    st <- new -- Create new symbol table with base types
    res <- recurse @Program @C.Program st p -- Traverse, generating symbol table modifications and typechecking (don't care about typecheck errors here)
    syml <- S.getMessages st -- Get inserted symbols
    msgDisabled <- S.getMsgStatus st -- Only take error if messages are disabled, i.e. symbol table error, not typecheck error
    return $
      either
        (\err ->
           if msgDisabled
             then (Just err, syml)
             else (Nothing, syml))
        (const (Nothing, syml))
        res

isBlankIdent :: C.ScopedIdent -> Bool
isBlankIdent (C.ScopedIdent _ (C.Ident vname)) = vname == "_"
