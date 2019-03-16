{-# LANGUAGE ExistentialQuantification #-}

module SymbolTable where

import           Control.Applicative (Alternative)

-- import           Control.Monad           (join)
import           Control.Monad.ST
import           Data
import           Data.Either         (partitionEithers)
import           Data.Foldable       (asum)
import qualified TypedData           as T

-- import           Data.Functor.Compose    (Compose (..), getCompose)
-- import qualified Data.HashTable.Class    as H
-- import qualified Data.HashTable.ST.Basic as HT
import           Data.List           (intercalate)
import           Data.List.NonEmpty  (NonEmpty (..), fromList, toList)
import qualified Data.List.NonEmpty  as NE (head, map)
import           Data.Maybe          (catMaybes)

-- import           Data.STRef
import           ErrorBundle
import           Numeric             (readOct)
import           Weeding             (weed)

-- import           Data.STRef
import qualified SymbolTableCore     as S

-- We define new types for symbols and types here
-- we largely base ourselves off types in the AST, however we do not need offsets for the symbol table
type SIdent = T.ScopedIdent

type Param = (String, SType)

type Field = (String, SType)

-- type Var = (SIdent, SType)
data Symbol
  = Base -- Base type, resolve to themselves, i.e. int
  | Constant -- For bools only
  | Func [Param]
         (Maybe SType)
  | Variable SType
  | SType SType -- Declared types
  deriving (Show, Eq)

data SType
  = Array Int
          SType
  | Slice SType
  | Struct [Field] -- List of fields
  | TypeMap SIdent
            SType
  | PInt
  | PFloat64
  | PBool
  | PRune
  | PString
  | Infer -- Infer the type at typechecking, not at symbol table generation
  deriving (Show, Eq)

-- | SymbolTable, cactus stack of SymbolScope
-- specific instantiation for our uses
type SymbolTable s = S.SymbolTable s Symbol (Maybe SymbolInfo)

-- | SymbolInfo: symbol name, corresponding symbol, scope depth
type SymbolInfo = (String, Symbol, S.Scope)

-- | Params with their respective scopes, for check FuncDecl
type ParamInfo = (Param, S.Scope)

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

-- | Insert field to struct table and return success or fail
-- add' :: StructTable s -> String -> Field -> ST s Bool
-- add' st ident fld = do
--   result <- S.lookup st ident -- We only need to check current scope for declarations
--   case result of
--     Just _ -> return False -- If we found a result, don't insert anything
--     Nothing -> do
--       S.insert st ident fld
--       return True
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

class Typify a
  -- Resolve AST types to SType, may return error message if type error
  where
  toType :: SymbolTable s -> a -> ST s (Either ErrorMessage' SType)

instance Symbolize HAST where
  recurse st (H a) = recurse st a

instance Symbolize Program where
  recurse st (Program _ tdl) = am (recurse st) tdl

instance Symbolize TopDecl where
  recurse st (TopDecl d)      = recurse st d
  recurse st (TopFuncDecl fd) = recurse st fd

instance Symbolize FuncDecl
  -- Check if function (ident) is declared in current scope (top scope)
  -- if not, we open new scope to symbolize body and then validate sig before declaring
                                                                                        where
  recurse st (FuncDecl ident@(Identifier _ vname) (Signature (Parameters pdl) t) (BlockStmt sl)) = do
    res <- S.isDef st vname -- Check if defined in symbol table
    if res
      then return $ Just $ createError ident (AlreadyDecl "Function " ident)
      else wrap
             st
             (do epl <- checkParams st pdl -- Either ErrorMessage' [Param]
      -- Either ErrorMessage' Symbol, want to get the corresponding Func symbol using our resolved params (if no errors in param declaration) and the type of the return of the signature, t, which is a Maybe Type'
                 ef <-
                   either
                     (return . Left)
                     (\pl ->
                        maybe
                          (return $ Right $ Func pl Nothing)
                          (\(_, t') -> do
                             et <- toType st t'
                             return $ fmap (Func pl . Just) et)
                          t)
                     epl
      -- We then take the Either ErrorMessage' Symbol, if no error we insert the Symbol (newly declared function) and recurse on statement list sl (from body of func) to declare things in body
                 either
                   (return . Just)
                   (\f -> do
                      _ <- S.insert st vname f
                      am (recurse st) sl)
                   ef)
    where
      checkParams ::
           SymbolTable s
        -> [ParameterDecl]
        -> ST s (Either ErrorMessage' [Param])
      checkParams st2 pdl' = do
        pl <- mapM (checkParam st2) pdl'
        return $ eitherL concat pl
      checkParam ::
           SymbolTable s -> ParameterDecl -> ST s (Either ErrorMessage' [Param])
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
        -> ST s (Maybe ErrorMessage', [Param])
      checkIds' st2 t' idl = pEithers <$> mapM (checkId' st2 t') (toList idl)
      checkId' ::
           SymbolTable s
        -> SType
        -> Identifier
        -> ST s (Either ErrorMessage' Param)
      checkId' st2 t' ident'@(Identifier _ vname') =
        let idv = vname'
         in do success <- add st2 idv (Variable t') -- Should not be declared
               return $
                 if success
                   then Right (vname', t')
                   else Left $ createError ident (AlreadyDecl "Param " ident')
  recurse _ FuncDecl {} =
    error "Function declaration's body is not a block stmt"

-- This will never happen but we do this for exhaustive matching on the FuncBody of a FuncDecl even though it is always a block stmt
-- | checkId over a list of identifiers, keep first error or return nothing
checkIds ::
     SymbolTable s
  -> SType
  -> String
  -> Identifiers
  -> ST s (Maybe ErrorMessage')
checkIds st t pfix idl = maybeJ <$> mapM (checkId st t pfix) (toList idl)

-- | Check that we can declare this identifier
checkId ::
     SymbolTable s
  -> SType
  -> String -- Error prefix for AlreadyDecl, what are we checking? i.e. Param, Var, Type
  -> Identifier
  -> ST s (Maybe ErrorMessage')
checkId st t pfix ident@(Identifier _ vname) =
  let idv = vname
   in do success <- add st idv (Variable t) -- Should not be declared
         return $
           if success
             then Nothing
             else Just $ createError ident (AlreadyDecl pfix ident)

instance Symbolize SimpleStmt where
  recurse st (ShortDeclare idl el) = checkDecl (toList idl) (toList el) st
    where
      checkDecl ::
           [Identifier] -> [Expr] -> SymbolTable s -> ST s (Maybe ErrorMessage')
      checkDecl idl' _ st' = do
        bl <- mapM (isNewDec st') idl'
        -- may want to add offsets to ShortDeclarations and create an error with those here for ShortDec
        return $
          if True `elem` bl
            then Nothing
            else Just $ createError (head idl') ShortDec
      isNewDec :: SymbolTable s -> Identifier -> ST s Bool
      isNewDec st2 (Identifier _ vname) =
        let idv = vname
         in do val <- S.lookupCurrent st2 idv
               case val of
                 Just _  -> return False
                 Nothing -> add st2 idv (Variable Infer)
  recurse _ EmptyStmt = return Nothing
  recurse st (ExprStmt e) = recurse st e -- Verify that expr only uses things that are defined
  recurse st (Increment _ e) = recurse st e
  recurse st (Decrement _ e) = recurse st e
  recurse st (Assign _ _ el _) = am (recurse st) (toList el)

instance Symbolize Stmt where
  recurse st (BlockStmt sl) = wrap st $ am (recurse st) sl
  recurse st (SimpleStmt s) = recurse st s
  recurse st (If (ss, e) s1 s2) =
    wrap st $ am (recurse st) [H ss, H e, H s1, H s2]
  recurse st (Switch ss me scs) =
    wrap st $ do
      r1 <-
        case me of
          Just e  -> am (recurse st) [H ss, H e]
          Nothing -> recurse st ss
      r2 <- am (recurse st) scs
      return $ maybeJ [r1, r2]
  recurse st (For (ForClause ss1 me ss2) s) =
    wrap st $ do
      r1 <-
        am (recurse st) $
        case me of
          Just e  -> [H ss1, H e, H ss2]
          Nothing -> [H ss1, H ss2]
      r2 <- recurse st s
      return $ maybeJ [r1, r2]
  recurse _ (Break _) = return Nothing
  recurse _ (Continue _) = return Nothing
  recurse st (Declare d) = recurse st d
  recurse st (Print el) = am (recurse st) el
  recurse st (Println el) = am (recurse st) el
  recurse st (Return (Just e)) = recurse st e
  recurse _ (Return Nothing) = return Nothing

instance Symbolize Decl where
  recurse st (VarDecl vdl) = am (recurse st) vdl
  recurse st (TypeDef tdl) = am (recurse st) tdl

instance Symbolize VarDecl' where
  recurse st (VarDecl' neIdl edef) =
    case edef of
      Left ((_, t), _) -> do
        et <- toType st t
        either (return . Just) (\t' -> checkIds st t' "Variable " neIdl) et
      Right _ -> checkIds st Infer "Variable " neIdl

instance Symbolize TypeDef' where
  recurse st (TypeDef' ident (_, t)) = do
    et <- toType st t
    either (return . Just) (\t' -> checkId st t' "Type " ident) et

instance Symbolize Expr where
  recurse st (Unary _ _ e) = recurse st e
  recurse st (Binary _ _ e1 e2) = am (recurse st) [e1, e2]
  recurse _ (Lit _) = return Nothing -- No identifiers to check here
  recurse st (Var ident@(Identifier _ vname)) -- Should be defined, otherwise we're trying to use undefined variable
   = do
    res <- S.isDef st vname
    if res
      then return Nothing
      else return $ Just $ createError ident (NotDecl "Variable " ident)
  recurse st (AppendExpr _ e1 e2) = am (recurse st) [e1, e2]
  recurse st (LenExpr _ e) = recurse st e
  recurse st (CapExpr _ e) = recurse st e
  recurse st (Selector _ e _) = recurse st e
  recurse st (Index _ e1 e2) = am (recurse st) [e1, e2]
  recurse st (Arguments _ e el) = am (recurse st) (e : el)

instance Symbolize SwitchCase where
  recurse st (Case _ nEl s) = am (recurse st) $ map H (toList nEl) ++ [H s]
  recurse st (Default _ s)  = recurse st s

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
-- maybeN :: ([b] -> c) -> [Maybe b] -> Maybe c
-- maybeN f ml =
--   if length (catMaybes ml) == length ml -- All values are Just values
--     then Just $ f $ catMaybes ml
--     else Nothing
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
  toType st (Type ident) = resolve ident st
  -- This should never happen, this is here for exhaustive pattern matching
  -- if we want to remove this then we have to change ArrayType to only take in literal ints in the AST
  -- if we expand to support Go later, then we'll change this to support actual expressions
  toType _ (ArrayType _ _) =
    error
      "Trying to convert type of an ArrayType with non literal int as length"

-- | Resolve type of an Identifier
resolve :: Identifier -> SymbolTable s -> ST s (Either ErrorMessage' SType)
resolve ident@(Identifier _ vname) st =
  let idv = vname
   in do res <- S.lookup st idv
         case res of
           Nothing -> return $ Left $ createError ident (NotDecl "Type " ident)
           Just (_, t) ->
             return $
             case resolve' t idv of
               Nothing -> Left $ createError ident (VoidFunc ident)
               Just t' -> Right t'

-- | Resolve symbol to type
resolve' :: Symbol -> String -> Maybe SType
resolve' Base ident' =
  Just $
  case ident' of
    "int"     -> PInt
    "float64" -> PFloat64
    "bool"    -> PBool
    "rune"    -> PRune
    "string"  -> PString
    _         -> error "Nonexistent base type in GoLite" -- This shouldn't happen, don't insert any other base types
resolve' Constant _ = Just PBool -- Constants reserved for bools only
resolve' (Variable t') _ = Just t'
resolve' (SType t') _ = Just t'
resolve' (Func _ mt) _ = mt

data SymbolError
  = AlreadyDecl String
                Identifier
  | NotDecl String
            Identifier
  | VoidFunc Identifier
  | TypeMismatch Identifier
                 SType
                 SType
  | NotLVal Identifier
            Symbol
  | ShortDec
  | BadUnaryOp String
               (NonEmpty SType)
  | BadBinaryOp String
                (NonEmpty SType)
  | AppendMismatch SType
                   SType
  | BadAppend SType
              SType
  | BadLen SType
  | BadCap SType
  | NonStruct SType
  | NoField String
  | BadIndex String
             SType
  | NonIndexable SType
  | NonFunctionCall
  | NonFunctionId String
  | ArgumentMismatch [SType]
                     [SType]
  deriving (Show, Eq)

instance ErrorEntry SymbolError where
  errorMessage c =
    case c of
      AlreadyDecl s (Identifier _ vname) -> s ++ vname ++ " already declared"
      NotDecl s (Identifier _ vname) -> s ++ vname ++ " not declared"
      VoidFunc (Identifier _ vname) -> vname ++ " resolves to a void function"
      TypeMismatch (Identifier _ vname) t1 t2 ->
        "Expression resolves to type " ++
        show t1 ++ " in assignment to " ++ vname ++ " of type " ++ show t2
      NotLVal (Identifier _ vname) s ->
        vname ++ " resolves to " ++ show s ++ " and is not an lvalue"
      ShortDec -> "Short declaration list contains no new variables"
      BadUnaryOp s t ->
        "Unary operator cannot be used on non-" ++
        s ++ " type " ++ show (NE.head t)
      BadBinaryOp s t ->
        "Binary operator cannot be used on non-" ++
        s ++ " types " ++ intercalate ", " (toList $ NE.map show t)
      AppendMismatch t1 t2 ->
        "Cannot append something of type " ++
        show t2 ++ " to slice of type []" ++ show t1
      BadAppend t1 t2 ->
        "Incorrect types " ++ show t1 ++ " and " ++ show t2 ++ " for append"
      BadLen t1 -> "Incorrect type " ++ show t1 ++ " for len"
      BadCap t1 -> "Incorrect type " ++ show t1 ++ " for cap"
      NonStruct t1 -> "Cannot access field on non-struct type " ++ show t1
      NoField f -> "No field " ++ f ++ " on struct"
      BadIndex ts ti -> "Cannot use type " ++ show ti ++ " as index for " ++ ts
      NonIndexable t -> show t ++ " is not indexable"
      NonFunctionCall -> "Cannot call non-function"
      NonFunctionId ident -> show ident ++ "is not a function"
      ArgumentMismatch as1 as2 ->
        "Argument mismatch between " ++ show as1 ++ " and " ++ show as2

-- | Extract top most scope from symbol table
topScope :: ST s (SymbolTable s) -> ST s (S.SymbolScope s Symbol)
topScope st = st >>= topScope'

topScope' :: SymbolTable s -> ST s (S.SymbolScope s Symbol)
topScope' = S.topScope

-- | Wrap a result of recurse inside a new scope
wrap ::
     SymbolTable s -> ST s (Maybe ErrorMessage') -> ST s (Maybe ErrorMessage')
wrap st stres = do
  S.enterScope st
  res <- stres
  S.exitScope st
  return res

-- | Main type inference function
infer :: SymbolTable s -> Expr -> ST s (Either ErrorMessage' SType)
-- Infers the inner type for a unary operator and checks if it matches using the fn
-- infer st ie@(Index _ e1 e2) = undefined
-- infer st ae@(Arguments  _ e el) = undefined
-- | Infers the types of '+' unary operator expressions
infer st e@(Unary _ Pos inner) =
  inferConstraint
    st
    isNumeric
    NE.head
    (BadUnaryOp "numeric")
    e
    (fromList [inner])
-- | Infers the types of '-' unary operator expressions
infer st e@(Unary _ Neg inner) =
  inferConstraint
    st
    isNumeric
    NE.head
    (BadUnaryOp "numeric")
    e
    (fromList [inner])
-- | Infers the types of '!' unary operator expressions
infer st e@(Unary _ Not inner) =
  inferConstraint
    st
    isBoolean
    NE.head
    (BadUnaryOp "boolean")
    e
    (fromList [inner])
-- | Infers the types of '^' unary operator expressions
infer st e@(Unary _ BitComplement inner) =
  inferConstraint
    st
    isInteger
    NE.head
    (BadUnaryOp "integer")
    e
    (fromList [inner])
-- | Infer types of binary expressions
infer st e@(Binary _ op inner1 inner2)
  | op `elem` [Or, And] =
    inferConstraint
      st
      isBoolean
      NE.head
      (BadBinaryOp "boolean")
      e
      (fromList [inner1, inner2])
  -- TODO: FIGURE THIS OUT, SINCE STRUCTS ARE COMPARABLE...
  | op `elem` [Data.EQ, Data.NEQ] = undefined
  --   inferConstraint st isComparable (const "TODO") (\t -> BadBinaryOp "TODO" t) e (fromList [inner1, inner2])
  | op `elem` [Data.LT, Data.LEQ, Data.GT, Data.GEQ] =
    inferConstraint
      st
      isOrdered
      (const PBool)
      (BadBinaryOp "ordered")
      e
      (fromList [inner1, inner2])
  | Arithm aop <- op =
    if aop `elem` [Subtract, Multiply, Divide]
      then inferConstraint
             st
             isNumeric
             (const PInt)
             (BadBinaryOp "numeric")
             e
             (fromList [inner1, inner2])
      else if aop `elem`
              [Remainder, BitOr, BitXor, ShiftL, ShiftR, BitAnd, BitClear]
             then inferConstraint
                    st
                    isInteger
                    (const PInt)
                    (BadBinaryOp "int")
                    e
                    (fromList [inner1, inner2])
             else undefined -- TODO: ADD
  | otherwise = undefined -- TODO: ADD, EQ, NEQ
infer _ (Lit l) =
  return $
  Right $
  case l of
    IntLit {}    -> PInt
    FloatLit {}  -> PFloat64
    RuneLit {}   -> PRune
    StringLit {} -> PString
infer st (Var ident) = resolve ident st
-- | Infer types of append expressions
-- An append expression append(e1, e2) is well-typed if:
-- * e1 is well-typed, has type S and S resolves to a []T;
-- * e2 is well-typed and has type T.
infer st ae@(AppendExpr _ e1 e2) = do
  sle <- infer st e1 -- Infer type of slice (e1)
  exe <- infer st e2 -- Infer type of value to append (e2)
  return $
    case (sle, exe) of
      (Right slt@(Slice t1), Right t2) ->
        if t1 == t2
          then Right slt
          else Left $ createError ae $ AppendMismatch t1 t2
    -- TODO: MORE CASES FOR NICER ERRORS?
      (Right t1, Right t2) -> Left $ createError ae $ BadAppend t1 t2
      (Left em, _) -> Left em
      (_, Left em) -> Left em
-- | Infer types of len expressions
-- A len expression len(expr) is well-typed if expr is well-typed, has
-- type S and S resolves to string, []T or [N]T. The result has type int.
infer st le@(LenExpr _ expr) =
  inferConstraint
    st
    isLenCompatible
    (const PInt)
    (BadLen . NE.head)
    le
    (fromList [expr])
-- | Infer types of cap expressions
-- A cap expression cap(expr) is well-typed if expr is well-typed, has
-- type S and S resolves to []T or [N]T. The result has type int.
infer st ce@(CapExpr _ expr) =
  inferConstraint
    st
    isCapCompatible
    (const PInt)
    (BadCap . NE.head)
    ce
    (fromList [expr])
-- | Infer types of selector expressions
-- Selecting a field in a struct (expr.id) is well-typed if:
-- * expr is well-typed and has type S;
-- * S resolves to a struct type that has a field named id.
infer st se@(Selector _ expr (Identifier _ ident)) = do
  eitherSele <- infer st expr
  return $ eitherSele >>= infer'
  where
    infer' :: SType -> Either ErrorMessage' SType
    infer' (Struct fdl) =
      case filter (\(fid, _) -> fid == ident) fdl of
        _:(_, sft):_ -> Right sft
        _            -> Left $ createError se $ NoField ident
    infer' t = Left $ createError se $ NonStruct t
-- | Infer types of index expressions
-- Indexing into a slice or an array (expr[index]) is well-typed if:
-- * expr is well-typed and resolves to []T or [N]T;
-- * index is well-typed and resolves to int.
-- The result of the indexing expression is T.
infer st ie@(Index _ e1 e2) = do
  e1e <- infer st e1
  e2e <- infer st e2
  return $ do
    t1 <- e1e
    t2 <- e2e
    case (t1, t2) of
      (Slice t, t')   -> indexable t t' "slice"
      (Array _ t, t') -> indexable t t' "array"
      (t, _)          -> Left $ createError ie $ NonIndexable t
     -- | Checks that second type is an int before returning type or error
  where
    indexable :: SType -> SType -> String -> Either ErrorMessage' SType
    indexable t PInt _   = Right t
    indexable t _ errTag = Left $ createError ie $ BadIndex errTag t
-- | Infer types of arguments (function call / typecast) expressions
-- A function call expr(arg1, arg2, ..., argk) is well-typed if:
-- * arg1, arg2, . . . , argk are well-typed and have types T1, T2, . . . , Tk respectively;
-- * expr is well-typed and has function type (T1 * T2 * ... * Tk) -> Tr.
-- The type of a function call is Tr.
infer st ae@(Arguments _ expr args) = do
  as <- mapM (infer st) args -- Moves ST out
  case (expr, sequence as) of
    (Var i@(Identifier _ ident), Right ts) -> do
      fn <- S.lookup st ident
      return $
        case fn of
          Just (_, Func pl rtm) ->
            if map snd pl == ts
              then maybe (Left $ createError ae $ VoidFunc i) Right rtm
              else Left $ createError ae $ ArgumentMismatch ts (map snd pl) -- argument mismatch
          -- Just (_, Base) -> undefined -- TODO: BASE TYPE CAST
          -- Just (_, SType ct) -> undefined -- TODO: DEFINED TYPE CAST
          Just _ -> Left $ createError ae $ NonFunctionId ident -- non-function identifier
          Nothing -> Left $ createError ae $ NotDecl "Function " i -- not declared
    (_, Right _) -> return $ Left $ createError ae NonFunctionCall -- trying to call non-function
    (_, Left err) -> return $ Left err

-- TODO: TYPECAST
inferConstraint ::
     SymbolTable s -- st
  -> (SType -> Bool) -- isCorrect
  -> (NonEmpty SType -> SType) -- resultSType
  -> (NonEmpty SType -> SymbolError) -- makeError
  -> Expr -- parentExpr
  -> NonEmpty Expr -- childs
  -> ST s (Either ErrorMessage' SType)
inferConstraint st isCorrect resultSType makeError parentExpr inners = do
  eitherTs <- sequence <$> mapM (infer st) inners
  return $ do
    ts <- eitherTs
    if all isCorrect ts
      then Right $ resultSType ts
      else Left $ createError parentExpr (makeError ts)

isLenCompatible :: SType -> Bool
isLenCompatible t =
  case t of
    PString  -> True
    Array {} -> True
    Slice {} -> True
    _        -> False

isCapCompatible :: SType -> Bool
isCapCompatible t =
  case t of
    Array {} -> True
    Slice {} -> True
    _        -> False

isNumeric :: SType -> Bool
isNumeric = flip elem [PInt, PFloat64, PRune]

-- isComparable: many many things...
isOrdered :: SType -> Bool
isOrdered = flip elem [PInt, PFloat64, PRune, PString]

isBoolean :: SType -> Bool
isBoolean = (==) PBool

isInteger :: SType -> Bool
isInteger = (==) PInt

-- | Resolves a defined type to a base type
resolveSType :: SType -> SType
resolveSType (Array i st) = Array i (resolveSType st)
resolveSType (Slice st) = Slice (resolveSType st)
resolveSType (Struct fl) =
  Struct $ map (\(ident, st) -> (ident, resolveSType st)) fl
resolveSType (TypeMap _ st) = resolveSType st
resolveSType t = t -- Other types

-- | Get the first duplicate in a list, for checking if fields of a struct are all unique
getFirstDuplicate :: Eq a => [a] -> Maybe a
getFirstDuplicate [] = Nothing
getFirstDuplicate (x:xs) =
  if x `elem` xs
    then Just x
    else getFirstDuplicate xs

-- | Take Symbol table scope and AST identifier to make ScopedIdent
mkSId :: S.Scope -> Identifier -> SIdent
mkSId (S.Scope s) = T.ScopedIdent (T.Scope s)

-- | String that goes through weeding
-- Get either an error message from weeding or success/error message with string of symbol table
-- Note this isn't an either because if the left side checks, we always want the string/partial symbol table even on error so we can print it out
pTable :: String -> Either ErrorMessage (Maybe ErrorMessage, String)
pTable code =
  fmap
    (\p ->
       let (me, syml) = pTable' p
        in ( me >>= (\e -> Just $ e code `withPrefix` "symbol table error at ")
           , syml))
    (weed code)

pTable' :: Program -> (Maybe ErrorMessage', String)
pTable' p =
  runST $ do
    st <- new
    res <- recurse st p
    syml <- S.getMessages st
    return (res, show syml)
