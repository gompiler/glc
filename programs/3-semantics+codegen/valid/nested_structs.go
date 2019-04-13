//~+1.000000e+000
//~+2.000000e+000
//~+3.000000e+000
//~hello
package main

type s1 struct {
	f float64
	s []string
}

type s2 struct {
	f float64
	s [] s1
}

type s3 struct {
	f float64
	s [] s2
}


func main() {
	var a1 s1
	var a2 s2
	var a3 s3
	a1.f = 1.0
	a2.f = 2.0
	a3.f = 3.0
	a1.s = append(a1.s, "hello")
	a2.s = append(a2.s, a1)
	a3.s = append(a3.s, a2)
	println(a1.f)
	println(a2.f)
	println(a3.f)
	println(a3.s[0].s[0].s[0])
}
