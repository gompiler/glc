{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TypeApplications  #-}

module ParserSpec
  ( spec
  ) where

import           Base
import           Data               as D
import           Parser
import           Scanner
import qualified TokensSpec         as T

import qualified Data.Either        as Either
import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
import           Data.List.Split    (splitOn)

{-# ANN module "HLint: ignore Redundant do" #-}

-- | Spec template listing some expected tests; not yet implemented
spec :: Spec
spec = do
  describe "Identifiers" $ do
    qcGen
      "ident list"
      False
      (genCommaList T.genId)
      (\x -> scanToP pId x == (Right $ reverse $ map (Identifier o) (splitOn "," x)))
  describe "Expressions" $ do
    qcGen "basic expressions" False genEBase (\(s, out) -> scanToP pE s == Right out)
    qcGen "binary expressions" False genEBin (\(s, out) -> scanToP pE s == Right out)
    qcGen "unary expressions" False genEUn (\(s, out) -> scanToP pE s == Right out)
  -- Though a single identifier is valid, we parse it without going through the identifiers type
  expectPass
    @Identifiers
    -- Basic
    ["a, b", "a, b, c, d, e"]
  expectFail @Identifiers ["", ",", "a,", ",b", "a,,c", "0"]
  expectPass @Type' ["asdf", "int", "a0", "_0a"]
  expectFail
    @Type'
    [ "0"
    , "-"
    , "*"
    -- TODO FullParser
    -- int int
    ]
  expectPass
    @TopDecl
    -- Basic
    [ "var a string"
    , "var int a"
    , "var ()"
    , "var(\n\n\n\t)"
    , "type a b"
    , "type (a int\n)"
    , "type ( a b; c d\n)"
    , "func f(a, b, c string) { }"
    ]
  expectFail
    @TopDecl
    [ "var a"
    , "type a = b"
    -- Must have type
    , "func (a, b, c) { }"
    -- Must have body
    , "func (a, b)"
    -- No variadic types
    , "func (a, b, c ...int)"
    -- No need for semicolon rule 2
    , "type (a b)"
    ]
  expectPass @Stmt ["if true { }"]
  expectPass
    @Expr
    -- Basic
    [ "a"
    , "-a"
    , "+abc"
    , "-(a + c * d) / a"
    , "`raw string`"
    , "append(a, 0 + 2)"
    , "len(array)"
    , "cap(array)"
    , "a.b"
    , "a[0 + 2]"
    , "a(b, c, d)"
    -- Advanced
    , "a.b(a[0] + c.d, 0, \"asdf\", 'a')[0]"
    ]
  expectAst
    @Expr
    [ ( "1 + 2 * 3"
      , Binary
          o
          (Arithm Add)
          (Lit (IntLit o Decimal "1"))
          (Binary o (Arithm Multiply) (Lit (IntLit o Decimal "2")) (Lit (IntLit o Decimal "3"))))
    , ( "1 * (2 + 3)"
      , Binary
          o
          (Arithm Multiply)
          (Lit (IntLit o Decimal "1"))
          (Binary o (Arithm Add) (Lit (IntLit o Decimal "2")) (Lit (IntLit o Decimal "3"))))
    , ( "2 < +a || 2 * 4"
      , Binary
          o
          Or
          (Binary o D.LT (Lit (IntLit o Decimal "2")) (Unary o Pos (Var (Identifier o "a"))))
          (Binary o (Arithm Multiply) (Lit (IntLit o Decimal "2")) (Lit (IntLit o Decimal "4"))))
    ]
  expectFail
    @Expr
    -- Two inputs only; no override
    [ "append(a, b, c)"
    , "a[[]"
    -- One char only in rune
    , "'aa'"
    --    , "090"
    --    , "0xG"
    --    , "00x0"
    ]
  expectPass @Stmt $
    [ "{}"
    -- , "{{{}}}"
    -- , "{{{/* nested */}}}"
    , "var a string"
    , "a++"
    , "b--"
    , "c := 2"
    , "c := 2;; (a + b)++"
    , "if a { c++ \n}"
    , "if a := 2; b { } else if 0 < 1 { c-- \n}"
    ] ++
    intExamples ++ floatExamples ++ map (\s -> "'" ++ s ++ "'") runeExamples
  expectPass @Stmt stmtExamples
  expectFail @Stmt $ map (\s -> "{" ++ s ++ "}") ["/*", "/**", "/* /* */ */"]
  expectPass
    @Signature
    ["(a int)", "(a int) int", "(a int, b int) int", "(a, b, c string) []string", "(a struct {\na int\n}, b [9]a)"]
  expectFail @Signature ["(a)", "(a int, b ...int)"]
  expectPass @Program programExamples
  expectFail
    @Program
    [ [text|
      package a

      func f(a int) int int {

      }
      |]
    ]
  where
    blankExpr = Var $ Identifier o "temp"
    blankStmt = blank

programMain :: [(String, FuncBody)]
programMain = [("", BlockStmt [])]

programMainL :: [(String, String)]
programMainL = [("", ""), ("var a = !!!!!! false;", "")]

programE :: [(String, Program)]
programE =
  map
    (\(s, body) ->
       ( "package main; func main(){" ++ s ++ "}"
       , Program
           { package = "main"
           , topLevels = [TopFuncDecl (FuncDecl (Identifier o "main") (Signature (Parameters []) Nothing) body)]
           }))
    programMain

programEL :: [(String, String)]
programEL = map (\(s, err) -> ("package main; func main(){" ++ s ++ "}", err)) programMainL

genCommaList ::
     Gen String -- ^ What we will be comma separating
  -> Gen String
genCommaList f = oneof [f >>= \s1 -> f >>= \s2 -> return $ s1 ++ ',' : s2, (++) <$> f <*> genCommaList f]

genEBase :: Gen (String, Expr)
genEBase =
  oneof
    [ T.genId >>= toTup (Var . Identifier o)
    , T.genNum >>= toTup (Lit . IntLit o Decimal)
    , T.genOct >>= toTup (Lit . IntLit o Octal)
    , T.genHex >>= toTup (Lit . IntLit o Hexadecimal)
    , T.genFloat >>= toTup (Lit . FloatLit o)
    , T.genChar >>= toTup (Lit . RuneLit o)
    , T.genString >>= toTup (Lit . StringLit o Interpreted)
    , T.genRString >>= toTup (Lit . StringLit o Raw)
    ]
  where
    toTup constr s = return (s, constr s)

genEBin :: Gen (String, Expr)
genEBin = do
  (s1, e1) <- genEBase
  (s2, e2) <- genEBase
  (sop, op) <-
    elements
      [ ("||", Or)
      , ("&&", And)
      , ("==", D.EQ)
      , ("!=", NEQ)
      , ("<", D.LT)
      , ("<=", LEQ)
      , (">", D.GT)
      , (">=", GEQ)
      , ("+", Arithm Add)
      , ("-", Arithm Subtract)
      , ("*", Arithm Multiply)
      , ("/", Arithm Divide)
      , ("%", Arithm Remainder)
      , ("|", Arithm BitOr)
      , ("^", Arithm BitXor)
      , ("&", Arithm BitAnd)
      , ("&^", Arithm BitClear)
      , ("<<", Arithm ShiftL)
      , (">>", Arithm ShiftR)
      ]
  return (s1 ++ sop ++ s2, Binary o op e1 e2)

genEUn1 :: Gen (String, Expr)
genEUn1 = do
  (s, e) <- genEBase
  (sop, op) <- elements [("+", Pos), ("-", Neg), ("!", Not), ("^", BitComplement)]
  return (sop ++ s, Unary o op e)

genEUn2 :: Gen (String, Expr)
genEUn2 = do
  (s, e) <- genEBase
  (sop, op) <- elements [("len (", LenExpr), ("cap (", CapExpr)]
  return (sop ++ s ++ ")", op o e)

genEUn :: Gen (String, Expr)
genEUn =
  frequency
    [ (4, genEUn1)
    , (2, genEUn2)
    , (1, genEBase >>= \(s, e) -> return ('(' : s ++ ")", e))
    , ( 1
      , T.genId >>= \id1 ->
          T.genId >>= \id2 -> return (id1 ++ '.' : id2, Selector o (Var $ Identifier o id1) $ Identifier o id2))
    ]

genE :: Gen (String, Expr)
genE = oneof [genEBase, genEUn, genEBin]

expectEL :: [(String, [Expr])]
expectEL =
  [ ("123, 888", (Lit $ IntLit o Decimal "123") : [Lit $ IntLit o Decimal "888"])
  , ("123, 88.8", (Lit $ IntLit o Decimal "123") : [Lit $ FloatLit o "88.8"])
  ]
