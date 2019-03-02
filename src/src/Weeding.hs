module Weeding (weed) where

import           Data.List.NonEmpty  (NonEmpty (..))
import qualified Data.List.NonEmpty  as NonEmpty

import           Control.Applicative
import           Data
import           Data.Maybe          as Maybe
import           ErrorBundle

type PureConstraint a = a -> Maybe ErrorBundle'

-- | Main weeding function
-- Takes in input code as well as ast program
weed :: String -> Program -> Either String Program
weed code program =
  case errorBundle of
    Just eb -> Left $ errorString $ eb (createInitialState code)
    Nothing -> Right program
  where
    errorBundle :: Maybe ErrorBundle'
    errorBundle = programVerify program

-- | Returns option of either the first element of a list or nothing
firstOrNothing :: [a] -> Maybe a
firstOrNothing []    = Nothing
firstOrNothing (x:_) = Just x

verifyAll :: PureConstraint a -> [a] -> Maybe ErrorBundle'
verifyAll constraint items = firstOrNothing $ mapMaybe constraint items

stmtRecursiveVerifyAll :: PureConstraint Stmt -> [Stmt] -> Maybe ErrorBundle'
stmtRecursiveVerifyAll c = verifyAll $ stmtRecursiveVerify c

-- | Takes a top level statement verifier and applies it to all scopes
stmtRecursiveVerify :: PureConstraint Stmt -> PureConstraint Stmt
stmtRecursiveVerify constraint stmt =
  constraint stmt <|>
  stmtRecursiveVerifyAll
    constraint
    (case stmt of
       BlockStmt stmts  -> stmts
       If _ s1 s2       -> [s1, s2]
       For _ s          -> [s]
       Switch _ _ cases -> map stmtFromCase cases
       _                -> [])
  where
    stmtFromCase :: SwitchCase -> Stmt
    stmtFromCase (Case _ _ stmt)  = stmt
    stmtFromCase (Default _ stmt) = stmt

-- | Verification rules for specific statements
stmtVerify :: Stmt -> Maybe ErrorBundle'
-- Verify that expression statements are only function calls
stmtVerify (SimpleStmt stmt) =
  case stmt of
    ExprStmt Arguments {} -> Nothing
    e@(ExprStmt _) -> Just $ createError e "Expression statements must be function calls" -- TODO: OFFSET
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
    s@ShortDeclare {} -> Just $ createError s "For post-statement cannot be declaration"
    _ -> Nothing
-- TODO
stmtVerify _ = Nothing

programVerify :: PureConstraint Program
programVerify program = firstOrNothing errors
  where
    errors :: [ErrorBundle']
    errors = mapMaybe (stmtRecursiveVerify stmtVerify) (mapMaybe topToStmt $ topLevels program)

-- Helpers
-- | Extracts block statements from top-level function declarations
topToStmt :: TopDecl -> Maybe Stmt
topToStmt (TopFuncDecl (FuncDecl _ _ stmt)) = Just stmt
topToStmt _                                 = Nothing
