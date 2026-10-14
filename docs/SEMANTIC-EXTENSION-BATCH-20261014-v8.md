# Extension suitability classification: eighth bundle (2026-10-14, v8)

Eight consecutive `review-extension` cases were inspected and executed
on PDP-6 using KCC and GCC `-O0`. This remains a classification-only
pass: no non-ICE compiler failures were debugged, and no code was changed.

| Test | KCC | GCC -O0 | Decision |
| --- | --- | --- | --- |
| `builtin-complex-1.c` | Compile rejection | PASS | Deferred: GNU complex and conjugate/real/imag functions |
| `builtin-prefetch-1.c` | Link failure: `__builtin_prefetch` | PASS | Deferred: prefetch constant arguments |
| `builtin-prefetch-2.c` | Link failure: `__builtin_prefetch` | PASS | Deferred: prefetch address expressions |
| `builtin-prefetch-3.c` | Link failure: `__builtin_prefetch` | PASS | Deferred: volatile prefetch addresses |
| `builtin-prefetch-4.c` | Link failure: `__builtin_prefetch` | PASS | Deferred: argument side effects |
| `builtin-prefetch-5.c` | Link failure: `__builtin_prefetch` | PASS | Deferred: unaligned addresses |
| `builtin-prefetch-6.c` | Link failure: `__builtin_prefetch` | PASS | Deferred: invalid addresses and 8-bit pointer-size assumption |
| `builtin-types-compatible-p.c` | Compile rejection | PASS | Deferred: `__builtin_types_compatible_p` and GNU `typeof` |

For the PDP-6, prefetch is not a useful performance primitive. The most
meaningful prefetch cases concern correct argument evaluation and avoidance
of faults, not cache warming. KCC's unresolved `__builtin_prefetch` symbol
is a compiler built-in recognition/lowering issue, not a missing shared
libc implementation. In `builtin-prefetch-6.c`, `8*sizeof(void *)` is
additionally not the correct PDP-10 pointer-bit count (`CHAR_BIT` is 9).

No matrix rows were registered because none of these tests passed both
compilers. The deferred sources and their original assertions remain intact.
