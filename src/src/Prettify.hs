{-# LANGUAGE FlexibleInstances #-}

module Prettify
  ( Prettify(..)
  , checkPrettifyInvariance
  ) where

import           Data
import           Data.List          (intercalate, null)
import           Data.List.NonEmpty (NonEmpty (..), toList)
import qualified Data.Maybe         as Maybe
import           Parser             (parse)

checkPrettifyInvariance :: String -> Either String String
checkPrettifyInvariance input = do
  ast1 <- parse input
  let pretty1 = prettify ast1
  ast2 <- parse input
  let pretty2 = prettify ast2
  case (ast1 == ast2, pretty1 == pretty2) of
    (False, _) -> Left $ "AST mismatch:\n\n" ++ show ast1 ++ "\n\n" ++ show ast2
    (_, False) -> Left $ "Prettify mismatch" ++ pretty1 ++ "\n\n" ++ pretty2
    _ -> Right pretty2

tab :: [String] -> [String]
tab = map ("    " ++)

commaJoin :: Prettify a => [a] -> String
commaJoin p = intercalate ", " $ map prettify p

-- | Joins last line of first list with first line of last list with a space
skipNewLine :: [String] -> [String] -> [String]
[] `skipNewLine` a = a
a `skipNewLine` [] = a
[a] `skipNewLine` (b:b') = (a ++ " " ++ b) : b'
(a:a') `skipNewLine` b = a : a' `skipNewLine` b

-- | Some prettified components span a single line
-- In that case, we can implement prettify by default
-- And use this function to derive the list format from the string format
prettify'' :: Prettify a => a -> [String]
prettify'' item = [prettify item]

class Prettify a where
  prettify :: a -> String
  prettify = intercalate "\n" . prettify'
  prettify' :: a -> [String]

instance Prettify Identifier where
  prettify (Identifier _ ident) = ident
  prettify' = prettify''

instance Prettify Identifiers where
  prettify idents = commaJoin $ toList idents
  prettify' = prettify''

instance Prettify Program where
  prettify' (Program package' topLevels') =
    ("package " ++ package') : (topLevels' >>= (("" :) . prettify'))

instance Prettify TopDecl where
  prettify' (TopDecl decl)     = prettify' decl
  prettify' (TopFuncDecl decl) = prettify' decl

instance Prettify Decl where
  prettify' (VarDecl [decl]) = ["var"] `skipNewLine` prettify' decl
  prettify' (VarDecl decls)  = "var (" : tab (decls >>= prettify') ++ [")"]
  prettify' (TypeDef [def])  = ["type"] `skipNewLine` prettify' def
  prettify' (TypeDef defs)   = "type (" : tab (defs >>= prettify') ++ [")"]

instance Prettify VarDecl' where
  prettify (VarDecl' idents (Left (t, exprs))) =
    prettify idents ++ " " ++ prettify t ++ exprs'
    where
      exprs' =
        if null exprs
          then ""
          else " = " ++ prettify exprs
  prettify (VarDecl' idents (Right exprs)) =
    prettify idents ++ " = " ++ intercalate ", " (map prettify $ toList exprs)
  prettify' = prettify''

instance Prettify TypeDef' where
  prettify (TypeDef' ident t) = prettify ident ++ " " ++ prettify t
  prettify' = prettify''

instance Prettify FuncDecl where
  prettify' (FuncDecl ident sig body) =
    ["func " ++ prettify ident] `skipNewLine`
    (prettify' sig `skipNewLine` ["{"]) ++
    tab (prettify' body) ++ ["}"]

instance Prettify ParameterDecl where
  prettify (ParameterDecl idents t) = prettify idents ++ " " ++ prettify t
  prettify' = prettify''

instance Prettify [ParameterDecl] where
  prettify' params = prettify' $ Parameters params

instance Prettify Parameters where
  prettify (Parameters params) = commaJoin params
  prettify' = prettify''

instance Prettify Signature where
  prettify' (Signature params t) =
    ["(" ++ prettify params ++ ")" ++ Maybe.maybe "" ((' ' :) . prettify) t]

--instance Prettify Scope
instance Prettify SimpleStmt where
  prettify' EmptyStmt = []
  prettify' (ExprStmt e) = prettify' e
  prettify' (Increment _ e) = ["(" ++ prettify e ++ ")++"]
  prettify' (Decrement _ e) = ["(" ++ prettify e ++ ")--"]
  prettify' (Assign _ op e1 e2) =
    [prettify e1 ++ " " ++ prettify op ++ " " ++ prettify e2]
  prettify' (ShortDeclare idents exprs) =
    [prettify idents ++ " := " ++ prettify exprs]

instance Prettify Stmt where
  prettify' (BlockStmt stmts) = stmts >>= prettify'
  prettify' (SimpleStmt s) = prettify' s
  prettify' (If c i e) = ("if " ++ prettify c ++ " {") : i' ++ e'
    where
      i' = tab $ prettify' i
      e' =
        case e of
          If {}                -> ["} else"] `skipNewLine` prettify' e -- Else If
          SimpleStmt EmptyStmt -> ["}"] -- No real else block, don't print anything
          _                    -> "} else {" : tab (prettify' e) ++ ["}"]
  prettify' (Switch ss se cases) =
    ("switch " ++ ss' ++ "{") : tab (cases >>= prettify') ++ ["}"]
    where
      ss' =
        case (ss, se) of
          (_, Just se')        -> prettify (ss, se') ++ " "
          (EmptyStmt, Nothing) -> ""
          (_, Nothing)         -> prettify ss ++ "; "
  prettify' (For fc s) =
    ("for " ++ prettify fc ++ "{") : tab (prettify' s) ++ ["}"]
  prettify' (Break _) = ["break"]
  prettify' (Continue _) = ["continue"]
  -- prettify' (Fallthrough _) = ["fallthrough"]
  prettify' (Declare d) = prettify' d
  prettify' (Print es) =
    ["print(" ++ intercalate ", " (es >>= prettify') ++ ")"]
  prettify' (Println es) =
    ["println(" ++ intercalate ", " (es >>= prettify') ++ ")"]
  prettify' (Return m) = ["return"] `skipNewLine` maybe [] prettify' m

instance Prettify SwitchCase where
  prettify' (Case _ e s)  = ("case " ++ prettify e ++ ":") : tab (prettify' s)
  prettify' (Default _ s) = "default:" : tab (prettify' s)

instance Prettify (SimpleStmt, Expr) where
  prettify (EmptyStmt, e) = prettify e
  prettify (s, e)         = prettify s ++ "; " ++ prettify e
  prettify' = prettify''

instance Prettify [Expr] where
  prettify = commaJoin
  prettify' = prettify''

instance Prettify ForClause where
  prettify ForInfinite = ""
  prettify (ForCond e) = prettify e ++ " "
  prettify (ForClause cs ce s) =
    prettify cs ++ "; " ++ prettify ce ++ "; " ++ prettify s ++ " "
  prettify' = prettify''

instance Prettify (NonEmpty Expr) where
  prettify e = commaJoin $ toList e
  prettify' = prettify''

instance Prettify Expr where
  prettify (Unary _ o e) = "(" ++ prettify o ++ prettify e ++ ")"
  prettify (Binary _ o e1 e2) =
    "(" ++ prettify e1 ++ " " ++ prettify o ++ " " ++ prettify e2 ++ ")"
  prettify (Lit l) = prettify l
  prettify (Var i) = prettify i
  prettify (AppendExpr _ e1 e2) =
    "append(" ++ prettify e1 ++ ", " ++ prettify e2 ++ ")"
  prettify (LenExpr _ e) = "len(" ++ prettify e ++ ")"
  prettify (CapExpr _ e) = "cap(" ++ prettify e ++ ")"
  prettify (Selector _ e i) = prettify e ++ "." ++ prettify i
  prettify (Index _ e1 e2) = prettify e1 ++ "[" ++ prettify e2 ++ "]"
  prettify (Arguments _ e ee) = prettify e ++ "(" ++ commaJoin ee ++ ")"
  prettify' = prettify''

instance Prettify Literal where
  prettify (IntLit _ _ i)              = i
  prettify (FloatLit _ f)              = f
  -- Quotes within string s
  prettify (RuneLit _ s)               = s
  -- Quotes within string s
  prettify (StringLit _ Interpreted s) = s
  -- Quotes within string s
  prettify (StringLit _ Raw s)         = s
  prettify' = prettify''

instance Prettify BinaryOp where
  prettify Or         = "||"
  prettify And        = "&&"
  prettify (Arithm o) = prettify o
  prettify Data.EQ    = "=="
  prettify NEQ        = "!="
  prettify Data.LT    = "<"
  prettify LEQ        = "<="
  prettify Data.GT    = ">"
  prettify GEQ        = ">="
  prettify' = prettify''

instance Prettify ArithmOp where
  prettify Add       = "+"
  prettify Subtract  = "-"
  prettify BitOr     = "|"
  prettify BitXor    = "^"
  prettify Multiply  = "*"
  prettify Divide    = "/"
  prettify Remainder = "%"
  prettify ShiftL    = "<<"
  prettify ShiftR    = ">>"
  prettify BitAnd    = "&"
  prettify BitClear  = "&^"
  prettify' = prettify''

instance Prettify UnaryOp where
  prettify Pos           = "+"
  prettify Neg           = "-"
  prettify Not           = "!"
  prettify BitComplement = "^"
  prettify' = prettify''

instance Prettify AssignOp where
  prettify (AssignOp op) = Maybe.maybe "" prettify op ++ "="
  prettify' = prettify''

instance Prettify IntType' where
  prettify' _ = []

instance Prettify StringType' where
  prettify' _ = []

instance Prettify Type' where
  prettify' (_, t) = prettify' t

instance Prettify Type where
  prettify' (ArrayType e t)   = ["[" ++ prettify e ++ "]" ++ prettify t]
  prettify' (StructType fdls) = "struct {" : tab (fdls >>= prettify') ++ ["}"]
  prettify' (SliceType t)     = ["[]" ++ prettify t]
  prettify' (FuncType s)      = ["func" ++ prettify s]
  prettify' (Type ident)      = [prettify ident]

--  prettify s@StructType {} = intercalate "; " $ prettify' s
instance Prettify FieldDecl where
  prettify' (FieldDecl idents t) = [prettify idents] `skipNewLine` prettify' t
