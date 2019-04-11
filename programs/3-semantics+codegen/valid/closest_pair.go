// Return closest pairs given a list of pairs
//~Generated pair:
//~(18,28)
//~(38,58)
//~(81,121)
//~(41,120)
//~(91,120)
//~(64,122)
//~(13,2)
//~(40,18)
//~(97,52)
//~(84,123)
//~(61,10)
//~(17,42)
//~(58,109)
//~(15,116)
//~(58,6)
//~(19,42)
//~(71,117)
//~(49,14)
//~(7,65)
//~(52,41)
//~(17,123)
//~(77,34)
//~(70,113)
//~(59,18)
//~(39,85)
//~(1,92)
//~(54,108)
//~(35,14)
//~(127,85)
//~(58,100)
//~(49,6)
//~(33,75)
//~(3,86)
//~(73,110)
//~(86,34)
//~(114,11)
//~(46,95)
//~(39,10)
//~(27,97)
//~(5,18)
//~(91,117)
//~(10,62)
//~(105,80)
//~(42,118)
//~(45,71)
//~(53,104)
//~(70,46)
//~(106,59)
//~(54,86)
//~(78,14)
//~Closest pair:
//~(19,42)
//~(17,42)

package main

type pair struct {
	x int
	y int
}

type ppair struct {
	p1 pair
	p2 pair
}

// pair list + index
type pl_ind struct {
	pl []pair
	ind int
}

// 2 pair lists
type twopl struct {
	pl1 []pair
	pl2 []pair
}

func abs(f float64) float64{
	if f >= 0.0 {
		return f
	} else {
		return -f
	}
}

// Approximate square root using Newton's method
func sqrt(f float64) float64 {
	xn := f/2.0
	tol := f/1000.0
	for i := 0; i < 10000; i++ {
		poly := xn * xn - f
		polyprime := 2.0 * xn

		diff := poly/polyprime

		xn = xn - diff

		// Within tolerance
		if (abs(diff) < tol) {
			return xn
		}
	}
	return xn
}

// Distance in R^2
func dist(p1, p2 pair) float64 {
	x := p1.x - p2.x
	y := p1.y - p2.y
	return sqrt(float64(((x * x) + (y * y))))
}

func partx(pl []pair, min, max int) pl_ind{
	pivot := pl[max].x
	t := min
	for i := min; i < max; i++ {
		if pl[i].x < pivot {
			pl[i], pl[t] = pl[t], pl[i]
			t++
		}
	}
	pl[t], pl[max] = pl[max], pl[t]
	var pli pl_ind
	pli.pl = pl
	pli.ind = t
	return pli
}

// Quicksort list of pairs by x coordinate
func qsortx(pl []pair, min, max int) []pair{
	if min < max {
		var pli pl_ind
		pli = partx(pl, min, max)
		pl = pli.pl
		pl = qsortx(pl, min, pli.ind - 1)
		pl = qsortx(pl, pli.ind + 1, max)
	}
	return pl
}

func party(pl []pair, min, max int) pl_ind{
	pivot := pl[max].y
	t := min
	for i := min; i < max; i++ {
		if pl[i].y < pivot {
			pl[i], pl[t] = pl[t], pl[i]
			t++
		}
	}
	pl[t], pl[max] = pl[max], pl[t]
	var pli pl_ind
	pli.pl = pl
	pli.ind = t
	return pli
}

// Quicksort list of pairs by y coordinate
func qsorty(pl []pair, min, max int) []pair{
	if min < max {
		var pli pl_ind
		pli = party(pl, min, max)
		pl = pli.pl
		pl = qsorty(pl, min, pli.ind - 1)
		pl = qsorty(pl, pli.ind + 1, max)
	}
	return pl
}

// Split pair list in half
func split(pl []pair) twopl {
	var pll twopl
	var pl1 []pair
	var pl2 []pair
	half := len(pl)/2
	for i := 0; i < half; i++ {
		pl1 = append(pl1, pl[i])
	}
	for i := half; i < len(pl); i++ {
		pl2 = append(pl2, pl[i])
	}
	pll.pl1 = pl1
	pll.pl2 = pl2
	return pll
}

// Initialize min distance to pairs that are far apart
func initMin() ppair {
	var min ppair
	min.p1.x = 999
	min.p1.y = 999
	min.p2.x = 0
	min.p2.y = 0
	return min
}

// Smaller distance among two pairs of pairs (not pairwise)
func minPpair(pp1, pp2 ppair) ppair{
	dist1 := dist(pp1.p1, pp1.p2)
	dist2 := dist(pp2.p1, pp2.p2)
	if (dist1 > dist2) {
		return pp2
	} else {
		return pp1
	}
}

// Iterative solution to finding closest points, used for base cases for divide and conquer
func iterClosest(pl []pair) ppair {
	var min = initMin()
	for i := 0; i < len(pl); i++ {
		for j := 0; j < len(pl); j++ {
			if i != j { // Don't compare the same points to each other
				var pp ppair
				pp.p1 = pl[i]
				pp.p2 = pl[j]
				min = minPpair(min, pp)
			}
		}
	}
	return min
}

func stripClosest(pl []pair, min ppair) ppair {
	pl = qsorty(pl, 0, len(pl) - 1)

	for i := 0; i < len(pl); i++ {
		// Try combination of pts until difference between y is less than minimum distance
		for j := i + 1; j < len(pl) && (float64(pl[i].y - pl[j].y)) < dist(min.p1, min.p2); j++ {
			if (dist(pl[i], pl[j]) < dist(min.p1, min.p2)) {
				min.p1 = pl[i]
				min.p2 = pl[j]
			}
		}
	}
	return min
}

func closestPairRec(pl []pair) ppair {
	if len(pl) <= 3 {
		return iterClosest(pl)
	} else {
		var pll twopl = split(pl)
		var midp pair = pl[len(pl)/2 - 1]
		var pp1 ppair
		var pp2 ppair
		pp1 = closestPairRec(pll.pl1)
		pp2 = closestPairRec(pll.pl2)
		var min ppair = minPpair(pp1, pp2)

		// Closest strip, contains points closer to middle line than min dist from either side
		var strip []pair
		for i := 0; i < len(pl); i++ {
			if abs(float64(pl[i].x - midp.x)) < dist(min.p1, min.p2) {
				strip = append(strip, pl[i])
			}
		}

		return minPpair(min, stripClosest(strip, min))
	}
}

func closestPair(pl []pair) ppair {
	return closestPairRec(qsortx(pl, 0, len(pl) - 1))
}

func pairgen(pa [2][]int) []pair{
	var pl []pair
	if (len(pa[0]) != len(pa[1])) {
		return pl
	} else {
		var p pair
		for i := 0; i < len(pa[0]); i++ {
			p.x = pa[0][i]
			p.y = pa[1][i]
			pl = append(pl, p)
		}
		return pl
	}
}

func printpair(p pair) {
	print("(")
	print(p.x)
	print(",")
	print(p.y)
	print(")")
}

func printpairl(pl []pair) {
	for i := 0; i < len(pl); i++ {
		printpair(pl[i])
		println()
	}
}

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

func dubnats(max int, rev bool) []int{
	var list []int
	if rev {
		for i := max; i > 0; i-- {
			list = append(list, i * 5)
		}
	} else {
		for i := 0; i < max; i++ {
			list = append(list, i * 5)
		}
	}
	return list
}

func main() {
	var pa [2][]int
	pa[0] = prbsgen(50, 9)
	pa[1] = prbsgen(50, 14)
	var pl []pair
	pl = pairgen(pa)
	println("Generated pair:")
	printpairl(pl)
	println("Closest pair:")
	var pp ppair = closestPair(pl)
	printpair(pp.p1)
	println()
	printpair(pp.p2)
}
