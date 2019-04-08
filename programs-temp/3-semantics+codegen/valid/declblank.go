//~11
//~39
//~22
//~tttt
//~4
package main

type l struct {
	_ int
}

type l2 struct {
	_ int
	a int
	_ int
}

func _() {
	println(31)
}

func _(_, _, _, a int) {
	println(32)
}

func _(_, _, _ int) {
	println(33)
}

func test(_ int, _ int) {
	println("tttt")
}

func retblank() l {
	var r l
	return r
}

func retl2(n int) l2 {
	var r l2
	r.a = n
	return r
}

func p(n int) int{
	println(n)
	return n
}

func main() {
	_, a, _ := p(11), 3, p(39)
	_ = p(22)
	_ = a
	test(5, 3)
	_ = retblank()
	println(retl2(4).a)
}
