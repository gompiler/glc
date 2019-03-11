{-# LANGUAGE QuasiQuotes #-}

module Examples where

import           Data.Text.Internal (Text)
import           NeatInterpolation

intExamples :: [String]
intExamples =
  [ "0"
  , "1"
  , "-123"
  , "1234567890"
  , "42"
  , "0600"
  , "0xBadFace"
  , "000"
  , "170141183460469231731687303715884105727"
  ]

floatExamples :: [String]
floatExamples =
  [ ".1234567890"
  , "0."
  , "0.0"
  , "0.00"
  , "0123.3210"
  , "72.40"
  , "072.40"
  , "2.71828"
  , "1."
  , "0.00000667428"
  , "10000"
  , ".25"
  , "12345"
  ]

runeExamples :: [String]
runeExamples =
  [ "a"
  , "b"
  , "c"
  , "\\a"
  , "\\b"
  , "\\f"
  , "\\n"
  , "\\r"
  , "\\t"
  , "\\v"
  , "\\\\"
  , "\\'"
  , "\""
  ]

topDeclExamples :: [Text]
topDeclExamples =
  [ [text|
    type bb struct {
      b int
      c, d float64
      e struct {
        f int
        g, h int
      }
    }
    |]
  , [text|
    func whatever() struct { int n; } {
    }
    |]
  ]

stmtExamples :: [Text]
stmtExamples =
  [ [text|
    if bool {
      for i := 0; i < twenty; i++ {
        for {
          switch {
            case i % 2 == 0:
              switch i {
                default:
                  append(s, s)
              }
            break
          }
        }
      }
    }
    |]
  ]

programExamples :: [Text]
programExamples =
  [ [text|package small|]
  , [text|
    package m

    type a m
    |]
  , [text|
    package comments

    // Comment
    /* Block comment */
    /* /* /* */
    /* // */
    |]
  , [text|
    package          big

    type a    int

    type (
      b int; c string
      _struct struct {
        b int
        c int
        c struct {}
        d [][4][][][2]a
      }
    )

    var a b;
    var ( int string; )

    func main() {
      // Golite commands
      print("Hello world")
      println("Done");
      append(a, b)
      len(a)
      cap(a)
    }

    func a(a, b int, c int, d float) int {
      var e = 2.0
      var __g__ = `raw`
      return 2 >= a && ^c < d
    }





    func forLOOPs() {
      for {
        // blank
      }
      for i := 0; i < 20; {
        infiniteLoop()
      }
      for i < 20 {
        single(condition)
      }
      // 'curried' calls
      a.b.c[e.f * 2].d()(a, b, c)(-a * b ^ (((((b % 2))))))
    }
    |]
  ]
