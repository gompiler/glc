// Returning nothing from a function that is non-void
// return does not typecheck because the enclosing function is not void
package main

func retInt() int{
	return
}

