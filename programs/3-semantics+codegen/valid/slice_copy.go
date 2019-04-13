//~0
package main

type s struct {
	x int
}

func main() {
	var a [1][1]s
	_ = a[0]
	var b [1][1]s
	b = a
	println(b[0][0].x)
}
