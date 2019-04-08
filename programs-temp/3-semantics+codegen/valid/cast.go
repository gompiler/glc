//~A
//~d
//~hello
//~13
//~13
//~65
//~65
//~100
//~100
//~+6.500000e+001
//~+1.390000e+001
//~+1.000000e+002
//~+1.300000e+001

package main

func main() {
	var a, b, c, d = 65, 13.9, 'd', "hello"
	println(string(a))
	println(string(c))
	println(string(d))
	println(int(b))
	println(rune(b))
	println(int(a))
	println(rune(a))
	println(int(c))
	println(rune(c))
	println(float64(a))
	println(float64(b))
	println(float64(c))
	println(float64(int(b)))
}
