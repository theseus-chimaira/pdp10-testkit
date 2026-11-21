# P1 native return-value oracle companions (2026-11-20, v1)

Two original P1 programs produce formatted output but fail to assert
their returned objects. These new independent, freestanding C89 tests
complete the **return-value oracle construction**, not the hosted
library requirements or compiler implementation. Original sources,
historical reports and P1 dispositions are unchanged.

## Originals and new tests

* Batch 6 `tests/todo/generic/generic/struct-ret-1.c` calls a
  function both directly and through a function pointer, with
  `B, char, double, B` arguments and an `X` return containing
  `char c[33]` and `char c1`. It compares `sprintf` output
  strings but overwrites its returned `X` without checking fields.
  `tests/semantic/regression/pdp10-large-struct-return-v1.c`
  checks each argument, the direct and indirect returned objects,
  scattered and tail bytes, and caller-storage independence.
* Batch 4 `tests/todo/generic/920726-1.c` compares formatted
  strings from variadic functions returning either an uninitialized
  scalar or uninitialized structure. Both returns are discarded.
  `tests/semantic/regression/pdp10-variadic-return-types-v1.c`
  instead initializes and checks both returns, uses genuine
  `<stdarg.h>`, `va_start`, `va_arg`, `va_end`, and verifies
  `5 20 ` output and buffer bounds with local integer conversion.
  It does not introduce a dummy hosted `sprintf`.

The new sources have normal `semantic-regression` matrix ownership;
they do not require `stdio.h`, `printf`, `sprintf`, or an allocator.
PDP-10 native 9-bit character addressing is retained, with no
8-bit-byte or operating-system-specific assumptions.

## Installed PDP-6 observations

| Native profile | Large `X` return | Variadic mixed returns |
| --- | --- | --- |
| KCC noopt | timeout | PASS |
| KCC opt | timeout | PASS |
| GCC O0 | run_fail, ID `003` | run_fail, ID `012` |
| GCC O1 | PASS | run_fail, ID `012` |
| GCC O2 | PASS | run_fail, ID `012` |
| GCC Os | PASS | run_fail, ID `012` |

IDs are **octal**. For the large-structure test, GCC O0 fails the
`char` argument check (ID 3). For the variadic test, all four GCC
profiles fail the *first scalar return* check (octal `012` =
decimal 10, `sum == 25`). They therefore have **not** reached the
returned-structure assertion. Both KCC variadic tests reach and
verify the scalar, structure fields, and output.

The KCC large-structure executions return SIMH `rc=124` with no
HALT and no guest-exit readback. They remain **timeouts**, not
proven ABI assertion failures. Overall: **5 PASS, 5 executed guest
failures, 2 timeouts**. Only PDP-6 has actually been executed.
All remaining native CPU profiles stay `pending`.

## Reproduce and verify

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/run-tests.py \
  --source tests/semantic/regression/pdp10-large-struct-return-v1.c \
  --family native --cpu pdp6 --compiler all --opt all \
  --out-dir "$TMPDIR/p10tk-p1-structret-oracle-matrix-20261120-v2" -j 2
python3 tools/run-tests.py \
  --source tests/semantic/regression/pdp10-variadic-return-types-v1.c \
  --family native --cpu pdp6 --compiler all --opt all \
  --out-dir "$TMPDIR/p10tk-p1-varargsreturn-oracle-matrix-20261120-v2" -j 2
python3 tools/audit-p1-return-oracles-v1.py
python3 tools/test-p1-return-oracles-v1.py
```

Both focused matrix runs deliberately return nonzero for genuine
compiler failures; they are not full sweeps. Their source SHA256s,
per-profile results, and actual report checksums are pinned in:

* `manifests/PDP10-P1-STRUCTRET-ORACLE-EVIDENCE-20261120-v1.tsv`
  and `refs/p10tk-p1-structret-oracle-evidence-20261120-v1.tar.gz`.
* `manifests/PDP10-P1-VARARGSRETURN-ORACLE-EVIDENCE-20261120-v1.tsv`
  and `refs/p10tk-p1-varargsreturn-oracle-evidence-20261120-v1.tar.gz`.

The host verifier checks every archived guest outcome, unchanged
original source hashes, the exact companion C sources and active
matrix profiles, and **12 negative controls** for false statuses,
tampered reports, source changes, missing profiles, and premature
P1 closure.

Both original obligations remain **blocked** in P1 resolution v9.
The new tests give genuine, observable return-value semantics for
future compiler investigation without claiming hosted formatting
support or fixing any compiler.
