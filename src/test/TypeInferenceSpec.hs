{-# LANGUAGE QuasiQuotes #-}

module TypeInferenceSpec
  ( spec
  ) where

import           Base             (Stringable (..), expectBase, toString)
import           Control.Monad.ST
import           Data             (Expr)
import           ErrorBundle
import           Parser           (parse)
import           Symbol
import qualified SymbolTable      as SymTab (add, new)
import           Test.Hspec
import           TypeInference    (infer)

parseAndInferNoST :: String -> Either ErrorMessage SType
parseAndInferNoST expStr = either Left runExpr parseResult
  where
    errgen e = e expStr `withPrefix` "typinf error"
    parseResult :: Either ErrorMessage Expr
    parseResult = parse expStr
    runExpr :: Expr -> Either ErrorMessage SType
    runExpr e =
      runST $ do
        st <- SymTab.new
        _ <- SymTab.add st "bool_var" (Variable PBool)
        _ <- SymTab.add st "int_var" (Variable PInt)
        _ <- SymTab.add st "float_var" (Variable PFloat64)
        _ <- SymTab.add st "rune_var" (Variable PRune)
        _ <- SymTab.add st "string_var" (Variable PString)
        _ <- SymTab.add st "int_5_arr" (Variable (Array 5 PInt))
        _ <- SymTab.add st "int_slice" (Variable (Slice PInt))
        _ <-
          SymTab.add
            st
            "fi_func"
            (Func [("a", PFloat64), ("b", PInt)] (Just PInt))
        -- type int_t int
        -- var it_var int_t
        _ <- SymTab.add st "int_t" (SType PInt)
        _ <-
          SymTab.add st "it_var" (Variable $ TypeMap (mkSIdStr' 1 "int_t") PInt)
        -- type struct_type struct {a int; b int;}
        -- var st_var struct_type
        -- _ <- SymTab.app
        _ <-
          SymTab.add
            st
            "struct_type"
            (SType $ Struct [("a", PInt), ("b", PString)])
        _ <-
          SymTab.add
            st
            "st_var"
            (Variable $
             TypeMap
               (mkSIdStr' 1 "struct_type")
               (Struct [("a", PInt), ("b", PString)]))
        -- type as_type [5]string
        -- var as_var as_type
        _ <- SymTab.add st "as_type" (SType $ Array 5 PString)
        _ <-
          SymTab.add
            st
            "as_var"
            (Variable $ TypeMap (mkSIdStr' 1 "as_type") (Array 5 PString))
        -- type sr_type []rune
        -- var sr_var sr_type
        _ <- SymTab.add st "sr_type" (SType $ Slice PRune)
        _ <-
          SymTab.add
            st
            "sr_var"
            (Variable $ TypeMap (mkSIdStr' 1 "sr_type") (Slice PRune))
        either (Left . errgen) Right <$> infer st e

expectPass :: Stringable s => [(s, SType)] -> SpecWith ()
expectPass =
  expectBase
    "success"
    (\(s, etyp) ->
       case parseAndInferNoST (toString s) of
         Left err ->
           expectationFailure $
           "Expected typeinf success on:\n\n" ++
           toString s ++ "\n\nbut failed with\n\n" ++ show err
         Right rtyp ->
           if etyp == rtyp
             then return ()
             else expectationFailure $
                  "Expected typeinf success on:\n\n" ++
                  toString s ++
                  "\n\nbut failed with\n\nexpected " ++
                  show etyp ++ ", got " ++ show rtyp)
    (\(s, _) -> toString s)
    "typeinf"

expectFail :: Stringable s => [s] -> SpecWith ()
expectFail =
  expectBase
    "fail"
    (\s ->
       case parseAndInferNoST (toString s) of
         Right styp ->
           expectationFailure $
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
    -- Arrays
    , ("int_5_arr[0]", PInt)
    -- Slices
    , ("int_slice[0]", PInt)
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
    , ("string('a')", PString)
    -- Primitive variables
    , ("bool_var", PBool)
    , ("int_var", PInt)
    , ("float_var", PFloat64)
    , ("rune_var", PRune)
    , ("string_var", PString)
    -- Built-ins
    , ("len(int_5_arr)", PInt)
    , ("len(int_slice)", PInt)
    , ("len(string_var)", PInt)
    , ("cap(int_5_arr)", PInt)
    , ("cap(int_slice)", PInt)
    , ("append(int_slice, 5)", Slice PInt)
    -- Functions
    , ("fi_func(5.0, 6)", PInt)
    -- Custom Type Definitions
    , ("st_var.a", PInt)
    , ("st_var.b", PString)
    , ("as_var[0]", PString)
    , ("as_var[it_var]", PString)
    , ("append(sr_var, '5')", TypeMap (mkSIdStr' 1 "sr_type") (Slice PRune))
    , ( "append(sr_var, rune(it_var))"
      , TypeMap (mkSIdStr' 1 "sr_type") (Slice PRune))
    ]
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
    , "string(true)"
    -- Bad built-ins - TODO
    , "len()"
    , "len(bool_var)"
    , "len(int_var)"
    , "len(float_var)"
    , "len(rune_var)"
    , "len(does_not_exist)"
    , "cap()"
    , "cap(bool_var)"
    , "cap(int_var)"
    , "cap(float_var)"
    , "cap(rune_var)"
    , "cap(string_var)"
    , "append(bool_var, true)"
    , "append(int_var, 5)"
    , "append(float_var, 5.0)"
    , "append(rune_var, 'a')"
    , "append(string_var, \"b\")"
    , "append(int_slice)"
    , "append(int_slice, 5.0)"
    , "append(int_slice, 'a')"
    , "append(int_slice, true)"
    -- Bad identifier
    , "does_not_exist"
    , "does_not_exist()"
    , "does_not_exist.field"
    -- Arrays
    , "int_var[0]"
    -- Functions
    , "fi_func()"
    , "fi_func(5.0)"
    -- Custom Type Definitions
    , "st_var.c"
    , "append(sr_var, 5)"
    , "as_var[float(it_var)]"
    ]
