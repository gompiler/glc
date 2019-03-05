{-# LANGUAGE FlexibleInstances #-}

module Weeding
  ( weed
  ) where

import           Control.Applicative
import           Data
import           Data.List.NonEmpty  (toList)
import           Data.Maybe          as Maybe
import           ErrorBundle
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
  programVerify program <|> continueVerify program <|> breakVerify program <|>
  progVerifyDecl program <|>
  progVerifyBlank program

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
      if length l1 == length l2
        then Nothing -- firstOrNothing $ mapMaybe exprAssignVerify $ toList l2
        else Just $
             createError a $
             "LHS(" ++
             show (length l1) ++
             ") and RHS(" ++
             show (length l2) ++ ") of assignments must be equal in length"
    a@(ShortDeclare identl el) ->
      if length identl == length el
        then Nothing
        else Just $
             createError a $
             "LHS(" ++
             show (length identl) ++
             ") and RHS(" ++
             show (length el) ++
             ") of short declaration must be equal in length"
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
    vdeclVer d@(VarDecl' identl (Right el)) =
      if length identl == length el
        then Nothing
        else Just $
             createError d $
             "LHS(" ++
             show (length identl) ++
             ") and RHS(" ++
             show (length el) ++
             ") of declaration assignment must be equal in length"
    vdeclVer d@(VarDecl' identl (Left (_, el))) =
      if null el || length identl == length el
        then Nothing
        else Just $
             createError d $
             "LHS(" ++
             show (length identl) ++
             ") and RHS(" ++
             show (length el) ++
             ") of declaration assignment with type must be equal in length"
declVerify _ = Nothing

progVerifyDecl :: PureConstraint Program
progVerifyDecl program = firstOrNothing errors
  where
    errors :: [ErrorBundle']
    errors =
      mapMaybe
        declVerify
        -- Extract all declarations from either top level (i.e. top level declaration, not in a block statement)
        -- or from a block stmt, using getScopes and calling stmtToDecl on each entry in the statement list
        (mapMaybe topToDecl (topLevels program) ++
         mapMaybe
           stmtToDecl
           (concat $ map getScopes $ mapMaybe topToStmt $ topLevels program))
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
    errors = mapMaybe blankVerify (concatMap toIdent $ topLevels program)

blankVerify :: Identifier -> Maybe ErrorBundle'
blankVerify (Identifier o str) =
  if str == "_"
    then Just $ createError o "Invalid use of blank identifier"
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
topToDecl (TopDecl d)                    = Just d

-- | Extract declaration from stmt
stmtToDecl :: Stmt -> Maybe Decl
stmtToDecl (Declare d) = Just d
stmtToDecl _           = Nothing

-- | toIdent for various structures from AST so we can extract identifiers
class BlankWeed a where
  toIdent :: a -> [Identifier]

-- | Extract identifiers that cannot be blank
instance BlankWeed TopDecl where
  toIdent (TopFuncDecl (FuncDecl ident (Signature (Parameters pdl) Nothing) stmt)) =
    (ident : pdIdentl) ++ stmtIdentl
    where
      pdIdentl = concatMap toIdent pdl
      stmtIdentl = toIdent stmt
  toIdent (TopFuncDecl (FuncDecl ident (Signature (Parameters pdl) (Just t)) stmt)) =
    (ident : pdIdentl) ++ stmtIdentl ++ toIdent t
    where
      pdIdentl = concatMap toIdent pdl
      stmtIdentl = toIdent stmt
  toIdent (TopDecl d) = toIdent d

instance BlankWeed ParameterDecl where
  toIdent (ParameterDecl il _) = toList il

instance BlankWeed Stmt where
  toIdent (BlockStmt stmts) = concatMap toIdent stmts
  toIdent (SimpleStmt stmt) = toIdent stmt
  toIdent (If (simp, e) s1 s2) =
    toIdent simp ++ toIdent e ++ toIdent s1 ++ toIdent s2
  toIdent (Switch simp (Just e) cases) =
    toIdent simp ++ toIdent e ++ concatMap toIdent cases
  toIdent (Switch simp Nothing cases) = toIdent simp ++ concatMap toIdent cases
  toIdent (For (ForCond e) s) = toIdent e ++ toIdent s
  toIdent (For (ForClause simp1 e simp2) s) =
    toIdent e ++ toIdent simp1 ++ toIdent simp2 ++ toIdent s
  toIdent (Declare d) = toIdent d
  toIdent (Print el) = concatMap toIdent el
  toIdent (Println el) = concatMap toIdent el
  toIdent (Return (Just e)) = toIdent e
  toIdent _ = []

instance BlankWeed SimpleStmt where
  toIdent (ExprStmt e) = toIdent e
  toIdent (Increment _ e) = toIdent e
  toIdent (Decrement _ e) = toIdent e
  toIdent (Assign _ _ _ el) = concatMap toIdent (toList el) -- We don't care about identifiers on the LHS
  toIdent (ShortDeclare identl el) =
    toList identl ++ concatMap toIdent (toList el)
  toIdent _ = []

instance BlankWeed Expr where
  toIdent (Unary _ _ e)        = toIdent e
  toIdent (Binary _ _ e1 e2)   = toIdent e1 ++ toIdent e2
  toIdent (Var ident)          = [ident]
  toIdent (LenExpr _ e)        = toIdent e
  toIdent (CapExpr _ e)        = toIdent e
  toIdent (Selector _ e ident) = ident : toIdent e
  toIdent (Index _ e1 e2)      = toIdent e1 ++ toIdent e2
  toIdent (Arguments _ e el)   = toIdent e ++ concatMap toIdent el
  toIdent _                    = []

instance BlankWeed SwitchCase where
  toIdent (Case _ el s) = concatMap toIdent (toList el) ++ toIdent s
  toIdent (Default _ s) = toIdent s

instance BlankWeed Decl where
  toIdent (VarDecl vdl) = concatMap toIdent vdl
  toIdent (TypeDef tdl) = concatMap toIdent tdl

instance BlankWeed VarDecl' where
  toIdent (VarDecl' _ (Left (t, el))) = toIdent t ++ concatMap toIdent el
  toIdent (VarDecl' _ (Right el))     = concatMap toIdent (toList el)

instance BlankWeed TypeDef' where
  toIdent (TypeDef' _ t) = toIdent t -- Don't care about idents on LHS

instance BlankWeed (Offset, Type) where
  toIdent (_, t) = toIdent t

instance BlankWeed Type where
  toIdent (ArrayType e t) = toIdent e ++ toIdent t
  toIdent (SliceType t) = toIdent t
  toIdent (StructType fdl) = concatMap toIdent fdl
  toIdent (FuncType (Signature (Parameters pdl) Nothing)) =
    concatMap toIdent pdl
  toIdent (FuncType (Signature (Parameters pdl) (Just t))) =
    concatMap toIdent pdl ++ toIdent t
  toIdent (Type ident) = [ident]

instance BlankWeed FieldDecl where
  toIdent (FieldDecl identl t) = toList identl ++ toIdent t

stmtFromCase :: SwitchCase -> Stmt
stmtFromCase (Case _ _ stmt)  = stmt
stmtFromCase (Default _ stmt) = stmt
