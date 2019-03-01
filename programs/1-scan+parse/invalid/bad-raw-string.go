// Will fail at scanning phase
// We cannot escape backticks (or include them) in a rawstring, so the \` will close the raw string and the last ` will emit an error because it doesn't match an opening backtick
package main

var rawString = `cannot escape backtick\` in here`