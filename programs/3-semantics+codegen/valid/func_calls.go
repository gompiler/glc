//~foo 0
//~0
//~foo 1
//~1
//~foo 2
//~2
//~foo 3
//~3
//~foo 4
//~4
//~foo 5
//~foo -2
//~foo 0
//~foo 2
//~case
package main

func main() {
	for i := 0; i < foo(i); i++ {
		println(i)
	}
	_ = foo(-2)
	switch foo(0) {
		case 1, 2, foo(2):
			println("case")
	}
	if false && foo(9) == 1 {
	
	}
}

func foo(i int) int {
	print("foo ")
	println(i)
	return 5
}