//~1
//~2
//~0
package main

var g = 1

func main() {

}

func init() {
	println(g)
	g += 1
}

func init() {
	println(g)
	g += 2
}

func init() {
	var g = 0
	println(g)
	g++
}
