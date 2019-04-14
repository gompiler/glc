//~0
//~3
//~+0.000000e+000
//~+3.000000e+000
//~0
//~97
//~0
//~0
//~0
package main

var i int
var i3 = 3
var f float64
var f3 = 3.0
var c rune
var c3 = 'a'

type st struct {
	x int
}

var s st
var a [2]int
var sl []int

func main() {
	println(i)
	println(i3)
	println(f)
	println(f3)
	println(c)
	println(c3)
	println(s.x)
	println(a[0])
	println(cap(sl))
}
