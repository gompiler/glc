module TypeInference
  ( ExpressionTypeError
  , infer
  , isNumeric
  , isComparable
  , isBase
  ) where

import qualified CheckedData        as T (Ident (..), Scope (..),
                                          ScopedIdent (..))
import           Control.Monad.ST
import           Data
import           Data.List          (intercalate)
import           Data.List.NonEmpty (NonEmpty (..), fromList, toList)
import qualified Data.List.NonEmpty as NE (head, map, nub)
import           ErrorBundle
import           Symbol             (SType (..), Symbol (..), SymbolTable,
                                     resolve)
import qualified SymbolTableCore    as S

data ExpressionTypeError
  = BadUnaryOp String
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
  | CompareMismatch SType
                    SType
  | IncompatibleCast SType
                     SType
  | CastArguments Int
  | ExprNotDecl String
                Identifier
  | ExprVoidFunc Identifier
  | NotVar Identifier
  | ExpectBaseType SType
  deriving (Show, Eq)

instance ErrorEntry ExpressionTypeError where
  errorMessage c =
    case c of
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
      CompareMismatch t1 t2 ->
        "Cannot compare different types " ++ show t1 ++ " and " ++ show t2
      IncompatibleCast t1 t2 ->
        "Cannot cast type " ++ show t2 ++ " to incompatible type " ++ show t1
      CastArguments l -> "Too many arguments for cast (" ++ show l ++ ")"
      ExprNotDecl s (Identifier _ vname) -> s ++ vname ++ " not declared"
      ExprVoidFunc (Identifier _ vname) ->
        "Void function " ++ vname ++ " cannot be used in expression"
      NotVar (Identifier _ vname) ->
        "Non-variable identifier " ++ vname ++ " cannot be used in this context"
      ExpectBaseType styp ->
        "Cast expects base type; non-base type " ++ show styp ++ " provided"

-- | Main type inference function
infer :: SymbolTable s -> Expr -> ST s (Either ErrorMessage' SType)
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
    (const PBool)
    (BadUnaryOp "boolean")
    e
    (fromList [inner])
-- | Infers the types of '^' unary operator expressions
infer st e@(Unary _ BitComplement inner) =
  inferConstraint
    st
    isIntegerLike
    NE.head
    (BadUnaryOp "integer-like")
    e
    (fromList [inner])
-- | Infer types of binary expressions
infer st e@(Binary _ op i1 i2) =
  (case op of
     And             -> andOrConstraint
     Or              -> andOrConstraint
     Data.EQ         -> comparableConstraint
     Data.NEQ        -> comparableConstraint
     Data.LT         -> orderConstraint
     Data.LEQ        -> orderConstraint
     Data.GEQ        -> orderConstraint
     Data.GT         -> orderConstraint
     Arithm Add      -> addConstraint
     Arithm Subtract -> arithConstraint
     Arithm Multiply -> arithConstraint
     Arithm Divide   -> arithConstraint
     _               -> arithIntConstraint -- other arithmetic operators
   )
    e
    innerList
  where
    innerList :: NonEmpty Expr
    innerList = fromList [i1, i2]
    andOrConstraint =
      inferConstraint st isBoolean (const PBool) (BadBinaryOp "boolean")
    comparableConstraint _ _ -- Special ugly case
     = do
      ei1 <- infer st i1
      ei2 <- infer st i2
      return $ do
        t1 <- ei1
        t2 <- ei2
        if t1 == t2 && isComparable t1
          then Right PBool
          else Left $ createError e $ CompareMismatch t1 t2
    orderConstraint =
      inferConstraint st isOrdered (const PBool) (BadBinaryOp "ordered")
    addConstraint =
      inferConstraint
        st
        isAddable
        NE.head
        (\ts ->
           BadBinaryOp
             (case NE.head ts of
                PString -> "string"
                _       -> "numeric")
             ts)
    arithConstraint =
      inferConstraint st isNumeric NE.head (BadBinaryOp "numeric")
    arithIntConstraint =
      inferConstraint st isIntegerLike NE.head (BadBinaryOp "integer-like")
-- | "Infer" the types of base literals
infer _ (Lit l) =
  return $
  Right $
  case l of
    IntLit {}    -> PInt
    FloatLit {}  -> PFloat64
    RuneLit {}   -> PRune
    StringLit {} -> PString
-- | Resolve variables to the type their identifier points to in the scope
infer st (Var ident@(Identifier _ vname)) = resolveVar st
  where
    resolveVar :: SymbolTable s -> ST s (Either ErrorMessage' SType)
    resolveVar st' = do
      res <- S.lookup st' vname
      case res of
        Nothing -> do
          _ <- S.addMessage st' Nothing -- Signal error to symbol table checker
          return $ Left $ createError ident (ExprNotDecl "Identifier " ident)
        Just (_, sym) -> return $
          case sym of
            Variable t' -> Right t'
            Constant    -> Right PBool -- Constants can only be booleans
            _           -> Left $ createError ident (NotVar ident)
-- | Infer types of append expressions
-- An append expression append(e1, e2) is well-typed if:
-- * e1 is well-typed, has type S and S resolves to a []T;
-- * e2 is well-typed and has type T.
infer st ae@(AppendExpr _ e1 e2) = do
  sle <- infer st e1 -- Infer type of slice (e1)
  exe <- infer st e2 -- Infer type of value to append (e2)
  return $
    case (sle, exe) of
    -- TODO: MORE CASES FOR NICER ERRORS?
      (Right st1, Right t2) ->
        case rpartSType st1 of
          Slice t1 ->
            if t1 == t2
              then Right st1
              else Left $ createError ae $ AppendMismatch t1 t2
          _ -> Left $ createError ae $ BadAppend st1 t2
        -- Left $ createError ae $ BadAppend t1 t2
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
  return $ eitherSele >>= (infer' . rpartSType)
  -- TODO: Look into resolveSType / alternates for this
  where
    infer' :: SType -> Either ErrorMessage' SType
    infer' (Struct fdl) =
      case filter (\(fid, _) -> fid == ident) fdl of
        [(_, sft)] -> Right sft
        _          -> Left $ createError se $ NoField ident
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
    case rpartSType t1 of
      Slice t   -> indexable t t2 "slice"
      Array _ t -> indexable t t2 "array"
      t         -> Left $ createError ie $ NonIndexable t
     -- | Checks that second type is an int before returning type or error
  where
    indexable :: SType -> SType -> String -> Either ErrorMessage' SType
    indexable t t' errTag =
      case rpartSType t' of
        PInt -> Right t
        _    -> Left $ createError ie $ BadIndex errTag t'
-- | Infer types of arguments (function call / typecast) expressions
-- A function call expr(arg1, arg2, ..., argk) is well-typed if:
-- * arg1, arg2, . . . , argk are well-typed and have types T1, T2, . . . , Tk respectively;
-- * expr is well-typed and has function type (T1 * T2 * ... * Tk) -> Tr.
-- The type of a function call is Tr.
infer st ae@(Arguments _ expr args) = do
  as <- mapM (infer st) args -- Moves ST out
  case (expr, sequence as) of
    (Var ident@(Identifier _ vname), Right ts) -> do
      fl <- S.lookup st vname
      -- Only used for base types, since it goes all the way
      fn <-
        resolve
          ident
          st
          (createError ident (ExprNotDecl "Type " ident))
      return $
        case fl of
          Just (_, Func pl rtm) ->
            if map snd pl == ts
              then maybe (Right Void) Right rtm
              else Left $ createError ae $ ArgumentMismatch ts (map snd pl) -- argument mismatch
          Just (_, Base) -> do
            ft <- fn
            case ts of
              [ct] -> tryCast ft ct
              _    -> Left $ createError ae $ CastArguments (length ts)
          Just (S.Scope scp, SType ft) ->
            case ts of
              [ct] ->
                tryCast
                  (TypeMap (T.ScopedIdent (T.Scope scp) (T.Ident vname)) ft)
                  ct -- Left $ createError ae $ ExprNotDecl (show ft) ident
              _    -> Left $ createError ae $ CastArguments (length ts)
          Just _ -> Left $ createError ae $ NonFunctionId vname -- non-function identifier
          Nothing -> Left $ createError ae $ ExprNotDecl "Function " ident -- not declared
    (_, Right _) -> return $ Left $ createError ae NonFunctionCall -- trying to call non-function
    (_, Left err) -> return $ Left err
  where
    tryCast :: SType -> SType -> Either ErrorMessage' SType
    tryCast ft ct =
      case (isBase rct, isBase rft) of
        (True, True) ->
          if rct == rft ||
            (isNumeric rct && isNumeric rft) ||
            (rft == PString && isIntegerLike rct)
            then Right ft
            else Left $ createError ae $ IncompatibleCast ft ct
        (False, _)    -> Left $ createError ae $ ExpectBaseType rct
        (True, False) -> Left $ createError ae $ ExpectBaseType rft
      where
        rct :: SType
        rct = rpartSType ct
        rft :: SType
        rft = rpartSType ft

inferConstraint ::
     SymbolTable s -- st
  -> (SType -> Bool) -- isCorrect
  -> (NonEmpty SType -> SType) -- resultSType
  -> (NonEmpty SType -> ExpressionTypeError) -- makeError
  -> Expr -- parentExpr
  -> NonEmpty Expr -- childs
  -> ST s (Either ErrorMessage' SType)
inferConstraint st isCorrect resultSType makeError parentExpr inners = do
  eitherTs <- sequence <$> mapM (infer st) inners
  return $ do
    ts <- eitherTs
     -- all the same and one of the valid types:
    if length (NE.nub ts) == 1 && (isCorrect . rpartSType) (NE.head ts)
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

isAddable :: SType -> Bool
isAddable = isOrdered

-- isComparable: many many things...
isOrdered :: SType -> Bool
isOrdered = flip elem [PInt, PFloat64, PRune, PString]

isBase :: SType -> Bool
isBase = flip elem [PInt, PFloat64, PBool, PRune, PString]

isBoolean :: SType -> Bool
isBoolean = (==) PBool

isIntegerLike :: SType -> Bool
isIntegerLike = flip elem [PInt, PRune]

-- | Checks if a type is comparable at all (arrays still need length checks).
isComparable :: SType -> Bool
isComparable styp =
  case styp of
    Slice _         -> False
    TypeMap _ styp' -> isComparable styp'
    _               -> True

-- | Resolves a defined type to a base type, WITHOUT nested types (arrays, etc)
rpartSType :: SType -> SType
rpartSType (TypeMap _ st) = rpartSType st
rpartSType t              = t -- Other types
