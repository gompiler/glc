// Assignment to non-addressable field
// v = e does not typecheck because v is not an addressable field
package main

func main() {
	(3 + 4) = 7
}

