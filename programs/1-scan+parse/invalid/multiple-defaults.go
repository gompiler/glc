// Multiple default case statements are not allowed, will fail at parser
package main

func main() {
	switch (5 + 5) {
	default: println("aaaa")
	default: println("bbbb")
	}
}
