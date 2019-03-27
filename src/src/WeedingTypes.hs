{-# LANGUAGE FlexibleInstances #-}

module WeedingTypes
  ( weedT
  ) where

import           Base
import           Control.Applicative
import           Data
import           Data.Foldable       (asum)
import           Data.List.NonEmpty  (toList)
import           Weeding

-- | Main weeding function
-- Takes in input code, will pass through parser
weedT :: String -> Either ErrorMessage Program
weedT code = do
  program <- weed code
  maybe
    (Right program)
    (\eb -> Left $ eb code `withPrefix` "typecheck weeding error at ")
    (verify program)

-- | Alternative sum, i.e. sum using <|> over each function mapped to program
verify :: Program -> Maybe ErrorMessage'
verify program =
  asum $
  [ initMainSignatureVerify
  , returnVerify
  , initReturnVerify
  , initMainFunctionVerify
  ] <*>
  [program]

returnVerify :: PureConstraint Program
returnVerify program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors = map returnConstraint (topLevels program)

-- | Checks to make sure the last statement is a return, traversing branches
returnConstraint :: TopDecl -> Maybe ErrorMessage'
returnConstraint (TopDecl _) = Nothing
returnConstraint (TopFuncDecl fd@(FuncDecl _ (Signature _ mrt) fb)) =
  maybe Nothing (const $ lastIsReturn fb) mrt
  where
    lastIsReturn :: Stmt -> Maybe ErrorMessage'
    lastIsReturn (If _ ifb elseb) = lastIsReturn ifb <|> lastIsReturn elseb
    lastIsReturn (For (ForClause _ Nothing _) forb)
      -- infinite for loops don't 'need' return unless they have a break in them
     = checkForBreak forb
    lastIsReturn (BlockStmt stmts) =
      case reverse stmts of
        st:_ -> lastIsReturn st
        []   -> Just $ createError fd LastReturn
    lastIsReturn (Switch _ _ cl) =
      if not (True `elem` (map checkForDefault cl))
        then Just $ createError fd ReturnNoDefault
        else asum $ map (lastIsReturn . getSwitchCaseStmt) cl
    lastIsReturn (Return _ _) = Nothing -- Just $ createError o LastReturn
    lastIsReturn _ = Just $ createError fd LastReturn
    getSwitchCaseStmt :: SwitchCase -> Stmt
    getSwitchCaseStmt (Case _ _ stmt)  = stmt
    getSwitchCaseStmt (Default _ stmt) = stmt
    checkForBreak :: Stmt -> Maybe ErrorMessage'
    checkForBreak (BlockStmt stmts) = asum $ map checkForBreak stmts
    checkForBreak (If _ ifb elseb) = checkForBreak ifb <|> checkForBreak elseb
    checkForBreak (Break o) = Just $ createError o LastReturnBreak
    checkForBreak _ = Nothing -- fors/switches start their own break 'scope'
    checkForDefault :: SwitchCase -> Bool
    checkForDefault (Default _ _) = True
    checkForDefault _             = False

initReturnVerify :: PureConstraint Program
initReturnVerify program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors = map initReturnConstraint (topLevels program)

initReturnConstraint :: TopDecl -> Maybe ErrorMessage'
initReturnConstraint (TopFuncDecl (FuncDecl (Identifier _ fname) _ fb)) =
  if fname == "init"
    then checkInitReturn fb
    else Nothing
  where
    checkInitReturn :: Stmt -> Maybe ErrorMessage'
    checkInitReturn (If _ ifb elseb) =
      checkInitReturn ifb <|> checkInitReturn elseb
    checkInitReturn (For _ forb) = checkInitReturn forb
    checkInitReturn (BlockStmt stmts) = asum $ map checkInitReturn stmts
    checkInitReturn (Return o (Just _)) = Just $ createError o InitReturn
    checkInitReturn _ = Nothing
initReturnConstraint _ = Nothing -- Non-function declarations don't matter here

initMainFunctionVerify :: PureConstraint Program
initMainFunctionVerify program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors = map initFunctionConstraint (topLevels program)
    initFunctionConstraint :: TopDecl -> Maybe ErrorMessage'
    initFunctionConstraint (TopDecl (VarDecl vdl)) = asum (map vdConstraint vdl)
    initFunctionConstraint (TopDecl (TypeDef tdl)) = asum (map tdConstraint tdl)
    initFunctionConstraint _ = Nothing -- Function declarations are fine
    vdConstraint :: VarDecl' -> Maybe ErrorMessage'
    vdConstraint (VarDecl' idents _) = asum (map iToE (toList idents))
    tdConstraint :: TypeDef' -> Maybe ErrorMessage'
    tdConstraint (TypeDef' ident _) = iToE ident
    iToE :: Identifier -> Maybe ErrorMessage'
    iToE (Identifier o s) =
      if s == "init" || s == "main"
        then Just $ createError o $ NonFunctionSpecial s
        else Nothing

initMainSignatureVerify :: PureConstraint Program
initMainSignatureVerify program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors = map miFunctionConstraint (topLevels program)
    miFunctionConstraint :: TopDecl -> Maybe ErrorMessage'
    miFunctionConstraint (TopFuncDecl (FuncDecl (Identifier o fname) sig _)) =
      if fname == "main" || fname == "init"
        then checkMainInitSignature sig
        else Nothing
      where
        checkMainInitSignature :: Signature -> Maybe ErrorMessage'
        checkMainInitSignature (Signature (Parameters pdl) rtyp) =
          (verifyParams pdl) <|> (verifyType rtyp)
        verifyParams :: [ParameterDecl] -> Maybe ErrorMessage'
        verifyParams pdl =
          if length pdl == 0
            then Nothing
            else Just $ createError o $ SpecialFunctionType fname
        verifyType :: Maybe Type' -> Maybe ErrorMessage'
        verifyType Nothing = Nothing
        verifyType _       = Just $ createError o $ SpecialFunctionType fname
    miFunctionConstraint _ = Nothing -- Non-function declarations don't matter here
