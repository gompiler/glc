//~3
//~13
//~99
//~3
//~29
package main

func main() {
	if a := false; a {
		println(1)
	} else if a := true; !a {
		println(2)
	} else if a {
		println(3)
	} else {
		println(4)
	}

	if b1 := false; false {
		println(11)
	} else if b2 := true; b1 {
		println(12)
	} else if b2 {
		println(13)
	} else {
		println(14)
	}

	if c := 99; false {
		println(33)
	} else {
		println(c)
	}

	var a = 29

	if a := 2; false {
		println("ll")
		println(a)
	} else if a := 3; false {
		println("zz")
	} else {
		println(a)
	}

	println(a)
}
