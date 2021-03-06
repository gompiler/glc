{-# LANGUAGE QuasiQuotes      #-}
{-# LANGUAGE TypeApplications #-}

module ParserSpec
  ( spec
  ) where

import           Data               as D
import           Data.List.NonEmpty (fromList)
import           Data.List.Split    (splitOn)
import           Parser
import           TestBase
import           Token              (InnerToken (..))
import qualified TokensSpec         as T

{-# ANN module "HLint: ignore Redundant do" #-}

qcGenMatch :: Parsable p => (String, p) -> Bool
qcGenMatch (s, out) = parse s == Right out

-- | Spec template listing some expected tests; not yet implemented
spec :: Spec
spec = do
  describe "Identifiers" $ do
    qcGen
      "ident list"
      False
      (genCommaList T.genId)
      (\x -> parse x == (Right $ fromList $ map (Identifier o) (splitOn "," x)))
  describe "Expressions" $ do
    qcGen "basic expressions" False genEBase qcGenMatch
    qcGen "binary expressions" False genEBin qcGenMatch
    qcGen "unary expressions" False genEUn qcGenMatch
  -- Though a single identifier is valid, we parse it without going through the identifiers type
  expectPass
    @Identifiers
    -- Basic
    ["a, b", "a, b, c, d, e"]
  expectFail @Identifiers ["", ",", "a,", ",b", "a,,c", "0"]
  expectPass
    @Type'
    ["asdf", "int", "a0", "_0a", "[3]string", "[0x12]string", "[0123]string"]
  expectFail
    @Type'
    [ "0"
    , "-"
    , "*"
    , "int int"
    -- Only int literals allowed
    , "[1 + 2]string"
    , "[2.0]float"
    , "[a]string"
    , "[\"a\"]string"
    , "['a']string"
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
    , "type ()"
    , "func f(a, b, c string) { }"
    ]
  expectError
    @TopDecl
      -- Missing semicolon
    [ ("var a", ParseError TSemicolon)
      -- Format should be 'type a b'
    , ("type a = b", ParseError TAssn)
      -- Func must have name
    , ("func () { }", ParseError TLParen)
    , ("func a(b, c) { }", ParseError TRParen)
      -- Must have body
    , ("func f(a b)", ParseError TSemicolon)
      -- No variadic types
    , ("func f(a, b, c ...int)", ParseError TLdots)
      -- No need for semicolon rule 2
    , ("type (a b)", ParseError TRParen)
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
          (Binary
             o
             (Arithm Multiply)
             (Lit (IntLit o Decimal "2"))
             (Lit (IntLit o Decimal "3"))))
    , ( "1 * (2 + 3)"
      , Binary
          o
          (Arithm Multiply)
          (Lit (IntLit o Decimal "1"))
          (Binary
             o
             (Arithm Add)
             (Lit (IntLit o Decimal "2"))
             (Lit (IntLit o Decimal "3"))))
    , ( "2 < +a || 2 * 4"
      , Binary
          o
          Or
          (Binary
             o
             D.LT
             (Lit (IntLit o Decimal "2"))
             (Unary o Pos (Var (Identifier o "a"))))
          (Binary
             o
             (Arithm Multiply)
             (Lit (IntLit o Decimal "2"))
             (Lit (IntLit o Decimal "4"))))
    , ( "-2 ^ 5"
      , Binary
          o
          (Arithm BitXor)
          (Unary o Neg (Lit (IntLit o Decimal "2")))
          (Lit (IntLit o Decimal "5")))
    ]
  expectFail
    @Expr
    -- Two inputs only; no override
    [ "append(a, b, c)"
    , "a[[]"
    -- One char only in rune
    , "'aa'"
    , "090"
    , "0xG"
    , "00x0"
    ]
  expectPass @Stmt $
    [ "{}"
    -- , "{{{}}}"
    -- , "{{{/* nested */}}}"
    , "var a string"
    , "a++"
    , "b--"
    , "c := 2"
    -- , "c := 2; (a + b)++"
    , "if a { c++ \n}"
    , "if a := 2; b { } else if 0 < 1 { c-- \n}"
    , "for ;; { }"
    , "for ; a; { }"
    , "for ;; a++{ }"
    , "for a:= 0;;{ }"
    , "for a:= 0; a < 3;{ }"
    , "for a:= 0;; a++{ }"
    , "for a < 5 { }"
    , "for a := 2; a < 5; a++ { }"
    , "for { }"
    ] ++
    intExamples ++ floatExamples ++ map (\s -> "'" ++ s ++ "'") runeExamples
  expectPass @Stmt stmtExamples
  expectFail @Stmt $ map (\s -> "{" ++ s ++ "}") ["/*", "/**", "/* /* */ */"]
  expectFail @Stmt ["a, b := 1", "a := 1, 2"]
  expectPass
    @Signature
    [ "(a int)"
    , "(a int) int"
    , "(a int, b int) int"
    , "(a, b, c string) []string"
    , "(a struct {\na int\n}, b [9]a)"
    ]
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

genCommaList ::
     Gen String -- ^ What we will be comma separating
  -> Gen String
genCommaList f =
  oneof
    [ f >>= \s1 -> f >>= \s2 -> return $ s1 ++ ',' : s2
    , (++) <$> f <*> genCommaList f
    ]

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
  (sop, op) <-
    elements [("+", Pos), ("-", Neg), ("!", Not), ("^", BitComplement)]
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
          T.genId >>= \id2 ->
            return
              ( id1 ++ '.' : id2
              , Selector o (Var $ Identifier o id1) $ Identifier o id2))
    ]
