# Extension suitability classification: fifteenth bundle (2026-10-14, v15)

Nine consecutive `review-extension` tests were compiled and attempted on
PDP-6 using KCC and GCC `-O0`. None can currently be activated without
changing the linkage environment or resolving compiler failures.

| Test | KCC PDP-6 | GCC -O0 PDP-6 | Decision |
| --- | --- | --- | --- |
| `string-opt-12.c` | Compile failure | Link failure: `strcspn` | Deferred |
| `generic/string-opt-13.c` | Compile failure | Link failure: `strcpy` | Deferred |
| `generic/string-opt-14.c` | Compile failure | Link failure: `memset` | Deferred |
| `generic/string-opt-15.c` | Compile failure | Link failure: `strcpy` | Deferred |
| `generic/string-opt-16.c` | Compile failure | Link failure: `memcmp` | Deferred |
| `string-opt-2.c` | Link failure: `strpbrk` | Link failure: `strpbrk` | Deferred |
| `string-opt-3.c` | Compile failure | Link failure: `strlen` | Deferred |
| `string-opt-4.c` | Link failure: `strchr` | Link failure: `strchr` | Deferred |
| `generic/string-opt-5.c` | Compile failure | Link failure: `strlen` | Deferred |

These tests concern ordinary string/memory functions, GNU built-in names,
and compiler optimization or argument-side-effect semantics. String/memory
function implementations are assigned to the shared assembler libc under
`KCC-EXTENSION-SUPPORT-POLICY-20261014-v1.md`; minimal `p10run` unresolved
references do not by themselves establish that libc functionality is absent.
The `__OPTIMIZE__`-guarded portions were not exercised under GCC `-O0`.

No compiler, libc or test sources were modified. No active matrix rows were
added. Classification-only policy remains in force for non-ICE failures.
