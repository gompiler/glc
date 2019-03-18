// for loop (while variant) with the condition not being of type bool
// for expr {} doesn't typecheck because expr isn't a bool
package main

func main() {
	for 1 {
		print(111111)
	}
}

