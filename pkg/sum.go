package simd

/*
#cgo CFLAGS: -Wall -Werror
// We declare our C function that we'll implement in sum.c.
void AddSlicesSIMDGo(long long *dst, long long *src, long long n);
*/
import "C"
import (
	"unsafe"
)

// AddSlicesSIMD adds elements from src into dst in place:
//
//	dst[i] += src[i]
//
// The length of dst and src should match.
// This uses ARM64 NEON code assembled by the system assembler via cgo.
func AddSlicesSIMD(dst, src []int64) {
	if len(dst) != len(src) {
		// For simplicity, do nothing (or panic).
		return
	}
	if len(dst) == 0 {
		return
	}
	// Call our C function, passing pointers and length.
	C.AddSlicesSIMDGo(
		(*C.longlong)(unsafe.Pointer(&dst[0])),
		(*C.longlong)(unsafe.Pointer(&src[0])),
		C.longlong(len(dst)),
	)
}
