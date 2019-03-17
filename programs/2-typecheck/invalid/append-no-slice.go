// Appending to an expression that isn't a slice
// append(e1, e2) isn't well typed because e1 isn't a slice

package main

func main() {
	var a [5]int
	a = append(a, 3)
}
