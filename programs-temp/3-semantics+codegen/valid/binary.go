//~aaaaaaab
//~true
//~false
//~true
//~true
//~false
//~false
//~false
//~true
//~false
//~true
//~6
//~false
//~false
//~false
//~true
//~true
//~false
//~true
//~true
//~false
//~true
//~8
//~2
//~2
//~0
//~6
//~0
//~16
//~1
//~4
//~6
//~+6.000000e+000
//~false
//~false
//~false
//~true
//~true
//~false
//~true
//~true
//~false
//~true
//~+8.000000e+000
//~+2.000000e+000
//~+2.000000e+000
//~true
//~ptrue 7
//~true
//~pfalse 9
//~true
//~false
//~true
//~false

package main

func ptrue(n int) bool{
	println("ptrue", n)
	return true
}

func pfalse(n int) bool{
	println("pfalse", n)
	return false
}

func main() {
	{
		var s1, s2 = "aaaa", "aaab"
		var s3 = "aaaa"
		println(s1 + s2)
		println(s1 < s2)
		println(s1 < s3)
		println(s1 <= s2)
		println(s1 <= s3)
		println(s1 > s2)
		println(s1 > s3)
		println(s1 >= s2)
		println(s1 >= s3)
		println(s1 == s2)
		println(s1 == s3)
	}
	{
		var s1, s2 = 4, 2
		var s3 = 4
		println(s1 + s2)
		println(s1 < s2)
		println(s1 < s3)
		println(s1 <= s2)
		println(s1 <= s3)
		println(s1 > s2)
		println(s1 > s3)
		println(s1 >= s2)
		println(s1 >= s3)
		println(s1 == s2)
		println(s1 == s3)
		println(s1 * s2)
		println(s1/s2)
		println(s1 - s2)
		println(s1 % s2)
		println(s1 | s2)
		println(s1 & s2)
		println(s1 << s2)
		println(s1 >> s2)
		println(s1 &^ s2)
		println(s1 ^ s2)
	}
	{
		var s1, s2 = 4.0, 2.0
		var s3 = 4.0
		println(s1 + s2)
		println(s1 < s2)
		println(s1 < s3)
		println(s1 <= s2)
		println(s1 <= s3)
		println(s1 > s2)
		println(s1 > s3)
		println(s1 >= s2)
		println(s1 >= s3)
		println(s1 == s2)
		println(s1 == s3)
		println(s1 * s2)
		println(s1/s2)
		println(s1 - s2)
	}
	println(true || ptrue(3))
	println(false || ptrue(7))
	println(pfalse(9) || true)
	println(false && ptrue(99))
	println(false || true || false || false || true || false || false || false)
	println(true && true && true && true && true && false && true)
}
