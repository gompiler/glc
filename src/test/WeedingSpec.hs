{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TypeApplications  #-}

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
               program ++ "\n\nbut got error\n\n" ++ err
             _ -> return ())
    toString
    "wrapped stmt"
  
expectWeedPassNoMain :: Stringable s => [s] -> SpecWith ()
expectWeedPassNoMain =
  expectBase
    "weed success"
    (\s ->
       let program =
             "package main\n" ++ toString s
        in case weed program of
             Left err ->
               expectationFailure $
               "Expected success on:\n\n" ++
               program ++ "\n\nbut got error\n\n" ++ err
             _ -> return ())
    toString
    "wrapped stmt"

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
       let program =
             "package main\n" ++ toString s
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
  expectWeedPass ["if true { }", "a.b()", "a++"]
  expectWeedPassNoMain ["", "var a = 5", "var a, b, c int", "var a, b, c = 1, 2, 3", "var a, b, c int = 1, 2, 3"]
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
  expectWeedFail
    [ "break"
    , "if t { break; }"
    -- ExprStmt must be functions
    , "action"
    , "a.b"
    -- len LHS != len RHS
    , "a, b, c = 1, 2"
    -- Blank ident in RHS of assignment
    -- , "a = _"
    -- Function is blank ident
    -- , "_()"
    -- Arg is blank ident
    -- , "f(_)"
    -- , "f(a, b, _)"
    -- Use of blank ident in selector inside func
    -- , "f(_.b)"
    -- , "f(_.b())"
    -- , "f(a, _.b, c)"
    -- Unary op with blank ident
    -- , "var a = 0 + _"
    ]
  expectWeedFailNoMain
    [ "var a, b = 3", "var a, b int = 3"
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
