//~ 0

package main

type s struct {
	x int
}

func main() {
	var a [][]s
	var aa []s
	var _s s

	aa = append(aa, _s)

	a = append(a, aa)

	a = append(a, aa)
	
	_s.x = 2
	
	println(a[0][0].x)
}
