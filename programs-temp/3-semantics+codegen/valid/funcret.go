//~5
//~5
//~+3.100000e+000
//~+3.100000e+000
//~102
//~102
//~ABC
//~ABC
//~2
//~2
//~9
//~9
//~+4.400000e+000
//~+4.400000e+000
//~+9.200000e+000
//~+9.200000e+000
//~108
//~108
//~100
//~100
//~hi
//~hi
//~gol
//~gol
//~25
//~25
//~66
//~66
//~+1.230000e+000
//~+1.230000e+000
//~+9.925000e+001
//~+9.925000e+001
//~122
//~122
//~103
//~103
//~www
//~www
//~lllll
//~lllll
//~1
//~1
//~+2.000000e+000
//~+2.000000e+000
//~3
//~3
//~4
//~4
//~9
//~9
//~10
//~10
//~+1.100000e+001
//~+1.100000e+001
//~+1.200000e+001
//~+1.200000e+001
//~13
//~13
//~14
//~14
//~15
//~15
//~16
//~16
//~17
//~17
//~18
//~18
//~+1.900000e+001
//~+1.900000e+001
//~+2.000000e+001
//~+2.000000e+001
//~21
//~21
//~22
//~22
//~23
//~23
//~24
//~24
//~1
//~1
//~+2.000000e+000
//~+2.000000e+000
//~3
//~3
//~4
//~4
//~9
//~9
//~10
//~10
//~+1.100000e+001
//~+1.100000e+001
//~+1.200000e+001
//~+1.200000e+001
//~13
//~13
//~14
//~14
//~15
//~15
//~16
//~16
//~17
//~17
//~18
//~18
//~+1.900000e+001
//~+1.900000e+001
//~+2.000000e+001
//~+2.000000e+001
//~21
//~21
//~22
//~22
//~23
//~23
//~24
//~24
//~1
//~1
//~+2.000000e+000
//~+2.000000e+000
//~3
//~3
//~4
//~4
//~9
//~9
//~10
//~10
//~+1.100000e+001
//~+1.100000e+001
//~+1.200000e+001
//~+1.200000e+001
//~13
//~13
//~14
//~14
//~15
//~15
//~16
//~16
//~17
//~17
//~18
//~18
//~+1.900000e+001
//~+1.900000e+001
//~+2.000000e+001
//~+2.000000e+001
//~21
//~21
//~22
//~22
//~23
//~23
//~24
//~24
//~1
//~1
//~+2.000000e+000
//~+2.000000e+000
//~3
//~3
//~4
//~4
//~9
//~9
//~10
//~10
//~+1.100000e+001
//~+1.100000e+001
//~+1.200000e+001
//~+1.200000e+001
//~13
//~13
//~14
//~14
//~15
//~15
//~16
//~16
//~17
//~17
//~18
//~18
//~+1.900000e+001
//~+1.900000e+001
//~+2.000000e+001
//~+2.000000e+001
//~21
//~21
//~22
//~22
//~23
//~23
//~24
//~24
//~1000
//~1000

package main

type int2 int
type float2 float64
type char rune
type string2 string

type ints []int
type int2s []int2
type floats []float64
type float2s []float2
type runes []rune
type chars []char
type strings []string
type string2s []string2

type inta [3]int
type int2a [3]int2
type floata [3]float64
type float2a [3]float2
type runea [3]rune
type chara [3]char
type stringa [3]string
type string2a [3]string2

type big struct {
	fint int
	ffloat64 float64
	frune rune
	fstring string
	fint2 int2
	ffloat2 float2
	fchar char
	fstring2 string2
	fints ints
	fint2s int2s
	ffloats floats
	ffloat2s float2s
	frunes runes
	fchars chars
	fstrings strings
	fstring2s string2s
	finta inta
	fint2a int2a
	ffloata floata
	ffloat2a float2a
	frunea runea
	fchara chara
	fstringa stringa
	fstring2a string2a
}

type bigger struct {
	b big
	ba [3]big
	bs []big
}
func ptype0(arg int)int {
	println(arg)
	return(arg)
}
func ptype1(arg float64)float64 {
	println(arg)
	return(arg)
}
func ptype2(arg rune)rune {
	println(arg)
	return(arg)
}
func ptype3(arg string)string {
	println(arg)
	return(arg)
}
func ptype4(arg ints)ints {
	println(arg[0])
	return(arg)
}
func ptype5(arg int2s)int2s {
	println(arg[0])
	return(arg)
}
func ptype6(arg floats)floats {
	println(arg[0])
	return(arg)
}
func ptype7(arg float2s)float2s {
	println(arg[0])
	return(arg)
}
func ptype8(arg runes)runes {
	println(arg[0])
	return(arg)
}
func ptype9(arg chars)chars {
	println(arg[0])
	return(arg)
}
func ptype10(arg strings)strings {
	println(arg[0])
	return(arg)
}
func ptype11(arg string2s)string2s {
	println(arg[0])
	return(arg)
}
func ptype12(arg inta)inta {
	println(arg[2])
	return(arg)
}
func ptype13(arg int2a)int2a {
	println(arg[2])
	return(arg)
}
func ptype14(arg floata)floata {
	println(arg[2])
	return(arg)
}
func ptype15(arg float2a)float2a {
	println(arg[2])
	return(arg)
}
func ptype16(arg runea)runea {
	println(arg[2])
	return(arg)
}
func ptype17(arg chara)chara {
	println(arg[2])
	return(arg)
}
func ptype18(arg stringa)stringa {
	println(arg[2])
	return(arg)
}
func ptype19(arg string2a)string2a {
	println(arg[2])
	return(arg)
}
func ptype20(arg big)big {
	_ = ptype0(ptype0(arg.fint))
	_ = ptype1(ptype1(arg.ffloat64))
	_ = ptype2(ptype2(arg.frune))
	_ = ptype3(ptype3(arg.fstring))
	_ = ptype4(ptype4(arg.fints))
	_ = ptype5(ptype5(arg.fint2s))
	_ = ptype6(ptype6(arg.ffloats))
	_ = ptype7(ptype7(arg.ffloat2s))
	_ = ptype8(ptype8(arg.frunes))
	_ = ptype9(ptype9(arg.fchars))
	_ = ptype10(ptype10(arg.fstrings))
	_ = ptype11(ptype11(arg.fstring2s))
	_ = ptype12(ptype12(arg.finta))
	_ = ptype13(ptype13(arg.fint2a))
	_ = ptype14(ptype14(arg.ffloata))
	_ = ptype15(ptype15(arg.ffloat2a))
	_ = ptype16(ptype16(arg.frunea))
	_ = ptype17(ptype17(arg.fchara))
	_ = ptype18(ptype18(arg.fstringa))
	_ = ptype19(ptype19(arg.fstring2a))
	return(arg)
}
func ptype21(arg bigger)bigger {
	ptype20(arg.b)
	// ptype20(arg.ba[0])
	// ptype20(arg.bs[0])
	return(arg)
}
func ptype22(arg struct{f int; f2 string;})struct {f int; f2 string;} {
	println(arg.f)
	return arg
}

func initBig()big {
	var ret big
	ret.fint = 1
	ret.ffloat64 = 2.0
	ret.frune = rune(3)
	ret.fstring = "4"
	ret.fint2 = int2(5)
	ret.ffloat2 = float2(6.0)
	ret.fchar = char(7)
	ret.fstring2 = string2("8")
	var t0 ints
	t0 = append(t0, 9)
	var t1 int2s
	t1 = append(t1, int2(10))
	var t2 floats
	t2 = append(t2, 11.0)
	var t3 float2s
	t3 = append(t3, float2(12.0))
	var t4 runes
	t4 = append(t4, rune(13))
	var t5 chars
	t5 = append(t5, char(14))
	var t6 strings
	t6 = append(t6, "15")
	var t7 string2s
	t7 = append(t7, string2("16"))
	ret.fints = t0
	ret.fint2s = t1
	ret.ffloats = t2
	ret.ffloat2s = t3
	ret.frunes = t4
	ret.fchars = t5
	ret.fstrings = t6
	ret.fstring2s = t7
	var ta0 inta
	ta0[2] = 17
	var ta1 int2a
	ta1[2] = int2(18)
	var ta2 floata
	ta2[2] = 19.0
	var ta3 float2a
	ta3[2] = float2(20.0)
	var ta4 runea
	ta4[2] = rune(21)
	var ta5 chara
	ta5[2] = char(22)
	var ta6 stringa
	ta6[2] = "23"
	var ta7 string2a
	ta7[2] = string2("24")
	ret.finta = ta0
	ret.fint2a = ta1
	ret.ffloata = ta2
	ret.ffloat2a = ta3
	ret.frunea = ta4
	ret.fchara = ta5
	ret.fstringa = ta6
	ret.fstring2a = ta7
	return ret
}

func main() {
	var unused0 = ptype0(ptype0(5))
	var unused1 = ptype1(ptype1(3.1))
	var unused2 = ptype2(ptype2('f'))
	var unused3 = ptype3(ptype3("ABC"))

	var t0 ints
	t0 = append(t0, 2)
	var t1 int2s
	t1 = append(t1, int2(9))
	var t2 floats
	t2 = append(t2, 4.4)
	var t3 float2s
	t3 = append(t3, float2(9.2))
	var t4 runes
	t4 = append(t4, 'l')
	var t5 chars
	t5 = append(t5, char('d'))
	var t6 strings
	t6 = append(t6, "hi")
	var t7 string2s
	t7 = append(t7, string2("gol"))
	var unused4 = ptype4(ptype4(t0))
	var unused5 = ptype5(ptype5(t1))
	var unused6 = ptype6(ptype6(t2))
	var unused7 = ptype7(ptype7(t3))
	var unused8 = ptype8(ptype8(t4))
	var unused9 = ptype9(ptype9(t5))
	var unused10 = ptype10(ptype10(t6))
	var unused11 = ptype11(ptype11(t7))
	var ta0 inta
	ta0[2] = 25
	var ta1 int2a
	ta1[2] = int2(66)
	var ta2 floata
	ta2[2] = 1.23
	var ta3 float2a
	ta3[2] = float2(99.25)
	var ta4 runea
	ta4[2] = 'z'
	var ta5 chara
	ta5[2] = char('g')
	var ta6 stringa
	ta6[2] = "www"
	var ta7 string2a
	ta7[2] = string2("lllll")
	var unused12 = ptype12(ptype12(ta0))
	var unused13 = ptype13(ptype13(ta1))
	var unused14 = ptype14(ptype14(ta2))
	var unused15 = ptype15(ptype15(ta3))
	var unused16 = ptype16(ptype16(ta4))
	var unused17 = ptype17(ptype17(ta5))
	var unused18 = ptype18(ptype18(ta6))
	var unused19 = ptype19(ptype19(ta7))
	var b big = initBig()
	// var bt big
	var bb bigger
	bb.b = b
	var unused20 = ptype20(ptype20(b))
	var unused21 = ptype21(ptype21(bb))
	var s struct {f int; f2 string;}
	s.f = 1000
	var unused22 = ptype22(ptype22(s))
	_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_ =		unused0,unused1,unused2,unused3,unused4,unused5,unused6,unused7,unused8,unused9,unused10,unused11,unused12,unused13,unused14,unused15,unused16,unused17,unused18,unused19,unused20,unused21, unused22

}
