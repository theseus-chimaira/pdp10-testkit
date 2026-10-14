# Final extension classification bundle (2026-10-14, v16)

The final nine manifest-ordered extension-review cases were compiled and
attempted using installed KCC and GCC `-O0` on PDP-6. One substantive
packed-structure test passed unchanged under both compilers.

| Test | KCC | GCC -O0 | Decision |
| --- | --- | --- | --- |
| `string-opt-6.c` | Compile rejection | Link failure: `strcpy` | Deferred: shared libc/harness linkage |
| `string-opt-7.c` | Compile rejection | Link failure: `memset` | Deferred: shared libc/harness linkage |
| `string-opt-8.c` | Compile rejection | Link failure: `strncmp` | Deferred: shared libc/harness linkage |
| `string-opt-9.c` | Compile rejection | Link failure: `strcpy` | Deferred: shared libc/harness linkage |
| `struct-ret-2.c` | PASS | PASS | **Active:** packed char and short assignment/readback |
| `wide-int/tmp.c` | Compile rejection | PASS | Deferred: nonstandard long-long bitfields |
| `va-arg-21.c` | Link failure: `malloc` | Compile rejection | Deferred: hosted allocation/varargs I/O |
| `generic/zerolen-1.c` | Compile rejection | PASS | Deferred: zero-length array under consideration |
| `zerolen-2.c` | Compile rejection | PASS | Deferred: zero-length array and GNU `mode(word)` |

The string/memory calls are handled through the shared assembler libc,
not by writing a second implementation inside KCC. The minimal PDP-6
test link does not automatically resolve them. Nonstandard bitfield base
types and zero-length arrays remain under consideration; GNU machine-mode
attributes remain unsupported by KCC. No non-ICE compiler failures were
investigated, and no compiler/libc/test source changes were made.

This completes disposition of every remaining `review-extension` manifest
entry. There are **zero extension/width/candidate reviews** outstanding.
Deferred sources remain available for targeted follow-up after the shared
libc linkage and implementation priorities are addressed.
