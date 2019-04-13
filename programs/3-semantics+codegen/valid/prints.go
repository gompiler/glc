//~
//~bcd
//~0
//~1
//~-1
//~1
//~-3.300000e+000
//~+3.300000e+000
//~hello	world
//~hello\tworld
//~a
package main

func main() {
	var a string
	println(a) // null
	println(a + "b" + a + "c" + "d")
	println(0)
	println(1)
	println(-1)
	println(-(-1))
	println(-3.3)
	println(3.3)
	println("hello\tworld")
	println(`hello\tworld`)
	println('a')
}
