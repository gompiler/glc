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
  case pResult of
    Left err -> Left err
    Right program -> weedProgram program
  where
    weedProgram :: Program -> Either String Program
    weedProgram program =
      case wResult of
        Just err -> Left err
        Nothing -> Right program
      where
        wResult :: Maybe String
        wResult = (weed program code)
    pResult :: Either String Program
    pResult = parser code

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
    BlockStmt stmts -> all stmts
    If _ s1 s2 -> (constraint stmt) <|> all [s1, s2]
    For _ s -> (constraint stmt) <|> all [s]
    Switch _ _ cases -> (constraint stmt) <|> (all $ map stmtFromCase cases)
    -- TODO: case statements (since they implicitly define scopes/block statements?)
    -- TODO finish
    -- Non-scoped statements will not yield errors here
    _ -> constraint stmt -- Just $ createError (Offset 0) (show a)
  where
    all :: [Stmt] -> Maybe ErrorBundle'
    all = stmtRecursiveVerifyAll constraint
    stmtFromCase :: SwitchCase -> Stmt
    stmtFromCase (Case _ _ stmt)  = stmt
    stmtFromCase (Default _ stmt) = stmt

-- | Verification rules for specific statements
stmtVerify :: Stmt -> Maybe ErrorBundle'

-- Verify that expression statements are only function calls
stmtVerify (SimpleStmt stmt) =
  case stmt of
    ExprStmt (Arguments _ _) -> Nothing
    ExprStmt _ -> Just $ createError (Offset 0) "Expression statements must be function calls" -- TODO: OFFSET
    _ -> Nothing

stmtVerify (If (stmt, _) _ _) = stmtVerify (SimpleStmt stmt)

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
stmtVerify (For (ForClause pre _ post) _) =
  (stmtVerify $ SimpleStmt pre)
  <|> case post of
    ShortDeclare (Identifier offset _ :| _) _ ->
      Just $ createError offset "For post-statement cannot be declaration"
    _ -> Nothing

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
