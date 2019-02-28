module Weeding where

import           Data
import           Data.Maybe  as Maybe
import           ErrorBundle

type PureConstraint = Program -> Maybe ErrorBundle'

switchVerify :: PureConstraint
switchVerify program =
  if null errors
    then Nothing
    else Just $ head errors
  where
    errors :: [ErrorBundle']
    errors = mapMaybe stmtVerify (mapMaybe topToStmt $ topLevels program)
    topToStmt :: TopDecl -> Maybe Stmt
    topToStmt (TopFuncDecl (FuncDecl _ _ stmt)) = Just stmt
    topToStmt _                                 = Nothing
    stmtVerify :: Stmt -> Maybe ErrorBundle'
    stmtVerify (Switch _ _ cases) =
      case [x | x@(Default _ _) <- cases] of
        (_:Default dupOffset _:_) -> Just $ createError dupOffset "Duplicate default found"
        _ -> Nothing
