module Weeding where

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty

import           Data
import           Data.Maybe  as Maybe
import           ErrorBundle

type PureConstraint a = a -> Maybe ErrorBundle'

-- | Returns option of either the first element of a list or nothing
firstOrNothing :: [a] -> Maybe a
firstOrNothing []    = Nothing
firstOrNothing (x:_) = Just x

verifyAll :: PureConstraint a -> [a] -> Maybe ErrorBundle'
verifyAll constraint items = firstOrNothing $ mapMaybe constraint items

stmtRecursiveVerifyAll :: PureConstraint Stmt -> [Stmt] -> Maybe ErrorBundle'
stmtRecursiveVerifyAll c stmts = verifyAll (stmtRecursiveVerify c) stmts

-- | Takes a top level statement verifier and applies it to all scopes
stmtRecursiveVerify :: PureConstraint Stmt -> PureConstraint Stmt
stmtRecursiveVerify constraint stmt =
  case stmt of
    BlockStmt stmts -> stmtRecursiveVerifyAll constraint stmts
    If _ s1 s2 -> stmtRecursiveVerifyAll constraint [s1, s2]
    For _ s -> stmtRecursiveVerifyAll constraint [s]
    -- TODO: case statements (since they implicitly define scopes/block statements?)
    -- TODO finish
    _ -> undefined

-- | Verification rules for specific statements
stmtVerify :: Stmt -> Maybe ErrorBundle'

-- Verify that expression statements are only function calls
stmtVerify (SimpleStmt stmt) =
  case stmt of
    ExprStmt (Arguments _ _) -> Nothing
    ExprStmt _ -> Just $ createError (Offset 0) "Expression statements must be function calls" -- TODO: OFFSET
    _ -> Nothing

-- Verify that switch statements only have one default
stmtVerify (Switch _ _ cases) =
  -- The [...] pattern matching returns all the examples in the list where the
  -- pattern was matched (i.e. a default case was found). Effectively a
  -- pattern-matching filter.
  case [x | x@(Default _ _) <- cases] of
    -- This pattern matching checks if the list is of length > 1 AND extracts
    -- the offset at the same time for error reporting.
    (_:Default dupOffset _:_) -> Just $ createError dupOffset "Duplicate default found"
    _ -> Nothing

-- Verify that for-loop post conditions are not short declarations
stmtVerify (For (ForClause _ _ post) _) =
  case post of
    ShortDeclare idents _ ->
      Just $ createError (getOffset $ NonEmpty.toList idents) "For post-statement cannot be declaration"
    _ -> Nothing
  where
    getOffset :: [Identifier] -> Offset
    getOffset ((Identifier offset _):_) = offset

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

-- | Extracts offsets from literals
literalOffset :: Literal -> Offset
literalOffset lit
  = case lit of
    IntLit offset _ _    -> offset
    FloatLit offset _    -> offset
    RuneLit offset _     -> offset
    StringLit offset _ _ -> offset
    FuncLit _ _          -> Offset 0 -- TODO!!!
