//~1
//~2
//~4
//~31
package main

var g = 1

func main() {
	println(31)
}

func stuff() {
	println(g)
}

func init() {
	stuff()
	g++
}

func init() {
	stuff()
	g += 2
}

func init() {
	var g = 0
	stuff()
	g += 3
}
