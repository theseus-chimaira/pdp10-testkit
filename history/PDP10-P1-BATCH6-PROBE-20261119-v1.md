# P1 Batch 6 deferred probe results v1

Original sources are unchanged. Results are real PDP-6 native KCC noopt and GCC O0 observations, not semantic acceptance or compiler fixes.

Observed cells: 18. compile_fail: 8, link_fail: 4, run_fail: 6.

| Original source | KCC | GCC |
| --- | --- | --- |
| `tests/todo/generic/comp-goto-1.c` | compile_fail | run_fail |
| `tests/todo/generic/gofast.c` | link_fail | compile_fail |
| `tests/semantic/upstream/extensions/old.tort.c` | compile_fail | run_fail |
| `tests/todo/generic/pdp10/strct-varg-1b.c` | run_fail | run_fail |
| `tests/semantic/upstream/extensions/stdio-opt-1.c` | link_fail | compile_fail |
| `tests/semantic/upstream/extensions/stdio-opt-2.c` | link_fail | link_fail |
| `tests/semantic/upstream/extensions/stdio-opt-3.c` | compile_fail | compile_fail |
| `tests/todo/generic/generic/struct-ret-1.c` | run_fail | compile_fail |
| `tests/semantic/upstream/extensions/va-arg-21.c` | run_fail | compile_fail |

PASS indicates the runner returned success, not that an independent nonvacuous oracle was proven. Failures remain unresolved; no fake stubs or assertion changes were introduced.
