// Trying to print an expression that doesn't resolve to a base type
// print(e) does not typecheck because e isn't of a base type

package main

func main() {
	var a []int // Slice
	print(a) // a isn't a base type
}

