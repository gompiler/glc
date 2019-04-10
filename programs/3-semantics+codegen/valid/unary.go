//~-31
//~31
//~-31
//~31
//~-32
//~31
//~-33
//~-103
//~103
//~-103
//~103
//~-104
//~103
//~-105
//~-2.244000e+001
//~+2.244000e+001
//~-2.244000e+001
//~+2.244000e+001
//~false
//~true

package main

func main() {
	int, float, rune, bool := 31, 22.44, 'g', true
	println(-int)
	println(+int)
	println(+-int)
	println(-(-int))
	println(^int)
	println(^(^int))
	println(^(-(+(^(-(-(+(int))))))))
	println(-rune)
	println(+rune)
	println(+-rune)
	println(-(-rune))
	println(^rune)
	println(^(^rune))
	println(^(-(+(^(-(-(+(rune))))))))
	println(-float)
	println(+float)
	println(+-float)
	println(-(-float))
	println(!bool)
	println(!(!(!(!bool))))
}
