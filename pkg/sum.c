#include <stdint.h>

// We'll link against this symbol (in sum_arm64.S).
// It's a standard ARM64 function: add_slices_arm64(dst, src, n).
extern void add_slices_arm64(int64_t *dst, int64_t *src, int64_t n);

// This is the function cgo calls. It just forwards to add_slices_arm64.
void AddSlicesSIMDGo(long long *dst, long long *src, long long n) {
    add_slices_arm64((int64_t *)dst, (int64_t *)src, (int64_t)n);
}
