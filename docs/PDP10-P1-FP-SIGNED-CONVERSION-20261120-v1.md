# P1 conversion.c: isolated signed arithmetic diagnostic (v1)

Date: 2026-11-20. Batch 4 slot 4,
`tests/semantic/upstream/pdp10/pdp10/conversion.c`, remains
**blocked**. The original checks signed and unsigned conversions
between 36-bit integers, floating point and, under GNU C, 71-bit
long-long values. Current installed GCC PDP-6 O0 cannot link
the real original because `__fixunssfsi` is missing from the
selected target runtime. KCC PDP-6 noopt reaches the original
assertions but returns nonzero. Neither result proves that every
original conversion family has been exercised.

## New freestanding signed-only companion

The new
`tests/semantic/regression/pdp10-fp-signed-conversion-v1.c`
isolates four *defined* C89 conversion directions:

* signed `int` to `float` (failure bit 1);
* signed `int` to `double` (failure bit 2);
* `float` to signed `int` (failure bit 4);
* `double` to signed `int` (failure bit 8).

The inputs are volatile and include -1024, -1, 0, 1 and 1024,
plus positive and negative fractional values for conversion back
to integer. The expected results come from independent numeric
constant tables, **not** from performing the same conversion
again. No out-of-range casts or unsigned conversion helper
dependencies are introduced. The test executes all 24 checks,
accumulates a four-bit failure mask, then calls `abort` only
after all families have completed. Its source also compiles,
executes and passes under a host ISO C89 compiler.

## Installed compiler observations

| PDP-6 profile | Guest result | Failed group mask (octal) |
| --- | --- | --- |
| KCC noopt | `run_fail` | `003` |
| KCC opt | `run_fail` | `017` |
| GCC O0 | `run_fail` | `001` |
| GCC O1 | `run_fail` | `001` |
| GCC O2 | `run_fail` | `001` |
| GCC Os | `run_fail` | `001` |

These masks identify actual execution coverage, not just the first
failing assertion. All six reports have `rc=0`,
`result=FAIL`, guest HALT, `__test_exit=1`, and the exact
recorded `fail_id`. GCC's linker maps resolve the real
`__floatsisf`, `__floatsidf`, `__fixsfsi`, and
`__fixdfsi` helpers. No runtime symbols were fabricated or
implemented during this task.

Source SHA256 and every actual report/map checksum are pinned in
`docs/PDP10-P1-FP-SIGNED-CONVERSION-EVIDENCE-20261120-v1.tsv`
and `refs/p10tk-p1-fp-signed-conversion-evidence-20261120-v1.tar.gz`.
`tools/audit-p1-fp-signed-conversion-v1.py` verifies all six
reports and the unchanged, blocked original P1 obligation.
`tools/test-p1-fp-signed-conversion-v1.py` runs seven mutation
controls, including wrong failure groups and tampered simulator
evidence.

Narrow reproduction:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/run-tests.py \
  --source tests/semantic/regression/pdp10-fp-signed-conversion-v1.c \
  --family native --cpu pdp6 --compiler all --opt all \
  --out-dir "$TMPDIR/p10tk-p1-fp-signed-conversion-pdp6-20261120-v2" -j 2
python3 tools/test-p1-fp-signed-conversion-v1.py
```

The normal matrix contains this source exactly once as a
`semantic-regression` with all six executed PDP-6 profiles
registered as real failures. Other native CPU profiles remain
`pending`. The historical `conversion.c` source is unchanged,
its GCC unsigned conversion `__fixunssfsi` prerequisite remains
open, and the entire P1 testkit obligation remains **blocked**.
No compiler/runtime repair or full compiler/CPU sweep occurred.
