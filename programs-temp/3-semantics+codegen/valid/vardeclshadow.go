//~false
//~true
//~notmain int float64 rune string int2 float642 rune2 string2

package main

func main() {
	var true2 = true
	var false2 = false
	var true = false2
	var false = true2
	println(true)
	println(false)
	var main = "notmain"
	var int = "int"
	var float64 = "float64"
	var rune = "rune"
	var string = "string"
	// Can we declare variables after overwritting prim types?
	var int2 = "int2"
	var float642 = "float642"
	var rune2 = "rune2"
	var string2 = "string2"
	println(main, int, float64, rune, string, int2, float642, rune2, string2)
}
