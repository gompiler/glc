module Weeding where

import           Data
import           Data.Maybe  as Maybe
import           ErrorBundle

type PureConstraint a = a -> Maybe ErrorBundle'

firstOrNothing :: [a] -> Maybe a
firstOrNothing []    = Nothing
firstOrNothing (x:_) = Just x

verifyAll :: PureConstraint a -> [a] -> Maybe ErrorBundle'
verifyAll constraint items = firstOrNothing $ mapMaybe constraint items

-- | Takes a top level statement verifier and applies it to all scopes
stmtRecursiveVerify :: PureConstraint Stmt -> PureConstraint Stmt
stmtRecursiveVerify constraint (BlockStmt stmts) = verifyAll (stmtRecursiveVerify constraint) stmts
stmtRecursiveVerify constraint (If _ s1 s2) = verifyAll (stmtRecursiveVerify constraint) [s1, s2]
stmtRecursiveVerify constraint (For _ s) = verifyAll (stmtRecursiveVerify constraint) [s]
-- TODO finish
stmtRecursiveVerify _ _ = undefined

switchVerify :: PureConstraint Program
switchVerify program =
  if null errors
    then Nothing
    else Just $ head errors
  where
    errors :: [ErrorBundle']
    errors = mapMaybe (stmtRecursiveVerify stmtVerify) (mapMaybe topToStmt $ topLevels program)
    topToStmt :: TopDecl -> Maybe Stmt
    topToStmt (TopFuncDecl (FuncDecl _ _ stmt)) = Just stmt
    topToStmt _                                 = Nothing
    stmtVerify :: Stmt -> Maybe ErrorBundle'
    stmtVerify (Switch _ _ cases) =
      case [x | x@(Default _ _) <- cases] of
        (_:Default dupOffset _:_) -> Just $ createError dupOffset "Duplicate default found"
        _ -> Nothing
