//~1 99 a
//~comp520123
//~123
//~73
//~73
//~13303534
//~13303534
//~+1.000000e+015
//~+1.000000e+015
//~+1.000000e-013
//~+1.000000e-013
//~-1.000000e+015
//~-1.000000e+015
//~-1.000000e-013
//~-1.000000e-013
//~erro
//~erro
//~true
//~true
//~false
//~false

package main

func print3(n int) {
	print(n)
	print("\n")
	println(n)
}

func print3f(f float64) {
	print(f)
	print("\n")
	println(f)
}

func print3s(s string) {
	print(s)
	print("\n")
	println(s)
}

func print3b(b bool) {
	print(b)
	print("\n")
	println(b)
}

func main() {
	println(1, 'c', "a")
	print("comp", 520)
	print3(123)
	print3(0111)
	print3(0xCAFEEE)

	var big = 1000000000000000.0
	var small = 0.0000000000001
	print3f(big)
	print3f(small)
	print3f(-big)
	print3f(-small)
	// for i := 0; i < 4; i++ {
	// 	big *= big
	// 	small *= small
	// }
	// print3f(big)
	// print3f(small)
	print3s("erro")
	print3b(true)
	print3b(false)
}
