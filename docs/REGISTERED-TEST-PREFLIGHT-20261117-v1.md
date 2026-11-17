# PDP-10 registered test integration and preflight (2026-11-17 v1)

## Scope and explicit boundaries

This pass addresses **test ownership, runner dispatch, prerequisite
resolution and accurate failure status**. No GCC/KCC source, backend,
assembler, simulator, historical source test, or expected assertion
was modified or weakened. Actual compiler behavior failures are
**recorded, not repaired**. A passing result is claimed only for an
observed executable source assertion or compile-only oracle.

Repository baseline: commit `47823d2` on `main`, clean at task start.
Original historical GCC review: 679/679 sources classified, 560
source snapshots retained, 119 inapplicable tombstones; these were not
changed. The authoritative compiler matrix still has 2,105 sources.

## Completed test ownership preparation

| Task | Result | Primary evidence |
| --- | --- | --- |
| 50 deferred-source duplicate pairs | All 50 manually assigned a canonical owner, hash/provenance and exact assertion; 48 remain deferred and two retain existing active owners with separate GCC failure evidence | `docs/DEFERRED-SOURCE-DUPLICATES-20261117-v2.tsv`, `docs/DEFERRED-SOURCE-DUPLICATES-REVIEW-20261117-v2.md` |
| 19 historical PDP-10 GCC target artifacts | 12 codegen owners, 4 shell oracles, 2 companion C files and one excluded ITS CIRC case; no double scheduling | `docs/GCC-PDP10-TARGET-OWNERSHIP-20261117-v2.tsv` and corresponding review |
| Special-suite execution graph | 232 enabled direct registrations, 11 entrypoint scenarios; disabled/manual/nested helper cases not redispatched | Registered `tools/test-special-suite-dispatch-v1.py` |
| Source/registry integrity | 2,105 compiler matrix sources; 246 special registry entries; no unowned C/assembler sources or scripts | `tools/audit-test-inventory-v1.py`, `tools/audit-script-ownership-v4.py` |

The unchanged v1 duplicate corpus records two active source copies,
`strct-pack-1.c` and `strct-pack-3.c`, and six deferred disposition
conflicts. V2 preserves both blocker explanations for every conflicting
pair, and the canonical copy does not imply any additional KCC/GCC
profile coverage.

## Executed compiler/runner preflights

| Execution sample | Result | Evidence/limitation |
| --- | --- | --- |
| GCC native PDP-6 `-O0`, 37 negative sources, 2 workers | **37 PASS**, zero failure checkpoints | Isolated `$TMPDIR/pdp10-testkit-gcc-negative-pdp6-o0-v1` |
| GCC native four CPUs (PDP-6, KA10, KI10, KS10), `-O0`/`-O2`, 37 negatives, 4 workers | **296/296 PASS**, zero failure checkpoints | `$TMPDIR/pdp10-testkit-gcc-negative-4cpu-o0o2-v1`; not all four optimization modes or all compiler families |
| Twelve original GCC PDP-10 target codegen oracles | **12/12 PASS** with original `dg-options`, positive/negative assembler scans | Existing native `gcc-target-codegen-v2` validator |
| Three preserved original target shell probes | **3/3 PASS** | Octal BADL source, no-static-members and 71/72-bit feature-macro sources |
| Stronger canonical BADL linker/runtime oracle | **PASS** for PDP-6 **and KA10**, including direct installed GCC link and all five byte-pointer table helpers | `misc/validation/test-badl-tables.sh` after correcting absent simulator environment defaults |
| PDP-10 historical byte-pointer and logical-shift codegen regressions | **8/8 PASS** across four GCC `-O2` targets | Actual `run_codegen_cell` status checkpoints and source-level required/forbidden regexes |
| Two KCC PDP-6 ISA cases (`ADD.c`, `AND.c`) | **2 `compile_only`**, not guest runtime passes | Actual compiler/ISA preflight checkpoints |
| Ten sampled historical semantic cells | **9 PASS, 1 unresolved KCC link failure** | Two KCC/6 GCC cells from batch 01; four GCC GNU-init cells from batch 12 |
| Six packed-structure differential guest cells | **2 KCC PASS, 4 GCC FAIL** | Both tests KCC noopt pass; GCC PDP-6 `-O0` and `-O2` both reach `abort()` |

The 37-cell PDP-6 negative batch is repeated within the separate
296-cell cross-CPU/profile run; the totals above are execution
observations, **not unique test count or whole-suite coverage**.
The four-shell target inventory includes one BADL test owned by the
stronger existing validation script, so it has not acquired a
redundant registry owner.

## Harness problems found and corrected

### Installed simulator path defaults for BADL

The original registered BADL validator attempted to use
`SIMH_PDP6` and `SIMH_KA` with `set -u`, but the canonical testkit
environment exports only `PDP10_PREFIX`. This failed **before any
compiler or emulator assertion was reached**. Its harness now
selects `$PDP10_PREFIX/bin/pdp6` and
`$PDP10_PREFIX/bin/pdp10-ka` by default, matching `p10run`'s
installed simulator resolution; callers can still explicitly select
a candidate simulator. The original BADL executable source and
helper assertions remain unchanged. The real PDP-6 and KA10 guest
runs subsequently passed.

### Link failure versus guest assertion failure

The native semantic runner previously labeled *all* non-timeout
`p10run` failures as `run_fail`, even when target linking never
finished. `p10run_failure_status` now distinguishes the explicit
`p10run: link failed` marker as `link_fail`, retains `run_fail` for
real guest assertion/termination failures and `timeout` for code 124.
`link_fail` is a known failing checkpoint status for restart and
summaries, not a silent skip or a passing result. The existing
versioned runner-accounting host regression includes synthetic
fail-closed assertions for these cases.

A real KCC PDP-6 `noopt` run of historical `20011115-1.c`
reproduced `dlink: undefined symbol: undefined_reference` and now
correctly records **`link_fail`**. This is a compiler/profile
behavior observation for the test's intentionally unreachable extern
branch. It is **not** relabeled `pass`, suppressed by a fake symbol
or changed into an expected failure. KCC compiler optimization is
outside this task's scope.

## Compiler regressions recorded, not changed

Two packed/aligned source assertions, `strct-pack-1.c` (short and
double member readback) and `strct-pack-3.c` (short/int-array
indexing), produce a genuine GCC PDP-6 guest abort at both `-O0`
and `-O2`; both pass KCC PDP-6 noopt. These are reproducible
compiler-specific results, not duplication errors. Their original
source bytes, existing matrix rows and executable `abort` assertions
are unchanged. The historical duplicate-defer record remains
independently available.

The KCC `20011115-1.c` undefined-reference link failure is also
recorded with its own failing checkpoint. The test's `__COMPILER_KCC__`
branch is an explicit optimization oracle, not a reason to inject an
undefined symbol provider or replace the code with a no-op.

**No compiler bugs were fixed or hidden.** No compiler or simulator
repository was modified or committed during this task.

## Remaining tests and how to continue

The work above completes the three requested *pre-sweep integration*
tasks and starts actual registered test execution. It does **not**
complete the full semantic/ISA or codegen matrices, the other GCC
optimization/target combinations, all special-suite prerequisites,
or original DejaGNU `dg-warning`/`dg-bogus` message matching. The
269 deferred semantic originals remain intentionally deferred until
their actual target libc, varargs, header, ISA or width gates are
met. All recognized compiler problems are separate follow-up work.

To reproduce only the successful broad negative slice with stable,
isolated checkpoint output:

```sh
export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
./run-tests.sh --compiler gcc --family native \
    --cpu pdp6,ka10,ki10,ks10 --opt o0,o2 --kind negative \
    -j 4 --out-dir "$TMPDIR/pdp10-testkit-gcc-negative-4cpu-o0o2-v1"
```

Run `python3 tools/audit-test-inventory-v1.py`,
`python3 tools/audit-script-ownership-v4.py`, and the registered
host `verify` tests before expanding compiler execution. The
complete repository-wide `./run-misc-tests.sh verify` additionally
executes the much larger `compat` and `validation` groups; it is
not equivalent to the host-only `verify` registry subgroup.
