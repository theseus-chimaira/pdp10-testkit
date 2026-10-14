# Extension suitability classification: thirteenth bundle (2026-10-14, v13)

Eight successive `review-extension` manifest entries were inspected and
compiled/executed on PDP-6 using KCC and GCC `-O0`. Only the substantively
passing pointer-arithmetic test was activated. No non-ICE failures were
investigated and no compiler or libc was modified.

| Test | KCC PDP-6 | GCC -O0 PDP-6 | Decision |
| --- | --- | --- | --- |
| `pdp10/string-opt-3.c` | Compile rejection | Link failure: `strlen` | Deferred: shared libc/harness linkage and GNU built-in optimization |
| `pdp10/string-opt-5.c` | Compile rejection | Link failure: `strlen` | Deferred: shared libc/harness linkage and GNU built-in optimization |
| `pdp10/string-opt-6.c` | Compile rejection | Link failure: `strcpy` | Deferred: shared libc/harness linkage and GNU built-in optimization |
| `pdp10/string-opt-7.c` | Compile rejection | Link failure: `memset` | Deferred: shared libc/harness linkage and GNU built-in optimization |
| `pdp10/string-opt-8.c` | Compile rejection | Link failure: `strncmp` | Deferred: shared libc/harness linkage and GNU built-in optimization |
| `ptr-arith-2.c` | PASS | PASS | **Active unchanged:** PDP-10 byte-width-aware pointer subtraction |
| `stdio-opt-1.c` | Link failure: `stdout` | Compile rejection | Deferred: hosted stdio |
| `stdio-opt-2.c` | Link failure: `printf` | Link failure: `printf` | Deferred: hosted stdio |

`ptr-arith-2.c` checks pointer differences across PDP-10 `size(7)` and
`size(8)` character types and ordinary element types. All its loops execute;
both compilers pass under PDP-6. It is registered in the semantic matrix.

The assembler-optimized libc remains the preferred implementation for string
and memory routines; unresolved references here reflect minimal test-harness
linkage rather than a reason to duplicate these routines as built-ins.
Hosted standard I/O compiler optimizations are outside the current
freestanding classification scope. Optimization-mode behavior is not claimed.
