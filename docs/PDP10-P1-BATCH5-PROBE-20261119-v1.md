# P1 Batch 5 deferred probe results v1

Original sources are unchanged. Results are real PDP-6 native KCC noopt and GCC O0 observations, not semantic acceptance or compiler fixes.

Observed cells: 20. compile_fail: 10, link_fail: 2, pass: 3, run_fail: 5.

| Original source | KCC | GCC |
| --- | --- | --- |
| `tests/todo/generic/930513-1.c` | pass | compile_fail |
| `tests/todo/generic/941014-2.c` | run_fail | compile_fail |
| `tests/todo/generic/960327-1.c` | pass | compile_fail |
| `tests/todo/generic/960521-1.c` | run_fail | run_fail |
| `tests/todo/generic/980605-1.c` | pass | compile_fail |
| `tests/todo/generic/980707-1.c` | link_fail | compile_fail |
| `tests/todo/generic/980709-1.c` | compile_fail | compile_fail |
| `tests/todo/generic/990628-1.c` | run_fail | run_fail |
| `tests/todo/generic/990826-0.c` | compile_fail | compile_fail |
| `tests/todo/generic/builtin-noret-1.c` | compile_fail | link_fail |

PASS indicates the runner returned success, not that an independent nonvacuous oracle was proven. Failures remain unresolved; no fake stubs or assertion changes were introduced.
