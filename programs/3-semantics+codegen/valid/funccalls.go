//~0 11 0 h
package main

func mutate(arr [9]int, sl []int, s struct { a int; }, str string) {
	arr[3] = 4
	sl[0] = 11
	s.a = 21
}

func main() {
	var arr [9]int
	var sl []int
	sl = append(sl, 0)
	var s struct { a int; }
	var str string = "h"
	mutate(arr, sl, s, str)
	println(arr[3], sl[0], s.a, str)
}
