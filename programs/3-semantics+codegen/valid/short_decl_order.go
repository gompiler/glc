//~foo
//~foo
//~2
//~1
//~2
//~2
//~2
package main

var a int

func foo() int {
	a++
	println("foo")
	return a
}

func main() {
	a, b, c, d, e := a, foo(), a, foo(), a
	println(a)
	println(b)
	println(c)
	println(d)
	println(e)
}
