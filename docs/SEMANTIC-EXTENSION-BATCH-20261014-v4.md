# Extension suitability classification: fourth bundle (2026-10-14, v4)

Eight consecutive `review-extension` manifest cases were attempted on PDP-6
with installed KCC and GCC `-O0`. This is suitability classification, not
compiler debugging, runtime repair or libc implementation.

| Test | KCC | GCC -O0 | Decision |
| --- | --- | --- | --- |
| `920428-2.c` | Compile rejection | PASS | Deferred: GNU nested functions and local-label jump |
| `920501-3.c` | Compile rejection | PASS | Deferred: label-address arithmetic and computed goto |
| `920501-7.c` | Compile rejection | PASS | Deferred: nested function, local label, recursion |
| `920612-2.c` | Compile rejection | PASS | Deferred: nested function closure |
| `920721-4.c` | Compile rejection | PASS | Deferred: nested label-address return and computed goto |
| `920728-1.c` | Compile rejection | PASS | Deferred: zero-length array extension and fixed 32-bit extraction |
| `920829-1.c` | Compile rejection | PASS | Deferred: wide-integer constant-initializer expression |
| `921007-1.c` | Link failure: `__builtin_strcmp` | Runtime failure | Deferred: built-in recognition and 9-bit char behavior |

Passing GCC results demonstrate its corresponding source executes under
PDP-6 at `-O0`, but do not justify activating a test KCC cannot compile
under the current shared test-matrix policy. Library built-in name
resolution and general libc implementation remain separate tasks.

No source, compiler, or library was modified. No matrix rows were added.
