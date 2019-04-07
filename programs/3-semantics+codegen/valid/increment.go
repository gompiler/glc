//~4 +6.700000e+000 101
//~3 +5.700000e+000 100
//~exec pret 0
//~exec pret 1
//~exec pret 2
//~exec pret 3
//~93 93 1 -1
package main

func pret(n int) int{
	println("exec pret", n)
	return n
}

func main() {
	var a = 3
	b := 5.7
	c := 'd'
	a++
	b++
	c++
	println(a, b, c)
	a--
	b--
	c--
	println(a, b, c)
	{
		var a []int
		var b [4]int
		a = append(a, 92)
		a = append(a, 94)
		a[pret(0)]++
		a[pret(1)]--
		b[pret(2)]++
		b[pret(3)]--
		println(a[0], a[1], b[2], b[3])
	}
}
