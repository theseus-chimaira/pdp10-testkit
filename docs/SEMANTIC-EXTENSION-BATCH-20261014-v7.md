# Extension suitability classification: seventh bundle (2026-10-14, v7)

Eight consecutive remaining `review-extension` cases were compiled and
attempted using installed KCC and GCC `-O0` on PDP-6. All eight remain
deferred; compiler and runtime problems were not debugged.

| Test | KCC PDP-6 | GCC PDP-6 -O0 | Decision |
| --- | --- | --- | --- |
| `bcp-1.c` | Compile rejection | PASS | Deferred: `__builtin_constant_p` tests; optimization-specific path excluded at `-O0` |
| `bf-layout-1.c` | Compile rejection | PASS | Deferred: nonstandard `long` bitfields |
| `bf-pack-1.c` | Compile rejection | Runtime failure | Deferred: packed 32-bit bitfields |
| `bf-sign-2.c` | Compile rejection | Runtime failure | Deferred: promotion of nonstandard-width bitfields |
| `bf64-1.c` | Compile rejection | Runtime failure | Deferred: 52-bit `long long` bitfields |
| `bitfld-2.c` | Compile rejection | PASS | Deferred: `unsigned short` bitfields |
| `built-in-setjmp.c` | Link failure: `strcmp` | Link failure: `strcpy` | Deferred: built-in setjmp/longjmp/alloca; bare-metal string linkage |
| `builtin-abs-2.c` | Compile rejection | PASS | Deferred: built-in absolute values and constant folding |

The shared assembler libc provides string operations; missing symbols in
this minimal `p10run` link are not evidence of absent library functions.
The `bcp-1.c` test additionally contains optimized-only checks that were
not exercised with `-O0`; its pass is not full optimizer validation.

No tests were altered and no matrix rows were activated. Unsupported GNU
bitfield types were not converted to standard integer bitfields, because
that would change the behavior under test. No ICE was observed.
