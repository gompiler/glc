//~true
//~true
//~false
//~true
//~true
//~true
//~false
package main

func main() {
	var a1 struct { _ int; }
	var a2 struct { _ int; }
	println(a1 == a2)
	var a3 struct { a int; }
	var a4 struct { a int; }
	println(a3 == a4)
	a3.a = 5
	println(a3 == a4)
	var a5 struct { a struct { _ struct { _ int; }; }; }
	var a6 struct { a struct { _ struct { _ int; }; }; }
	println(a5 == a6)
	var a7 struct { a struct { a [3]struct { a [4]struct {a [9][8][7][6][5]int; }; }; }; }
	var a8 struct { a struct { a [3]struct { a [4]struct {a [9][8][7][6][5]int; }; }; }; }
	println(a7 == a8)
	a7.a.a[2].a[3].a[8][7][6][5][4] = 0
	println(a7 == a8)
	a7.a.a[2].a[3].a[8][7][6][5][4] = 3
	println(a7 == a8)
}
