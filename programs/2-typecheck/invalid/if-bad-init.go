// if init doesn't typecheck
// if init; expr {} doesn't typecheck because init doesn't typecheck
package main

func main() {
	var a string
	if a = 5; true {
		
	}
}
