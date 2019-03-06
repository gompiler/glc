// Short declaration where all the variables on the left hand side are already declared in the current scope
// x1, x2 , ..., xk := e1, e2, ..., ek does not type check because x1, ..., xk are already declared in current scope

package main

func main() {
	var a int;
	var b int;
	a, b := 1,2
}
