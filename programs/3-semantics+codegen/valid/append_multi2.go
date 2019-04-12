//~2
//~3
//~2
//~3
//~0
//~3
//~0
//~3
//~0
//~0
//~0
//~0

package main

type s struct {
	x int
}

func main() {
	var a [][]s
	var aa []s
	var _s s
	_s.x = 2
	
	aa = append(aa, _s)
	
	_s.x = 3
	
	aa_1 := append(aa, _s)
	aa_2 := append(aa, _s)
	
	a = append(a, aa_1)
	a = append(a, aa_2)
	
	println(a[0][0].x)
	println(a[0][1].x)
	println(a[1][0].x)
	println(a[1][1].x)
	
	var _s2 s
	
	// Modification affects both nested slice
	aa[0] = _s2
	
	println(a[0][0].x)
	println(a[0][1].x)
	println(a[1][0].x)
	println(a[1][1].x)
	
	var _s3 s
	_s3.x = 4
	
	// Size 3; new copy
	aa_3 := append(aa_1, _s3)
	aa_4 := append(aa_1, _s3)
	
	a = append(a, aa_3)
	a = append(a, aa_4)
	
	println(a[2][0].x)
	println(a[3][0].x)
	
	// Modification does not affect slices since they are copied
	aa_1[0] = _s3
	
	println(a[2][0].x)
	println(a[3][0].x)
}
