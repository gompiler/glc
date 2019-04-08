// Operations for n-tuples (treat each tuple as a slice), generating them, printing them, etc.
//~1, 98, 1, 31
//~2, 97, 2, 30
//~3, 96, 3, 29
//~4, 95, 4, 28
//~5, 94, 5, 27
//~6, 93, 6, 26
//~7, 92, 7, 25
//~8, 91, 8, 24
//~9, 90, 9, 23
//~10, 89, 10, 22
//~11, 88, 11, 21
//~12, 87, 12, 20
//~13, 86, 13, 19
//~14, 85, 14, 18
//~15, 84, 15, 17
//~16, 83, 16, 16
//~17, 82, 17, 15
//~18, 81, 18, 14
//~19, 80, 19, 13
//~20, 79, 20, 12
//~21, 78, 21, 11
//~22, 77, 22, 10
//~23, 76, 23, 9
//~24, 75, 24, 8
//~25, 74, 25, 7
//~26, 73, 26, 6
//~27, 72, 27, 5
//~28, 71, 28, 4
//~29, 70, 29, 3
//~30, 69, 30, 2
//~31, 68, 31, 1
//~32, 67, 32
//~33, 66, 33
//~34, 65, 34
//~35, 64, 35
//~36, 63, 36
//~37, 62, 37
//~38, 61, 38
//~39, 60, 39
//~40, 59, 40
//~41, 58, 41
//~42, 57, 42
//~43, 56, 43
//~44, 55, 44
//~45, 54, 45
//~46, 53, 46
//~47, 52
//~48, 51
//~49, 50
//~50, 49
//~51, 48
//~52, 47
//~53, 46
//~54, 45
//~55, 44
//~56, 43
//~57, 42
//~58, 41
//~59, 40
//~60, 39
//~61, 38
//~62, 37
//~63, 36
//~64, 35
//~65, 34
//~66, 33
//~67, 32
//~68, 31
//~69, 30
//~70, 29
//~71, 28
//~72, 27
//~73, 26
//~74, 25
//~75, 24
//~76, 23
//~77, 22
//~78, 21
//~79, 20
//~80, 19
//~81, 18
//~82, 17
//~83, 16
//~84, 15
//~85, 14
//~86, 13
//~87, 12
//~88, 11
//~89, 10
//~90, 9
//~91, 8
//~92, 7
//~93, 6
//~94, 5
//~95, 4
//~96, 3
//~97, 2
//~98, 1

package main

func max(a, b int) int{
	if a > b {
		return a
	} else {
		return b
	}
}

func min(a, b int) int{
	return -(max (-a, -b))
}

func zip(a [][]int, b [][]int) [][]int{
	var combine [][]int = a
	m_a := len(a)
	m_b := len(b)
	if m_b > m_a {
		// Always have longest slice
		return zip(b, a)
	} else {
		m := min(m_a, m_b)
		for i := 0; i < m; i++ {
			n := min(len(a[i]), len(b[i]))
			for j := 0; j < n; j++{
				combine[i] = append(combine[i], b[i][j])
			}
		}
		return combine
	}
}

// Generate list of natural numbers, rev is whether we want it reversed or not (increasing vs decreasing)
func nats(max int, rev bool) []int{
	var list []int
	if rev {
		for i := max; i > 0; i-- {
			list = append(list, i)
		}
	} else {
		for i := 0; i < max; i++ {
			list = append(list, i)
		}
	}
	return list
}

// List of list of nats, 1 per list
func natsL(max int, rev bool) [][]int{
	var list [][]int
	if rev {
		for i := max; i > 0; i-- {
			var inner []int
			inner = append(inner, i)
			list = append(list, inner)
		}
	} else {
		for i := 0; i < max; i++ {
			var inner []int
			inner = append(inner, i)
			list = append(list, inner)
		}
	}
	return list
}

func printlist(l []int){
	n := len(l)
	if n > 0 {
		print(l[0])
		for i := 1; i < n; i++ {
			print(", ")
			print(l[i])
		}
	}
}

func printlist2(l [][]int){
	n := len(l)
	for i := 1; i < n; i++ {
		printlist(l[i])
		println()
	}
}

func main() {
	printlist2(zip((zip(natsL(99, false), natsL(99, true))), (zip(natsL(32, true), natsL(47, false)))))
}
