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

spec :: Spec
spec = do
  expectWeedPass
    ["if true { }", "a.b()", "a++", "switch a {case a: _ = 5;}", "_ := 5"]
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
    ["var a, b = 3", "var a, b int = 3", "type g struct { a _; }", "var a = 1, 3", "var a float = 1, 3"]
  expectWeedFailNoMain
    [ [text|
         var (
            a, b = 0
         )
         |]
    , [text|
         var (
            a, b int = 0
         )
         |]
    , [text|
         var (
            a int = 1, 2
         )
         |]
    , [text|
         var (
            a = 1, 2
         )
         |]
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
