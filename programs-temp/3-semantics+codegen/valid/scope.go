//~21
//~22
//~46

package main

var g int = 21

func g2(){
	var g int = 22
	println(g)
}

// Increment global g
func gplus(){
	{
		var g = g
	}
	g++
}

// Increment local g, no effect on global g
func gplusl(){
	var g = g
	g++
}

func main() {
	{ var g = 0; }
	for ;g == 21; gplus() {
		{ var g = 0; }
		println(g)
	}
	gplusl()
	if g != 22 {
		print(200)
	} else if g == 22 {
		g2()
	} else {
		print(31)
	}

	switch gplus(); g {
	case 22:
		{ var g = 0; }
		g = 44
		println(g)
	case g:
		{ var g = 0; }
		g = 46
		println(g)
	default:
		{ var g = 0; }
		g = 29
		println(g)
	}
}
