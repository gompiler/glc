module Weeding
  ( weed
  ) where

import           Control.Applicative
import           Data
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
  programVerify program <|> continueVerify program <|> breakVerify program

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

stmtFromCase :: SwitchCase -> Stmt
stmtFromCase (Case _ _ stmt)  = stmt
stmtFromCase (Default _ stmt) = stmt
