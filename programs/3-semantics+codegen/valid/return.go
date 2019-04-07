//~0 32 0 hello
package main

func reta(r [9]int)[9]int{
	return r
}

func retsl(r []int)[]int{
	return r
}

func rets(r struct {a int; })struct {a int;} {
	return r
}

func retstr(r string) string {
	return r
}

func main() {
	var arr [9]int
	var sl []int
	sl = append(sl, 11)
	var s struct {a int;}
	var str = "hello"
	a, b, c, d := reta(arr), retsl(sl), rets(s), retstr(str)
	a[0] = 44
	b[0] = 32
	c.a = 11
	d = "eee"
	_ = d
	println(arr[0], sl[0], s.a, str)
}
