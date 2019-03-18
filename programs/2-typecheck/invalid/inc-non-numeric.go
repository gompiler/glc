// Using increment with an expression that doesn't resolve to a numeric base type
// expr++ doesn't typecheck because expr does not resolve to a numeric base type

package main

func main() {
	var a string
	a++
}

