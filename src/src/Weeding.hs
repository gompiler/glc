module Weeding
  ( weed
  ) where

import           Control.Applicative
import           Data
import           Data.Maybe          as Maybe
import           ErrorBundle
import           Data.List.NonEmpty   (toList)
import           Parser              (parse)

type PureConstraint a = a -> Maybe ErrorBundle'

-- | Main weeding function
-- Takes in input code, will pass through parser
weed :: String -> Either String Program
weed code = do
  program <- parse code
  maybe
    (Right program)
    (\eb ->
       Left $
       "Error: weeding error at " ++ errorString (eb $ createInitialState code))
    (verify program)

verify :: Program -> Maybe ErrorBundle'
verify program =
  programVerify program <|> continueVerify program <|> breakVerify program <|> progVerifyDecl program <|> progVerifyBlank program

-- | Returns option of either the first element of a list or nothing
firstOrNothing :: [a] -> Maybe a
firstOrNothing []    = Nothing
firstOrNothing (x:_) = Just x

verifyAll :: PureConstraint a -> [a] -> Maybe ErrorBundle'
verifyAll constraint items = firstOrNothing $ mapMaybe constraint items

recursiveVerifyAll ::
     (Stmt -> [Stmt]) -> PureConstraint Stmt -> [Stmt] -> Maybe ErrorBundle'
recursiveVerifyAll getScopes c = verifyAll $ recursiveVerify getScopes c

-- | Takes a top level statement verifier and applies it to specified scopes
-- | (based on a passed function which extracts statements from the current
-- | statement).
recursiveVerify ::
     (Stmt -> [Stmt]) -> PureConstraint Stmt -> PureConstraint Stmt
recursiveVerify getScopes constraint stmt =
  constraint stmt <|> recursiveVerifyAll getScopes constraint (getScopes stmt)

-- | Takes a top level statement verifier and applies it to all scopes
stmtRecursiveVerify :: PureConstraint Stmt -> PureConstraint Stmt
stmtRecursiveVerify = recursiveVerify getScopes
  where
    getScopes :: Stmt -> [Stmt]
    getScopes stmt =
      case stmt of
        BlockStmt stmts  -> stmts
        If _ s1 s2       -> [s1, s2]
        For _ s          -> [s]
        Switch _ _ cases -> map stmtFromCase cases
        _                -> []

-- | Verification rules for specific statements
stmtVerify :: Stmt -> Maybe ErrorBundle'
-- Verify that expression statements are only function calls
stmtVerify (SimpleStmt stmt) =
  case stmt of
    ExprStmt Arguments {} -> Nothing
    e@(ExprStmt _) ->
      Just $ createError e "Expression statements must be function calls"
    a@(Assign _ _ l1 l2) ->
      if length l1 == length l2 then Nothing -- firstOrNothing $ mapMaybe exprAssignVerify $ toList l2
      else Just $ createError a $ "LHS(" ++ show (length l1) ++ ") and RHS(" ++ show (length l2) ++ ") of assignments must be equal in length"
    a@(ShortDeclare identl el) ->
      if length identl == length el then Nothing
      else Just $ createError a $ "LHS(" ++ show (length identl) ++ ") and RHS(" ++ show (length el) ++ ") of short declaration must be equal in length"
    _ -> Nothing
stmtVerify (If (stmt, _) _ _) = stmtVerify (SimpleStmt stmt)
-- | Verify that switch statements only have one default
-- The [...] pattern matching returns all the examples in the list where the
-- pattern was matched (i.e. a default case was found). Effectively a
-- pattern-matching filter.
-- The default dupOffset pattern matching checks if the list is of length > 1 AND
-- extracts the offset at the same time for error reporting.
stmtVerify (Switch s _ cases) =
  stmtVerify (SimpleStmt s) <|>
  case [x | x@(Default _ _) <- cases] of
    (_:d@Default {}:_) -> Just $ createError d "Duplicate default found"
    _                  -> Nothing
-- Verify that for-loop post conditions are not short declarations
stmtVerify (For (ForClause pre _ post) _) =
  stmtVerify (SimpleStmt pre) <|> stmtVerify (SimpleStmt post) <|>
  case post of
    s@ShortDeclare {} ->
      Just $ createError s "For post-statement cannot be declaration"
    _ -> Nothing
stmtVerify _ = Nothing

-- Verify declarations (LHS = RHS if an assignment)
declVerify :: Decl -> Maybe ErrorBundle'
declVerify (VarDecl vdl) = firstOrNothing $ mapMaybe vdeclVer vdl
  where
    vdeclVer d@(VarDecl' identl (Right el)) = if length identl == length el then Nothing
      else Just $ createError d $ "LHS(" ++ show (length identl) ++ ") and RHS(" ++ show (length el) ++ ") of declaration assignment must be equal in length"
    vdeclVer d@(VarDecl' identl (Left (_, el))) = if length el == 0 || length identl == length el then Nothing
      else Just $ createError d $ "LHS(" ++ show (length identl) ++ ") and RHS(" ++ show (length el) ++ ") of declaration assignment with type must be equal in length"
declVerify _ = Nothing

progVerifyDecl :: PureConstraint Program
progVerifyDecl program = firstOrNothing errors
  where
    errors :: [ErrorBundle']
    errors =
      mapMaybe
        (declVerify)
        -- Extract all declarations from either top level (i.e. top level declaration, not in a block statement)
        -- or from a block stmt, using getScopes and calling stmtToDecl on each entry in the statement list
        ((mapMaybe topToDecl $ topLevels program) ++ (mapMaybe stmtToDecl $ concat $ map getScopes $ mapMaybe topToStmt $ topLevels program))
    getScopes stmt =
      case stmt of
        BlockStmt stmts  -> stmts
        If _ s1 s2       -> [s1, s2]
        For _ s          -> [s]
        Switch _ _ cases -> map stmtFromCase cases
        _                -> []

progVerifyBlank :: PureConstraint Program
progVerifyBlank program = firstOrNothing errors
  where
    errors :: [ErrorBundle']
    errors = mapMaybe blankVerify (concatMap topToIdent $ topLevels program)

blankVerify :: Identifier -> Maybe ErrorBundle'
blankVerify (Identifier o str) = if str == "_" then Just $ createError o "Invalid use of blank identifier"
                                 else Nothing

programVerify :: PureConstraint Program
programVerify program = firstOrNothing errors
  where
    errors :: [ErrorBundle']
    errors =
      mapMaybe
        (stmtRecursiveVerify stmtVerify)
        (mapMaybe topToStmt $ topLevels program)

continueRecursiveVerify :: PureConstraint Stmt -> PureConstraint Stmt
continueRecursiveVerify = recursiveVerify getScopes
  where
    getScopes :: Stmt -> [Stmt]
    getScopes stmt =
      case stmt of
        BlockStmt stmts  -> stmts
        If _ s1 s2       -> [s1, s2]
        Switch _ _ cases -> map stmtFromCase cases
        _                -> []

continueConstraint :: Stmt -> Maybe ErrorBundle'
continueConstraint (Continue o) =
  Just $ createError o "Continue statement must occur in for loop"
continueConstraint _ = Nothing

continueVerify :: PureConstraint Program
continueVerify program = firstOrNothing errors
  where
    errors :: [ErrorBundle']
    errors =
      mapMaybe
        (continueRecursiveVerify continueConstraint)
        (mapMaybe topToStmt $ topLevels program)

breakRecursiveVerify :: PureConstraint Stmt -> PureConstraint Stmt
breakRecursiveVerify = recursiveVerify getScopes
  where
    getScopes :: Stmt -> [Stmt]
    getScopes stmt =
      case stmt of
        BlockStmt stmts -> stmts
        If _ s1 s2      -> [s1, s2]
        _               -> [] -- Skip for and switch, since breaks can occur there

breakConstraint :: Stmt -> Maybe ErrorBundle'
breakConstraint (Break o) =
  Just $
  createError o "Break statement must occur in for loop or switch statement"
breakConstraint _ = Nothing

breakVerify :: PureConstraint Program
breakVerify program = firstOrNothing errors
  where
    errors :: [ErrorBundle']
    errors =
      mapMaybe
        (breakRecursiveVerify breakConstraint)
        (mapMaybe topToStmt $ topLevels program)

-- Helpers
-- | Extracts block statements from top-level function declarations
topToStmt :: TopDecl -> Maybe Stmt
topToStmt (TopFuncDecl (FuncDecl _ _ stmt)) = Just stmt
topToStmt _                                 = Nothing

-- | Extract declarations from top-level declarations
topToDecl :: TopDecl -> Maybe Decl
topToDecl (TopFuncDecl (FuncDecl _ _ s)) = stmtToDecl s
topToDecl (TopDecl d) = Just d

-- | Extract declaration from stmt
stmtToDecl :: Stmt -> Maybe Decl
stmtToDecl (Declare d) = Just d
stmtToDecl _ = Nothing

-- | Extract identifiers that cannot be blank
topToIdent :: TopDecl -> [Identifier]
topToIdent (TopFuncDecl (FuncDecl ident (Signature (Parameters pdl) Nothing) stmt)) =
  (ident:(pdIdentl)) ++ stmtIdentl
  where
    pdIdentl = concatMap paramDeclToIdent pdl
    stmtIdentl = stmtToIdent stmt
topToIdent (TopFuncDecl (FuncDecl ident (Signature (Parameters pdl) (Just t)) stmt)) =
  (ident:(pdIdentl)) ++ stmtIdentl ++ type'ToIdent t
  where
    pdIdentl = concatMap paramDeclToIdent pdl
    stmtIdentl = stmtToIdent stmt
topToIdent (TopDecl d) = declToIdent d

paramDeclToIdent :: ParameterDecl -> [Identifier]
paramDeclToIdent (ParameterDecl il _) = toList il

stmtToIdent :: Stmt -> [Identifier]
stmtToIdent (BlockStmt stmts) = concatMap stmtToIdent stmts
stmtToIdent (SimpleStmt stmt) = simpleToIdent stmt
stmtToIdent (If (simp, e) s1 s2) = (simpleToIdent simp) ++ (exprToIdent e) ++ (stmtToIdent s1) ++ (stmtToIdent s2)
stmtToIdent (Switch (simp) (Just e) cases) = (simpleToIdent simp) ++ (exprToIdent e) ++ (concatMap casesToIdent cases)
stmtToIdent (Switch (simp) (Nothing) cases) = (simpleToIdent simp) ++ (concatMap casesToIdent cases)
stmtToIdent (For (ForCond e) s) = exprToIdent e ++ stmtToIdent s
stmtToIdent (For (ForClause simp1 e simp2) s) = exprToIdent e ++ simpleToIdent simp1 ++ simpleToIdent simp2 ++ stmtToIdent s
stmtToIdent (Declare d) = declToIdent d
stmtToIdent (Print el) = concatMap exprToIdent el
stmtToIdent (Println el) = concatMap exprToIdent el
stmtToIdent (Return (Just e)) = exprToIdent e
stmtToIdent _ = []

simpleToIdent :: SimpleStmt -> [Identifier]
simpleToIdent (ExprStmt e) = exprToIdent e
simpleToIdent (Increment _ e) = exprToIdent e
simpleToIdent (Decrement _ e) = exprToIdent e
simpleToIdent (Assign _ _ _ el) = concatMap exprToIdent (toList el) -- We don't care about identifiers on the LHS
simpleToIdent (ShortDeclare identl el) = toList identl ++ concatMap exprToIdent (toList el)
simpleToIdent _ = []

exprToIdent :: Expr -> [Identifier]
exprToIdent (Unary _ _ e) = exprToIdent e
exprToIdent (Binary _ _ e1 e2) = exprToIdent e1 ++ exprToIdent e2
exprToIdent (Var ident) = [ident]
exprToIdent (LenExpr _ e) = exprToIdent e
exprToIdent (CapExpr _ e) = exprToIdent e
exprToIdent (Selector _ e ident) = ident:(exprToIdent e)
exprToIdent (Index _ e1 e2) = exprToIdent e1 ++ exprToIdent e2
exprToIdent (Arguments _ e el) = exprToIdent e ++ concatMap exprToIdent el
exprToIdent _ = []

casesToIdent :: SwitchCase -> [Identifier]
casesToIdent (Case _ el s) = concatMap exprToIdent (toList el) ++ stmtToIdent s
casesToIdent (Default _ s) = stmtToIdent s

declToIdent :: Decl -> [Identifier]
declToIdent (VarDecl vdl) = concatMap vdeclToIdent vdl
declToIdent (TypeDef tdl) = concatMap tdefToIdent tdl

vdeclToIdent :: VarDecl' -> [Identifier]
vdeclToIdent (VarDecl' _ (Left (t, el))) = type'ToIdent t ++ concatMap exprToIdent el
vdeclToIdent (VarDecl' _ (Right el)) = concatMap exprToIdent (toList el)

tdefToIdent :: TypeDef' -> [Identifier]
tdefToIdent (TypeDef' _ t) = type'ToIdent t -- Don't care about idents on LHS

type'ToIdent :: Type' -> [Identifier]
type'ToIdent (_, t) = typeToIdent t

typeToIdent :: Type -> [Identifier]
typeToIdent (ArrayType e t) = exprToIdent e ++ typeToIdent t
typeToIdent (SliceType t) = typeToIdent t
typeToIdent (StructType fdl) = concatMap fdToIdent fdl
typeToIdent (FuncType (Signature (Parameters pdl) Nothing)) = concatMap paramDeclToIdent pdl
typeToIdent (FuncType (Signature (Parameters pdl) (Just t))) = concatMap paramDeclToIdent pdl ++ type'ToIdent t
typeToIdent (Type ident) = [ident]

fdToIdent :: FieldDecl -> [Identifier]
fdToIdent (FieldDecl identl t) = toList identl ++ type'ToIdent t

stmtFromCase :: SwitchCase -> Stmt
stmtFromCase (Case _ _ stmt)  = stmt
stmtFromCase (Default _ stmt) = stmt
