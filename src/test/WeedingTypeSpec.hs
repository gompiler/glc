{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE QuasiQuotes       #-}

module WeedingTypeSpec
  ( spec
  ) where

import           TestBase
import           WeedingTypes

expectWeedFailNoMain :: Stringable s => [s] -> SpecWith ()
expectWeedFailNoMain =
  expectBase
    "weed types fail"
    (\s ->
       let program = "package main\n" ++ toString s
        in case weedT program of
             Right p ->
               expectationFailure $
               "Expected failure on:\n\n" ++
               program ++ "\n\nbut got program\n\n" ++ show p
             _ -> return ())
    toString
    "wrapped stmt"

spec :: Spec
spec = do
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
    , [text|
      func f() int {
            for ; true ; { // This isn't valid because this condition can be false
                return 42
            }
      }
      |]
    , [text|
      func f() int {
            for {
                break // Break gets us out of infinite loop
            }
      }
      |]
    , [text|
      func f() int {
            switch { // Switch with no defaults cannot guarantee a return, might not enter any cases
                case true:
                    return 2;
                case false:
                    return 222;
            }
      }
      |]
    , [text|
      func f() int {
            switch { // Switch with break cannot guarantee return
                case true:
                    break;
                case false:
                    return 222;
                default:
                    return 3;
            }
      }
      |]
    ]
