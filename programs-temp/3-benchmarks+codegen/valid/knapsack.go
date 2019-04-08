//&5 seconds
//~14358
package main;
// Generate array of pseudorandom bitsequences using PRBS7
func prbsgen(size, start int) []int {
	var list []int
	n := start
	for i := 0; i < size; i++ {
		n += i
		n = (((n << 1) | (n >> 6) ^ (n >> 5) & 1) & 0x7f)
		list = append(list, n)
	}
	return list
}

// "Allocate" slice by appending initialized entries
func alloc(def, size int) []int {
	var slice []int
	for i := 0; i < size; i++ {
		slice = append(slice, def)
	}
	return slice
}

func min(a, b int) int {
	if (a > b) {
		return b
	} else {
		return a
	}
}

func max(a, b int) int {
	return -min(-a, -b)
}

// Calculate optimal solution for a certain index for the knapsack problem
// i is number of items to consider, weight limit is j
func getOpt(opt [][]int, values, weights []int, i, j int) int{
	switch i {
	case 0:
		return 0
	}
	switch j {
	case 0:
		return 0
	}

	if (opt[i - 1][j] == -1){ // Not yet calculated
		opt[i - 1][j] = getOpt(opt, values, weights, i - 1, j)
	}

	if (weights[i] > j) { // Cannot fit item i in the backpack, use prev opt
		opt[i][j] = opt[i - 1][j]
	} else if (opt[i - 1][j - weights[i]] == -1){
		opt[i - 1][j - weights[i]] = getOpt(opt, values, weights, i - 1, j - weights[i])
		opt[i][j] = max(opt[i - 1][j], opt[i - 1][j - weights[i]] + values[i])
	}
	return opt[i][j]
}

// Dynamic programming approach for optimal solution, NP-Complete
func knapsack(values, weights []int, maxcap int) int{
	var n = min(len(values), len(weights))
	var opt [][]int
	// Allocate entries
	// Will get: [n + 1][cap + 1]
	for i := 0; i < n + 1; i++ {
		opt = append(opt, alloc(-1, maxcap + 1))
	}
	return getOpt(opt, values, weights, n - 1, maxcap)
}

func main() {
	weights, values := prbsgen(4361, 34), prbsgen(4361, 99)
	println(knapsack(values, weights, 12983))
}
