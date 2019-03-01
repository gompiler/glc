module Weeding where

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty

import           Control.Applicative
import           Data
import           Data.Maybe  as Maybe
import           ErrorBundle

type PureConstraint a = a -> Maybe ErrorBundle'

-- | Main weeding function
weed :: Program -> String -> Maybe String
weed program code =
  case errorBundle of
    Just eb -> Just $ errorString $ eb (createInitialState code)
    Nothing -> Nothing
  where
    errorBundle :: Maybe ErrorBundle'
    errorBundle = programVerify program

-- | Replace this, but hooks up parser to weeder
wCoupler :: (String -> Either String Program) -> String -> Either String Program
wCoupler parser code =
  either Left weedProgram (parser code)
  where
    weedProgram :: Program -> Either String Program
    weedProgram program =
      maybe (Right program) Left (weed program code)

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
      (constraint stmt) -- Check constraints against the current statement
  <|> (stmtRecursiveVerifyAll constraint $ case stmt of  -- Recursively traverse all child scopes
        BlockStmt stmts -> stmts
        If _ s1 s2 -> [s1, s2]
        For _ s -> [s]
        Switch _ _ cases -> map stmtFromCase cases
        -- TODO finish
        _ -> [])
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
    ExprStmt _ -> Just $ createError (Offset 0) "Expression statements must be function calls" -- TODO: OFFSET
    _ -> Nothing

stmtVerify (If (stmt, _) _ _) = stmtVerify (SimpleStmt stmt)

-- Verify that switch statements only have one default
stmtVerify (Switch s _ cases) =
      (stmtVerify $ SimpleStmt s)
  <|> case [x | x@(Default _ _) <- cases] of
    -- The [...] pattern matching returns all the examples in the list where the
    -- pattern was matched (i.e. a default case was found). Effectively a
    -- pattern-matching filter.

    -- The below pattern matching checks if the list is of length > 1 AND
    -- extracts the offset at the same time for error reporting.
    (_:Default dupOffset _:_) -> Just $ createError dupOffset "Duplicate default found"
    _ -> Nothing

-- Verify that for-loop post conditions are not short declarations
stmtVerify (For (ForClause pre _ post) _) =
      (stmtVerify $ SimpleStmt pre)
  <|> (stmtVerify $ SimpleStmt post)
  <|> case post of
    ShortDeclare (Identifier offset _ :| _) _ ->
      Just $ createError offset "For post-statement cannot be declaration"
    _ -> Nothing

-- TODO
stmtVerify otherwise = Nothing

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
