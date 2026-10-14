# Extension suitability classification: twelfth bundle (2026-10-14, v12)

The next eight manifest-ordered extension cases were compiled and attempted
using KCC and GCC `-O0` on PDP-6. These are separate PDP-10-import copies
of upstream tests. No compiler, libc, or source was changed.

| Test (`pdp10/`) | Feature | KCC | GCC -O0 | Decision |
| --- | --- | --- | --- | --- |
| `bf-sign-2.c` | Nonstandard bitfield base types / promotion | Compile rejection | Runtime failure | Deferred: under consideration |
| `built-in-setjmp.c` | `__builtin_setjmp`, `longjmp`, `alloca` | Link failure: `strcmp` | Link failure: `strcpy` | Deferred: KCC policy undecided; libc linkage |
| `builtin-complex-1.c` | Complex and conj/real/imag built-ins | Compile rejection | PASS | Deferred: unsupported by KCC |
| `comp-goto-1.c` | Computed goto and fixed 32-bit layout | Compile rejection | Compile rejection | Deferred: computed goto planned |
| `complex-1.c` | GNU complex arithmetic | Compile rejection | PASS | Deferred: unsupported by KCC |
| `complex-2.c` | GNU complex arithmetic and ABI | Compile rejection | Runtime failure | Deferred: unsupported by KCC |
| `ll-1.c` | GNU `mode(DI)` | Compile rejection | PASS | Deferred: unsupported machine-mode attribute |
| `string-opt-15.c` | Short `memcmp`, including zero length | Compile rejection | Link failure: `strcpy` | Deferred: assembler libc linkage distinct from compiler built-ins |

`strcmp` and `strcpy` are implemented by the shared assembler libc; their
absence from these minimal `p10run` links does not imply missing libc work.
Complex C support has been ruled out for KCC. Computed goto remains planned;
nonstandard bitfield types remain under consideration; stack-control built-ins
remain undecided. No test met both-compilers activation criteria, so the
semantic compiler matrix is unchanged.
