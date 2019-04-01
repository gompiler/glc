//~1
//~+1.000000e+000
//~1
//~49

//~0

//~1
//~24
//~0
//~1
//~0

//~2
//~12
//~0
//~1
//~0

package main

func printarr (a [5]int){
	for i := 0; i < 5; i++{
		println(a[i])
	}
}

func printsl (s []int){
	var l = len(s)
	for i := 0; i < l; i++{
		println(s[i])
	}
}

func main() {
	var int1 int;
	int1 = 1
	var float1 float64;
	float1 = 1.0
	var string1 string;
	string1 = "1"
	var rune1 rune;
	rune1 = '1'

	println(int1)
	println(float1)
	println(string1)
	println(rune1)

	var inta [5]int

	inta[0], inta[1], inta[2], int1, inta[3] = int1, 24, inta[0], inta[0], int1

	println(int1)
	printarr(inta)

	var ints []int

	for i :=0; i < 5; i++{
		ints = append(ints, inta[i])
	}

	ints[0] += 1
	ints[1] /= 2
	ints[2] *= 2
	ints[3] %= 21

	printsl(ints)
}
