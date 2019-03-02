// break outside of for or switch is invalid and will fail at the parser phase
package main

func main() {
	for i = 0; i < 6; i++{
	}
	break;
}

