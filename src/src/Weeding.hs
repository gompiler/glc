{-# LANGUAGE FlexibleInstances #-}

module Weeding
  ( weed
  , WeedingError(..)
  ) where

import           Control.Applicative
import           Data
import           Data.Foldable       (asum)
import           Data.List.NonEmpty  (toList)
import           Data.Maybe          as Maybe
import           ErrorBundle
import           Parser

type PureConstraint a = a -> Maybe ErrorMessage'

-- | Main weeding function
-- Takes in input code, will pass through parser
weed :: String -> Either ErrorMessage Program
weed code = do
  program <- parse code
  maybe
    (Right program)
    (\eb -> Left $ eb code `withPrefix` "weeding error at ")
    (verify program)

-- | Alternative sum, i.e. sum using <|> over each function mapped to program
verify :: Program -> Maybe ErrorMessage'
verify program =
  asum $
  [programVerify, continueVerify, breakVerify, progVerifyDecl, progVerifyBlank] <*>
  [program]

verifyAll :: PureConstraint a -> [a] -> Maybe ErrorMessage'
verifyAll constraint items = asum $ map constraint items

recursiveVerifyAll ::
     (Stmt -> [Stmt]) -> PureConstraint Stmt -> [Stmt] -> Maybe ErrorMessage'
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
stmtVerify :: Stmt -> Maybe ErrorMessage'
-- Verify that expression statements are only function calls
stmtVerify (SimpleStmt stmt) =
  case stmt of
    ExprStmt Arguments {}    -> Nothing
    e@(ExprStmt _)           -> Just $ createError e ExprStmtNotFunction
    (Assign _ _ e1 e2)       -> checkListSize (toList e1) (toList e2)
    (ShortDeclare identl el) -> checkListSize (toList identl) (toList el)
    _                        -> Nothing
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
    (_:d@Default {}:_) -> Just $ createError d DuplicateDefault
    _                  -> Nothing
-- Verify that for-loop post conditions are not short declarations
stmtVerify (For (ForClause pre _ post) _) =
  stmtVerify (SimpleStmt pre) <|> stmtVerify (SimpleStmt post) <|>
  case post of
    s@ShortDeclare {} -> Just $ createError s ForPostDecl
    _                 -> Nothing
stmtVerify _ = Nothing

-- Verify declarations (LHS = RHS if an assignment)
declVerify :: Decl -> Maybe ErrorMessage'
declVerify (VarDecl vdl) = asum $ map vdeclVer vdl
  where
    vdeclVer (VarDecl' identl (Right el)) =
      checkListSize (toList identl) (toList el)
    vdeclVer (VarDecl' identl (Left (_, el))) =
      if null el
        then Nothing -- If no expressions, i.e. type only, then nothing on RHS, don't care about length
        else checkListSize (toList identl) el
declVerify _ = Nothing

-- | Given two lists, check if the sizes are equal, if not, output a corresponding error
checkListSize ::
     (ErrorBreakpoint a, ErrorBreakpoint b) => [a] -> [b] -> Maybe ErrorMessage'
checkListSize (_:t1) (_:t2) = checkListSize t1 t2
checkListSize [] (h2:_)     = Just $ createError h2 ListSizeMismatch
checkListSize (h1:_) []     = Just $ createError h1 ListSizeMismatch
checkListSize [] []         = Nothing

progVerifyDecl :: PureConstraint Program
progVerifyDecl program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors =
      map
        declVerify
        -- Extract all declarations from either top level (i.e. top level declaration, not in a block statement)
        -- or from a block stmt, using getScopes and calling stmtToDecl on each entry in the statement list
        (mapMaybe topToDecl (topLevels program) ++
         mapMaybe
           stmtToDecl
           (concatMap getStmts $ mapMaybe topToStmt $ topLevels program))
    getStmts stmt =
      case stmt of
        BlockStmt stmts  -> stmts
        If _ s1 s2       -> [s1, s2]
        For _ s          -> [s]
        Switch _ _ cases -> map stmtFromCase cases
        _                -> []

progVerifyBlank :: PureConstraint Program
progVerifyBlank program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors = map blankVerify (topLevels program >>= toIdent)

blankVerify :: Identifier -> Maybe ErrorMessage'
blankVerify (Identifier o str) =
  if str == "_"
    then Just $ createError o InvalidBlankId
    else Nothing

programVerify :: PureConstraint Program
programVerify program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors =
      map
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

continueConstraint :: Stmt -> Maybe ErrorMessage'
continueConstraint (Continue o) = Just $ createError o ContinueScope
continueConstraint _            = Nothing

continueVerify :: PureConstraint Program
continueVerify program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors =
      map
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

breakConstraint :: Stmt -> Maybe ErrorMessage'
breakConstraint (Break o) = Just $ createError o BreakScope
breakConstraint _         = Nothing

breakVerify :: PureConstraint Program
breakVerify program = asum errors
  where
    errors :: [Maybe ErrorMessage']
    errors =
      map
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
  toIdent (TopFuncDecl (FuncDecl _ (Signature (Parameters pdl) Nothing) stmt)) =
    pdIdentl ++ stmtIdentl
    where
      pdIdentl = pdl >>= toIdent
      stmtIdentl = toIdent stmt
  toIdent (TopFuncDecl (FuncDecl _ (Signature (Parameters pdl) (Just t)) stmt)) =
    pdIdentl ++ stmtIdentl ++ toIdent t
    where
      pdIdentl = pdl >>= toIdent
      stmtIdentl = toIdent stmt
  toIdent (TopDecl d) = toIdent d

instance BlankWeed ParameterDecl where
  toIdent (ParameterDecl il _) = toList il

instance BlankWeed Stmt where
  toIdent (BlockStmt stmts) = stmts >>= toIdent
  toIdent (SimpleStmt stmt) = toIdent stmt
  toIdent (If (simp, e) s1 s2) =
    toIdent simp ++ toIdent e ++ toIdent s1 ++ toIdent s2
  toIdent (Switch simp (Just e) cases) =
    toIdent simp ++ toIdent e ++ (cases >>= toIdent)
  toIdent (Switch simp Nothing cases) = toIdent simp ++ (cases >>= toIdent)
  toIdent (For (ForClause simp1 (Just e) simp2) s) =
    toIdent e ++ toIdent simp1 ++ toIdent simp2 ++ toIdent s
  toIdent (For (ForClause simp1 Nothing simp2) s) =
    toIdent simp1 ++ toIdent simp2 ++ toIdent s
  toIdent (Declare d) = toIdent d
  toIdent (Print el) = el >>= toIdent
  toIdent (Println el) = el >>= toIdent
  toIdent (Return (Just e)) = toIdent e
  toIdent _ = []

instance BlankWeed SimpleStmt where
  toIdent (ExprStmt e)        = toIdent e
  toIdent (Increment _ e)     = toIdent e
  toIdent (Decrement _ e)     = toIdent e
  toIdent (Assign _ _ _ el)   = toList el >>= toIdent -- We don't care about identifiers on the LHS
  toIdent (ShortDeclare _ el) = toList el >>= toIdent -- Don't care about LHS
  toIdent _                   = []

instance BlankWeed Expr where
  toIdent (Unary _ _ e)        = toIdent e
  toIdent (Binary _ _ e1 e2)   = toIdent e1 ++ toIdent e2
  toIdent (Var ident)          = [ident]
  toIdent (LenExpr _ e)        = toIdent e
  toIdent (CapExpr _ e)        = toIdent e
  toIdent (Selector _ e ident) = ident : toIdent e
  toIdent (Index _ e1 e2)      = toIdent e1 ++ toIdent e2
  toIdent (Arguments _ e el)   = toIdent e ++ (el >>= toIdent)
  toIdent _                    = []

instance BlankWeed SwitchCase where
  toIdent (Case _ el s) = (toList el >>= toIdent) ++ toIdent s
  toIdent (Default _ s) = toIdent s

instance BlankWeed Decl where
  toIdent (VarDecl vdl) = vdl >>= toIdent
  toIdent (TypeDef tdl) = tdl >>= toIdent

instance BlankWeed VarDecl' where
  toIdent (VarDecl' _ (Left (t, el))) = toIdent t ++ (el >>= toIdent)
  toIdent (VarDecl' _ (Right el))     = toList el >>= toIdent

instance BlankWeed TypeDef' where
  toIdent (TypeDef' _ t) = toIdent t -- Don't care about idents on LHS

instance BlankWeed (Offset, Type) where
  toIdent (_, t) = toIdent t

instance BlankWeed Type where
  toIdent (ArrayType e t) = toIdent e ++ toIdent t
  toIdent (SliceType t) = toIdent t
  toIdent (StructType fdl) = fdl >>= toIdent
  toIdent (Type ident) = [ident]

instance BlankWeed FieldDecl where
  toIdent (FieldDecl _ t) = toIdent t

stmtFromCase :: SwitchCase -> Stmt
stmtFromCase (Case _ _ stmt)  = stmt
stmtFromCase (Default _ stmt) = stmt

data WeedingError
  = ListSizeMismatch
  | ExprStmtNotFunction
  | DuplicateDefault
  | ForPostDecl
  | InvalidBlankId
  | ContinueScope
  | BreakScope
  deriving (Show, Eq)

instance ErrorEntry WeedingError where
  errorMessage c =
    case c of
      ListSizeMismatch -> "LHS and RHS of assignments must be equal in length"
      ExprStmtNotFunction -> "Expression statements must be function calls"
      DuplicateDefault -> "Duplicate default found"
      InvalidBlankId -> "Invalid use of blank identifier"
      ForPostDecl -> "For post-statement cannot be declaration"
      ContinueScope -> "Continue statement must occur in for loop"
      BreakScope -> "Break statement must occur in for loop or switch statement"
