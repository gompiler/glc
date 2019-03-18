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
    [ "var a = 5;"
    , "type _ int"
    , "type int int"
    , "type float64 int"
    -- Assignment ops
    , "var a int; a += 2;"
    , "var a rune; a -= 'a'"
    , "var a float64; a *= 2.0"
    , "var g [0xf]int"
    , "type inta [3]int; var a inta; a[2] = 5"
    , "switch i:=0; i {case 1: var a = 5; case 2: var a = 3; default: var a = 9;}"
    , "type g struct {a int;}"
    , "type g struct {_ int;}; var b g"
    , "type g struct {b int;}; var b g; b.b = 5"
    , "type a struct {g struct { z struct { l int;};};}; var g a; g.g.z.l = 5"
    , "for i:=0;;{var i = 3;}"
    , "if i:=0;true{var i = 3;}"
    ]
  expectTypecheckFail
    -- Assignment ops
    -- Constants not allowed
    [ "var a bool; a += 2"
    , "var s string; s *= `s`"
    , "2 += 3"
    , "'b' -= 'c'"
    , "'a' = 'b'"
    , "type inta [3]int; var a inta; var b [3]int; a = b"
    , "type inta [3]int; var a inta; var b [3]int; a = inta(b);"
    , "switch i:=0; true {case 5: var a = 6;};"
    , "switch i:=0; i {case 1: var a = 5; case 2: var b = a;}"
    , "if true {var a = 21;} else {var b = a;}"
    ]
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
    , [text|
      // Assignment for addressable items
      var p struct {x int;}
      p.x = 2
      var i []int
      i[1] = p.x
      var j [2][]int
      j[0] = i
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
    , [text|
          a := 1
     // No new var
     _, a := 2, 3
     |]
    , [text|
      a := 1
      // Bad type
      a, b = 'a', 'b'
      |]
    , [text|
      // Check against explicit type
      var a, b, c int = 1, true, 3
      |]
    , [text|
     // Cannot use var if not defined
     var a, b, c int = 1, a, 3
     |]
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
    [ "type b struct { x, y int; }"
    , "type a int"
    , "var g [5]int"
    , "var g [0]int"
    , "func init(){}; func init(){};"
    , "func zz (a, b int) int{ return 5; }"
    , "func zz (a,b int) {}"
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
    , [text|
      // Init is not a keyword
      func a(init int) {
      }

      func b() {
        type init int
      }

      func c() {
        init := 2
      }

      // Main is not a keyword

      func ma(main int) {
      }

      func mb() {
        type main int
      }

      func mc() {
        main := 2
      }
      |]
    , [text|
      // Complex return

      type int2 int

      func a() int2 {
        return int2(0)
      }

      func b() int2 {
        // Doesn't affect anything
        type int2 int
        return a()
      }

      func c() float64 {
        return float64(b()) * 2.0
      }
      |]
    , [text|
              type s1 struct{
	      a bool
	      a2 int
              }

              type s2 struct{
	      a int
	      a2 s1
              }

              type (
	      g int
	      s3 struct{
              a g
	      }
	      _ int
	      _a int
	      _a_ _a
	      __ _a_
              )

              func __j() int{
	      a, _ := 6, 3
	      // _ = 3
	      return 9
              }

              func retInt() int{
	      return 5
              }

              func retBool(a int) bool{
	      return true
              }

              func main() {
	      type false bool
	      var b int = 5

	      for {
              type int float64
              var ssss int = int(63.0)
	      }

	      type int2 int
	      type int bool

	      type int3 int2

	      var c int = int(retBool(7))
	      var shouldBeBool int = int(true)
	      var intVar int2 = int2(5)
	      var intVar2 int3 = int3(5)
	      if true {
              // intVar2 = int3(5)
	      }

              }

              func weird() int{
	      if (true){
              // type int float64
              var g int = int(6)
              return g
	      }else{
              // type int float64
              var g int = int(5)
              return g
	      }
              }
              type int3 int
              type int bool

              func bbool() int{
	      return int(true)
              }
              func sl(g []int3) []int3{
	      // _ = 7
	      var _ = 7
	      g = append(g, int3(5))
	      return g
              }

              func wut(){
	      var z []int3
	      _ = sl(z)
              }

              var _ = 5
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
    ]
  expectTypecheckFailNoMain
    [ "var g [-5]int, var g [(-5)]int"
    , "var g[(1)] int"
    , "func main(){}; func main(){};"
    , "type a int2"
    , "func zz (a, b int) int {}"
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
    , [text|
     // Init must be a function at the top level
     type init int
     |]
    , [text|
     // Main must be a function at the top level
     type main int
     |]
    , [text|
      // Main can only be declared once
      func main() {
      }

      func main() {
      }
      |]
    -- Returns
    , [text|
      func a() int {
        // Bad return type
        return a
      }
      |]
    , [text|
      // No returns allowed at all if void; even if type is fine
      func a() {
        return a()
      }
      |]
    , [text|
      // Complex return

      type int2 int

      func a() int2 {
        return int2(0)
      }

      func b() int2 {
        type int2 int
        // Incompatible return type
        return int2(3)
      }
      |]
    , [text|
      func a() int {
        return 0
        // Continue typecheck even if this will never happen
        var a int = true
        return 2
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
    ]
