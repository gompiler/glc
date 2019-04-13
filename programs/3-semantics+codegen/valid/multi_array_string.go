//~5
//~1
//~3
package main

type t [5][1][3]string

func main() {
	var s t
	println(cap(s))
	println(cap(s[0]))
	println(cap(s[0][0]))
	println(s[0][0][0])
	
}
