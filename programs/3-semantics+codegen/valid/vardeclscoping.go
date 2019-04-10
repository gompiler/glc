//~5
//~5
//~5
package main

func main() {
	var a = 5
	{
		var a = a
		println(a)
	}
	{
		a := a
		println(a)
	}
	{
		var a int = a
		println(a)
	}
}
