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
        _ <- SymTab.add st "int_5_arr_2" (Variable (Array 5 PInt))
        _ <- SymTab.add st "int_3_arr" (Variable (Array 3 PInt))
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
        _ <-
          SymTab.add
            st
            "int_t_slice"
            (Variable (Slice $ TypeMap (mkSIdStr' 1 "int_t") PInt))
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
               (mkSIdStr' 2 "struct_type")
               (Struct [("a", PInt), ("b", PString)]))
        -- type as_type [5]string
        -- var as_var as_type
        _ <- SymTab.add st "a5s" (Variable $ Array 5 PString)
        _ <- SymTab.add st "as_type" (SType $ Array 5 PString)
        _ <- SymTab.add st "b_type" (SType PBool)
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
        _ <- SymTab.add st "struct_slice" (SType $ (Struct [("a", Slice PInt)]))
        _ <- SymTab.add st "arr_slice" (SType $ Array 5 (Slice PInt))
        either (Left . errgen) Right <$> infer st e

expectPass :: Stringable s => String -> [(s, SType)] -> SpecWith ()
expectPass tag =
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
    ("typeinf: " ++ tag)

expectFail :: Stringable s => String -> [s] -> SpecWith ()
expectFail tag =
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
    ("typeinf: " ++ tag)

spec :: Spec
spec
  -- | Binary operations
  -- * Subexpressions must be well typed
  -- * Both expressions must have same type
 = do
  expectPass
    "unary operations"
    [ ("+5", PInt)
    , ("-5", PInt)
    , ("+5.0", PFloat64)
    , ("-5.0", PFloat64)
    , ("+'a'", PRune)
    , ("-'a'", PRune)
    , ("!true", PBool)
    , ("!false", PBool)
    , ("!(1 < 2)", PBool)
    , ("!!(1 <= 2)", PBool)
    , ("!!(1 > 2)", PBool)
    , ("!!!(1 >= 2)", PBool)
    , ("!!!!(1 == 2)", PBool)
    , ("!!!(1 != 2)", PBool)
    , ("^100", PInt)
    , ("^'b'", PRune)
    ]
  expectFail "unary operations" ["+\"string\"", "-\"string\""]
  expectPass
    "binary operations"
    -- Bool ops
    [ ("false || true", PBool)
    , ("false && true", PBool)
    -- Comparable ops
    -- See https://golang.org/ref/spec#Comparison_operators
    -- bool, rune, int, float64, string, struct if all fields comparable
    , ("2 == 54", PBool)
    , ("st_var == st_var", PBool)
    , ("int_5_arr == int_5_arr_2", PBool)
    -- TODO compare structs
    -- Ordered ops
    -- See See https://golang.org/ref/spec#Comparison_operators
    -- rune, int, float64, string
    , ("5 + 6", PInt)
    , ("5.5 + 6.6", PFloat64)
    , ("'a' + 'b'", PRune)
    , ("\"a\" + \"b\"", PString)
    -- Arrays
    , ("int_5_arr[0]", PInt)
    -- Slices
    , ("int_slice[0]", PInt)
    ]
  expectFail
    "binary operations"
    -- Bad numeric operations
    [ "5 - \"9\""
    , "5 + \"5\""
    , "5 - '5'"
    , "5.0 * 5"
    , "5 / '2'"
    -- Bad boolean operations
    , "1 || 2"
    , "1 && 2"
    , "1.0 || 2.0"
    , "1.0 && 2.0"
    , "'a' || 'b'"
    , "'a' && 'b'"
    , "5.0 % 3.0"
    , "int_t_slice < int_t_slice"
    , "true <= false"
    , "\"a\" || \"b\""
    -- not comparable:
    , "int_5_arr == int_3_arr"
    , "int_slice == int_slice"
    , "struct_slice == struct_slice"
    , "arr_slice == arr_slice"
    ]
  -- | Type casts
  -- type(expr) is valid if:
  -- type is base type (int, float64, bool, rune, string)
  -- expr is well type and
  -- * type == typeof expr
  -- * typeof type and typeof expr are both numeric
  -- * typeof type is string and typeof expr is rune or int
  expectPass
    "casting"
     -- Identity casts
    [ ("int(5)", PInt)
    , ("float64(5.0)", PFloat64)
    , ("rune('a')", PRune)
    , ("string(\"a\")", PString)
    , ("string(`a`)", PString)
    , ("bool(true)", PBool)
    -- Identity var casts
    , ("int(int_var)", PInt)
    , ("float64(float_var)", PFloat64)
    , ("rune(rune_var)", PRune)
    , ("string(string_var)", PString)
    , ("bool(bool_var)", PBool)
    -- Numeric casts
    , ("float64(5)", PFloat64)
    , ("float64('a')", PFloat64)
    , ("int(5.0)", PInt)
    , ("int('a')", PInt)
    , ("rune(5.0)", PRune)
    , ("rune(5)", PRune)
    -- Numeric expr casts
    , ("int(5.0 - 1. * float_var)", PInt)
    , ("float64('a' + 'b' - rune_var)", PFloat64)
    , ("rune(2 % 9 * int_var)", PRune)
    -- String casts
    , ("string(-2)", PString)
    , ("string(5)", PString)
    , ("string('a')", PString)
    , ("string('a' + 'b')", PString)
    -- String var casts
    , ("string(int_var)", PString)
    , ("string(rune_var)", PString)
    -- Nested casts
    , ("string(rune(5 + int(5.0)) + 'c' + rune(float64('a') + 2.0))", PString)
    -- Custom type casts
    , ("int_t(7)", TypeMap (mkSIdStr' 1 "int_t") (PInt))
    ]
  expectFail
    "casting"
    -- Bad string casts
    ["string(5.0)", "string(true)"]
  -- | Variables + build ins
  expectPass
    "build in"
    [ ("len(int_5_arr)", PInt)
    , ("len(int_slice)", PInt)
    , ("len(string_var)", PInt)
    , ("cap(int_5_arr)", PInt)
    , ("cap(int_slice)", PInt)
    , ("append(int_slice, 5)", Slice PInt)
    ]
  expectFail
    "built in"
    [ "len()"
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
    ]
  expectPass
    "custom"
    -- Primitive variables
    [ ("bool_var", PBool)
    , ("int_var", PInt)
    , ("float_var", PFloat64)
    , ("rune_var", PRune)
    , ("string_var", PString)
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
    -- Unary ops
    , ("+int_t(5)", TypeMap (mkSIdStr' 1 "int_t") PInt)
    , ("-int_t(5)", TypeMap (mkSIdStr' 1 "int_t") PInt)
    , ("^int_t(5)", TypeMap (mkSIdStr' 1 "int_t") PInt)
    -- Binary ops
    , ("int_t(5) + int_t(5)", TypeMap (mkSIdStr' 1 "int_t") PInt)
    , ("int_t(5) == int_t(5)", PBool)
    , ("int_t(5) >= int_t(5)", PBool)
    , ("b_type(true) || b_type(true)", TypeMap (mkSIdStr' 1 "b_type") PBool)
    ]
  expectFail
    "custom"
    -- Bad identifier
    [ "does_not_exist"
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
    , "as_type(a5s)" -- cast needs base types
    , "int_t(5) == 5"
    , "int_t_slice == int_t_slice"
    ]
