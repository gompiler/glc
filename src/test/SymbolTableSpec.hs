{-# LANGUAGE QuasiQuotes #-}

module SymbolTableSpec
  ( spec
  ) where

import           TestBase        (Stringable (..), expectBase, text, toString)
import           SymbolTable (pTable, typecheckGen)
import           Test.Hspec

expectSymPass :: Stringable s => [s] -> Spec
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

expectSymFail :: Stringable s => [s] -> Spec
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

expectTypecheckPass :: Stringable s => [s] -> Spec
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

expectTypecheckFail :: Stringable s => [s] -> Spec
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

expectTypecheckPassNoMain :: Stringable s => [s] -> Spec
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

expectTypecheckFailNoMain :: Stringable s => [s] -> Spec
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
    , "type x struct {a []x;}"
    , "type a []struct {x a;}"
    , "type a []a"
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
    , "if i:=0; true {var i = 3;}"
    , "if i:=true; i {}"
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
    , "type x struct {a x;}"
    , "type x struct {a [5]x;}"
    , "switch i:=0; true {case 5: var a = 6;};"
    , "switch i:=0; i {case 1: var a = 5; case 2: var b = a;}"
    , "if true {var a = 21;} else {var b = a;}"
    -- Append alone is an expression
    , "var a []int; var b int; append(a, b)"
    , "a, a := 0, 1"
    , "true = true"
    , "false = false"
    , "true = false"
    , "false = true"
    , "type int2 int; int2(5)"
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
    , [text|
      // Multi type check
      var a []int
      var b [2]int
      a[0] = b[0]
      type c []int
      var e c
      var d []c
      |]
    , [text|
      type point struct {x int; y int;}
      var a point
      {
      type point struct {x int;}
      var b point
      a.y = b.x
      }
      a.y = a.x
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
    , [text|
      var a []int
      var b int
      var c []int
      // Append not valid lvar
      append(a, b) := c
      |]
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
    , "type a []a"
    , "type a struct {b []a;}"
    , "type a []struct {b a;}"
    , "type a []struct {a1 a; a2 a; a3 a;}"
    , "type a struct {a1 []a; a2 []a; a3 []a;}"
    , "type a []struct {a struct {a a;}; }"
    , "func a (int, float64, string, rune int){}"
    , "func a (int int, b int){}"
    , "func a ()int { for {};}" -- Infinite loops don't need to return
    , "func a ()int { for ;; {};}"
    , "func a ()int { for a:=0;; {};}"
    , "func a ()int { for a:=0;;a++ {};}"
    , "func a ()int { var a = 3; for ;;a=0 {};}"
    , "func a () {}; func main () { a(); }"
    ]
  expectTypecheckPassNoMain
    [ [text|
      func init() {
      }
      |]
    , [text|
      func init() {
        return
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
               func a () []int{
                    var r []int
                    return r
               }
               func main (){
                    // Slices always addressable
                    a()[0] = 3
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
    , [text|
      func test() int {
        type a []int
        var b []a
        return len(b[0])
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
  expectTypecheckFailNoMain
    [ "var g [-5]int, var g [(-5)]int"
    , "var g[(1)] int"
    , "func main(){}; func main(){};"
    , "type a int2"
    , "func zz (a, b int) int {}"
    , "type a struct {b a;}"
    , "type a struct {a1 []a; a2 []a; a3 a;}"
    , "type a struct {a int; a int;}"
    , "type a struct {a,b,a int; c int;}"
    , "func a(b int, b int){}"
    , "func a(){}; func main(){ a := a(); }"
    , "func a(){}; func main(){ b := a(); }"
    , "func a(){}; func main(){ var b = a(); }"
    , "func a(){}; func main(){ if a() {}; }"
    , "func a(){}; func main(){ switch a() {}; }"
    , "func a(){}; func main(){ for a() {}; }"
    , "func a(a1 int, a2 float64){}; func main(){ a(3);}"
    -- , "var a int; type b a;"
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
    , [text|
      type a struct {b int;}
      func f() a {
          var r a
          return r
      }
      func main(){ f().b++
      }
      |]
    , [text|
      type a struct {b int;}
      func f() a {
          var r a
          return r
      }
      func main(){
          // Not addressable because it's a function return
          f().b--
      }
      |]
    , [text|
      type a struct {b int;}
      func f() a {
          var r a
          return r
      }
      func main(){
          var g a;
          // Func return not addressable
          f() = g;
      }
      |]
    , [text|
      type a struct {b int;}
      func f() a {
          var r a
          return r
      }
      func main(){
          // Func return not addressable
          f().b = 3;
      }
      |]
    , [text|
      func f() [5]int {
          var r [5]int
          return r
      }
      func main(){
          // Func return (not slice) not addressable
          f()[3] = 3;
      }
      |]
    , [text|
      func f() [5]int {
          var r [5]int
          return r
      }
      func main(){
          // Func return (not slice) not addressable
          f()[3]++;
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
    ]
