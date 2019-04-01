// Test which switch cases are entered
//~1
//~234
//~2
//~235
//~3
//~4
//~137
//~5
//~438
//~6
//~132
//~2
package main

func println2(n int){
	println(n)
}

var g int = 0

func gplus() int{
	g++
	return g
}

func main() {
	// Match case with only 1 element
	// Prints 1 then 234
	switch println2(1); 34 {
	case 1, 2, 5, 7, 9, 24:
		println2(69)
	case 34:
		println2(234)
	}
	// Match case with multiple elements
	// Prints 2 then 235
	switch println2(2); 35 {
	case 1, 2, 5, 7, 9, 24:
		println2(69)
	case 22, 35, 55, 99, 101:
		println2(235)
	}
	// Match no case
	// Prints 3
	switch println2(3); 36 {
	case 1, 2, 5, 7, 9, 24:
		println2(69)
	case 22, 35, 55, 99, 101:
		println2(235)
	}

	// Match first case
	// Prints 4, then 137
	switch println2(4); 37 {
	case 37:
		println2(137)
	case 37:
		println2(237)
	case 37, 44:
		println2(337)
	}

	// Match default
	// Prints 5, then 438
	switch println2(5); 38 {
	case 37:
		println2(138)
	case 37:
		println2(238)
	case 37, 44:
		println2(338)
	default:
		println2(438)
	}

	switch println2(6); {
	case 32 == 32:
		println2(132)
	case true:
		println2(99)
	default:
		println2(122)
	}

	switch gplus() {
	case 2:
		println(1)
	case 1:
		println(2)
	case 2:
		println(3)
	}
}
