//~11
//~22
//~39
package main

func _() {
	println(31)
}

func _(_, _, _, a int) {
	println(32)
}

func _(_, _, _ int) {
	println(33)
}

func p(n int) int{
	println(n)
	return n
}

func main() {
	_, a, _ := p(11), 3, p(39)
	_ = p(22)
}
