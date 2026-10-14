# Extension suitability classification: third bundle (2026-10-14, v3)

Eight consecutive `review-extension` entries were inspected and attempted
with installed KCC and GCC `-O0` on PDP-6. Classification-only scope means
compiler failures, extension support and library linkage are not repaired.

| Test | KCC | GCC -O0 | Decision |
| --- | --- | --- | --- |
| `20011121-1.c` | Link failure: `__builtin_memcpy` | PASS | Deferred: built-in recognition/lowering |
| `20020108-1.c` | PASS, vacuous | PASS, vacuous | Deferred: shift/mode test entirely gated off for `CHAR_BIT=9` |
| `20020227-1.c` | Compile rejection | Runtime failure | Deferred: packed GNU complex float |
| `20020406-1.c` | Compile rejection | Link failure: `malloc` | Deferred: allocations/hosted dependencies |
| `20020411-1.c` | Compile rejection | Runtime failure | Deferred: GNU complex/conjugate builtin |
| `20020412-1.c` | Compile rejection | Compile rejection | Deferred: variably modified `va_arg` aggregate |
| `920302-1.c` | Compile rejection | Link failure: `strcmp` | Deferred: computed label extension and separate linkage issue |
| `920415-1.c` | Compile rejection | PASS | Deferred: local labels and computed goto |

`20020108-1.c` only exercises shifts under `CHAR_BIT` values 8, 16 or 32;
its otherwise successful PDP-10 execution validates none of those cases.
The test cannot be activated without a meaningful target adaptation.

Unresolved library symbols in the minimal execution harness should not be
equated with absent shared assembler libc functions. No sources, compilers,
or libraries were modified, and no new matrix registrations were enabled.
