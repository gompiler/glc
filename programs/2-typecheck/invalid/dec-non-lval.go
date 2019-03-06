// Using decrement with a non lvalue
// expr-- does not typecheck because expr isn't an lvalue
package main

func main() {
	var a int
	(a + 5)++
}
