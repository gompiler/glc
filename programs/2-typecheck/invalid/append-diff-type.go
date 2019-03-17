// Appending an expression of a certain type to a slice of a different type
// append(e1, e2) is not well typed because e1 resolves to []T1 and e2 resolves to T2 where T1 != T2

package main

func main() {
	var s []int
	s = append(s, 5.0)
}
