package main

import (
	"fmt"

	simd "github.com/yashp5/simd/pkg"
)

func main() {
	a := []int64{1, 2, 3, 4, 5}
	b := []int64{10, 20, 30, 40, 50}

	simd.AddSlicesSIMD(a, b)

	// Expect a == [11, 22, 33, 44, 55]
	fmt.Println("Result of adding slices:", a)
}
