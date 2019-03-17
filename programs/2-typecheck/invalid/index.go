// Index does not resolve to an int
// expr[index] is not well typed because index does not resolve to an int

package main

func main() {
	var a []int
	a[5.0] = 3
}
