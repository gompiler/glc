// expression of case is different from the switch expr
/* switch expr {
   case e1:
}*/ // Doesn't typecheck because typeof expr is not the same as typeof e1

package main

func main() {
	var a int = 0;
	switch a {
	case "0":
		print("Int is a String")
	}
}
