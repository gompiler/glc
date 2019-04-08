//~CTGCTCTT-TT
//~CTGC-CGTCTT
package main

func backtrack(s1, s2 [10]rune, arrows [11][11]rune) string {
	var (
		i   int    = 10
		j   int    = 10
		as1 string = ""
		as2 string = ""
	)

	for i > 0 || j > 0 {
		if i > 0 && j > 0 && arrows[i][j] == 'm' {
			as1 = string(s1[i-1]) + as1
			as2 = string(s2[j-1]) + as2
			i--
			j--
		} else if i > 0 && arrows[i][j] == 'l' {
			as1 = string(s1[i-1]) + as1
			as2 = "-" + as2
			i--
		} else {
			as1 = "-" + as1
			as2 = string(s2[j-1]) + as2
			j--
		}
	}

	return as1 + "\n" + as2
}

func score(a, b rune, match int, mismatch int) int {
	if a == b {
		return match
	}

	return mismatch
}

func get_alignment(s1, s2 [10]rune, gap int, match int, mismatch int) string {
	var (
		matrix [11][11]int
		arrows [11][11]rune
	)

	for i := 0; i < 11; i++ {
		matrix[i][0] = i * gap
		matrix[0][i] = i * gap
	}

	for i := 1; i < 11; i++ {
		for j := 1; j < 11; j++ {
			var mma int = matrix[i-1][j-1] + score(s1[i-1], s2[j-1], match, mismatch)
			var del int = matrix[i-1][j] + gap
			var ins int = matrix[i][j-1] + gap

			var new_val int
			var arrow rune

			if mma > del && mma > ins {
				new_val = mma
				arrow = 'm'
			} else if del > mma && del > ins {
				new_val = del
				arrow = 'l'
			} else if ins > mma && ins > del {
				new_val = ins
				arrow = 'u'
			} else {
				// Prefer mismatches
				new_val = mma
			}

			matrix[i][j] = new_val
			arrows[i][j] = arrow
		}
	}

	return backtrack(s1, s2, arrows)
}

func main() {
	var sequence_1 [10]rune
	var sequence_2 [10]rune

	sequence_1[0] = 'C'
	sequence_1[1] = 'T'
	sequence_1[2] = 'G'
	sequence_1[3] = 'C'
	sequence_1[4] = 'T'
	sequence_1[5] = 'C'
	sequence_1[6] = 'T'
	sequence_1[7] = 'T'
	sequence_1[8] = 'T'
	sequence_1[9] = 'T'

	sequence_2[0] = 'C'
	sequence_2[1] = 'T'
	sequence_2[2] = 'G'
	sequence_2[3] = 'C'
	sequence_2[4] = 'C'
	sequence_2[5] = 'G'
	sequence_2[6] = 'T'
	sequence_2[7] = 'C'
	sequence_2[8] = 'T'
	sequence_2[9] = 'T'

	println(get_alignment(sequence_1, sequence_2, -1, 1, -1))
}
