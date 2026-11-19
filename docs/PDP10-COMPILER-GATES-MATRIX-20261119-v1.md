# PDP10 16 canonical compiler gates: normal matrix integration (2026-11-19 v1)

## Ownership and scope

The sixteen source-pinned, compiler-specific gates in
`UPSTREAM-CONSOLIDATED-COMPILER-GATES-20261118-v21.tsv` are ordinary
`COMPILER_MATRIX.tsv` test sources, **not separate runnable test suites**.
The original v21 sources, import/disposition provenance, compiler gate
assertions and recorded expected failures remain unchanged.

Eight previously `no_test` KCC PDP-6 rows were made executable in the
ordinary matrix. Seven retain an observed `error` disposition and the
now-passing `20011113-1.c` uses `semantic`. The other eight already had
runnable PDP-6 cells, including historical `error`/`fail` statuses.
These statuses **schedule** compiler execution; they never convert a
compiler failure into a passing test. The existing consolidation/source
inventory audit now fails if any of the sixteen canonical gate profiles
become unscheduled, missing, duplicated or source-hash inconsistent.

The standard matrix runs KCC both optimized/unoptimized or GCC at
`-O0`, `-O1`, `-O2`, `-Os` on PDP-6 as appropriate, for **38 cells total**.
The full 38-cell run was performed through the regular `run-tests.sh`
entrypoint with `--source` selecting each original canonical source,
`--compiler`, `--family native`, `--cpu pdp6`, `--opt all`,
`--kind semantic`. Results are from actual compiler and linked PDP-6
simulator runs, not static assessments.

Result ledger: `PDP10-COMPILER-GATES-MATRIX-RESULTS-20261119-v1.tsv`.
Full 38 source/compiler/linker/runtime evidence records are retained
in `refs/compiler-gates-pdp6-matrix-20261119-v1.tar.gz`. The existing
source-consolidation auditor checks the ledger, exact expected profile
set, original source hashes, archive members, evidence SHA256 and
compiler/guest result consistency; tampering is rejected.

## Current PDP-6 observations

Status words below are the actual *test-runner outcomes*, never the
matrix scheduling disposition. Every `run_fail`, `compile_fail`,
`link_fail` or `compiler_ice` is a real **failed** compiler cell.

| Gate | Failing compiler | Canonical source | Native PDP-6 observations |
|---:|---|---|---|
| 1 | KCC | `930106-1.c` | opt: run_fail, noopt: run_fail |
| 2 | GCC | `strct-pack-1.c` | o0: run_fail, o1: run_fail, o2: run_fail, os: run_fail |
| 3 | KCC | `ashrdi-1.c` | opt: compile_fail, noopt: compile_fail |
| 4 | KCC | `ashldi-1.c` | opt: compile_fail, noopt: compile_fail |
| 5 | KCC | `920909-1.c` | opt: link_fail, noopt: link_fail |
| 6 | GCC | `990106-2.c` | o0: run_fail, o1: run_fail, o2: run_fail, os: run_fail |
| 7 | KCC | `920721-4.c` | opt: compile_fail, noopt: compile_fail |
| 8 | KCC | `20020314-1.c` | opt: link_fail, noopt: link_fail |
| 9 | KCC | `991014-1.c` | opt: run_fail, noopt: run_fail |
| 10 | KCC | `930111-1.c` | opt: compiler_ice, noopt: compiler_ice |
| 11 | KCC | `20010124-1.c` | opt: compile_fail, noopt: compile_fail |
| 12 | GCC | `strct-pack-3.c` | o0: run_fail, o1: run_fail, o2: run_fail, os: run_fail |
| 13 | KCC | `bcp-1.c` | opt: compiler_ice, noopt: compiler_ice |
| 14 | KCC | `bf-pack-1.c` | opt: compile_fail, noopt: compile_fail |
| 15 | KCC | `20011113-1.c` | opt: pass, noopt: pass |
| 16 | KCC | `bf-layout-1.c` | opt: compile_fail, noopt: compile_fail |

The observed cell totals are **16 runtime failures, 12 compilation
failures, four link failures, four compiler internal errors and two
passes**. Thus **36/38 cells fail**; only `20011113-1.c` passes.

## Gate 15: independent assertion-strength validation

`tests/todo/generic/20011113-1.c` is now registered in the normal KCC
PDP-6 semantic matrix (opt and noopt). Its original source was not
changed. Both normal executions successfully run through `main`,
`baz`, `foo`, `memcpy`, `bar` and the checked result path. The assembly
of both profiles retains both copy operations, both calls into `bar`,
and `bar`'s abort branch. The test does *not* just compile its code
without exercising the assertion.

Separate test-of-test evidence deliberately corrupts `t.d[2]` before
`baz()` or before `foo()`, in isolated temporary source copies. Both
corruptions are detected with nonzero `__test_exit` in both KCC modes;
the unmodified program succeeds in both. The original upstream test
and its source hash remain unchanged. This supports closing the PDP-6
KCC portion of that gate, **not** all other PDP-10 CPU profiles.

The negative controls are oracle-construction checks, not alternative
compiler tests. They are kept separate from the matrix's pass-expected
original source so intentional corruptions cannot be mislabeled as
compiler regressions.

## Remaining work and policy

The other fifteen canonical gates still fail in their captured PDP-6
compiler profiles. Compiler fixes are explicitly deferred until testkit
construction is complete. Some failures correspond to unsupported KCC
GNU extensions or missing freestanding/runtime dependencies; the
preserved failures alone do not establish sixteen independent compiler
bugs. Link failures and unsupported features must be diagnosed before
any future assertion is treated as compiler acceptance.

The original historical v21 open-gate ledger is preserved rather than
rewriting its dated assertions/results. Further CPU family coverage,
including the KA10, KI10 and KS10 semantics and separate floating-point
hardware oracles, remains P1 test construction. Benchmarking and
optimization remain P2/P3.
