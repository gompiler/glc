{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeApplications      #-}

module Prettify
  ( Prettify(..)
  , checkPrettifyInvariance
  , tabS
  , tabSize
  ) where

import           Base
import qualified CheckedData        as C
import           Data
import           Data.List          (intercalate, null)
import           Data.List.NonEmpty (NonEmpty (..), toList)
import qualified Data.List.NonEmpty as NE (map, unzip)
import qualified Data.Maybe         as Maybe
import           Parser

checkPrettifyInvariance :: String -> Glc String
checkPrettifyInvariance input = do
  ast1 <- parse @Program input
  let pretty1 = prettify ast1
  ast2 <- parse @Program input
  let pretty2 = prettify ast2
  case (ast1 == ast2, pretty1 == pretty2) of
    (False, _) ->
      Left $
      createError' $ "AST mismatch:\n\n" ++ show ast1 ++ "\n\n" ++ show ast2
    (_, False) ->
      Left $ createError' $ "Prettify mismatch" ++ pretty1 ++ "\n\n" ++ pretty2
    _ -> Right pretty2

tabSize :: Int
tabSize = 4

tabS :: String
tabS = replicate tabSize ' '

tab :: [String] -> [String]
tab = map (tabS ++)

commaJoin :: Prettify a => [a] -> String
commaJoin p = intercalate ", " $ map prettify p

-- | Joins last line of first list with first line of last list with a space
skipNewLine :: [String] -> [String] -> [String]
skipNewLine = skipNewLineBase " "

-- | Joins last line of first list with first line of last list with the provided string in between
skipNewLineBase :: String -> [String] -> [String] -> [String]
skipNewLineBase _ [] a       = a
skipNewLineBase _ a []       = a
skipNewLineBase s [a] (b:b') = (a ++ s ++ b) : b'
skipNewLineBase s (a:a') b   = a : skipNewLineBase s a' b

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
  prettify' (Program (Identifier _ package') topLevels') =
    ("package " ++ package') : (topLevels' >>= (("" :) . prettify'))

instance Prettify TopDecl where
  prettify' (TopDecl decl)     = prettify' decl
  prettify' (TopFuncDecl decl) = prettify' decl

instance Prettify Decl where
  prettify' (VarDecl [])     = ["var ()"]
  prettify' (VarDecl [decl]) = ["var"] `skipNewLine` prettify' decl
  prettify' (VarDecl decls)  = "var (" : tab (decls >>= prettify') ++ [")"]
  prettify' (TypeDef [])     = ["type ()"]
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
  prettify' (TypeDef' ident t) = prettify' ident `skipNewLine` prettify' t

instance Prettify FuncDecl where
  prettify' (FuncDecl ident sig body) =
    skipNewLineBase
      ""
      ["func " ++ prettify ident]
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
  prettify' (Return _ m) = ["return"] `skipNewLine` maybe [] prettify' m

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

-- Note that generated string s fits within "for s{";
-- there is already a space beforehand but none after
instance Prettify ForClause where
  prettify (ForClause EmptyStmt Nothing EmptyStmt) = ""
  prettify (ForClause EmptyStmt (Just ce) EmptyStmt) = prettify ce ++ " "
  prettify (ForClause cs ce' s) =
    prettify cs ++
    "; " ++ Maybe.maybe "" prettify ce' ++ "; " ++ prettify s ++ " "
  prettify' = prettify''

instance Prettify (NonEmpty Expr) where
  prettify e = commaJoin $ toList e
  prettify' = prettify''

instance Prettify Expr where
  prettify (Unary _ o' e) = "(" ++ prettify o' ++ prettify e ++ ")"
  prettify (Binary _ o' e1 e2) =
    "(" ++ prettify e1 ++ " " ++ prettify o' ++ " " ++ prettify e2 ++ ")"
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
  prettify Or          = "||"
  prettify And         = "&&"
  prettify (Arithm o') = prettify o'
  prettify Data.EQ     = "=="
  prettify NEQ         = "!="
  prettify Data.LT     = "<"
  prettify LEQ         = "<="
  prettify Data.GT     = ">"
  prettify GEQ         = ">="
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
  prettify' (Type ident)      = [prettify ident]

--  prettify s@StructType {} = intercalate "; " $ prettify' s
instance Prettify FieldDecl where
  prettify' (FieldDecl idents t) = [prettify idents] `skipNewLine` prettify' t

instance Prettify C.Program where
  prettify' p = prettify' (toOrig p :: Program)

class ConvertAST a b where
  toOrig :: a -> b

o :: Offset
o = Offset 0

-- | Scoped identifier to identifier with offset
si2ident :: C.ScopedIdent -> Identifier
si2ident (C.ScopedIdent _ (C.Ident vname)) = Identifier o vname

-- | Scoped identifier to non empty idents with offsets
si2idents :: C.ScopedIdent -> Identifiers
si2idents si = (si2ident si) :| []

instance ConvertAST C.Program Program where
  toOrig (C.Program (C.Ident vname) tl) =
    Program (Identifier o vname) (map toOrig tl)

instance ConvertAST C.TopDecl TopDecl where
  toOrig (C.TopDecl d)      = TopDecl (toOrig d)
  toOrig (C.TopFuncDecl fd) = TopFuncDecl (toOrig fd)

instance ConvertAST C.Decl Decl where
  toOrig (C.VarDecl vdl) = VarDecl (map toOrig vdl)
  toOrig (C.TypeDef tdl) = TypeDef (Maybe.mapMaybe toOrig tdl)

instance ConvertAST C.VarDecl' VarDecl' where
  toOrig (C.VarDecl' si t (Just e)) =
    VarDecl' (si2idents si) (Left (toOrig t, [toOrig e]))
  toOrig (C.VarDecl' si t Nothing) =
    VarDecl' (si2idents si) (Left (toOrig t, []))

instance ConvertAST C.TypeDef' (Maybe TypeDef') where
  toOrig (C.TypeDef' si t) = Just $ TypeDef' (si2ident si) (toOrig t)
  toOrig C.NoDef           = Nothing

instance ConvertAST C.FuncDecl FuncDecl where
  toOrig (C.FuncDecl si sig fb) =
    FuncDecl (si2ident si) (toOrig sig) (toOrig fb)

instance ConvertAST C.ParameterDecl ParameterDecl where
  toOrig (C.ParameterDecl si t) = ParameterDecl (si2idents si) (toOrig t)

instance ConvertAST C.Parameters Parameters where
  toOrig (C.Parameters pdl) = Parameters (map toOrig pdl)

instance ConvertAST C.Signature Signature where
  toOrig (C.Signature params (Just t)) =
    Signature (toOrig params) (Just (toOrig t))
  toOrig (C.Signature params Nothing) = Signature (toOrig params) Nothing

instance ConvertAST C.SimpleStmt SimpleStmt where
  toOrig C.EmptyStmt = EmptyStmt
  toOrig (C.ExprStmt e) = ExprStmt (toOrig e)
  toOrig (C.Increment e) = Increment o (toOrig e)
  toOrig (C.Decrement e) = Decrement o (toOrig e)
  toOrig (C.Assign op eltup) =
    let (nel1, nel2) = NE.unzip eltup
     in Assign o (toOrig op) (NE.map toOrig nel1) (NE.map toOrig nel2)
  toOrig (C.ShortDeclare ideltup) =
    let (nsil, nel) = NE.unzip ideltup
     in ShortDeclare (NE.map si2ident nsil) (NE.map toOrig nel)

instance ConvertAST C.Stmt Stmt where
  toOrig (C.BlockStmt sl) = BlockStmt (map toOrig sl)
  toOrig (C.SimpleStmt ss) = SimpleStmt (toOrig ss)
  toOrig (C.If (ss, e) s1 s2) = If (toOrig ss, toOrig e) (toOrig s1) (toOrig s2)
  toOrig (C.Switch ss (Just e) scl) =
    Switch (toOrig ss) (Just (toOrig e)) (map toOrig scl)
  toOrig (C.Switch ss Nothing scl) = Switch (toOrig ss) Nothing (map toOrig scl)
  toOrig (C.For fcl s) = For (toOrig fcl) (toOrig s)
  toOrig C.Break = Break o
  toOrig C.Continue = Continue o
  toOrig (C.Declare d) = Declare (toOrig d)
  toOrig (C.Print el) = Print (map toOrig el)
  toOrig (C.Println el) = Println (map toOrig el)
  toOrig (C.Return (Just e)) = Return o (Just (toOrig e))
  toOrig (C.Return Nothing) = Return o Nothing

instance ConvertAST C.SwitchCase SwitchCase where
  toOrig (C.Case nle s) = Case o (NE.map toOrig nle) (toOrig s)
  toOrig (C.Default s)  = Default o (toOrig s)

instance ConvertAST C.ForClause ForClause where
  toOrig (C.ForClause ss1 (Just e) ss2) =
    ForClause (toOrig ss1) (Just (toOrig e)) (toOrig ss2)
  toOrig (C.ForClause ss1 Nothing ss2) =
    ForClause (toOrig ss1) Nothing (toOrig ss2)

instance ConvertAST C.Expr Expr where
  toOrig (C.Unary _ op e) = Unary o (toOrig op) (toOrig e)
  toOrig (C.Binary _ op e1 e2) = Binary o (toOrig op) (toOrig e1) (toOrig e2)
  toOrig (C.Lit lit) = Lit (toOrig lit)
  toOrig (C.Var _ si) = Var (si2ident si)
  toOrig (C.AppendExpr _ e1 e2) = AppendExpr o (toOrig e1) (toOrig e2)
  toOrig (C.LenExpr e) = LenExpr o (toOrig e)
  toOrig (C.CapExpr e) = CapExpr o (toOrig e)
  toOrig (C.Selector _ e (C.Ident vname)) =
    Selector o (toOrig e) (Identifier o vname)
  toOrig (C.Index _ e1 e2) = Index o (toOrig e1) (toOrig e2)
  toOrig (C.Arguments _ e el) = Arguments o (toOrig e) (map toOrig el)

instance ConvertAST C.Literal Literal where
  toOrig (C.IntLit i)    = IntLit o Decimal (show i)
  toOrig (C.FloatLit f)  = FloatLit o (show f)
  toOrig (C.RuneLit c)   = RuneLit o (show c)
  toOrig (C.StringLit s) = StringLit o Interpreted s

instance ConvertAST C.BinaryOp BinaryOp where
  toOrig op =
    case op of
      C.Or         -> Or
      C.And        -> And
      C.Arithm aop -> Arithm (toOrig aop)
      C.EQ         -> Data.EQ
      C.NEQ        -> NEQ
      C.LT         -> Data.LT
      C.LEQ        -> LEQ
      C.GT         -> Data.GT
      C.GEQ        -> GEQ

instance ConvertAST C.ArithmOp ArithmOp where
  toOrig op =
    case op of
      C.Add       -> Add
      C.Subtract  -> Subtract
      C.BitOr     -> BitOr
      C.BitXor    -> BitXor
      C.Multiply  -> Multiply
      C.Divide    -> Divide
      C.Remainder -> Remainder
      C.ShiftL    -> ShiftL
      C.ShiftR    -> ShiftR
      C.BitAnd    -> BitAnd
      C.BitClear  -> BitClear

instance ConvertAST C.UnaryOp UnaryOp where
  toOrig op =
    case op of
      C.Pos           -> Pos
      C.Neg           -> Neg
      C.Not           -> Not
      C.BitComplement -> BitComplement

instance ConvertAST C.AssignOp AssignOp where
  toOrig (C.AssignOp (Just op)) = AssignOp (Just (toOrig op))
  toOrig (C.AssignOp Nothing)   = AssignOp Nothing

instance ConvertAST C.Type Type' where
  toOrig t = (o, toOrig t)

instance ConvertAST C.Type Type where
  toOrig (C.ArrayType i t) =
    ArrayType (Lit (IntLit o Decimal (show i))) (toOrig t)
  toOrig (C.SliceType t) = SliceType (toOrig t)
  toOrig (C.StructType fdl) = StructType (map toOrig fdl)
  toOrig C.PInt = Type (Identifier o "int")
  toOrig C.PFloat64 = Type (Identifier o "float64")
  toOrig C.PBool = Type (Identifier o "bool")
  toOrig C.PRune = Type (Identifier o "rune")
  toOrig C.PString = Type (Identifier o "string")

instance ConvertAST C.FieldDecl FieldDecl where
  toOrig (C.FieldDecl (C.Ident vname) t) =
    FieldDecl (Identifier o vname :| []) (toOrig t)
