//
// Assemble with: clang -c sum_arm64.S
// Link into Go via cgo.
//
// macOS typically uses leading underscore for symbol names, so we define
// _add_slices_arm64. Then in C, we reference add_slices_arm64(...).
// The linker strips the leading underscore from the final symbol in C-land.
//
.text
.align 2
.global _add_slices_arm64

// void add_slices_arm64(int64_t *dst, int64_t *src, int64_t n)
// On entry:
//   x0 = dst
//   x1 = src
//   x2 = n
_add_slices_arm64:
    // If n == 0 => return
    cbz x2, .done

    // We'll process 2 int64s (128 bits) at a time:
    //   chunk = n >> 1
    //   leftover = n & 1
    lsr x3, x2, #1         // x3 = chunk
    and x4, x2, #1         // x4 = leftover

    // If chunk == 0, jump to leftover logic
    cbz x3, .leftover

// .loop:
.loop:
    // Load 2 x int64 from dst => v0.2d, post-increment dst by 16
    ld1 {v0.2d}, [x0], #16
    // Load 2 x int64 from src => v1.2d, post-increment src by 16
    ld1 {v1.2d}, [x1], #16

    // Vector add 2 lanes of 64 bits each
    add v0.2d, v0.2d, v1.2d

    // Store result back to (x0 - 16) because x0 has moved
    sub x5, x0, #16
    st1 {v0.2d}, [x5]

    // Decrement chunk
    subs x3, x3, #1
    b.ne .loop

// .leftover:
.leftover:
    cbz x4, .done

    // leftover == 1 => scalar add the final element
    // dst[0] += src[0]
    ldr x5, [x0]
    ldr x6, [x1]
    add x5, x5, x6
    str x5, [x0]

// .done:
.done:
    ret
