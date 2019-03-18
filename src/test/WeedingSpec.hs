{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE QuasiQuotes       #-}

module WeedingSpec
  ( spec
  ) where

import           Base
import           Weeding

expectWeedPass :: Stringable s => [s] -> SpecWith ()
expectWeedPass =
  expectBase
    "weed success"
    (\s ->
       let program =
             "package main\n\nfunc main() {\n\n" ++ toString s ++ "\n\n}"
        in case weed program of
             Left err ->
               expectationFailure $
               "Expected success on:\n\n" ++
               program ++ "\n\nbut got error\n\n" ++ show err
             _ -> return ())
    toString
    "wrapped stmt"

expectWeedPassNoMain :: Stringable s => [s] -> SpecWith ()
expectWeedPassNoMain =
  expectBase
    "weed success"
    (\s ->
       let program = "package main\n" ++ toString s
        in case weed program of
             Left err ->
               expectationFailure $
               "Expected success on:\n\n" ++
               program ++ "\n\nbut got error\n\n" ++ show err
             _ -> return ())
    toString
    "wrapped stmt"

expectWeedError :: Stringable s => [(s, WeedingError)] -> SpecWith ()
expectWeedError =
  expectBase
    "weed fail"
    (\(s, e) ->
       let s' = toString s
        in case weed s' of
             Right p ->
               expectationFailure $
               "Expected failure on:\n\n" ++
               s' ++ "\n\nbut got program\n\n" ++ show p
             Left err -> err `containsError` e)
    (toString . fst)
    "program"

expectWeedFail :: Stringable s => [s] -> SpecWith ()
expectWeedFail =
  expectBase
    "weed fail"
    (\s ->
       let program =
             "package main\n\nfunc main() {\n\n" ++ toString s ++ "\n\n}"
        in case weed program of
             Right p ->
               expectationFailure $
               "Expected failure on:\n\n" ++
               program ++ "\n\nbut got program\n\n" ++ show p
             _ -> return ())
    toString
    "wrapped stmt"

expectWeedFailNoMain :: Stringable s => [s] -> SpecWith ()
expectWeedFailNoMain =
  expectBase
    "weed fail"
    (\s ->
       let program = "package main\n" ++ toString s
        in case weed program of
             Right p ->
               expectationFailure $
               "Expected failure on:\n\n" ++
               program ++ "\n\nbut got program\n\n" ++ show p
             _ -> return ())
    toString
    "wrapped stmt"

expectWeedFailBlankPackage :: Stringable s => [s] -> SpecWith ()
expectWeedFailBlankPackage =
  expectBase
    "weed fail"
    (const $
     let program = "package _\n"
      in case weed program of
           Right p ->
             expectationFailure $
             "Expected failure on:\n\n" ++
             program ++ "\n\nbut got program\n\n" ++ show p
           _ -> return ())
    toString
    "package identifier"

spec :: Spec
spec = do
  expectWeedPass
    [ "if true { }"
    , "a.b()"
    , "a++"
    , "switch a {case a: _ = 5;}"
    , "_ := 5"
    , "_, a := 0, 0"
    , "_ = 0"
    ]
  expectWeedPassNoMain
    [ ""
    , "var a = 5"
    , "var a, b, c int"
    , "var a, b, c = 1, 2, 3"
    , "var a, b, c int = 1, 2, 3"
    , "var _ = 5"
    , "var _ int"
    , "var _, _, c int"
    , "var _, _, c boolean"
    , "var a, _, _ string"
    , "var a, _, _, b int"
    , "func _(){}"
    , "func _(_ int) {}"
    , "func _(_, _ int) {}"
    , "type _ struct {}"
    , "type _ struct {_ int;}"
    ]
  expectWeedPass
    [ [text|
      for {
        // within for loop scope
        break
      }
      |]
    , [text|
      for {
        {
          a++
          if true {
            // Still within loop scope
            break
          }
        }
      }
      |]
    , [text|
      switch {
        case a:
          // Within switch scope
          break
        default:
          break
      }
      |]
    ]
  expectWeedPassNoMain
    [ [text|
      func test() int {
        for {
        }
      }
      |]
    , [text|
      func test() int {
        for i := 0; i < 10; i++ {
          return 10;
          println("bbb");
        }
        return 5;
      }
      |]
    , [text|
      func test() int {
        {
          return 10;
          return 9;
          return 8;
        }
      }
      |]
    , [text|
      func test() {}
      |]
    , [text|
      func test() {
        if true {
          return
        } else {}
      }
      |]
    , [text|
      func init() {
        return
      }
      |]
    , [text|
      func init() {
        {
          return
        }
      }
      |]
    , [text|
      func init() {
        if true {
          return
        } else {}
      }
      |]
    , [text|
      func init() {
      }
      |]
    ]
  expectWeedError $
    map
      (\(s, e) ->
         ("package main\n\nfunc main() {\n\n" ++ toString s ++ "\n\n}", e))
      [("break", BreakScope)]
  expectWeedFail
    [ "break"
    , "if t { break; }"
    -- ExprStmt must be functions
    , "action"
    , "a.b"
    -- len LHS != len RHS
    , "a, b, c = 1, 2"
    -- Blank ident in RHS of assignment
    , "a = _"
    -- Function is blank ident
    , "_()"
    -- Arg is blank ident
    , "f(_)"
    , "f(a, b, _)"
    -- Use of blank ident in selector inside func
    , "f(_.b)"
    , "f(_.b())"
    , "f(a, _.b, c)"
    -- Unary op with blank var
    , "var a = + _"
    -- Binary op
    , "var a = 0 + _"
    , "var b = len(_)"
    , "var b = cap(_)"
    , "var b = [_]b"
    , "var b = [5]_"
    , "var b = _.a"
    , "var b = a._"
    , "var b = _++"
    , "var b = _--"
    , "b := _"
    , "switch _ {}"
    , "switch a {case _: c = 4;}"
    , "switch a {case a: g = _;}"
    , "switch a {default: g = _;}"
    , "println(_)"
    , "print(_)"
    , "for _ {}"
    , "for _; i < 3; i++ {}"
    , "for i := 0; _; i++ {}"
    , "for i := 0; i < 3; _ {}"
    , "if _ {}"
    , "return _"
    ]
  expectWeedFailNoMain
    [ "var a, b = 3"
    , "var a, b int = 3"
    , "type g struct { a _; }"
    , "var a = 1, 3"
    , "var a float = 1, 3"
    , "func _(ab _) {}"
    , "func _(_, _ _) {}"
    ]
  expectWeedError
    [ ( [text|
        package main

        var (
          a, b = 0
        )
        |]
      , ListSizeMismatch)
    , ( [text|
        package main

        var (
          a, b int = 0
        )
        |]
      , ListSizeMismatch)
    , ( [text|
        package main

        var (
           a int = 1, 2
        )
        |]
      , ListSizeMismatch)
    , ( [text|
        package main

        var (
          a = 1, 2
        )
        |]
      , ListSizeMismatch)
    ]
  expectWeedFail
    [ [text|
      switch {
        case a:
        case b:
        default:
        case c:
        default:
      }
      |]
    , [text|
      for {
        a.b
      }
      |]
      -- No short decl in post
    , [text|
      for i := 0; i < 20; i := 0 {
      }
      |]
    ]
  expectWeedFailNoMain
    [ [text|
      func test() int {
        if true {
          return 5
        } else {
          println("hello world")
        }
      }
      |]
    , [text|
      func test() int {
        if true {
          return 5
        } else {
          return 10
          println("hello world")
        }
      }
      |]
    , [text|
      func test() int {
        for i := 0; i < 10; i++ {
        }
      }
      |]
    , [text|
      func test() int {
        for i := 0; i < 10; i++ {
          return 5
          println("555")
        }
      }
      |]
    , [text|
      func test() int {
      }
      |]
    , [text|
      func init() {
        return 5
      }
      |]
    , [text|
      func init() {
        {
          return 6
          println("aaaaaa")
        }
      }
      |]
    , [text|
      func init() {
        if true {
          return 3
          for {}
        } else {
          return
        }
      }
      |]
    , [text|
      func init() {
        for i := 0; i < 10; i++ {
          return 5555
        }
        return
      }
      |]
    , [text|
      func init() {
        {
          return
          return
          return 10
          return 10
          return
          return
        }
        return
        return
      }
      |]
    , [text|
      func main(a int) {}
      |]
    , [text|
      func main() int {}
      |]
    , [text|
      func main(a float) string {}
      |]
    ]
  expectWeedFailBlankPackage [""]
