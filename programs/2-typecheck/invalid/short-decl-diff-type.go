// Short declaration where the already defined variables on the left-hand side are not of the same type as their assigned expr
// x1, x2, ..., xk := e1, e2, ..., ek doesn't typecheck because a variable on lhs has different type than its corresponding expr
package main

func main() {
	var a int
	var c string
	a, b, c := 1, 2, 3
}
