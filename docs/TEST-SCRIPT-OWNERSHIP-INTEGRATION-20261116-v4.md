# Test script ownership and disconnected test integration (2026-11-16 v4)

## Purpose and evidence level

**STATIC INTEGRATION ONLY. No compiler, assembler, or guest tests were run
for this stage.** The goal is to connect available tests to their owning
runner before starting any further test sweeps. The ledger
`docs/TEST-SCRIPT-OWNERSHIP-20261116-v4.tsv` gives an explicit disposition
for every discovered `.sh`/`.py` script below `misc/`, `tests/`, or `tools/`
in the current `pdp10-testkit` checkout. New scripts with no owner cause
`tools/audit-script-ownership-v4.py` to fail in the future `verify` suite.

The current staged integration scope accounts for 375 scripts, including
the historical `.sh` files retained in `refs/`: 228 enabled registered
roots, seven registered manual entries, 128 delegated scripts, five
imported helper modules, three dispatch or legacy entrypoints, two
explicitly manual analysis tools and two explicitly superseded oracles.
There were
zero unclassified script paths. These numbers are not successful test
counts. The owner graph checks exact script references and that delegation
reaches a registered root or an explicit entrypoint. It cannot prove that
the reference is executed, that all assertions are meaningful, or that
prerequisites are installed.

## Newly integrated scripts

Three UTF-9 conversion regressions were reachable through the independent
`pdp10-tools/Makefile` `check-utf9` target but absent from the authoritative
special registry. They now have three distinct `tools` cases, which use
the **same** isolated Git-archived build as the other independent utility
checks:

| Case | Standalone test owned | Utilities required |
| --- | --- | --- |
| `pdp10-tools-utf9-file-v3` | `misc/compat/test-utf9-file-v1.py` | `utf9-file-v1` |
| `pdp10-tools-utf9-s6rec-v3` | `misc/compat/test-utf9-s6rec-v1.py` | `utf9-file-v1`, `utf9-s6rec-v1`, `csix` |
| `pdp10-tools-s6rec-utf9-v3` | `misc/compat/test-s6rec-utf9-v1.py` | `utf9-s6rec-v1`, `s6rec-utf9-v1`, `utf9-file-v1` |

The existing optional Makefile target was not changed or scheduled as a
second registry entry. Each UTF-9 test now uses `$TMPDIR` and explicit
`require()` failures rather than Python `assert`, which can disappear
when run under `python -O`. The new scripts have not been executed yet.

Five original standalone PDP-6 KCC `run.sh` regressions under
`tests/semantic/imported/target/` now have separate `kcc-regression`
registrations: indexed call, local word array, loop return, pointer
scan, and six-argument character-buffer call. Their `matrix-semantic.c`
wrappers were already present in `COMPILER_MATRIX.tsv`, but the original
runners additionally select `-Pgnu99`/native assembler options and
exercise an explicit target regression result. This is **intentional
complementary coverage**, not a claim that running the same test twice
with identical options is useful. The original five runners are otherwise
unchanged, and have not been executed in this integration stage.

The exploratory AAP JRST relocation probe has an explicit **manual-only**
registration; its own source says it is not proof of ILLOP coverage.
The old `misc/tools/run.sh` remains a backwards-compatible command-line
entrypoint, not a separately scheduled regression. Seven `das` entries
whose profile is `nested` are owned by registered fast/native aggregate
scripts, not independently dispatched. Additional DAS `.py` checkers
consume different assembler fixtures through their owners and are not
scheduled individually without those fixtures.

## Remaining source and policy gaps

This ledger covers executable Python/shell scripts in `pdp10-testkit`,
including the five historical reference shell scripts.
The compiler matrix's C/assembler source ownership is audited separately
by `tools/audit-test-inventory-v1.py`. The current `gcc-pdp10` Git
checkout intentionally omits the old DejaGNU testsuite, but the source
is recoverable from revision `b0f5374`. Eighteen applicable target-specific
artifacts are already preserved under `refs/gcc-pdp10-target-v2/`:
twelve C codegen oracles have a registered runner, three shell oracles
now have registered wrappers, and one is covered by a stronger existing
BADL test. The obsolete ITS-only CIRC case was explicitly excluded.
See `docs/GCC-TARGET-SHELL-OWNERSHIP-20261116-v3.md` for the review.
The larger historical GCC corpus (including 693 independently flagged
unmirrored C candidates) still needs assertion-level source review.

The separate `daimos-testkit` repository also has a substantially larger
target/validation script collection. Its integration/ownership accounting
must be completed separately before declaring **all project test suites**
fully connected. Deferred C/assembler test sources and tools invoked
through dynamic code also require independent review. This review does
not mark such external or deferred coverage complete.

The earlier uncommitted GCC negative-classifier and parallel-result work
is deliberately **not acceptance evidence** for this integration stage;
its additional uncommitted GCC classifier self-test is not included in
the 366-script committed inventory count. That work should be reviewed
and committed separately after owner registration
and remaining static audits are settled. The next step is to continue
source inventory and registration, not to execute broad compiler sweeps.

**Subsequent review (2026-11-17):** The four previously uncommitted
GCC negative-classifier/parallel-result changes were audited and
accepted with corrected reserved-exit and worker status handling.
Two directly registered host checks, `test-gcc-negative-policy-v1`
and `test-runner-result-accounting-v1`, now exercise historical GCC
diagnostics, fail-closed restarts, worker exceptions and compiler
exit codes. The current static ownership audit passes with 378
discovered scripts (the earlier 366 count is the historical v4
snapshot). Real GCC negative cells passed sequentially and with two
workers. See `docs/GCC-NEGATIVE-RUNNER-ACCOUNTING-20261117-v1.md`;
this is not a full GCC compiler matrix or DejaGNU-text oracle sweep.
