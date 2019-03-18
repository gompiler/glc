// Function call where the expr/function does not exist, i.e. it doesn't have a type
// expr(arg1, arg2, ..., argk) is not well typed because expr is not well typed/doesn't have function type

package main

func main() {
	a := f()
}
