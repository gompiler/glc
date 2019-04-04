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
import qualified CheckedData        as T
import qualified Cyclic             as C
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

tempVar :: Symbol
tempVar = Variable $ C.new Infer

void :: CType
void = C.new Void

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
  _ <- S.insert st "_" tempVar -- Dummy symbol so that we can lookup the blank identifier and just ignore the type
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
        Just _ -> S.disableMessages st $> False -- Found something, aka a conflict, so stop printing symbol table after this
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
    Just _  -> S.disableMessages st $> False -- Signal error, key should not be defined

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
  toType :: SymbolTable s -> Maybe SIdent -> a -> ST s (Glc' CType)
  toType st root t = do
    let root' = maybe (Nothing, t) (\x -> (Just x, t)) root
    stype <- toType' st root' t False -- Do not allow recursive types by default
    return $ C.new <$> stype
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
    -> ST s (Glc' SType)

-- | Returns matching id if current type is a reference,
-- and parent identity matches current type identity
getMatchingSIdent :: Maybe SIdent -> Type -> Maybe SIdent
getMatchingSIdent (Just sident@(T.ScopedIdent _ (T.Ident rootIdent))) (Type (Identifier _ ident)) =
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
    -> ST s (Glc' SType)
  toType' st root (ArrayType (Lit l) t) brec = do
    symEither <- toType' st root t brec
    return $ do
      sym <- symEither
      size <- intTypeToInt l <?> createError (Offset 0) "Invalid index" -- TODO add actual offset
      Right $ Array size sym -- Negative indices are not possible because we only accept int lits, no unary ops, no need to check
  -- In golite, we can use a slice type x while creating type x
  toType' st root@(_, _) (SliceType t) _ = resolveType
      -- Default resolution method
    where
      resolveType :: ST s (Glc' SType)
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
      checkFields :: ST s (Glc' [Field]) -- Check for duplicates first
      checkFields =
        checkDup
          st
          getAllIdents
          (AlreadyDecl "Field ")
          (concat <$$> mapS checkField fdl)
      checkField :: FieldDecl -> ST s (Glc' [Field])
      checkField (FieldDecl idl (_, t)) = toField idl <$$> fieldType' t
      -- | Checks first for cyclic type, then defaults to the generic type resolver
      fieldType' :: Type -> ST s (Glc' SType)
      fieldType' t =
        case (getMatchingSIdent rootSIdent t, isTypeStruct rootType)
                -- Cycles only permitted on matching root sident with a non struct root type
              of
          (Just _, False) -> return $ Right Infer -- TODO verify; getMatchinSIdent can also return bool now
          _               -> toType' st root t brec
      toField :: Identifiers -> SType -> [Field]
      toField idl t = map (\(Identifier _ vname) -> (vname, t)) (toList idl)
      isTypeStruct :: Type -> Bool
      isTypeStruct (StructType _) = True
      isTypeStruct _              = False
  toType' st (rootSIdent, _) t@(Type ident) brec =
    case getMatchingSIdent rootSIdent t of
      Just _ ->
        if brec
          then return $ Right Infer
          else resolveId
      _ -> resolveId
    where
      resolveId :: ST s (Glc' SType)
      resolveId = resolve ident st (createError ident (NotDecl "Type " ident))
  -- This last array case should never happen, this is here for exhaustive pattern matching
  -- if we want to remove this then we have to change ArrayType to only take in literal ints in the AST
  -- if we expand to support Go later, then we'll change this to support actual expressions
  toType' _ _ (ArrayType _ _) _ =
    error
      "Trying to convert type of an ArrayType with non literal int as length"

instance Symbolize Program T.Program where
  recurse st (Program (Identifier _ pkg) tdl)
    -- Recurse on the top level declarations of a program in a new scope
   = S.wrap st $ fmap (T.Program (T.Ident pkg)) <$> recurse st tdl

instance Symbolize TopDecl T.TopDecl
  -- Recurse on declarations
                             where
  recurse st (TopDecl d)      = fmap T.TopDecl <$> recurse st d
  recurse st (TopFuncDecl fd) = fmap T.TopFuncDecl <$> recurse st fd

-- | Helper for a list of top declarations, does the same thing as above except we use mapM and sequence the results (i.e. if we have a Left in any of the results, we'll just use that because we have an error)
instance Symbolize [TopDecl] [T.TopDecl] where
  recurse st vdl = do
    el <- mapM (recurse st) vdl
    return (sequence el)

instance Symbolize FuncDecl T.FuncDecl
  -- Check if function (ident) is declared in current scope (top scope)
  -- if not, we open new scope to symbolize body and then validate sig before declaring
                                                                                        where
  recurse :: forall s. SymbolTable s -> FuncDecl -> ST s (Glc' T.FuncDecl)
  recurse st (FuncDecl ident@(Identifier _ vname) (Signature (Parameters pdl) t) body@(BlockStmt sl)) =
    if vname == "init"
      then addInit
      else addFunc
      -- Get return type of function
    where
      retType :: ST s (Glc' CType)
      retType = maybe (return $ Right void) (toType st Nothing . snd) t
      -- Insert dummy function before checking arguments, in case arguments refer to function name
      dummyFunc :: ST s (Maybe ErrorMessage')
      dummyFunc = do
        rtm <- retType
        either
          (return . Just)
          (\rt -> S.insert st vname (Func [] rt) $> Nothing)
          rtm
      -- Add any function that is not init to symbol table
      addFunc :: ST s (Glc' T.FuncDecl)
      addFunc = do
        notdef <- isNDefL st vname -- Check if defined in symbol table
        if notdef
          then do
            me <- dummyFunc
            maybe
              (do epl <- S.wrap st $ checkParams pdl -- Dummy scope to check params
                -- Glc' Symbol, want to get the corresponding
                -- Func symbol using our resolved params (if no errors in param
                -- declaration) and the type of the return of the signature, t,
                -- which is a Maybe Type'
                  ef <- either (return . Left) createFunc epl
                -- We then take the Glc' Symbol, if no error we
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
          funcSym :: ([Param], CType) -> Symbol
          funcSym (pl, ret) = Func pl ret
          createFunc ::
               [(Param, SymbolInfo)]
            -> ST s (Glc' (([Param], CType), [SymbolInfo]))
          createFunc l
              -- TODO don't use toType here; resolve only type def types
           =
            let (pl, sil) = unzip l
             in (\ret -> ((pl, ret), sil)) <$$> retType
          insertFunc ::
               (([Param], CType), [SymbolInfo]) -> ST s (Glc' T.FuncDecl)
          insertFunc (ftup, sil) =
            let f = funcSym ftup
             in do scope <- S.insert st vname f
                   _ <- S.addMessage st (vname, f, scope)
                   S.wrap'
                     st
                     f
                     (do mapM_ (\(k, sym, _) -> add st k sym) sil
                         recurseSl scope)
            where
              recurseSl :: S.Scope -> ST s (Glc' T.FuncDecl)
              recurseSl scope' =
                fmap
                  (T.FuncDecl (mkSIdStr scope' vname) (func2sig scope' ftup) .
                   T.BlockStmt) .
                sequence <$>
                mapM (recurse st) sl
      -- Adds the init function to message list
      addInit :: ST s (Glc' T.FuncDecl)
      addInit =
        maybe
          (do scope <- S.scopeLevel st -- Should be 1
              _ <- S.addMessage st (vname, Func [] void, scope)
              recurseBody scope)
          (\(_, t') -> do
             et2 <- toType st Nothing t'
             _ <- S.disableMessages st
             return $ (Left . createError ident . InitNVoid) =<< et2)
          t
        where
          recurseBody :: S.Scope -> ST s (Glc' T.FuncDecl)
          recurseBody scope' =
            T.FuncDecl
              (mkSIdStr scope' vname)
              (T.Signature (T.Parameters []) Nothing) <$$>
            recurse st body
      getAllIdents :: [Identifier]
      getAllIdents = concatMap (\(ParameterDecl nidl _) -> toList nidl) pdl
      checkParams :: [ParameterDecl] -> ST s (Glc' [(Param, SymbolInfo)])
      checkParams pdl' =
        checkDup st getAllIdents DuplicateParam $
        concat <$$> mapS checkParam pdl'
      checkParam :: ParameterDecl -> ST s (Glc' [(Param, SymbolInfo)])
      checkParam (ParameterDecl idl (_, t')) = do
        et <- toType st Nothing t' -- Remove ST
        either
          (return . Left)
          (\t2 -> do
             einfo <- checkIds' t2 idl
                                   -- Alternatively we can add messages at the checkId level instead of making the ParamInfo type
             either
               (\e -> S.disableMessages st $> Left e)
               (return . Right)
               einfo)
          et
      checkIds' :: CType -> Identifiers -> ST s (Glc' [(Param, SymbolInfo)])
      checkIds' t' idl = do
        scope <- S.scopeLevel st
        mapS (checkId' scope t') (toList idl)
      checkId' ::
           S.Scope -> CType -> Identifier -> ST s (Glc' (Param, SymbolInfo))
      checkId' scope t' ident'@(Identifier _ idv) = do
        notdef <- isNDefL st idv -- Should not be declared
        if notdef
          then return $ Right ((idv, t'), (idv, Variable t', scope))
          else return $ Left $ createError ident (AlreadyDecl "Param " ident')
      p2pd :: S.Scope -> Param -> T.ParameterDecl
      p2pd scope (s, t') = T.ParameterDecl (mkSIdStr scope s) (toBase t')
      func2sig :: S.Scope -> ([Param], CType) -> T.Signature
      func2sig scope (pl, t') =
        T.Signature
          (T.Parameters (map (p2pd scope) pl))
          (if C.get t' == Void
             then Nothing
             else Just $ toBase t')
  recurse st (FuncDecl idents sig stmt) =
    recurse st (FuncDecl idents sig (BlockStmt [stmt]))

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

instance Symbolize SimpleStmt T.SimpleStmt where
  recurse :: forall s. SymbolTable s -> SimpleStmt -> ST s (Glc' T.SimpleStmt)
  recurse st (ShortDeclare idl el) = do
    ets <- mapM (infer st) el' -- Check that everything on RHS can be inferred, otherwise we may be assigning to something on LHS
    either
      (return . Left)
      (const $ T.ShortDeclare <$$> checkDecl)
      (sequence ets)
    where
      idl' = toList idl
      el' = toList el
      checkDecl :: ST s (Glc' (NonEmpty (SIdent, T.Expr)))
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
               [(Bool, (T.ScopedIdent, T.Expr))]
            -> Either (String -> ErrorMessage) (NonEmpty (T.ScopedIdent, T.Expr))
          check l =
            let (bl, decl) =
                  unzip
                    (filter (\(_, (sident, _)) -> not (isBlankIdent sident)) l)
             in if True `elem` bl
                  then Right (fromList decl)
                  else Left $ createError (head idl') ShortDec
      checkDec :: Identifier -> Expr -> ST s (Glc' (Bool, (SIdent, T.Expr)))
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
            -> T.Expr
            -> ST s (Glc' (Bool, (SIdent, T.Expr)))
          attachExpr eb e' = return $ (\(b, sid) -> (b, (sid, e'))) <$> eb
          checkId' ::
               Identifier
            -> CType
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
                _ <- add st vname tempVar -- Add infer so that we don't print out the actual type
                scope <- S.insert st vname (Variable t) -- Overwrite infer with actual type so we can infer other variables
                return $ Right (True, mkSIdStr scope vname)
  recurse _ EmptyStmt = return $ Right T.EmptyStmt
  recurse st (ExprStmt e@(Arguments _ (Var (Identifier _ vname)) _)) = do
    res <- S.lookup st vname
    case res of
      Just (_, Func _ _) ->
        T.ExprStmt <$$> recurse st e -- Verify that expr only uses things that are defined
      _ -> return $ Left $ createError e ESNotFunc
  recurse st (ExprStmt e) = T.ExprStmt <$$> recurse st e -- If the above case isn't matched, then we pass to here which will fail because func call isn't on an identifier
  recurse st (Increment _ e) = do
    et <- infer st e
    eaddr <- isAddr st e
    ee <- recurse st e
    return $ join $ createInc <$> et <*> eaddr <*> ee
    where
      createInc :: CType -> Bool -> T.Expr -> Glc' T.SimpleStmt
      createInc t' addressible e' =
        if isNumeric t' && addressible
          then Right $ T.Increment e'
          else Left $ createError e (NonNumeric e "incremented")
  recurse st (Decrement _ e) = do
    et <- infer st e
    eaddr <- isAddr st e
    ee <- recurse st e
    return $ join $ createDec <$> et <*> eaddr <*> ee
    where
      createDec :: CType -> Bool -> T.Expr -> Glc' T.SimpleStmt
      createDec t' addressible e' =
        if isNumeric t' && addressible
          then Right $ T.Decrement e'
          else Left $ createError e (NonNumeric e "decremented")
  recurse st (Assign _ aop@(AssignOp mop) el1 el2) = do
    ets <- mapM (infer st) (toList el2) -- Check that everything on RHS can be inferred, otherwise we may be assigning to something on LHS
    me <- mapM (isAddrE st) (toList el1) -- Make sure everything is an lvalue
    either
      (return . Left)
      (const $
       maybe
         (do l1 <- mapM (recurse st) (toList el1)
             l2 <- mapM (recurse st) (toList el2)
             case mop of
               Nothing -> do
                 ee <- mapM sameType (zip (toList el1) (toList el2))
                 either
                   (return . Left)
                   (const $
                    either
                      (return . Left)
                      (\l1' ->
                         either
                           (return . Left)
                           (return .
                            Right .
                            T.Assign (T.AssignOp Nothing) . fromList . zip l1')
                           (sequence l2))
                      (sequence l1))
                   (sequence ee)
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
                                 T.Assign
                                   (aop2aop' aop)
                                   (fromList $ zip l1' l2'))
                              (sequence l2))
                         (sequence l1)))
                   (sequence el))
         (return . Left . head)
         (sequence me))
      (sequence ets)
      -- convert op and 2 expressions to binary op, infer type of this to make sure it makes sense
    where
      aop2e :: BinaryOp -> (Expr, Expr) -> Expr
      aop2e op (e1, e2) = Binary (offset e1) op e1 e2
      aop2aop' :: AssignOp -> T.AssignOp
      aop2aop' (AssignOp (Just aop')) = T.AssignOp $ Just $ aopConv aop'
      aop2aop' (AssignOp Nothing)     = T.AssignOp Nothing
      -- | Check if two expressions have the same type and if LHS is addressable, helper for assignments
      sameType :: (Expr, Expr) -> ST s (Glc' ())
      sameType (Var (Identifier _ "_"), _) = return $ Right () -- Do not compare if LHS is "_"
      sameType (e1, e2) = do
        et1 <- infer st e1
        et2 <- infer st e2
        eaddr <- isAddr st e1
        return $ join $ comp <$> et1 <*> et2 <*> eaddr
        where
          comp :: CType -> CType -> Bool -> Glc' ()
          comp t1 t2 addr
            | t1 /= t2 = Left $ createError e1 (TypeMismatch1 t1 t2 e2)
            | addr = Right ()
            | otherwise = Left $ createError e1 (NonLVal e1)

-- | Convert ArithmOp from original AST to new AST
aopConv :: ArithmOp -> T.ArithmOp
aopConv op =
  case op of
    Add       -> T.Add
    Subtract  -> T.Subtract
    BitOr     -> T.BitOr
    BitXor    -> T.BitXor
    Multiply  -> T.Multiply
    Divide    -> T.Divide
    Remainder -> T.Remainder
    ShiftL    -> T.ShiftL
    ShiftR    -> T.ShiftR
    BitAnd    -> T.BitAnd
    BitClear  -> T.BitClear

instance Symbolize Stmt T.Stmt where
  recurse :: forall s. SymbolTable s -> Stmt -> ST s (Glc' T.Stmt)
  recurse st (BlockStmt sl) = S.wrap st $ T.BlockStmt <$$> mapS (recurse st) sl
  recurse st (SimpleStmt s) = T.SimpleStmt <$$> recurse st s
  recurse st (If (ss, e) s1 s2) =
    S.wrap st $ do
      ess' <- recurse st ss
      et <- infer st e
      either
        (return . Left)
        (\t ->
           if C.get (resolveCType t) == PBool
             then do
               ee' <- recurse st e
               es1' <- recurse st s1
               es2' <- recurse st s2
               return $
                 (\ss' ->
                    (\e' -> (\s1' -> T.If (ss', e') s1' <$> es2') =<< es1') =<<
                    ee') =<<
                 ess'
             else return $ Left $ createError e (CondBool e t))
        et
  recurse st (Switch ss me scs) =
    S.wrap st $ do
      ess' <- recurse st ss
      maybe
        (do escs' <- mapS (recurse' $ C.new PBool) scs
            return $ (\ss' -> T.Switch ss' Nothing <$> escs') =<< ess')
        (\e -> do
           t <- infer st e
           ee' <- recurse st e
           either
             (return . Left)
             (\t' ->
                if isComparable t'
                  then do
                    escs' <- mapS (recurse' t') scs
                    return $
                      (\ss' ->
                         (\scs' -> (\e' -> T.Switch ss' (Just e') scs') <$> ee') =<<
                         escs') =<<
                      ess'
                  else return $ Left $ createError e (NotCompSw t'))
             t)
        me
    where
      recurse' :: CType -> SwitchCase -> ST s (Glc' T.SwitchCase)
      recurse' t (Case _ nEl s) = do
        eel <- mapS (isType t) (toList nEl)
        es' <- recurse st s
        return $ (\el -> T.Case (fromList el) <$> es') =<< eel
      recurse' _ (Default _ s) = T.Default <$$> recurse st s
          -- Also return new expr after check
      isType :: CType -> Expr -> ST s (Glc' T.Expr)
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
    S.wrap st $ do
      ess1' <- recurse st ss1
      ess2' <- recurse st ss2
      es' <- recurse st s
      maybe
        (return $
         (\ss1' ->
            (\ss2' -> (Right . T.For (T.ForClause ss1' Nothing ss2')) =<< es') =<<
            ess2') =<<
         ess1')
        (\e -> do
           et' <- infer st e
           either
             (return . Left)
             (\t' ->
                if C.get (resolveCType t') == PBool
                  then return $
                       (\ss1' ->
                          (\ss2' ->
                             (Right . T.For (T.ForClause ss1' Nothing ss2')) =<<
                             es') =<<
                          ess2') =<<
                       ess1'
                  else return $ Left $ createError e (CondBool e t'))
             et')
        me
  recurse _ (Break _) = return $ Right T.Break
  recurse _ (Continue _) = return $ Right T.Continue
  recurse st (Declare d) = T.Declare <$$> recurse st d
  recurse st (Print el) = T.Print <$$> mapS (recBaseE st) el
  recurse st (Println el) = T.Println <$$> mapS (recBaseE st) el
  recurse st (Return o (Just e)) = do
    et <- getRet o st
    et' <- infer st e
    ee' <- recurse st e
    return $
      join $
      (\retType t' e' ->
         if C.get retType == Void
           then Left $ createError e VoidRet
           else if retType == t'
                  then Right (T.Return $ Just e')
                  else Left $ createError e (RetMismatch t' retType)) <$>
      et <*>
      et' <*>
      ee'
  recurse st (Return o Nothing) = do
    et <- getRet o st
    return $
      (\retType ->
         if C.get retType == Void
           then Right $ T.Return Nothing
           else Left $ createError o $ RetMismatch void retType) =<<
      et

-- | recurse wrapper but guarantee that expression is a base type for printing
recBaseE :: SymbolTable s -> Expr -> ST s (Glc' T.Expr)
recBaseE st e = do
  et <- infer st e
  either
    (return . Left)
    (\t ->
       if isPrim t
         then recurse st e
         else return $ Left $ createError e (NonBaseP t))
    et

instance Symbolize Decl T.Decl where
  recurse st (VarDecl vdl) = T.VarDecl <$$> recurse st vdl
  recurse st (TypeDef tdl) = T.TypeDef <$$> recurse st tdl

instance Symbolize [VarDecl'] [T.VarDecl'] where
  recurse st vdl = concat <$$> mapS (recurse st) vdl

instance Symbolize VarDecl' [T.VarDecl'] where
  recurse :: forall s. SymbolTable s -> VarDecl' -> ST s (Glc' [T.VarDecl'])
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
        me <- checkIds st tempVar "Variable " neIdl
        either
          (return . Left)
          (const $
           maybe (checkDeclI (toList neIdl) (toList nel)) (return . Left) me)
          (sequence ets)
    where
      checkDecl :: CType -> [Identifier] -> [Expr] -> ST s (Glc' [T.VarDecl'])
      checkDecl t2 idl [] = do
        edl <- mapM (checkDec t2 Nothing) idl
        return $ sequence edl
      checkDecl t2 idl el' = do
        edl <- mapM (\(i, ex) -> checkDec t2 (Just ex) i) (zip idl el')
        return $ sequence edl
      checkDec :: CType -> Maybe Expr -> Identifier -> ST s (Glc' T.VarDecl')
      checkDec t2 me ident@(Identifier _ vname) = do
        scope <- S.scopeLevel st
        maybe
          (return $
           Right $ T.VarDecl' (mkSIdStr scope vname) (toBase t2) Nothing)
          (\e -> do
             et' <- infer st e
             either
               (return . Left)
               (\t' ->
                  if t2 == t'
                    then (do ee' <- recurse st e
                             return $
                               T.VarDecl' (mkSIdStr scope vname) (toBase t2) .
                               Just <$>
                               ee')
                    else return $
                         Left $ createError e (TypeMismatch2 ident t' t2))
               et')
          me
      checkDeclI :: [Identifier] -> [Expr] -> ST s (Glc' [T.VarDecl'])
      checkDeclI idl el' = do
        edl <- mapM (\(i, ex) -> checkDecI ex i) (zip idl el')
        return $ sequence edl
      checkDecI :: Expr -> Identifier -> ST s (Glc' T.VarDecl')
      checkDecI e (Identifier _ vname) = do
        et' <- infer st e
        either
          (return . Left)
          (\t' -> do
             scope <- S.insert st vname (Variable t') -- Update type of variable
             ee' <- recurse st e
             return $
               fmap (T.VarDecl' (mkSIdStr scope vname) (toBase t') . Just) ee')
          et'

instance Symbolize [TypeDef'] [T.TypeDef'] where
  recurse st vdl = do
    el <- mapM (recurse st) vdl
    return (sequence el)

instance Symbolize TypeDef' T.TypeDef' where
  recurse st (TypeDef' ident@(Identifier _ vname) (_, t)) = do
    scope <- S.scopeLevel st
    let sident = mkSIdStr scope vname
    et <- toType st (Just sident) t
    either
      (return . Left)
      (\t' -> do
         me <- checkId st (SType t') "Type " ident
         maybe
           (case C.get t' -- Ignore all types except for structs, as structs will be the only types we will have to define
                  of
              Struct _ -> return $ Right $ T.TypeDef' sident (toBase t')
              _        -> return $ Right T.NoDef)
           (return . Left)
           me)
      et

instance Symbolize Expr T.Expr where
  recurse st eu@(Unary _ op e) = do
    et' <- infer st eu -- Use typecheck from type inference
    either
      (return . Left)
      (\t -> T.Unary (toBase t) (convOp op) <$$> recurse st e)
      et'
    where
      convOp :: UnaryOp -> T.UnaryOp
      convOp op' =
        case op' of
          Pos           -> T.Pos
          Neg           -> T.Neg
          Not           -> T.Not
          BitComplement -> T.BitComplement
  recurse st e@(Binary _ op e1 e2) = do
    et' <- infer st e
    ee1' <- recurse st e1
    ee2' <- recurse st e2
    return $ T.Binary <$> (toBase <$> et') <*-> convOp op <*> ee1' <*> ee2'
    where
      convOp :: BinaryOp -> T.BinaryOp
      convOp op' =
        case op' of
          Or         -> T.Or
          And        -> T.And
          Arithm aop -> T.Arithm $ aopConv aop
          Data.EQ    -> T.EQ
          NEQ        -> T.EQ
          Data.LT    -> T.LT
          LEQ        -> T.LEQ
          Data.GT    -> T.GT
          GEQ        -> T.GEQ
  recurse _ (Lit lit) =
    return $
    case lit of
      IntLit {} -> do
        int <- intTypeToInt lit <?> createError (Offset 0) "Invalid index" -- TODO add actual offset
        Right $ T.Lit $ T.IntLit int
      FloatLit _ fs ->
        Right $
        T.Lit $
        T.FloatLit $
        read $
        case break (== '.') fs -- Separate by String by . and check if any side is empty
              of
          (_, ['.'])  -> fs ++ "0" -- Append 0 because 1. is not a valid Float in Haskell
          ([], '.':_) -> '0' : fs -- Prepend 0 because .1 is not a valid Float
          (_, _)      -> fs
      RuneLit _ cs ->
        Right $
        T.Lit $
        T.RuneLit $
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
      StringLit _ _ s -> Right $ T.Lit $ T.StringLit s -- TODO: Resolve separate types of strings
  recurse st (Var ident@(Identifier o vname)) -- Should be defined, otherwise we're trying to use undefined variable
   = do
    msi <- S.lookup st vname
    maybe
      (S.disableMessages st $>
       (Left $ createError ident (NotDecl "Variable " ident)))
      (return . toVal)
      msi
    where
      toVal :: (S.Scope, Symbol) -> Glc' T.Expr
      toVal (scope, sym) =
        case sym of
          ConstantBool ->
            case vname of
              "true"  -> Right $ T.Lit $ T.BoolLit True
              "false" -> Right $ T.Lit $ T.BoolLit False
              _       -> Left $ createError o InvalidCBool
          Variable stype -> Right $ T.Var (toBase stype) (mkSIdStr scope vname)
          _ -> Left $ createError o NotAVar
  recurse st e@(AppendExpr _ e1 e2) = do
    et' <- infer st e
    ee1' <- recurse st e1
    ee2' <- recurse st e2
    either
      (return . Left)
      (\t -> return $ (\e1' -> T.AppendExpr (toBase t) e1' <$> ee2') =<< ee1')
      et'
  recurse st ec@(LenExpr _ e) = do
    ect' <- infer st ec
    ee' <- recurse st e
    either (return . Left) (const $ return $ T.LenExpr <$> ee') ect'
  recurse st ec@(CapExpr _ e) = do
    ect' <- infer st ec
    ee' <- recurse st e
    either (return . Left) (const $ return $ T.CapExpr <$> ee') ect'
  recurse st ec@(Selector _ e (Identifier _ vname)) = do
    ect' <- infer st ec
    ee' <- recurse st e
    either
      (return . Left)
      (\t -> return $ (\e' -> T.Selector (toBase t) e' (T.Ident vname)) <$> ee')
      ect'
  recurse st e@(Index _ e1 e2) = do
    et' <- infer st e
    ee1' <- recurse st e1
    ee2' <- recurse st e2
    either
      (return . Left)
      (\t -> return $ (\e1' -> T.Index (toBase t) e1' <$> ee2') =<< ee1')
      et'
  recurse st ec@(Arguments _ (Var (Identifier _ vname)) el) = do
    ect' <- infer' st ec -- This is infer' because it is allowed to be a Void call
    eel' <- mapM (recurse st) el
    return $
      (\el' t' -> T.Arguments (toBase t') (T.Ident vname) el') <$> sequence eel' <*>
      ect'
  recurse _ (Arguments _ e _) = return $ Left $ createError e ESNotIdent

intTypeToInt :: Literal -> Maybe Int
intTypeToInt (IntLit _ t s) =
  case t of
    Decimal     -> Just $ read s
    Hexadecimal -> Just $ read s
    Octal       -> Just $ fst $ head $ readOct s
intTypeToInt _ = Nothing

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
  | InitNVoid CType
  | InitParams
  deriving (Show, Eq)

data TypeCheckError
  = TypeMismatch1 CType
                  CType
                  Expr
  | TypeMismatch2 Identifier
                  CType
                  CType
  | CondBool Expr
             CType
  | NonNumeric Expr
               String
  | NotCompSw CType
  | NotComp CType
            CType
  | NonBaseP CType
  | VoidRet
  | RetMismatch CType
                CType
  | NonLVal Expr
  | RetOut -- Return outside of function, should never happen
  | NotFunc -- Trying to get the return value of a symbol that isn't a function, shouldn't happen
  | ESNotFunc -- ExprStmt isn't a function
  | ESNotIdent
  | InvalidCBool
  | NotAVar
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
      ESNotFunc -> "Expression statement must be a function call"
      ESNotIdent ->
        "Expression statement expression is not a variable/function name"
      InvalidCBool -> "Invalid constant bool value"
      NotAVar -> "Cannot get type of non-const/var identifier"

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
toBase :: CType -> T.CType
toBase = C.mapContainer toBase'
  where
    toBase' :: SType -> T.Type
    toBase' (Array i t) = T.ArrayType i (toBase' t)
    toBase' (Slice t) = T.SliceType (toBase' t)
    toBase' (Struct fls) = T.StructType (map f2fd fls)
      where
        f2fd :: Field -> T.FieldDecl
        f2fd (s, t) = T.FieldDecl (T.Ident s) (toBase' t)
    toBase' (TypeMap _ t) = T.TypeMap $ toBase t
    toBase' PInt = T.PInt
    toBase' PFloat64 = T.PFloat64
    toBase' PBool = T.PBool
    toBase' PRune = T.PRune
    toBase' PString = T.PString
    -- TODO remove error
    toBase' Void = error "Void cannot be converted to CheckedData base type"
    toBase' Infer = T.Cycle

-- | Is the expression addressable, aka an lvalue that we can assign to?
isAddr :: SymbolTable s -> Expr -> ST s (Glc' Bool)
isAddr st e =
  case e of
    Var ident@(Identifier _ vname) -> do
      res <- S.lookup st vname
      case res of
        Nothing -> return $ Left $ createError ident (NotDecl "Variable " ident)
        Just (_, ConstantBool) -> return $ Right False
        Just _ -> return $ Right True
    Selector _ e' _ -> isAddr st e' -- Check if expr on LHS is addressable, e.g. function return is not addressable
    Index _ e' _
      -- Indices are only addressable if the underlying expression is
      -- addressable (is var) or if the expression is a slice, any
      -- slice can be assigned to but arrays returned by functions
      -- (without being assigned to a variable), cannot
     -> do
      et' <- infer st e'
      eaddr <- isAddr st e'
      return $
        (\t addr ->
           case C.get t of
             Slice _ -> True
             _       -> addr) <$>
        et' <*>
        eaddr
    _ -> return $ Right False

-- | Check if given expression is addressable, if not, return error message
isAddrE :: SymbolTable s -> Expr -> ST s (Maybe ErrorMessage')
isAddrE st e = do
  eaddr <- isAddr st e
  return $
    either
      Just
      (\addressable ->
         if addressable
           then Nothing
           else Just $ createError e (NonLVal e))
      eaddr

-- | Get the return value of function we are currently declaring, aka latest declared function
getRet :: Offset -> SymbolTable s -> ST s (Glc' CType)
getRet o st = do
  fm <- S.getCtx st
  -- This error should never happen as our parser doesn't allow a return statement outside of a function body
  return $ maybe (Left $ createError o RetOut) getRet' fm
  where
    getRet' :: Symbol -> Glc' CType
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

typecheckGen :: String -> Glc T.Program
typecheckGen code =
  either
    Left
    (either (\e -> Left $ e code `withPrefix` "Typecheck error at ") Right .
     typecheckGen')
    (weedT code)

-- | Generate new AST from Program
typecheckGen' :: Program -> Glc' T.Program
typecheckGen' p =
  runST $ do
    st <- new
    recurse @Program @T.Program st p

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
pTable :: String -> Glc (Maybe ErrorMessage, String)
pTable code =
  (\p ->
     let (me, syml) = pTable' p
      in ( me >>= (\e -> Just $ e code `withPrefix` "Symbol table error at ")
         , syml)) <$>
  weedT code

pTable' :: Program -> (Maybe ErrorMessage', String)
pTable' p =
  sl2str $
  runST $ do
    st <- new -- Create new symbol table with base types
    res <- recurse @Program @T.Program st p -- Traverse, generating symbol table modifications and typechecking (don't care about typecheck errors here)
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

isBlankIdent :: T.ScopedIdent -> Bool
isBlankIdent (T.ScopedIdent _ (T.Ident vname)) = vname == "_"
