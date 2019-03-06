// Indexing into an expression that isn't a slice or an array
// expr[index] isn't well-typed because expr doesn't resolve to []T or [N]T

package main

func main() {
	var a string = "hello"; // Although a string is a slice in Go, they are not slices in GoLite
	b := a[3]
}
