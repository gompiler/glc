//~8
//~8
package main

func main() {
	var a = 8
	{
		var a = a
		println(a)
	}
	{
		var a int = a
		println(a)
	}
}
