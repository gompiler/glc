{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module PrettifySpec
  ( spec
  ) where

import NeatInterpolation

import Base
import Data
import Prettify

instance (Prettify a, Show a) => SpecBuilder a String () where
  expectation ast s = it (show ast) $ prettify ast `shouldBe` s

shouldPrettifyTo' :: (HasCallStack, Prettify a) => a -> Text -> Expectation
ast `shouldPrettifyTo'` s = prettify ast `shouldBe` unpack s

spec :: Spec
spec = do
  litSpec
  exprSpec

litSpec :: SpecWith ()
litSpec =
  describe "Literals" $ do
    specAll "IntLit" intLit
    specAll "FloatLit" floatLit
    specAll "StringLit Interpreted" stringLitInterpreted
    specAll "StringLit Raw" stringLitRaw

intLit = map (\(i, e) -> (IntLit o i e, e)) [(Decimal, "12"), (Hexadecimal, "0xCAFEBABE"), (Octal, "01001")]

floatLit = fstConvert (FloatLit o) [(0.123, "0.123"), (0.0, "0.0"), (-1.0, "-1.0")]

stringLitInterpreted = map (\i -> (StringLit o Interpreted $ wrap i, wrap i)) ["hello", "world", "\"", "new\nline"]
  where
    wrap s = "\"" ++ s ++ "\""

stringLitRaw = map (\i -> (StringLit o Raw $ wrap i, wrap i)) ["hello", "world", "\"", "new\nline"]
  where
    wrap s = "`" ++ s ++ "`"

exprSpec :: SpecWith ()
exprSpec = specAll "Expr" exprs

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
  , (Lit (RuneLit o 'c'), "'c'")
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