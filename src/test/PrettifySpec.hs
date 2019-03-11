{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TypeApplications     #-}
{-# LANGUAGE TypeSynonymInstances #-}

module PrettifySpec
  ( spec
  ) where

import           Base
import           Data
import           Prettify (tabS)

spec :: Spec
spec = do
  expectPrettyInvar @Identifiers ["a, b"]
  expectPrettyInvar
    @Expr
    [ "1 + 2 * 3"
    , "(((2))) * abc - _s"
    , "index[0]"
    , "-a"
    -- All bin ops
    , "1 || 1 && 1 == 1 != 1 < 1 <= 1 > 1 >= 1 + 1 - 1 | 1 ^ 1 * 1 / 1 % 1 << 1 >> 1 & 1 &^ 1"
    , "+1 && -1 && !1 && ^1"
    ]
  expectPrettyInvar @Type' ["asdf", "struct {a int; b int;}", "[0][0]a"]
  expectPrettyInvar @TopDecl topDeclExamples
  expectPrettyInvar @Stmt stmtExamples
  expectPrettyInvar @Program programExamples
  expectPrettyExact @Program expectPrettyExactExamples
  specAll "prettyformat" $
    map
      PrettyFormat
      [ ("asdf", "asdf")
      -- Whitespaces should be trimmed
      , ("\nasdf  \n \n", "asdf")
      -- Tabs should be reformatted using gcd
      , ( "asdf\n\t\tasdf\n\t\t\t\tasdf"
        , "asdf\n" ++ tabS ++ "asdf\n" ++ tabS ++ tabS ++ "asdf")
      ]
  where
    expectPrettyExactExamples =
      [ [text|
        package top

        type (
          num int
          point struct {
            x, y float64
            a struct {
              x, y float64
            }
          }
          a []b
          c [2]d
        )

        type a int

        var (
          a, b = 2, 3
          c string
        )

        var a string

        |]
      , [text|
        package f

        func f() {
        }

        func fs(a, b int) int {
        }
        |]
      , [text|
        package main

        func whatever(zz, yy string) struct {
            x int
            y int
            x, y float64
        } {
        }

        type w int

        type cc [10]rune

        type aa []string

        type bb struct {
            b int
            c, d float64
            e struct {
                f int
                g, h int
            }
        }

        func f(a int, b int, c string, d int) {
            return
        }

        func f(a, b int, c string, d int) string {
            return c
        }

        func main() {
            type num int
            type point struct {
                x, y float64
            }
            println()
            print()
            println((5 + 6))
            println((5 & 6))
            println((5 - 6))
            println((5 * 6))
            println((5 / 6))
            println((5 % 3))
            println((5 << 2))
            println((50 >> 2))
            println((5 ^ 2))
            println((5 | 6))
            println((5 < 6), (5 > 6), (5 <= 6), (5 >= 6), (5 == 6), (5 != 6))
            print('\a', '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'')
            print('\a')
            var (
                a = 255
                b int = 0377
                c = 0xFF
            )
            var d float = 0.12
            e = .12
            var _e = 12.
            println("hello\n", "world\n")
            print(`raw`, `string`)
            var x1, x2 int
            var y1, y2 = 42, 43
            var z1, z2 int = 1, 2
            var (
                x1, x2 int
                y1, y2 = 42, 43
                z1, z2 int = 1, 2
            )
            type (
                num int
                point struct {
                    x, y float64
                }
            )
            var x []int
            x = append(x, 1)
            x = append(x, 2)
            x = append(x, 3)
            var x [3]int
            x[0] = 1
            x[1] = 2
            x[2] = 3
            var p point
            p.x = 1
            p.y = 2
            p.z = 3
            var p point
            p.x = 1
            p.y = 2
            p.z = 3
            a, b = b, a
            a, b := b, a
            print()
            print(1)
            print(1, 2)
            println()
            println(1)
            println(1, 2)
            return
            return
            return 5
            return 1023213
            if 5 {
            } else if true {
            } else if whatever().e32 {
            } else {
                println("hello")
            }
            switch {
                case (3 < 4):
                    println(1, 2, 3)
                    println("hi")
            }
            switch i := 2; {
                default:
                    println("what")
            }
            for {
                continue
                break
            }
            switch i = 2; (5 + 6) {
                default:
                    break
            }
            a := 0334523475
            (a)++
            (a)--
            if (a)--; (b < a) {
                println("A")
            }
            if (a < b) {
            } else if a := 5; (a < b) {
            }
            for (a < 10) {
                println("a")
                println(`b`)
            }
            for i := 0; (i < 10); (i)++ {
                println("b")
                function()
            }
        }
        |]
      ]
