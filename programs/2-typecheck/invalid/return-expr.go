// Return an expression that isn't the same type as the return type of the function
// return expr does not typecheck because the type of expr is not the same return type of the enclosing function
package main;

func retInt() int {
	return "5"
}
