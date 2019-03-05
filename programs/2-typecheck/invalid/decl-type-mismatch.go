// Trying to declare and assign a variable to an expression of a different type than what was explicitly stated
// var x T = expr fails because expr is not of type T
package main

func main() {
	var a int = "5";
}

