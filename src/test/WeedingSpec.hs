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

spec :: Spec
spec = do
  expectWeedPass ["if true { }", "a.b()", "a++"]
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
        -- len LHS != len RHS
        , [text|
               a, b, c = 1, 2
               |]
            -- Blank ident in RHS of assignment
            -- , [text|
            --        a = _
            --        |]
            --     -- Function is blank ident
            --     , [text|
            --            _()
            --            |]
            --         -- Arg is blank ident
            --     , [text|
            --            f(_)
            --            |]
            --     , [text|
            --            f(a, b, _)
            --            |]
            --         -- Use of blank ident in selector inside func
            --     , [text|
            --            f(_.b)
            --            |]
            --     , [text|
            --            f(_.b())
            --            |]
            --     , [text|
            --            f(a, _.b, c)
            --            |]
            --         -- Unary op with blank ident
            --     , [text|
            --            var a = 0 + _
            --            |]
    ]
