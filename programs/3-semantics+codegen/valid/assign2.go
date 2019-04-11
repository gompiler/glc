//~44 29
//~22 0
//~99 99
//~37 37
//~42 0
package main

func main() {
	var a, b int
	a = 29
	b = 44
	a, b = b, a
	println(a, b)
	var arr1, arr2 [100]int
	arr2 = arr1
	arr1[34] = 22
	println(arr1[34], arr2[34])

	var sl1, sl2 []int
	sl1 = append(sl1, 99)
	sl2 = sl1
	println(sl1[0], sl2[0])
	sl1[0] = 37
	println(sl1[0], sl2[0])

	var s1, s2 struct { a int; }
	s2 = s1
	s1.a = 42
	println(s1.a, s2.a)
}
