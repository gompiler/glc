// We cannot declare a function inside another function
package main

import "fmt"

func main() {
	func main2() {
		println("main's brother")
	}
}

