// Casting a float to a string is not valid
// type(expr) is not well-typed because type resolves to a string and expr does not resolve to an integer type

package main

func main() {
	print(string(5.0))
}
