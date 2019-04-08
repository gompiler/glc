//~infinite?
//~infinite2
//~fall
//~time to continue
//~fall
//~ok
//~1 2
//~pret exec 0
//~pret exec 1
//~pret exec 9

package main

func pret(n int) int{
	println("pret exec", n)
	return n
}

func main() {
	for {
		println("infinite?")
		break
	}
	for true {
		println("infinite2")
		break
	}
	for a, b := 3, 9; a < b || b == 3; a, b = b, a {
		if (a > b) {
			b++
			println("time to continue")
			continue
		}
		println("fall")
	}

	var a, b = 1, 2
	for a, _ := 3, 4; a == 3; a++ {
		println("ok")
	}
	println(a, b)

	for a := 9; false; pret(a) {
		println("no")
	}

	for i := 0; i < 2; i = pret(i) + 1 {
		continue
	}

	for ;; pret(11) {
		break
	}

	for i := 0; i < 2; i = pret(i) + 1 {
		i = 9
	}
}
