{-# LANGUAGE QuasiQuotes       #-}
module TypeInferenceSpec
  ( spec
  ) where

import Control.Monad.ST
import Base          (expectBase, toString, Stringable(..))
import Data          (Expr)
import ErrorBundle
import Parser        (parse)
import Test.Hspec
import Symbol
import qualified SymbolTable        as SymTab (new)
import TypeInference (infer)

parseAndInferNoST :: String -> Either ErrorMessage SType
parseAndInferNoST expStr =
  either
    (Left)
    runExpr
    parseResult
  where
    errgen e = e expStr `withPrefix` "typinf error"
    parseResult :: Either ErrorMessage Expr
    parseResult = parse expStr
    runExpr :: Expr -> Either ErrorMessage SType
    runExpr e =
      runST $ do
        st <- SymTab.new
        infer st e >>= (\et -> return $ either (Left . errgen) Right et)

expectPass :: Stringable s => [(s, SType)]  -> SpecWith ()
expectPass = expectBase
             "success"
             (\(s, etyp) ->
                 case parseAndInferNoST (toString s) of
                   Left err ->            expectationFailure $
                     "Expected typeinf success on:\n\n" ++
                     toString s ++ "\n\nbut failed with\n\n" ++ show err
                   Right rtyp -> if etyp == rtyp
                      then return ()
                      else expectationFailure $
                        "Expected typeinf success on:\n\n" ++
                        toString s ++ "\n\nbut failed with\n\nexpected " ++
                        show etyp ++ ", got " ++ show rtyp)
              (\(s, _) -> toString s)
             "typeinf"

expectFail :: Stringable s => [s] -> SpecWith ()
expectFail = expectBase
             "fail"
             (\s ->
                 case parseAndInferNoST (toString s) of
                   Right styp ->            expectationFailure $
                     "Expected typeinf failure on:\n\n" ++
                     toString s ++ "\n\nbut succeeded with\n\n" ++ show styp
                   _ -> return ())
             toString
             "typeinf"

spec :: Spec
spec = do
  expectPass
    [ ("false || false", PBool)
    , ("false && false", PBool)
    , ("5 + 6", PInt)
    , ("5.5 + 6.6", PFloat64)
    , ("'a' + 'b'", PRune)
    , ("\"a\" + \"b\"", PString)

    -- Identity casts
    , ("int(5)", PInt)
    , ("float64(5.0)", PFloat64)
    , ("rune('a')", PRune)
    , ("string(\"a\")", PString)
    , ("bool(true)", PBool)

    -- Numeric casts
    , ("float64(5)", PFloat64)
    , ("rune(5)", PRune)
    , ("int(5.0)", PInt)
    , ("rune(5.0)", PRune)
    , ("int('a')", PInt)
    , ("float64('a')", PFloat64)

    -- String casts
    , ("string(5)", PString)
    , ("string('a')", PString)]
  expectFail
    [ "5-\"9\""
    , "5 + \"5\""

    -- Bad boolean operations
    , "1 || 2"
    , "1 && 2"
    , "1.0 || 2.0"
    , "1.0 && 2.0"
    , "'a' || 'b'"
    , "'a' && 'b'"
    , "\"a\" || \"b\""

    -- Bad string casts
    , "string(5.0)"
    , "string(true)"]
