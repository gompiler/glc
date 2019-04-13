//~2
package main

type s1 struct {
	f float64
	s []s2
}

type s2 struct {
	f float64
	s [] s1
}

func main() {
	var a1 s1
	var a2 s2
	a2.f = 2.0
	a1.s = append(a1.s, a2)
	a2.s = append(a2.s, a1)
	println(a2.s[0].s[0].f)
	
}
