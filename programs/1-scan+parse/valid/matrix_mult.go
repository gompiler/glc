// Benchmark, performs matrix multiplication of large matrices
// We use the naive O(n^3) iterative algorithm
package main

// Treating matrix as [# ROWS][# COLS]
func mult(a [][]int, b [][]int) [][]int{
	m_a := len(a)
	n_a := len(a[0])
	m_b := len(b)
	n_b := len(b[0])

	var prod [][]int

	if n_a != m_b {
		return prod
	} else {
		for i := 0; i < m_a; i++ {
			var inner []int
			for j := 0; j < n_b; j++ {
				sum := 0
				for k :=0; k < n_a; k++ {
					sum += a[i][k] * b[k][j]
				}
				inner = append(inner, sum)
			}
			prod = append(prod, inner)
		}
		return prod
	}
}

func matrixGen(m, n int) [][]int{
	// Generate entries with a pseudorandom bitsequence
	var gen [][] int;
	for i := 0; i < m; i++ {
		var inner []int;
		for j := 0; j < n; j++ {
			// Use pseudorandom bitsequence 7 (x^7 + x^6 + 1) linear feedback shift register
			n := i + j
			n = (((n << 1) | (n >> 6) ^ (n >> 5) & 1) & 0x7f)
			inner = append(inner, n)
		}
		gen = append(gen, inner)
	}
	return gen
}

func main() {
	var a [][]int = matrixGen(1000, 1000);
	var b [][]int = matrixGen(1000, 1000);
	for i := 0; i < 10; i++ {
		mult(a,b)
	}
}

