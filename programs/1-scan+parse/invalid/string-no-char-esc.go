// Will fail at scanning phase, we cannot escape single quotes inside of an interpreted string
package main

func main(){
     var r rune = '\'' // This is valid
     var s string = "\'" // This is not valid
     var s2 string = "'" // This is valid
}