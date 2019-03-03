{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TypeApplications     #-}
{-# LANGUAGE TypeSynonymInstances #-}

module PrettifySpec
  ( spec
  ) where

import           Base
import           Data
import           Prettify

spec :: Spec
spec = do
  expectPrettyInvar @Identifiers ["a, b"]
  expectPrettyInvar
    @Expr
    [ "1 + 2 * 3"
    , "(((2))) * abc - _s"
    , "index[0]"
    , "-a"
    -- All bin ops
    , "1 || 1 && 1 == 1 != 1 < 1 <= 1 > 1 >= 1 + 1 - 1 | 1 ^ 1 * 1 / 1 % 1 << 1 >> 1 & 1 &^ 1"
    , "+1 && -1 && !1 && ^1"
    ]
  expectPrettyInvar @Type' ["asdf", "struct {a int; b int;}", "[0][0]a"]
  expectPrettyInvar @TopDecl topDeclExamples
  expectPrettyInvar @Stmt stmtExamples
  expectPrettyInvar @Program programExamples
  expectPrettyExact
    @Program
    [ [text|
      package top

      type (
        num int
        point struct {
          x, y float64
          a struct {
            x, y float64
          }
        }
        a []b
        c [2]d
      )

      type a int

      var (
        a, b = 2, 3
        c string
      )

      var a string

      |]
    , [text|
      package f

      func f() {
      }

      func fs(a, b int) int {
      }
      |]
    ]

intLit =
  map
    (\(i, e) -> (IntLit o i e, e))
    [(Decimal, "12"), (Hexadecimal, "0xCAFEBABE"), (Octal, "01001")]

floatLit =
  fstConvert (FloatLit o) [("0.123", "0.123"), ("0.0", "0.0"), ("-1.0", "-1.0")]

stringLitInterpreted =
  map
    (\i -> (StringLit o Interpreted $ wrap i, wrap i))
    ["hello", "world", "\"", "new\nline"]
  where
    wrap s = "\"" ++ s ++ "\""

stringLitRaw =
  map
    (\i -> (StringLit o Raw $ wrap i, wrap i))
    ["hello", "world", "\"", "new\nline"]
  where
    wrap s = "`" ++ s ++ "`"

baseId = Identifier o "test"

baseId' = "test"

baseType = (o, SliceType $ Type baseId)

baseType' = "[]" ++ baseId'

baseExpr = Unary o Neg $ Var baseId

baseExpr' = "(-" ++ baseId' ++ ")"

exprs =
  [ (baseExpr, baseExpr')
  , (Unary o Pos baseExpr, "(+" ++ baseExpr' ++ ")")
  , ( Binary o LEQ baseExpr baseExpr
    , "(" ++ baseExpr' ++ " <= " ++ baseExpr' ++ ")")
  , (Lit (RuneLit o "'c'"), "'c'")
  , (Var baseId, baseId')
  , ( AppendExpr o baseExpr baseExpr
    , "append(" ++ baseExpr' ++ ", " ++ baseExpr' ++ ")")
  , (LenExpr o baseExpr, "len(" ++ baseExpr' ++ ")")
  , (CapExpr o baseExpr, "cap(" ++ baseExpr' ++ ")")
  , (Selector o baseExpr baseId, baseExpr' ++ "." ++ baseId')
  , (Index o baseExpr baseExpr, baseExpr' ++ "[" ++ baseExpr' ++ "]")
  , ( Arguments o baseExpr [baseExpr, baseExpr, baseExpr]
    , baseExpr' ++
      "(" ++ baseExpr' ++ ", " ++ baseExpr' ++ ", " ++ baseExpr' ++ ")")
  ]
