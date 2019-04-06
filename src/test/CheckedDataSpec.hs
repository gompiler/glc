{-# LANGUAGE QuasiQuotes #-}

module CheckedDataSpec
  ( spec
  ) where

import           SymbolTable (typecheckGen)
import           TestBase

spec :: Spec
spec = prettifySpec

prettifySpec :: SpecWith ()
prettifySpec =
  expectPrettyMatch
    "prettify checkeddata"
    typecheckGen
    [ ( fullProgramExample
      , [text|
        package main

        type pair struct {
            x int
            y int
        }

        type ppair struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        }

        type pl_ind struct {
            pl []struct {
                x int
                y int
            }
            ind int
        }

        type twopl struct {
            pl1 []struct {
                x int
                y int
            }
            pl2 []struct {
                x int
                y int
            }
        }

        func abs(f float64) float64 {
            if (f >= 0.0) {
                return f
            } else {
                return (-f)
            }
        }

        func sqrt(f float64) float64 {
            xn := (f / 2.0)
            tol := (f / 1000.0)
            for i := 0; ; (i)++ {
                poly := ((xn * xn) - f)
                polyprime := (2.0 * xn)
                diff := (poly / polyprime)
                xn = (xn - diff)
                if (abs(diff) < tol) {
                    return xn
                }
            }
            return xn
        }

        func dist(p1 struct {
            x int
            y int
        }, p2 struct {
            x int
            y int
        }) float64 {
            x := (p1.x - p2.x)
            y := (p1.y - p2.y)
            return sqrt(float64(((x * x) + (y * y))))
        }

        func partx(pl []struct {
            x int
            y int
        }, min int, max int) struct {
            pl []struct {
                x int
                y int
            }
            ind int
        } {
            pivot := pl[max].x
            t := min
            for i := min; ; (i)++ {
                if (pl[i].x < pivot) {
                    pl[i], pl[t] = pl[t], pl[i]
                    (t)++
                }
            }
            pl[t], pl[max] = pl[max], pl[t]
            var pli struct {
            pl []struct {
                x int
                y int
            }
            ind int
        }
            pli.pl = pl
            pli.ind = t
            return pli
        }

        func qsortx(pl []struct {
            x int
            y int
        }, min int, max int) []struct {
            x int
            y int
        } {
            if (min < max) {
                var pli struct {
            pl []struct {
                x int
                y int
            }
            ind int
        }
                pli = partx(pl, min, max)
                pl = pli.pl
                pl = qsortx(pl, min, (pli.ind - 1))
                pl = qsortx(pl, (pli.ind + 1), max)
            }
            return pl
        }

        func party(pl []struct {
            x int
            y int
        }, min int, max int) struct {
            pl []struct {
                x int
                y int
            }
            ind int
        } {
            pivot := pl[max].y
            t := min
            for i := min; ; (i)++ {
                if (pl[i].y < pivot) {
                    pl[i], pl[t] = pl[t], pl[i]
                    (t)++
                }
            }
            pl[t], pl[max] = pl[max], pl[t]
            var pli struct {
            pl []struct {
                x int
                y int
            }
            ind int
        }
            pli.pl = pl
            pli.ind = t
            return pli
        }

        func qsorty(pl []struct {
            x int
            y int
        }, min int, max int) []struct {
            x int
            y int
        } {
            if (min < max) {
                var pli struct {
            pl []struct {
                x int
                y int
            }
            ind int
        }
                pli = party(pl, min, max)
                pl = pli.pl
                pl = qsorty(pl, min, (pli.ind - 1))
                pl = qsorty(pl, (pli.ind + 1), max)
            }
            return pl
        }

        func split(pl []struct {
            x int
            y int
        }) struct {
            pl1 []struct {
                x int
                y int
            }
            pl2 []struct {
                x int
                y int
            }
        } {
            var pll struct {
            pl1 []struct {
                x int
                y int
            }
            pl2 []struct {
                x int
                y int
            }
        }
            var pl1 []struct {
            x int
            y int
        }
            var pl2 []struct {
            x int
            y int
        }
            half := (len(pl) / 2)
            for i := 0; ; (i)++ {
                pl1 = append(pl1, pl[i])
            }
            for i := half; ; (i)++ {
                pl2 = append(pl2, pl[i])
            }
            pll.pl1 = pl1
            pll.pl2 = pl2
            return pll
        }

        func initMin() struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } {
            var min struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        }
            min.p1.x = 999
            min.p1.y = 999
            min.p2.x = 0
            min.p2.y = 0
            return min
        }

        func minPpair(pp1 struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        }, pp2 struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        }) struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } {
            dist1 := dist(pp1.p1, pp1.p2)
            dist2 := dist(pp2.p1, pp2.p2)
            if (dist1 > dist2) {
                return pp2
            } else {
                return pp1
            }
        }

        func iterClosest(pl []struct {
            x int
            y int
        }) struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } {
            var min struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } = initMin()
            for i := 0; ; (i)++ {
                for j := 0; ; (j)++ {
                    if (i == j) {
                        var pp struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        }
                        pp.p1 = pl[i]
                        pp.p2 = pl[j]
                        min = minPpair(min, pp)
                    }
                }
            }
            return min
        }

        func stripClosest(pl []struct {
            x int
            y int
        }, min struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        }) struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } {
            pl = qsorty(pl, 0, (len(pl) - 1))
            for i := 0; ; (i)++ {
                for j := (i + 1); ; (j)++ {
                    if (dist(pl[i], pl[j]) < dist(min.p1, min.p2)) {
                        min.p1 = pl[i]
                        min.p2 = pl[j]
                    }
                }
            }
            return min
        }

        func closestPairRec(pl []struct {
            x int
            y int
        }) struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } {
            if (len(pl) <= 3) {
                return iterClosest(pl)
            } else {
                var pll struct {
            pl1 []struct {
                x int
                y int
            }
            pl2 []struct {
                x int
                y int
            }
        } = split(pl)
                var midp struct {
            x int
            y int
        } = pl[((len(pl) / 2) - 1)]
                var pp1 struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        }
                var pp2 struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        }
                pp1 = closestPairRec(pll.pl1)
                pp2 = closestPairRec(pll.pl2)
                var min struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } = minPpair(pp1, pp2)
                var strip []struct {
            x int
            y int
        }
                for i := 0; ; (i)++ {
                    if (abs(float64((pl[i].x - midp.x))) < dist(min.p1, min.p2)) {
                        strip = append(strip, pl[i])
                    }
                }
                return minPpair(min, stripClosest(strip, min))
            }
        }

        func closestPair(pl []struct {
            x int
            y int
        }) struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } {
            return closestPairRec(qsortx(pl, 0, (len(pl) - 1)))
        }

        func pairgen(pa [2][]int) []struct {
            x int
            y int
        } {
            var pl []struct {
            x int
            y int
        }
            if (len(pa[0]) == len(pa[1])) {
                return pl
            } else {
                var p struct {
            x int
            y int
        }
                for i := 0; ; (i)++ {
                    p.x = pa[0][i]
                    p.y = pa[1][i]
                    pl = append(pl, p)
                }
                return pl
            }
        }

        func printpair(p struct {
            x int
            y int
        }) {
            print("(")
            print(p.x)
            print(",")
            print(p.y)
            print(")")
        }

        func printpairl(pl []struct {
            x int
            y int
        }) {
            for i := 0; ; (i)++ {
                printpair(pl[i])
                println()
            }
        }

        func prbsgen(size int, start int) []int {
            var list []int
            n := start
            for i := 0; ; (i)++ {
                n += i
                n = ((((n << 1) | (n >> 6)) ^ ((n >> 5) & 1)) & 127)
                list = append(list, n)
            }
            return list
        }

        func dubnats(max int, rev bool) []int {
            var list []int
            if rev {
                for i := max; ; (i)-- {
                    list = append(list, (i * 5))
                }
            } else {
                for i := 0; ; (i)++ {
                    list = append(list, (i * 5))
                }
            }
            return list
        }

        func main() {
            var pa [2][]int
            pa[0] = prbsgen(50, 9)
            pa[1] = prbsgen(50, 14)
            var pl []struct {
            x int
            y int
        }
            pl = pairgen(pa)
            println("Generated pair:")
            printpairl(pl)
            println("Closest pair:")
            var pp struct {
            p1 struct {
                x int
                y int
            }
            p2 struct {
                x int
                y int
            }
        } = closestPair(pl)
            printpair(pp.p1)
            println()
            printpair(pp.p2)
        }
        |])
    ]
