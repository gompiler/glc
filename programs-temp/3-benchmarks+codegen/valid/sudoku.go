//&6 seconds
//~----------------------------------------------------
//~|0  16 8  2  |0  0  6  3  |0  0  0  13 |0  0  0  0  |
//~|10 0  0  9  |1  0  0  2  |8  0  16 3  |0  0  15 0  |
//~|12 0  11 1  |0  0  0  0  |0  0  0  0  |0  8  0  0  |
//~|0  14 0  6  |0  0  0  0  |9  0  0  0  |0  0  0  0  |
//~----------------------------------------------------
//~|0  0  0  0  |0  5  0  10 |0  0  0  0  |0  0  0  16 |
//~|1  11 13 0  |7  0  8  0  |0  0  0  10 |0  0  0  14 |
//~|0  0  12 0  |3  1  14 0  |0  8  0  9  |10 0  13 0  |
//~|4  0  0  0  |9  2  15 16 |0  0  0  0  |0  3  7  0  |
//~----------------------------------------------------
//~|0  0  0  11 |0  0  0  0  |0  2  10 12 |4  5  0  0  |
//~|6  0  0  0  |0  0  0  0  |7  9  0  16 |0  0  0  0  |
//~|0  0  0  0  |0  0  0  5  |0  3  6  0  |0  0  16 12 |
//~|0  0  3  15 |0  0  0  0  |4  0  13 5  |0  7  9  0  |
//~----------------------------------------------------
//~|8  0  10 0  |0  0  0  0  |0  0  4  0  |15 13 0  7  |
//~|0  0  0  0  |0  0  0  0  |0  0  0  0  |0  0  0  0  |
//~|0  0  0  0  |0  0  0  0  |0  0  0  0  |0  0  0  0  |
//~|0  0  0  0  |0  0  0  0  |0  0  0  0  |0  0  0  0  |
//~----------------------------------------------------
//~Solved:
//~----------------------------------------------------
//~|5  16 8  2  |4  7  6  3  |1  10 15 13 |9  12 14 11 |
//~|10 4  7  9  |1  11 12 2  |8  14 16 3  |5  6  15 13 |
//~|12 3  11 1  |13 14 9  15 |2  5  7  6  |16 8  4  10 |
//~|13 14 15 6  |5  10 16 8  |9  4  12 11 |7  1  2  3  |
//~----------------------------------------------------
//~|2  6  9  3  |11 5  13 10 |12 7  14 4  |1  15 8  16 |
//~|1  11 13 5  |7  4  8  12 |15 16 3  10 |2  9  6  14 |
//~|7  15 12 16 |3  1  14 6  |5  8  2  9  |10 11 13 4  |
//~|4  8  14 10 |9  2  15 16 |6  13 11 1  |12 3  7  5  |
//~----------------------------------------------------
//~|16 13 1  11 |6  8  7  9  |14 2  10 12 |4  5  3  15 |
//~|6  2  5  12 |14 15 3  4  |7  9  8  16 |13 10 11 1  |
//~|9  7  4  8  |10 13 1  5  |11 3  6  15 |14 2  16 12 |
//~|14 10 3  15 |12 16 2  11 |4  1  13 5  |6  7  9  8  |
//~----------------------------------------------------
//~|8  5  10 14 |16 9  11 1  |3  6  4  2  |15 13 12 7  |
//~|3  1  2  4  |8  12 5  7  |13 15 9  14 |11 16 10 6  |
//~|11 9  6  13 |15 3  10 14 |16 12 1  7  |8  4  5  2  |
//~|15 12 16 7  |2  6  4  13 |10 11 5  8  |3  14 1  9  |
//~----------------------------------------------------

package main

type sudoku struct {
	// n = 3, n2 = 9 for standard sudoku
	// n is amount of squares per row, n2 is number of numbers per row
	n, n2 int
	grid [][]int
}

// Pair of sudoku and boolean, reporting if we we're successful or not
type bsudoku struct {
	s sudoku
	b bool
}

// "Allocate" slice by appending initialized entries
func alloc(def, size int) []int {
	var slice []int
	for i := 0; i < size; i++ {
		slice = append(slice, def)
	}
	return slice
}

func alloc2(def, size int) [][]int {
	var slice2 [][]int
	for i :=0; i < size; i++ {
		slice2 = append(slice2, alloc(def, size))
	}
	return slice2
}

func initSudoku(n int) sudoku{
	var s sudoku
	s.n = n
	s.n2 = n * n
	s.grid = alloc2(0, s.n2)
	return s
}

func checks(rcb, row, col, num int, s sudoku) bool {
	switch rcb {
	case 0: // row
		for i := 0; i < s.n2; i++ {
			if (s.grid[i][col] == num) {
				return false
			}
		}
	case 1: //col
		for j := 0; j < s.n2; j++ {
			if (s.grid[row][j] == num) {
				return false
			}
		}
	case 2: //box
		// Reset to first index of box
		boxrow, boxcol := row - row % s.n, col - col % s.n
		for i := 0; i < s.n; i++ {
			for j := 0; j < s.n; j++ {
				if (s.grid[boxrow + i][boxcol + j] == num){
					return false
				}
			}
		}
	}
	return true
}

// Function to check if adding num is valid
func check(row, col, num int, s sudoku) bool {
	r := checks(0, row, col, num, s)
	c := checks(1, row, col, num, s)
	b := checks(2, row, col, num, s)
	return r && c && b
}

// Solve using backtracking
func solve(row, col int, s sudoku) bsudoku {
	for i := row; i < s.n2; i++ {
		if (i != row) { // Start from first column if we aren't on first row
			col = 0
		}
		for j := col ;  j < s.n2; j++ {
			if (s.grid[i][j] == 0) {
				for try := 1; try <= s.n2; try++ {
					if (check(i, j, try, s)) {
						s.grid[i][j] = try
						res := solve(i, j + 1, s)
						if (res.b) { // Successful
							return res
						} else {
							// Backtrack our attempt
							s.grid[i][j] = 0
						}
					}
				}
				// Tried all numbers but no success, backtrack
				s.grid[i][j] = 0
				var res bsudoku
				res.b = false
				res.s = s
				return res
			}
		}
	}
	var res bsudoku
	res.b = true
	res.s = s
	return res
}

func nspaces(n int) string{
	spaces := ""
	for i := 0; i < n; i++ {
		spaces += " "
	}
	return spaces
}

func ndash(n int) string{
	dashes := ""
	for i := 0; i < n; i++ {
		dashes += "-"
	}
	return dashes
}

func printsudoku(s sudoku) {
	spacing := s.n2 / 10 + 1
	spaces := ""
	for i := 0; i < spacing; i++ {
		spaces += " "
	}
	for i := 0; i < s.n2; i++ {
		if (i == 0) {
			print(ndash((s.n2 / 10 + 2) * s.n2 + s.n))
			println()
		}
		print("|")
		for j := 0; j < s.n2; j++ {
			t := s.grid[i][j]
			print(t, nspaces((s.n2 / 10) - (t / 10) + 1))
			if (j % s.n == s.n - 1) {
				print("|")
			}
		}
		println()
		if (i % s.n == s.n - 1) {
			print(ndash((s.n2 / 10 + 2) * s.n2 + s.n))
			println()
		}
	}
}


func main() {
	s := initSudoku(4)
	// --------------------------------------------------------------
	// Example 9 x 9 sudoku
	// s.grid[0][0] = 3
	// s.grid[0][1] = 6
	// s.grid[0][3] = 8

	// s.grid[1][0] = 9
	// s.grid[1][2] = 5
	// s.grid[1][4] = 1
	// s.grid[1][5] = 2
	// s.grid[1][8] = 4

	// s.grid[2][1] = 4
	// s.grid[2][4] = 7
	// s.grid[2][7] = 8

	// s.grid[3][3] = 1
	// s.grid[3][6] = 3

	// s.grid[4][1] = 1
	// s.grid[4][2] = 3
	// s.grid[4][6] = 2
	// s.grid[4][7] = 7

	// s.grid[5][2] = 9
	// s.grid[5][5] = 7

	// s.grid[6][1] = 9
	// s.grid[6][4] = 8
	// s.grid[6][7] = 2

	// s.grid[7][0] = 8
	// s.grid[7][3] = 7
	// s.grid[7][4] = 9
	// s.grid[7][6] = 5
	// s.grid[7][8] = 1


	// s.grid[8][5] = 1
	// s.grid[8][7] = 9
	// s.grid[8][8] = 7

	// --------------------------------------------------------------------------
	// Example 16 x 16, allow multiple solutions to solve faster

	s.grid[0][1] = 16
	s.grid[0][2] = 8
	s.grid[0][3] = 2
	s.grid[0][6] = 6
	s.grid[0][7] = 3
	s.grid[0][11] = 13

	s.grid[1][0] = 10
	s.grid[1][3] = 9
	s.grid[1][4] = 1
	s.grid[1][7] = 2
	s.grid[1][8] = 8
	s.grid[1][10] = 16
	s.grid[1][11] = 3
	s.grid[1][14] = 15

	s.grid[2][0] = 12
	s.grid[2][2] = 11
	s.grid[2][3] = 1
	s.grid[2][13] = 8

	s.grid[3][1] = 14
	s.grid[3][3] = 6
	s.grid[3][8] = 9

	s.grid[4][5] = 5
	s.grid[4][7] = 10
	s.grid[4][15] = 16

	s.grid[5][0] = 1
	s.grid[5][1] = 11
	s.grid[5][2] = 13
	s.grid[5][4] = 7
	s.grid[5][6] = 8
	s.grid[5][11] = 10
	s.grid[5][15] = 14

	s.grid[6][2] = 12
	s.grid[6][4] = 3
	s.grid[6][5] = 1
	s.grid[6][6] = 14
	s.grid[6][9] = 8
	s.grid[6][11] = 9
	s.grid[6][12] = 10
	s.grid[6][14] = 13

	s.grid[7][0] = 4
	s.grid[7][4] = 9
	s.grid[7][5] = 2
	s.grid[7][6] = 15
	s.grid[7][7] = 16
	s.grid[7][13] = 3
	s.grid[7][14] = 7

	s.grid[8][3] = 11
	s.grid[8][9] = 2
	s.grid[8][10] = 10
	s.grid[8][11] = 12
	s.grid[8][12] = 4
	s.grid[8][13] = 5

	s.grid[9][0] = 6
	s.grid[9][8] = 7
	s.grid[9][9] = 9
	s.grid[9][11] = 16

	s.grid[10][7] = 5
	s.grid[10][9] = 3
	s.grid[10][10] = 6
	s.grid[10][14] = 16
	s.grid[10][15] = 12

	s.grid[11][2] = 3
	s.grid[11][3] = 15
	// s.grid[11][7] = 14
	s.grid[11][8] = 4
	s.grid[11][10] = 13
	s.grid[11][11] = 5
	s.grid[11][13] = 7
	s.grid[11][14] = 9

	s.grid[12][0] = 8
	s.grid[12][2] = 10
	s.grid[12][10] = 4
	s.grid[12][12] = 15
	s.grid[12][13] = 13
	s.grid[12][15] = 7

	// s.grid[13][3] = 16
	// s.grid[13][5] = 14
	// s.grid[13][11] = 6
	// s.grid[13][12] = 2
	// s.grid[13][14] = 4
	// s.grid[13][15] = 1

	// s.grid[14][6] = 3
	// s.grid[14][7] = 4
	// s.grid[14][10] = 15
	// s.grid[14][12] = 8
	// s.grid[14][13] = 12
	// s.grid[14][14] = 11

	// s.grid[15][1] = 13
	// s.grid[15][3] = 7
	// s.grid[15][8] = 2
	// s.grid[15][13] = 16
	// s.grid[15][15] = 9
	printsudoku(s)

	res := solve(0, 0, s)

	if (res.b) {
		println("Solved:")
		printsudoku(res.s)
	} else {
		println("Not solvable")
		printsudoku(res.s)
	}

}
