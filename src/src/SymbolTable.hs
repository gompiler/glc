{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeApplications      #-}

module SymbolTable
  ( typecheckP
  , symbol
  , pTable
  , new
  , add
  ) where

import           Control.Monad      (join)
import           Control.Monad.ST
import           Data
import           Data.Either        (partitionEithers)

import           Data.List.Extra    (concatUnzip)
import           Data.List.NonEmpty (NonEmpty (..), fromList, toList)
import           Data.Maybe         (catMaybes)

import qualified CheckedData        as C
import           ErrorBundle
import           Numeric            (readOct)
import           Scanner            (putExit, putSucc)
import           TypeInference
import           Weeding            (weed)
import           Prettify (prettify)

import           Symbol

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
-- isDef :: SymbolTable s -> String -> ST s Bool
-- isDef st k = do
--   res <- S.lookup st k
--   case res of
--     Just _ -> return True
--     Nothing -> do
--       _ <- S.addMessage st Nothing -- Signal error, key should be defined
--       return False
-- Class to generalize traverse function for each AST structure
-- also return the typechecked AST
class Symbolize a b where
  recurse :: SymbolTable s -> a -> ST s (Either ErrorMessage' b)

class Typify a
  -- Resolve AST types to SType, may return error message if type error
  where
  toType :: SymbolTable s -> a -> ST s (Either ErrorMessage' SType)

instance Symbolize Program C.Program where
  recurse st (Program pkg tdl) =
    wrap st $ fmap (C.Program pkg) <$> (recurse st tdl)

instance Symbolize TopDecl C.TopDecl where
  recurse st (TopDecl d)      = fmap C.TopDecl <$> recurse st d
  recurse st (TopFuncDecl fd) = fmap C.TopFuncDecl <$> recurse st fd

instance Symbolize [TopDecl] [C.TopDecl] where
  recurse st vdl = do
    el <- mapM (recurse st) vdl
    return (sequence el)

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
                   (fmap
                      (C.FuncDecl (mkSIdStr scope vname) (func2sig f) .
                       C.BlockStmt) .
                    sequence) <$>
                     mapM (recurse st) sl))
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
      p2pd (s, t') = C.ParameterDecl (mkSIdStr (S.Scope 2) s) (toBase t')
      func2sig :: Symbol -> C.Signature
      func2sig (Func pl mt) =
        C.Signature (C.Parameters (map p2pd pl)) (toBase <$> mt)
      func2sig _ =
        error "Trying to convert a symbol that isn't a function to a signature" -- Should never happen
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
    fmap C.ShortDeclare <$> (checkDecl (toList idl) (toList el) st)
    where
      checkDecl ::
           [Identifier]
        -> [Expr]
        -> SymbolTable s
        -> ST s (Either ErrorMessage' (NonEmpty (SIdent, C.Expr)))
      checkDecl idl' el' st' = do
        eb <- mapM (\(ident, e) -> checkDec ident e st') (zip idl' el')
        -- may want to add offsets to ShortDeclarations and create an error with those here for ShortDec
        return $
          either
            Left
            (\l ->
               let (bl, decl) = unzip l
                in if True `elem` bl
                     then Right (fromList decl)
                     else Left $ createError (head idl') ShortDec)
            (sequence eb)
      checkDec ::
           Identifier
        -> Expr
        -> SymbolTable s
        -> ST s (Either ErrorMessage' (Bool, (SIdent, C.Expr)))
      checkDec ident e st' = do
        et <- infer st' e -- Either ErrorMessage' SType
        either
          (return . Left)
          (\t -> do
             et' <- recurse st' e
             eb <- checkId' ident t st'
             either
               (return . Left)
               (\e' ->
                  return $ either Left (\(b, sid) -> Right (b, (sid, e'))) eb)
               et')
          et
        where
          checkId' ::
               Identifier
            -> SType
            -> SymbolTable s
            -> ST s (Either ErrorMessage' (Bool, SIdent)) -- Bool is to indicate whether the variable was already declared or not and also create scoped ident
      -- Note that short declarations require at least *one* new declaration
          checkId' ident'@(Identifier _ vname) t st2 = do
            val <- S.lookupCurrent st2 vname
            case val of
              Just (scope, Variable t2) ->
                return $
                  if t2 == t
                    then Right (False, mkSIdStr scope vname)
                            -- if locally defined, check if type matches
                    else Left $ createError e (TypeMismatch2 ident' t t2)
              Just _ ->
                return $ Left $ createError ident' (NotVar ident')
              Nothing -> do
                _ <- add st2 vname (Variable Infer) -- Add infer so that we don't print out the actual type
                scope <- S.insert' st2 vname (Variable t) -- Overwrite infer with actual type so we can infer other variables
                return $ Right (True, mkSIdStr scope vname)
  recurse _ EmptyStmt = return $ Right C.EmptyStmt
  recurse st (ExprStmt e) = fmap C.ExprStmt <$> recurse st e -- Verify that expr only uses things that are defined
  recurse st (Increment _ e) = do
    et <- infer st e
    either
      (return . Left)
      (\t ->
         if isNumeric t && isAddr e
           then fmap C.Increment <$> recurse st e
           else return $ Left $ createError e (NonNumeric e "incremented"))
      et
  recurse st (Decrement _ e) = do
    et <- infer st e
    either
      (return . Left)
      (\t ->
         if isNumeric t && isAddr e
           then fmap C.Decrement <$> recurse st e
           else return $ Left $ createError e (NonNumeric e "decremented"))
      et
  recurse st (Assign _ aop@(AssignOp mop) el1 el2) = do
    l1 <- mapM (recurse st) (toList el1)
    l2 <- mapM (recurse st) (toList el2)
    case mop of
      Nothing -> do
        me <- mapM (sameType st) (zip (toList el1) (toList el2))
        maybe
          (either
             (return . Left)
             (\l1' ->
                either
                  (return . Left)
                  (return .
                   Right . C.Assign (C.AssignOp Nothing) . fromList . zip l1')
                  (sequence l2))
             (sequence l1))
          (return . Left)
          (maybeJ me)
      Just op -> do
        el <-
          mapM
            ((infer st) . (aop2e $ Arithm op))
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
                        Right $ C.Assign (aop2aop' aop) (fromList $ zip l1' l2'))
                     (sequence l2))
                (sequence l1)))
          (sequence el)
      -- convert op and 2 expressions to binary op, infer type of this to make sure it makes sense
    where
      aop2e :: BinaryOp -> (Expr, Expr) -> Expr
      aop2e op (e1, e2) = Binary (Offset 0) op e1 e2
      aop2aop' :: AssignOp -> C.AssignOp
      aop2aop' (AssignOp (Just aop')) = C.AssignOp $ Just $ aopConv aop'
      aop2aop' (AssignOp Nothing)     = C.AssignOp Nothing
      -- | Check if two expressions have the same type and if LHS is addressable, helper for assignments
      sameType :: SymbolTable s -> (Expr, Expr) -> ST s (Maybe ErrorMessage')
      sameType st' (e1, e2) = do
        et1 <- infer st' e1
        et2 <- infer st' e2
        return $
          either
            Just
            (\t1 ->
               either
                 Just
                 (\t2 ->
                    if not (t1 == t2)
                      then Just (createError e1 (TypeMismatch1 e1 e2))
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
  recurse st (BlockStmt sl) =
    wrap st $ (fmap C.BlockStmt . sequence) <$> mapM (recurse st) sl
  recurse st (SimpleStmt s) = fmap C.SimpleStmt <$> recurse st s
  recurse st (If (ss, e) s1 s2) =
    wrap st $ do
      et <- infer st e
      either
        (return . Left)
        (\t ->
           if t == PBool
             then do
               ess' <- recurse st ss
               ee' <- recurse st e
               es1' <- recurse st s1
               es2' <- recurse st s2
               return $
                 (\ss' ->
                    join $
                    (\e' ->
                       join $
                       (\s1' -> (\s2' -> C.If (ss', e') s1' s2') <$> es2') <$>
                       es1') <$>
                    ee') =<<
                 ess'
             else return $ Left $ createError e (CondBool e t))
        et
  recurse st (Switch ss me scs) =
    wrap st $ do
      ess' <- recurse st ss
      maybe
        (do escs' <- sequence <$> mapM (recurse' st PBool) scs
            return $
              (\ss' -> (\scs' -> C.Switch ss' Nothing scs') <$> escs') =<< ess')
        (\e -> do
           t <- infer st e
           ee' <- recurse st e
           either
             (return . Left)
             (\t' ->
                if isComparable t'
                  then do
                    escs' <- sequence <$> mapM (recurse' st t') scs
                    return $
                      (\ss' ->
                         join $
                         (\scs' -> (\e' -> C.Switch ss' (Just e') scs') <$> ee') <$>
                         escs') =<<
                      ess'
                  else return $ Left $ createError e (NotCompSw t'))
             t)
        me
    where
      recurse' ::
           SymbolTable s
        -> SType
        -> SwitchCase
        -> ST s (Either ErrorMessage' C.SwitchCase)
      recurse' st' t (Case _ nEl s) = do
        eel <- sequence <$> mapM (isType st' t) (toList nEl)
        es' <- recurse st' s
        return $ (\el -> (\s' -> C.Case (fromList el) s') <$> es') =<< eel
      recurse' st' _ (Default _ s) = fmap C.Default <$> recurse st' s
          -- Also return new expr after check
      isType ::
           SymbolTable s -> SType -> Expr -> ST s (Either ErrorMessage' C.Expr)
      isType st' t e = do
        et <- infer st' e
        either
          (return . Left)
          (\t2 ->
             if t2 == t
               then recurse st' e
               else return $ Left $ createError e (NotComp t2 t))
          et
  recurse st (For (ForClause ss1 me ss2) s) = wrap st $ do
    ess1' <- recurse st ss1
    ess2' <- recurse st ss2
    es' <- recurse st s
    maybe
      (return $
       (\ss1' ->
          join $
          (\ss2' ->
             join $
             (\s' -> Right $ C.For (C.ForClause ss1' Nothing ss2') s') <$> es') <$>
          ess2') =<<
       ess1')
      (\e -> do
         et' <- infer st e
         either
           (return . Left)
           (\t' ->
              if t' == PBool
                then return $
                     (\ss1' ->
                        join $
                        (\ss2' ->
                           join $
                           (\s' ->
                              Right $ C.For (C.ForClause ss1' Nothing ss2') s') <$>
                           es') <$>
                        ess2') =<<
                     ess1'
                else return $ Left $ createError e (CondBool e t'))
           et')
      me
  recurse _ (Break _) = return $ Right C.Break
  recurse _ (Continue _) = return $ Right C.Continue
  recurse st (Declare d) = fmap C.Declare <$> recurse st d
  recurse st (Print el) = (fmap C.Print . sequence) <$> mapM (recBaseE st) el
  recurse st (Println el) =
    (fmap C.Println . sequence) <$> mapM (recBaseE st) el
  recurse st (Return _ (Just e)) = do
    mt <- getRet st
    maybe
      (return $ Left $ createError e VoidRet)
      (\t -> do
         et' <- infer st e
         either
           (return . Left)
           (\t' ->
              if t == t'
                then fmap (C.Return . Just) <$> recurse st e
                else return $ Left $ createError e (RetMismatch t' t))
           et')
      mt
  recurse st (Return o Nothing) = do
    mt <- getRet st
    return $ maybe (Right $ C.Return Nothing) (\t -> Left $ createError o (RetMismatch Void t)) mt
    

-- | recurse wrapper but guarantee that expression is a base type for printing
recBaseE :: SymbolTable s -> Expr -> ST s (Either ErrorMessage' C.Expr)
recBaseE st e = do
  et <- infer st e
  either
    (return . Left)
    (\t ->
       if isBase t
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
  recurse st (VarDecl' neIdl edef) =
    case edef of
      Left ((_, t), el) -> do
        et <- toType st t
        either
          (return . Left)
          (\t' -> do
             me <- checkIds st (Variable t') "Variable " neIdl
             maybe (checkDecl st t' (toList neIdl) el) (return . Left) me)
          et
      Right nel -> do
        me <- checkIds st (Variable Infer) "Variable " neIdl
        maybe (checkDeclI st (toList neIdl) (toList nel)) (return . Left) me
    where
      checkDecl ::
           SymbolTable s
        -> SType
        -> [Identifier]
        -> [Expr]
        -> ST s (Either ErrorMessage' [C.VarDecl'])
      checkDecl st' t2 idl [] = do
        edl <- mapM (checkDec st' t2 Nothing) idl
        return $ sequence edl
      checkDecl st' t2 idl el' = do
        edl <- mapM (\(i, ex) -> checkDec st' t2 (Just ex) i) (zip idl el')
        return $ sequence edl
      checkDec ::
           SymbolTable s
        -> SType
        -> Maybe Expr
        -> Identifier
        -> ST s (Either ErrorMessage' C.VarDecl')
      checkDec st' t2 me ident@(Identifier _ vname) = do
        scope <- S.scopeLevel st'
        maybe
          (return $
           Right $ C.VarDecl' (mkSIdStr scope vname) (toBase t2) Nothing)
          (\e -> do
             et' <- infer st' e
             either
               (return . Left)
               (\t' ->
                  if t2 == t'
                    then (do ee' <- recurse st' e
                             return $
                               either
                                 Left
                                 (Right .
                                  C.VarDecl' (mkSIdStr scope vname) (toBase t2) .
                                  Just)
                                 ee')
                    else return $
                         Left $ createError ident (TypeMismatch2 ident t2 t'))
               et')
          me
      checkDeclI ::
           SymbolTable s
        -> [Identifier]
        -> [Expr]
        -> ST s (Either ErrorMessage' [C.VarDecl'])
      checkDeclI st' idl el' = do
        edl <- mapM (\(i, ex) -> checkDecI st' ex i) (zip idl el')
        return $ sequence edl
      checkDecI ::
           SymbolTable s
        -> Expr
        -> Identifier
        -> ST s (Either ErrorMessage' C.VarDecl')
      checkDecI st' e (Identifier _ vname) = do
        et' <- infer st' e
        either
          (return . Left)
          (\t' -> do
             scope <- S.insert' st' vname (Variable t') -- Update type of variable 
             ee' <- recurse st' e
             return $
               either
                 (Left)
                 (\ce ->
                    Right $
                    C.VarDecl' (mkSIdStr scope vname) (toBase t') (Just ce))
                 ee')
          et'

instance Symbolize [TypeDef'] [C.TypeDef'] where
  recurse st vdl = do
    el <- mapM (recurse st) vdl
    return (sequence el)

instance Symbolize TypeDef' C.TypeDef' where
  recurse st (TypeDef' ident@(Identifier _ vname) (_, t)) = do
    et <- toType st t
    either
      (return . Left)
      (\t' -> do
         me <- checkId st (SType t') "Type " ident
         maybe
           (case t' -- Ignore all types except for structs, as structs will be the only types we will have to define
                  of
              Struct _ -> do
                scope <- S.scopeLevel st
                return $ Right $ C.TypeDef' (mkSIdStr scope vname) (toBase t')
              _ -> return $ Right C.NoDef)
           (return . Left)
           me)
      et

instance Symbolize Expr C.Expr where
  recurse st eu@(Unary _ op e) = do
    et' <- infer st eu -- Use typecheck from type inference
    either
      (return . Left)
      (const $ fmap (\ec -> C.Unary (convOp op) ec) <$> recurse st e)
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
      (const $
       return $
       (\e1' -> (\e2' -> C.Binary (convOp op) e1' e2') <$> ee2') =<< ee1')
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
      (do
          _ <- S.addMessage st Nothing
          return $ Left $ createError ident (NotDecl "Variable " ident))
      (\(scope, _) -> return $ Right $ C.Var (mkSIdStr scope vname)) msi
  recurse st e@(AppendExpr _ e1 e2) = do
    et' <- infer st e
    ee1' <- recurse st e1
    ee2' <- recurse st e2
    either
      (return . Left)
      (const $
       return $ (\e1' -> (\e2' -> C.AppendExpr e1' e2') <$> ee2') =<< ee1')
      et'
  recurse st ec@(LenExpr _ e) = do
    ect' <- infer st ec
    ee' <- recurse st e
    either (return . Left) (const $ return $ (C.LenExpr) <$> ee') ect'
  recurse st ec@(CapExpr _ e) = do
    ect' <- infer st ec
    ee' <- recurse st e
    either (return . Left) (const $ return $ (C.CapExpr) <$> ee') ect'
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
      (const $ return $ (\e1' -> (\e2' -> C.Index e1' e2') <$> ee2') =<< ee1')
      et'
  recurse st ec@(Arguments _ e el) = do
    ect' <- infer st ec
    ee' <- recurse st e
    eel' <- mapM (recurse st) el
    either
      (return . Left)
      (const $
       return $
       (\e' -> (\el' -> C.Arguments e' el') <$> (sequence eel')) =<< ee')
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
  | NotVar Identifier
  | ShortDec
  deriving (Show, Eq)

data TypeCheckError
  = TypeMismatch1 Expr
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
  deriving (Show, Eq)

instance ErrorEntry SymbolError where
  errorMessage c =
    case c of
      AlreadyDecl s (Identifier _ vname) -> s ++ vname ++ " already declared"
      NotDecl s (Identifier _ vname) -> s ++ vname ++ " not declared"
      VoidFunc (Identifier _ vname) -> vname ++ " resolves to a void function"
      NotVar (Identifier _ vname) ->
        vname ++ " is not a var and cannot be short declared"
      ShortDec -> "Short declaration list contains no new variables"

instance ErrorEntry TypeCheckError where
  errorMessage c =
    case c of
      TypeMismatch1 e1 e2 ->
        "Expression " ++
        prettify e1 ++
        " resolves to different type than " ++ prettify e2 ++ " in assignment"
      TypeMismatch2 (Identifier _ vname) t1 t2 ->
        "Expression resolves to type " ++
        show t1 ++ " in assignment to " ++ vname ++ " of type " ++ show t2
      CondBool e t ->
        "Condition " ++
        prettify e ++ " resolves to " ++ show t ++ ", expecting a bool"
      NonNumeric e s -> prettify e ++ " is a non numeric type and cannot be " ++ s
      NotCompSw t ->
        "Switch statement expression resolves to type " ++
        show t ++ " and is not comparable"
      NotComp t1 t2 ->
        "Cannot compare expression of type " ++
        show t1 ++ " with type " ++ show t2 ++ " (type of switch expression)"
      NonBaseP t ->
        "Expression resolves to non base type " ++
        show t ++ " and cannot be printed"
      VoidRet -> "Cannot return expression from void function"
      RetMismatch t1 t2 ->
        "Return expression resolves to type " ++
        show t1 ++ " but function return type is " ++ show t2
      NonLVal e ->
        prettify e ++ " is not an lvalue and cannot be assigned to"

-- | Wrap a result of recurse inside a new scope
wrap ::
     SymbolTable s
  -> ST s (Either ErrorMessage' a)
  -> ST s (Either ErrorMessage' a)
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
    f2fd (s, t) = C.FieldDecl (C.Ident s) (toBase t)
toBase (TypeMap _ t) = toBase t
toBase t = C.Type $ C.Ident $ show t -- The last ones are primitive types

-- | Is the expression addressable, aka an lvalue that we can assign to?
isAddr :: Expr -> Bool
isAddr e = case e of
             Var _ -> True
             Selector _ _ _ -> True
             Index _ _ _ -> True
             _ -> False

-- | Get the return value of function we are currently declaring, aka latest declared function
getRet :: SymbolTable s -> ST s (Maybe SType)
getRet st = do
  l <- S.getMessages st
  return $ getRet' (reverse l) -- Reverse to get latest declared rather than first
  where
    getRet' :: [Maybe SymbolInfo] -> Maybe SType
    getRet' []                         = Nothing
    getRet' (Just (_, Func _ mt, _):_) = mt
    getRet' (_:t)                      = getRet' t

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

-- | Top level function for cli to verify if program passes typecheck
typecheckP :: String -> IO ()
typecheckP s = either putExit (const $ putSucc "OK") (typecheckGen s)

typecheckGen :: String -> Either ErrorMessage C.Program
typecheckGen code =
  either
    Left
    (either (\e -> Left $ e code `withPrefix` "Typecheck error at ") Right .
     typecheckGen')
    (weed code)

-- | Generate new AST from Program
typecheckGen' :: Program -> Either ErrorMessage' C.Program
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
    (weed code)

pTable' :: Program -> (Maybe ErrorMessage', String)
pTable' p =
  sl2str $
  runST $ do
    st <- new
    res <- recurse @Program @C.Program st p
    syml <- S.getMessages st
    return $ either (\err -> (Just err, syml)) (const (Nothing, syml)) res
