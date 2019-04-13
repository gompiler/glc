//~bar
//~init1
//~init2
//~init3
//~init4
//~init5
//~main
package main

func init() {
	println("init1")
}

func foo(a struct{a int;}) {
	println("foo")
}

func init() {
	println("init2")
}

func main() {
	println("main")
}

func init() {
	println("init3")
}

func bar() int {
	println("bar")
	return 0
}

func init() {
	println("init4")
}

var _ = bar()

func init() {
	println("init5")
}

