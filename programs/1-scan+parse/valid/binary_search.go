package main

// Recursive binary search function
func binary_search(a [10]int, l, r int, target int) bool {
	if r - l <= 1 {
		return a[l] == target
	}

	var midpoint = (l + r)  / 2

	if a[midpoint] == target {
		return true
	}

	return binary_search(a, l, midpoint, target) || binary_search(a, midpoint, r, target)
}

// Helper wrapper for recursive function
func search(a [10]int, target int) bool {
	return binary_search(a, 0, len(a), target)
}

func main() {
	var a [10]int
	a[0] = 5
	a[1] = 3
	a[2] = 8
	a[3] = 12
	a[4] = 11
	a[5] = 19
	a[6] = -3
	a[7] = 1
	a[8] = 0
	a[9] = 3

	println("Found", 3, ":", search(a, 3))
	println("Found", 2, ":", search(a, 2))
}

