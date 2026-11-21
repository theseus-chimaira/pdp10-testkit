# Upstream semantic import: fourth batch of eight (2026-10-14, v4)

Next eight candidate rows were compiled with KCC on PDP-6 and executed
using the bare-metal `__test_exit=0` contract. Original sources were not
modified, and neither compiler was changed.

| Source | Observation | Classification |
| --- | --- | --- |
| `20000603-1.c` | Runtime PASS, but incompatible structure-pointer aliasing invokes undefined C behavior | deferred to `tests/todo/generic/` |
| `20000605-1.c` | PASS; floating-point stepping and loop result | active |
| `20000605-2.c` | PASS; const-qualified aggregate pointer in loop | active |
| `20000605-3.c` | PASS; block-scoped const aggregate initialization | active |
| `20000622-1.c` | Compiles, aborts in pointer/integer parameter assertion | deferred to `tests/todo/generic/` |
| `20000706-1.c` | PASS; five-member structure argument and trailing parameters | active |
| `20000706-2.c` | PASS; structure argument between pointer arguments | active |
| `20000706-3.c` | PASS; address of a parameter and companion scalar argument | active |

Six passing tests have semantic matrix entries. Their other CPU, compiler,
and optimization profiles are unverified. Runtime failure is documented as
an observation, not attributed to a proven compiler root cause.
