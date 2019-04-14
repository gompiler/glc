//~0
//~1
//~0
package main

var x int

func main() {
	println(x)
	var x = x
	x++
	println(x)
	t()
}

func t() {
	println(x)
}
