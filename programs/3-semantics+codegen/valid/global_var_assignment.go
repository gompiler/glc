//~0
//~1
//~0
package main

var x int

func t() {
	println(x)
}

func main() {
	println(x)
	var x = x
	x++
	println(x)
	t()
}
