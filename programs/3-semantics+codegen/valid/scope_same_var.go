//~8
//~8
package main

func main() {
	var a = 8
	{
		var int = a
		println(a)
	}
	{
		var a int = a
		println(a)
	}
}
