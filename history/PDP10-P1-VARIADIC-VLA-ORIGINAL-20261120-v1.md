# Original GNU variable-sized va_arg: executable P1 oracle (v1)

Date: 2026-11-20. The original Batch 4 slot 5,
`tests/todo/generic/20020412-1.c`, is unchanged and contains a
substantive GNU C test: two anonymous variable-sized structures,
`va_arg(ap, typeof(d))` twice, two five-character input arrays,
and ten sequential character assertions (`'0'` through `'9'`)
using the advancing static counter in `bar()`.

This is **not ISO C89**: the variable-size struct/typeof constructs
are deliberate GNU extensions. No replacement with a fixed-size
aggregate would validate the original compiler feature. KCC does
not currently compile the original; GCC does and reaches its real
guest assertions. The original source does not require hosted
`stdio.h` and has no dummy runtime routines.

## Real installed PDP-6 observations

| Source/profile | Actual result |
| --- | --- |
| KCC native noopt | `compile_fail`: four GNU VLA/struct errors |
| GCC native O0 | `run_fail`: guest HALT, `__test_exit=1` |
| GCC native O1 | `run_fail`: guest HALT, `__test_exit=1` |
| GCC native O2 | `run_fail`: guest HALT, `__test_exit=1` |
| GCC native Os | `run_fail`: guest HALT, `__test_exit=1` |

Every GCC execution links genuine `memcpy`, `abort`, and
`exit`, runs without step expiry, and terminates with the
test's nonzero assertion exit. No compiler success is claimed.
The four GCC reports, their actual link maps, and the KCC
compiler-error log are archived, all source-SHA256 checked, in
`refs/p10tk-p1-variadic-vla-original-evidence-20261120-v1.tar.gz`
with the five-row record
`manifests/PDP10-P1-VARIADIC-VLA-ORIGINAL-EVIDENCE-20261120-v1.tsv`.

The audit
`tools/audit-p1-variadic-vla-original-v1.py` and its
`tools/test-p1-variadic-vla-original-v1.py` regression suite
verify genuine assertions, GCC execution, KCC syntax rejection,
runtime linkage and **seven negative controls**.

Reproduce only these compiler cells, not the full sweep:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/run-tests.py \
  --source tests/todo/generic/20020412-1.c \
  --family native --cpu pdp6 --compiler gcc --opt all \
  --out-dir "$TMPDIR/p10tk-p1-variadic-vla-guest-pdp6-20261120-v1" -j 2
python3 tools/test-p1-variadic-vla-original-v1.py
```

The live P1 test-construction obligation is **covered**, but the
KCC GNU-extension rejection and all four GCC run failures remain
compiler defects to investigate later. No GCC, KCC, runtime or
original-source edits have been made, and no full sweep was run.

`conversion.c` remains **blocked**: its original contains both
ordinary and GNU-only 71-bit conversion paths; installed GCC
cannot link `__fixunssfsi`, and KCC executes but fails the
original assertions. That is not evidence that the full unsigned
and long-long conversion scope has been exercised.
