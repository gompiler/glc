//~0 32 0
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

func main() {
	var arr [9]int
	var sl []int
	sl = append(sl, 11)
	var s struct {a int;}
	a, b, c := reta(arr), retsl(sl), rets(s)
	a[0] = 44
	b[0] = 32
	c.a = 11
	println(arr[0], sl[0], s.a)
}
