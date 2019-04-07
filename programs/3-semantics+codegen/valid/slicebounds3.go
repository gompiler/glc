//!
package main

func main() {
	var a []int
	for i := 0; i < 30; i++ {
		a = append(a, i)
	}
	print(a[30])
}
