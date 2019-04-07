//~true
//~false
//~true
//~false
package main

func main() {
	var a [3]int
	var b [3]int
	for i := 0; i < 3; i++ {
		a[i] = i
		b[i] = i
	}
	println(a == b)
	b[2] = 7
	println(a == b)

	var as1 [2]struct { a int; }
	var as2 [2]struct { a int; }
	println(as1 == as2)
	as1[1].a = 3
	println(as1 == as2)
}
