// Op-assignment where the variable and expression are not compatible with the operator
// v op= expr does not typecheck because op does not accept typeof(v) and typeof(expr) and return typeof(v)
package main

func main() {
	var a int = 5
	a += "1"
}
