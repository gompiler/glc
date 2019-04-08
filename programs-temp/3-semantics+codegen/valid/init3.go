//~1
//~2
//~4
package main

var g = 1

func main() {

}

func stuff() {
	println(g)
}

func init() {
	stuff()
	g += 1
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
