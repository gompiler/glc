//~exec pret 4
//~exec pret 5
//~in if
//~exec pret 8
//~exec pret 7
//~exec pret 8
//~exec pret 14
//~exec pret 14
//~in case

package main

func pret(n int) int{
	println("exec pret", n)
	return n
}

func main() {
	switch pret(4) {
	case pret(5):
		println(5)
	case 4:
		if (true) {
			for {
				break
			}
			println("in if")
			break
		}
		println("in case")
		break
	}

	switch pret(8) {
	case pret(7):
		println(5)
	case pret(8), pret(9):
		if (true) {
			break
		}
		println("in case")
		break
	}

	switch pret(14) {
	case pret(14):
		if (false) {
			break
		}
		println("in case")
		break
	}
}
