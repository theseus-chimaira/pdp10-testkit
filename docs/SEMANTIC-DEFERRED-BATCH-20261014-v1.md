# Deferred semantic review: first eight tests (2026-10-14, v1)

The first eight `deferred` entries in manifest order were retried with
installed KCC and GCC `-O0`, a PDP-6 simulator, and the minimal bare-metal
link harness. This is a disposition review, not a compiler-debugging task.

| Source | KCC | GCC -O0 | Review outcome |
| --- | --- | --- | --- |
| `20000223-1.c` | Compile failure | PASS | Remain deferred: GNU `__alignof__` not accepted by KCC |
| `20000227-1.c` | Runtime failure | PASS | Remain deferred: raw source byte and octal escape equivalence; requires explicit source-encoding policy |
| `20000314-3.c` | Compile failure | PASS | Remain deferred: C99 void expression `return` compatibility |
| `20000603-1.c` | PASS | PASS | Remain deferred: incompatible structure-pointer aliasing is undefined behavior |
| `20000622-1.c` | Runtime failure | PASS | Remain deferred: argument passing and integer-to-pointer ABI assumptions |
| `20000703-1.c` | Link failure `__builtin_memcpy` | Link failure `memset` | Remain deferred: builtin name recognition and bare-metal libc linkage are distinct issues |
| `20000801-3.c` | Compile failure | PASS | Remain deferred: empty GNU structure and designated initializer extension |
| `20000815-1.c` | Link failure `__builtin_memset` | PASS | Remain deferred: KCC builtin spelling vs shared assembler libc implementation |

No compiler, assembler libc or test source changes were made. All eight
already have `deferred` status in the manifest and remain deferred. A
two-compiler runtime PASS is insufficient to activate a regression test
whose intended behavior depends on undefined C aliasing rules.

The two memory built-in cases should be revisited with the shared assembler
libc correctly linked. Do not duplicate memory primitives in the compiler
solely to satisfy `__builtin_*` spellings.
