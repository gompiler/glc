// Using the selector operator on a struct that does not have that field
// expr.id does not typecheck because the type of expr does not have a field named id

package main

type big struct {
	tiny int
}

func main() {
	var b big
	b.large = 9999
}
