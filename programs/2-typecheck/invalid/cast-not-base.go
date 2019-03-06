// Casting to a type that isn't a base type
// type(expr) doesn't typecheck because type isn't a base type

package main

type int2 struct {
	x int
}

func main() {
	var a int2 = int2(5)
}
