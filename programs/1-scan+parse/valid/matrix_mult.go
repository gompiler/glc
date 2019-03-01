// Benchmark, performs matrix multiplication of large matrices
// We use the naive O(n^3) iterative algorithm because a divide and conquer algorithm is not feasible without variable size function param and return types
package main

// Treating matrix as [# ROWS][# COLS]
func mult(a [500][500]int, b [500][500]int) [500][500]int{

	var prod [500][500]int;
	for i := 0; i < 500; i++ {
		for j := 0; j < 500; j++ {
			sum := 0
			for k := 0; k < 500; k++ {
				sum += a[i][k] * b[k][j]
			}
			prod[i][j] = sum
		}
	}
	return prod
}

func matrixGen() [500][500]int{
	// Generate entries with a pseudorandom bitsequence
	// Use PRBS7
	var gen [500][500] int;
	for i := 0; i < 500; i++ {
		for j := 0; j < 500; j++ {
			n := i + j
			gen[i][j] = (((n << 1) | (n >> 6) ^ (n >> 5) & 1) & 0x7f)
		}
	}
	return gen
}

func main() {
	var a [500][500]int = matrixGen();
	var b [500][500]int = matrixGen();
	for i := 0; i < 10; i++ {
		mult(a,b)
	}
}

