// Function call with arguments of different type than the function's arguments
// expr(arg1, arg2, ..., argk) is not well typed because some of the args are of different type than the parameter types of expr

package main

func plus(a, b int) int {
	return a + b
}

func main() {
	a := plus(3, "4")
}
