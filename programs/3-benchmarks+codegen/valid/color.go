//~One of the optimal colorings: 6 5 4 5 5 6 6
//~Min coloring of the graph: 3
//~One of the optimal colorings: 6 5 4 3 2 1 0
//~Min coloring of the graph: 7
//~One of the optimal colorings: 6 6 6 6 6 6 6
//~Min coloring of the graph: 1
//~One of the optimal colorings: 6 5 5 6 6 5 4
//~Min coloring of the graph: 3
//~One of the optimal colorings: 6 5 6 5 4 6 6
//~Min coloring of the graph: 3

//&6 seconds

package main

// "Allocate" slice by appending initialized entries
func alloc(def bool, size int) []bool {
	var slice []bool
	for i := 0; i < size; i++ {
		slice = append(slice, def)
	}
	return slice
}

type colornode struct {
	color int
	row []bool
}

type colorgraph []colornode

func initgraph(n int) colorgraph {
	var r colorgraph
	for i := 0; i < n; i++ {
		var c colornode
		c.color = 0
		c.row = alloc(false, n)
		c.row[i] = true // Adjacent to self
		r = append(r, c)
	}
		return r
	}

func check(graph colorgraph) bool {
	n := len(graph)
	for i := 0; i < n; i++ {
		col := graph[i].color
		for j := 0; j < n; j++ {
			// Check if node i is adjacent to node j in adjacency matrix
			// If same color, not a proper coloring
			if (i != j && graph[i].row[j] && col == graph[j].color) {
				return false
			}
		}
	}
	return true
}

// Is n in list?
func elem(n int, list []int)bool {
	l := len(list)
	for i := 0; i < l; i++ {
		if (list[i] == n) {
			return true
		}
	}
	return false
}

func min(a, b int) int {
	if (a > b) {
		return b
	} else {
		return a
	}
}
// Number of distinct colors of nodes
func colors(graph colorgraph) int {
	n := len(graph)
	var cols []int
	for i := 0; i < n; i++ {
		col := graph[i].color
		if (!elem(col, cols)) {
			cols = append(cols, col)
		}
	}
	return len(cols)
}

type res struct {
	b bool // Is it solvable
	g colorgraph
}

func pcolor(graph colorgraph) {
	n := len(graph)
	for i := 0; i < n - 1; i++ {
		print(graph[i].color, " ")
	}
	print(graph[n - 1].color)
	println()
}

func cp(graph colorgraph) colorgraph {
	n := len(graph)
	var r colorgraph
	for i := 0; i < n; i++ {
		r = append(r, graph[i])
	}
	return r
}

func solve(i int, graph colorgraph) res {
	n := len(graph)
	mincolors := n
	var res res
	res.b = false
	// Copy so that we don't return a modified vers
	res.g = cp(graph)
	if (i >= n) {
		res.b = check(graph)
	} else {
		for j := 0; j < n; j++ {
			graph[i].color = j
			r := solve(i + 1, graph)
			if (r.b) {
				res = r
				mincolors = min(mincolors, colors(r.g))
			}
		}
	}
	return res
}

func addEdge(g colorgraph, i, j int) {
	g[i].row[j] = true
	g[j].row[i] = true
}

func main() {
	for i := 0; i < 5; i++ {
		g := initgraph(7)
		switch i {
		case 0:
			addEdge(g, 0, 1)
			addEdge(g, 0, 2)
			addEdge(g, 0, 3)
			addEdge(g, 0, 4)
			addEdge(g, 1, 2)
		case 1:
			// complete graph
			for i2 := 0; i2 < len(g); i2++ {
				for j := 0; j < len(g); j++ {
					addEdge(g, i2, j)
				}
			}
		case 2:
			// graph with no edges
		case 3:
			addEdge(g, 0, 1)
			addEdge(g, 0, 2)
			addEdge(g, 1, 3)
			addEdge(g, 2, 3)
			addEdge(g, 4, 5)
			addEdge(g, 4, 6)
			addEdge(g, 5, 6)
		case 4:
			addEdge(g, 0, 1)
			addEdge(g, 0, 3)
			addEdge(g, 1, 2)
			addEdge(g, 3, 2)
			addEdge(g, 3, 4)
			addEdge(g, 2, 4)
			addEdge(g, 4, 6)
			addEdge(g, 4, 5)
		}

		r := solve(0, g)
		print("One of the optimal colorings: ")
		c := colors(r.g)
		pcolor(r.g)
		print("Min coloring of the graph: ")
		println(c)
	}
}
