//~Result: 1225
package main

var ASCII_DIGIT_OFFSET = 48

func pow(a, b int) int {
	c := 1
	for i := 0; i < b; i++ {
		c *= a
	}
	return c
}

func main() {
	/*
		Computes the output of a reverse Polish notation program.
	*/

	var program [7]rune
	program[0] = '3'
	program[1] = '4'
	program[2] = '+'
	program[3] = '5'
	program[4] = '*'
	program[5] = '2'
	program[6] = '^'

	var stack []int
	var top = 0

	for i := 0; i < len(program); i++ {
		if program[i] == ' ' {
			continue
		}

		if program[i] == '+' {
			if top < 2 {
				println("Error: stack is not tall enough for +")
				return
			}

			// Pop and op
			a := stack[top-2]
			b := stack[top-1]
			top--
			stack[top-1] = a + b
		} else if program[i] == '-' {
			if top < 2 {
				println("Error: stack is not tall enough for -")
				return
			}

			// Pop and op
			a := stack[top-2]
			b := stack[top-1]
			top--
			stack[top-1] = a - b
		} else if program[i] == '*' {
			if top < 2 {
				println("Error: stack is not tall enough for *")
				return
			}

			// Pop and op
			a := stack[top-2]
			b := stack[top-1]
			top--
			stack[top-1] = a * b
		} else if program[i] == '/' {
			if top < 2 {
				println("Error: stack is not tall enough for /")
				return
			}

			// Pop and op
			a := stack[top-2]
			b := stack[top-1]
			if b == 0 {
				println("Error: division by 0")
				return
			}
			top--
			stack[top-1] = a / b
		} else if program[i] == '^' {
			if top < 2 {
				println("Error: stack is not tall enough for ^")
				return
			}

			// Pop and op
			a := stack[top-2]
			b := stack[top-1]
			if b < 0 {
				println("Error: power of negative number")
				return
			}
			top--
			stack[top-1] = pow(a, b)
		} else {
			if len(stack)-1 < top {
				stack = append(stack, int(program[i])-ASCII_DIGIT_OFFSET)
				top = len(stack)
			} else {
				stack[top] = int(program[i]) - ASCII_DIGIT_OFFSET
				top++
			}
		}
	}

	println("Result:", stack[top-1])
}
