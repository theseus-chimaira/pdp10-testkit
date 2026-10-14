# Extension suitability classification: first bundle (2026-10-14, v1)

Eight manifest-ordered `review-extension` cases were inspected and tried
using PDP-6 KCC and GCC `-O0` with the installed `$HOME/cross` toolchain.
Classification does not investigate ordinary compiler errors or add libc.

| Test | KCC | GCC -O0 | Decision and reason |
| --- | --- | --- | --- |
| `20000223-1.c` | Compile rejection | PASS | Defer: GCC `__alignof__`, unsupported in KCC |
| `20000703-1.c` | Link failure `__builtin_memcpy` | Link failure `memset` | Defer: built-in recognition/linking, not necessarily missing libc implementation |
| `20000801-3.c` | Compile rejection | PASS | Defer: GNU empty structures |
| `20000815-1.c` | Link failure `__builtin_memset` | PASS | Defer: built-in lowering; assembly `memset` exists |
| `20000822-1.c` | Compile rejection | PASS | Defer: GNU nested-function trampolines |
| `20001026-1.c` | Link failure `__builtin_memset` | PASS | Defer: built-in lowering/struct-return interaction |
| `20010119-1.c` | PASS, vacuous | PASS, vacuous | Defer: `__OPTIMIZE__` disabled at `-O0`; `__builtin_constant_p` branch untested |
| `20010122-1.c` | Compile rejection | Runtime failure | Defer: return-address/frame built-ins and attributes |

Do not equate an unresolved `__builtin_memset` reference with absence of
the already installed optimized assembler `memset` routine. Record compiler
recognition/lowering and bare-metal runtime linkage as distinct issues.
Do not add vacuous optimized-only tests to the active matrix.

No source files, compilers, or libraries were modified. No new matrix
registrations were made. The next bundle begins with the next unclassified
extension manifest entry.
