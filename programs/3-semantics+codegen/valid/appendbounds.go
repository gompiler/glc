//!
package main

func main() {
	var a, b []int
	b = a
	a = append(a, 1)
	println(b[0])
}
