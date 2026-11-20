# P1 Batch 4 hosted-runtime prerequisite evidence (2026-11-20, v1)

Two **unchanged original** sources were probed with the installed PDP-6
toolchain in KCC noopt and GCC O0. No general matrix sweep, compiler
change, library substitution, or original-assertion modification occurred.

| Original source | KCC noopt | GCC O0 |
| --- | --- | --- |
| `tests/todo/generic/20020406-1.c` | `timeout` | `timeout` |
| `tests/todo/generic/920810-1.c` | `timeout` | `compile_fail` |

The SHA256-pinned snapshot is
`docs/PDP10-P1-BATCH4-HOSTED-CONTRACT-20261120-v1.tsv`. Earlier
historical `run_fail` labels remain historical, not current guest
assertion evidence.

## Findings

The polynomial recursion source `20020406-1.c` uses `__SIZE_TYPE__`,
`malloc`, `calloc`, `printf`, a degree-order comparison, and
a recursive operand swap. Both installed compilers compile and link.
The actual maps resolve `malloc`, `calloc` and `printf`, but both
SIMH runs reach an 18-second wall timeout (`rc=124`, no HALT,
no guest `__test_exit`). This is **not** a missing-symbol link
failure or an executed failing assertion. The original main path
returns zero without a separate final result assertion; it cannot
establish a general-purpose polynomial library's correctness.

The allocation/struct-copy source `920810-1.c` allocates with
`malloc`, calls `memcpy` and `memset`, then explicitly checks
parent pointer, name and size before `exit(0)`. KCC links
all three named calls, but SIMH also times out without readback.
GCC fails preprocessing at
`stdio.h: No such file or directory`. This is a missing
installed **target header**; GCC never reaches linking or execution
for this source.

Resolution of the symbols in a map is not a claim of correct hosted
service behavior. No allocator stub, host header substitution or
new runtime implementation was introduced.

## Reproduce and verify

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/probe-deferred-libc-v1.py \
  --source tests/todo/generic/20020406-1.c \
  --source tests/todo/generic/920810-1.c \
  --compiler all \
  --outdir "$TMPDIR/p10tk-p1-batch4-hosted-20261120-v1"
python3 tools/audit-p1-batch4-hosted-contract-v1.py \
  --results "$TMPDIR/p10tk-p1-batch4-hosted-20261120-v1/results-v1.tsv"
```

The auditor checks original source SHA256, frozen Batch 4 slots 9 and
10, unresolved P1 states, selected installed target header paths,
actual completed linker maps, simulator timeout reports and compiler
diagnostics. A registered host test checks eight negative mutations,
including falsely promoting a timeout to `run_fail` or `pass`,
invented missing allocator symbols, moved slots and premature P1
closure.

Both original sources remain **blocked**. Neither may be called a
passing semantic test until actual guest termination/assertion evidence
is obtained.
