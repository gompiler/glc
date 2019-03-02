// Operations for n-tuples (treat each tuple as a slice), generating them, printing them, etc.
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

