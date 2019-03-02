{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TypeApplications     #-}
{-# LANGUAGE TypeSynonymInstances #-}

module PrettifySpec
  ( spec
  ) where

import           NeatInterpolation

import           Base
import           Data
import           Debug.Trace       (trace)
import           Prettify

spec :: Spec
spec = do
  expectPrettyInvar @Identifiers ["a, b"]
  expectPrettyInvar @Expr ["1 + 2 * 3", "(((2))) * abc - _s", "index[0]", "-a"]
  expectPrettyInvar @Type' ["asdf", "struct {a int; b int;}"]
  expectPrettyInvar
    @TopDecl
    [ [text|
      type bb struct {
        b int
        c, d float64
        e struct {
          f int
          g, h int
        }
      }
      |],
      [text|
      func whatever() struct { int n; } {
      }
      |]
    ]
  printError $
    prettify <$>
    parse
      @TopDecl
      [text|
      func whatever() struct { int n; } { }
      |]

intLit = map (\(i, e) -> (IntLit o i e, e)) [(Decimal, "12"), (Hexadecimal, "0xCAFEBABE"), (Octal, "01001")]

floatLit = fstConvert (FloatLit o) [("0.123", "0.123"), ("0.0", "0.0"), ("-1.0", "-1.0")]

stringLitInterpreted = map (\i -> (StringLit o Interpreted $ wrap i, wrap i)) ["hello", "world", "\"", "new\nline"]
  where
    wrap s = "\"" ++ s ++ "\""

stringLitRaw = map (\i -> (StringLit o Raw $ wrap i, wrap i)) ["hello", "world", "\"", "new\nline"]
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
  , (Binary o LEQ baseExpr baseExpr, "(" ++ baseExpr' ++ " <= " ++ baseExpr' ++ ")")
  , (Lit (RuneLit o "'c'"), "'c'")
  , (Var baseId, baseId')
  , (AppendExpr o baseExpr baseExpr, "append(" ++ baseExpr' ++ ", " ++ baseExpr' ++ ")")
  , (LenExpr o baseExpr, "len(" ++ baseExpr' ++ ")")
  , (CapExpr o baseExpr, "cap(" ++ baseExpr' ++ ")")
  , (Conversion o baseType baseExpr, baseType' ++ "(" ++ baseExpr' ++ ")")
  , (Selector o baseExpr baseId, baseExpr' ++ "." ++ baseId')
  , (Index o baseExpr baseExpr, baseExpr' ++ "[" ++ baseExpr' ++ "]")
  , (TypeAssertion o baseExpr baseType, baseExpr' ++ ".(" ++ baseType' ++ ")")
  , ( Arguments o baseExpr [baseExpr, baseExpr, baseExpr]
    , baseExpr' ++ "(" ++ baseExpr' ++ ", " ++ baseExpr' ++ ", " ++ baseExpr' ++ ")")
  ]
