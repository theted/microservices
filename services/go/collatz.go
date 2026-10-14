// One hailstone step in Go.
package main

import "fmt"

func step(n int64) int64 {
	if n%2 == 0 {
		return n / 2
	}
	return 3*n + 1
}

func main() {
	var n int64
	fmt.Scan(&n)
	fmt.Println(step(n))
}
