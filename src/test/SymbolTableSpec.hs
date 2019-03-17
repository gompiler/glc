{-# LANGUAGE QuasiQuotes #-}

module SymbolTableSpec
  ( spec
  ) where

import           Base        (Stringable (..), expectBase, text, toString)
import           SymbolTable (pTable, typecheckGen)
import           Test.Hspec

expectSymPass :: Stringable s => [s] -> SpecWith ()
expectSymPass =
  expectBase
    "success"
    (\s ->
       let c = "package main\n\n" ++ toString s
        in case pTable c of
             Left err ->
               expectationFailure $
               "Expected symbol success on:\n\n" ++
               toString s ++ "\n\nbut failed with\n\n" ++ show err
             Right (Just e, _) ->
               expectationFailure $
               "Expected symbol success on:\n\n" ++
               toString s ++ "\n\nbut failed with\n\n" ++ show e
             _ -> return ())
    toString
    "symbol"

expectSymFail :: Stringable s => [s] -> SpecWith ()
expectSymFail =
  expectBase
    "fail"
    (\s ->
       let c = "package main\n\n" ++ toString s
        in case pTable c of
             Right (Nothing, str) ->
               expectationFailure $
               "Expected symbol failure on:\n\n" ++
               toString s ++ "\n\nbut succeeded with\n\n" ++ str
             _ -> return ())
    toString
    "symbol"

expectTypecheckPass :: Stringable s => [s] -> SpecWith ()
expectTypecheckPass =
  expectBase
    "success"
    (\s ->
       let c = "package main\n\nfunc main() {\n\n" ++ toString s ++ "\n\n}"
        in case typecheckGen c of
             Left err ->
               expectationFailure $
               "Expected typecheck success on:\n\n" ++
               toString s ++ "\n\nbut failed with\n\n" ++ show err
             _ -> return ())
    toString
    "typecheck"

expectTypecheckFail :: Stringable s => [s] -> SpecWith ()
expectTypecheckFail =
  expectBase
    "fail"
    (\s ->
       let c = "package main\n\nfunc main() {\n\n" ++ toString s ++ "\n\n}"
        in case typecheckGen c of
             Right p ->
               expectationFailure $
               "Expected typecheck fail on:\n\n" ++
               toString s ++ "\n\nbut succeeded with\n\n" ++ show p
             _ -> return ())
    toString
    "typecheck"

expectTypecheckPassNoMain :: Stringable s => [s] -> SpecWith ()
expectTypecheckPassNoMain =
  expectBase
    "success"
    (\s ->
       let c = "package main\n\n" ++ toString s
        in case typecheckGen c of
             Left err ->
               expectationFailure $
               "Expected typecheck success on:\n\n" ++
               toString s ++ "\n\nbut failed with\n\n" ++ show err
             _ -> return ())
    toString
    "typecheck"

expectTypecheckFailNoMain :: Stringable s => [s] -> SpecWith ()
expectTypecheckFailNoMain =
  expectBase
    "fail"
    (\s ->
       let c = "package main\n\n" ++ toString s
        in case typecheckGen c of
             Right p ->
               expectationFailure $
               "Expected typecheck fail on:\n\n" ++
               toString s ++ "\n\nbut succeeded with\n\n" ++ show p
             _ -> return ())
    toString
    "typecheck"

spec :: Spec
spec = do
  expectSymPass [""]
  expectSymFail ["var a = b"]
  expectSymFail
    [ [text|
      var a = 5
      var a = 6
      |]
    ]
  expectTypecheckPass
    ["var a = 5;", "type _ int", "type int int", "type float64 int"]
  expectTypecheckPass
    [ [text|
      type int2 int
      type int3 int
      type int4 int2
      var a int2 = int2(5)
      {
          type int2 int3
      }
      var b int3 = int3(7)
      var c int4 = int4(int2(9))
      type int5 int4
      var d int5 = int5(int4(int2(24)))
      |]
    , [text|
      type int2 int
      type int3 int2
      var a = int2(5)
      var b = int3(int2(5))
      b = int3(int2(7))
      var c int3 = int3(a)
      c = int3(int2(9))
      c = b
      |]
    , [text|
      type int2 int
      type int3 int2
      var a = int2(5)
      var b = int3(int2(5))
      a, b, c := a, int3(a), int3(int2(99))
      |]
    , [text|
      var a, b, c = 1, 2, 3
      {
        var d = 4
        // At least one var not in current scope
        a, b, c, d := 4, 5, 6, 7
        _, e := 2, 3
      }
      |]
    ]
  expectTypecheckFail ["var b = a;"]
  expectTypecheckFail
    [ [text|
      type int2 int
      type int3 int
      type int4 int2
      var a int2 = int2(5)
      {
          type int2 int3
      }
      var b int3 = 7
      var c int4 = int2(9)
      type int5 int4
      var d int5 = int4(int2(24))
      |]
    , [text|
      type int i
      |]
    , [text|
      struct point {x int; y int}
      struct point2 {x int; y int}
      var a point
      var b point
      if a == b {
      }
      |]
    , [text|
      var a, b, c = 1, 2, 3
      // No new var
      a, b, c := 4, 5, 6
      |]
    , [text|
      a := 1
      // No new var
      a := 2
      |]
--    , [text| -- TODO currently failing
--      a := 1
--      // No new var
--      _, a := 2, 3
--      |]
    , [text|
      a := 1
      // Bad type
      a, b = 'a', 'b'
      |]
--    , [text|
--      |]
--    , [text|
--      |]
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
    ]
  expectTypecheckPassNoMain
    [ [text|
      func init() {
      }
      |]
    , [text|
      func a() int {
        return 0
      }

      // Multiple inits allowed
      func init() {
        a()
      }

      func init() {
        a()
        a()
      }

      func init() {
      }
      |]
    , [text|
      // Recursion
      func a() int {
        return a()
      }
      |]
    , [text|
      func a(a int) {
        a = 2
      }
      |]
    ]
  expectTypecheckFailNoMain
    -- Init must have no inputs, no return, and be correctly typed
    [ [text|
      func init(a int) {
      }
      |]
    , [text|
      func init() int {
        return 0
      }
      |]
    , [text|
      func init() {
        return 'a'
      }
      |]
    -- Init is not callable
    , [text|
      func init() {
        init()
      }
      |]
    , [text|
      func init() {
      }

      func a() {
        init()
      }
      |]
    , [text|
      func a(_ int) {
        // Cannot use blank ident as param
        a(_)
      }
      |]
    , [text|
      // Functions must be in order
      func a() {
        b()
      }
      func b() {
      }
      |]
    , [text|
      // Function and var cannot be same name
      var a = 2
      func a() {
      }
      |]
    , [text|
      // Var and type cannot be same name
      var a = 2
      type a int
      |]
    , [text|
      func a(a int) {
        // Can no longer call func a as it is shadowed by int a
        a(a)
      }
      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
--    , [text|
--      |]
    ]
