# P1 920501 many-argument/stdio oracle v1

Date: 2026-11-20. Scope: `pdp10-testkit` only; the full sweep is
explicitly deferred. The historical original `tests/todo/generic/920501-8.c`
is byte-identical to SHA256
`21884df76c9d24d4d4808d78de8e8a4e7909fffd1ee26a72f96f4be00a22b56a`.

## Original and real hosted blockers

The original calls a mixed `int,double,int,...` function, takes thirteen
additional `int` varargs, calls hosted `printf`, calls `sprintf` with
sixteen format arguments, and checks the resulting string against
`1,1.000000,2,3,4,5,6,7,8,9,10,11,12,13,14,15`.

Targeted current installed PDP-6 original-source evidence:

| Profile | Observed status | Exact condition |
| --- | --- | --- |
| KCC noopt | `timeout` | SIMH `rc=124`, `result=FAIL`, no HALT |
| GCC O0 | `link_fail` | `dlink: duplicate global: vsprintf` |

The GCC generated C assembly refers to `printf` and `sprintf`; the
selected real `p10stdio-format-v2.s` contains one visible `vsprintf`
global definition. The duplicate diagnostic must be investigated in
the assembler/linker and its selected object set. It is **not** an
established missing `vsprintf` function, nor is a timeout proof of
failed guest assertions. The original's real console `printf` path
also remains OS/hosted-runtime dependent.

## Source-linked freestanding companion

The normal matrix now owns
`tests/semantic/regression/pdp10-variadic-manyargs-sprintf-v1.c`.
It keeps the exact sixteen-field formatting request, thirteen actual
`va_arg` integer reads and full expected string. It omits unasserted
console output, uses the real installed target `sprintf`, validates
every extracted integer, and gives distinct guest nonzero exit codes
for wrong vararg fields, negative formatting results, mismatched
output bytes, missing NUL or wrong aggregate result.

Six fresh PDP-6 guest runs execute the integer-varargs loop and reach
**exit 41 (octal 051)** because `sprintf` returns a negative value
when handling the original default-precision `%f`. Each case is
recorded as `run_fail`, not PASS. All six link a real `sprintf` symbol
and have archived emitted assembly. The original's unverified `printf`
dependency is neither stubbed nor called fixed.

A focused scratch-only differential using `%.0f` instead of `%f`
passed KCC noopt but still failed GCC O0. That experiment suggested
distinct floating formatter and many-argument issues, but it was not
an activated original-source oracle and does not count as another
verified matrix PASS. The intact sixteen-field `%f` assertion is kept
in the permanent companion.

## Versioned evidence and P1 disposition

`docs/PDP10-P1-920501-MANYARGS-EVIDENCE-20261120-v1.tsv` and
`refs/p10tk-p1-920501-manyargs-20261120-v1.tar.gz` pin both original
profiles and all six companion failures, including the exact GCC
linker diagnostic, KCC timeout, six real guest exit codes, linker maps
where available and all generated C assembly. The source-specific
verifier `tools/test-p1-920501-manyargs-v1.py` rejects ten mutations.

The live v18 P1 ledger marks test **construction** covered: the
previously unasserted hosted dependency has been split from a real
freestanding compiler/variadic/formatting oracle. Compiler ABI and
formatter errors **remain open**, and no runtime PASS is invented.
The original and versioned historical manifests are preserved.

To select only the companion's six native PDP-6 profiles:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/pdp10-variadic-manyargs-final-v7" \
  --source tests/semantic/regression/pdp10-variadic-manyargs-sprintf-v1.c \
  --compiler all --cpu pdp6 --opt all -j 6
python3 tools/test-p1-920501-manyargs-v1.py
python3 tools/build-p1-semantic-resolution-v18.py
```
