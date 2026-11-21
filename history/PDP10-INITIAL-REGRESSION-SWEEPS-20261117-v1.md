# Initial registered PDP-10 compiler regression sweeps (2026-11-17 v1)

## Scope and explicit constraint

Work started from clean `pdp10-testkit` commit `4ca7e00` on `main`.
Only the test harness, per-compiler invocation, two test fixture include
settings, a host regression check and test-specific documentation were
changed. **No GCC/KCC compiler, assembler, simulator, libgcc, runtime,
historical source test assertion or compiler backend was modified.**
Existing failing compiler tests remain enabled and failing; neither
false-green expectations nor mass `no_test` reclassifications were used.

This is **real installed toolchain execution**, with compiler output,
per-cell statuses and failing report paths under stable `$TMPDIR`
directories, not a source-inventory acceptance claim.

## Results by distinct registered matrix cell

| Registered selection | Cells | Pass | Fail | Breakdown |
| --- | ---: | ---: | ---: | --- |
| GCC native negative, PDP-6/KA10/KI10/KS10 `-O0` and `-O2` | 296 | 296 | 0 | Prior verified selection, checkpoint rechecked |
| GCC native negative, PDP-6/KA10/KI10/KS10 `-O1` and `-Os` | 296 | 296 | 0 | Executed during this stage, four workers |
| GCC native codegen, PDP-6 `-O0` and `-O2` | 1,803 | 1,773 | 30 | 25 `compile_fail`, 3 `compiler_ice`, 2 `policy_fail` |
| GCC native codegen, PDP-6 `-O1` and `-Os` | 1,800 | 1,765 | 35 | 30 `compile_fail`, 3 `compiler_ice`, 2 `policy_fail` |
| KCC native codegen, PDP-6 `noopt` | 962 | 800 | 162 | 96 `compile_fail`, 3 `compiler_ice`, 63 `policy_fail` |
| **Total distinct cells** | **5,157** | **4,930** | **227** | **151 compile failures, 9 ICE/signal failures, 67 policy failures** |

The independent 37-source GCC PDP-6 `-O0` negative preflight from the
prior integration pass was also observed and its output checked. It is
**not** counted twice in the table because those same 37 cells are
included in the 296-cell `-O0`/`-O2` selection above.

The codegen-only total is **4,565 cells: 4,338 pass, 227 fail**.
The four-CPU native GCC negative-test coverage is now complete for
`-O0`, `-O1`, `-O2` and `-Os`: **592/592 pass**. This does not imply
that GCC base/PDP-10 families, KCC codegen optimized profiles,
all CPUs' codegen, or the large semantic/ISA matrices have been run.

All new bulk selections used `-j 4`. Every selection ended with zero
missing-source rows; selected-cell counts, completed statuses and
`failures.tsv` were cross-checked against `summary.txt`. No
nonpassing status was skipped or represented as green.

## Complete, versioned failure inventory

`manifests/PDP10-INITIAL-SWEEP-FAILURES-20261117-v1.tsv` contains **all
227 final failing source/profile cells**. Each row contains the
compiler, machine, exact profile, registered source, current source
SHA-256, outcome class and a short original diagnostic excerpt. The
227 failures involve **178 unique source paths**. No result was
silently omitted; the manifest is derived from the runner's
`failures.tsv` reports and validated against the five unique selections.

Full compiler diagnostics and assembly files remain in the stable
per-cell directories under `$TMPDIR`. This TSV pins the result state
without copying potentially very large assembler output or simulator
logs into Git. Diagnostic excerpts are kept ASCII and normalized to
repo-relative source names where possible.

### Compiler failures (not repaired)

The nine genuine internal-error/signal codegen failures include:

| Compiler | Original source | Profile(s) | Diagnostic |
| --- | --- | --- | --- |
| GCC | `upstream-gcc/compile/20011217-2.c` | PDP-6 `-O0` | `instantiate_virtual_regs_1`, `function.c:4444` |
| GCC | `upstream-gcc/compile/20020617-3.c` | PDP-6 `-O0` | `instantiate_virtual_regs_1`, `function.c:4444` |
| GCC | `upstream-gcc/compile/930120-1.c` | PDP-6 `-O1`, `-O2`, `-Os` | `instantiate_virtual_regs_1`, `function.c:4290` |
| GCC | `upstream-gcc/compile/goto-1.c` | PDP-6 `-Os` | `cc1` segmentation fault |
| KCC | `upstream-gcc/compile/920501-22.c` | PDP-6 `noopt` | `[Internal error] simsmove: bad size 0` |
| KCC | `upstream-gcc/compile/init-1.c` | PDP-6 `noopt` | `[Internal error] gizlist: bad size 0` |
| KCC | `gcc-historical-b08-v1/line4.c` | PDP-6 `noopt` | Abnormal compiler exit; no source diagnostic text |

`compiler_ice` is intentionally a failure even if the compiler exits
with a normal nonzero status after printing an ICE. The full KCC and
GCC negative/correctness expectations were not changed. The other
151 compile failures include nonportable source/dialect requirements
and historical compiler limitations; the other 67 policy failures
include KCC instruction-shape expectations and GCC acceptance of
`vla-vla-switch-in-negative.c` when rejection was expected. These
are **not** reported as passed or fixed merely by classification.

## Test harness/integration repairs actually validated

### GCC 3.2 ICE classification

Prior to the sweep, the main runner labeled source-located compiler
ICE diagnostics with exit status 1 as `compile_fail`. On the original
`20011217-2.c`, `20020617-3.c` and `930120-1.c` failures, this was
wrong. `compile_failure_status` now accepts diagnostics and uses the
existing shared `ICE_RE` before emitting `compiler_ice`. The original
source, compiler behavior, and fail-closed exit status are unchanged.
The registered `test-runner-result-accounting-v1.py` now asserts this
for a real GCC 3.2-style ICE and a control source syntax error.

### Two test fixture integration errors

1. `tests/codegen/kcc-ported/local-idempotent-cleanup-selfmove.c` had a
   stale relative include path to the existing
   `tests/semantic/validation-gcc/abi/abi_call_torture_07.c` fixture.
   Correcting only the include path restores the intended actual C
   body, rather than creating a stub or weakening any assembly oracle.
2. `tests/codegen/kcc-ported/pp-include-next-v1.c` required three
   source-specific include paths already declared for KCC. Those same
   original header-chain prerequisites were not passed to GCC.
   An explicit `codegen-gcc-extra` directive now supplies the three
   paths to the GCC compilation command; the original CPP and
   assembler assertions stay unchanged.

**Four GCC codegen cells recovered** in a targeted resumption:
1,769/1,803 became 1,773/1,803, with zero new failures. Resumption
skipped the 1,769 already-green cells and retried exactly the 34
original failures; the resulting checkpoint census is fail-closed.

### KCC output bytes and source/assembler path handling

KCC special multi-invocation diagnostics can contain raw `0xff` byte
sentinels. The special-check subprocess capture now decodes as
Latin-1 instead of crashing with `UnicodeDecodeError`. A registered
host regression, `test-kcc-special-output-decoding-v1.py`, verifies
exact output-byte preservation for both exit 0 and exit 1. The real
multi-CPU `local-dse` special regression now **passes**, not merely
avoids the exception.

KCC does not reliably search the input source directory for adjacent
quoted/macro include files, unlike the GCC invocation. The runner
now explicitly puts the source directory first in KCC `-I` paths.
This restores the actual `mi1c.h` checks in
`gcc-historical-b08-v1/include1.c` and
`gcc-historical-b09-v1/mi4.c`, plus the original
`variadic-macros-stringize.c` prerequisite. No header or source
oracle was replaced.

KCC also imposes a 169-character filename limit. The original
runner repeated the full test identity in generated preprocessor
input filenames and in regular `-R` output path arguments. Synthetic
preprocessor tests now use a private `input.c` and compile from
that cell's directory with a short input argument; normal KCC
compilation similarly emits `unit.s` via private `-R=unit`, then
atomically renames it into the stable versioned per-cell assembly
artifact. Compiler source and support includes are passed as absolute
paths because each cell's private directory is the invocation CWD.
This preserves parallel isolation, stable checkpoints, original
compiler options and output-assembler policies.

A deliberately long (>180-character) output-directory probe passed
real installed KCC `-S` and `-E` test cells. The complete 962-cell
KCC native PDP-6 noopt codegen selection was rerun **in full** after
changing source include routing and again **in full** after changing
`-R` output routing. Final result: **800 pass, 162 fail**, versus
795 pass, 167 fail before these five harness fixes. No new failures
appeared and the original 162 compiler/policy failures stayed failing.

As a separate compatibility check after KCC's invocation CWD changed,
two already registered semantic guest tests (`strct-pack-1.c`,
`strct-pack-3.c`) still **PASS**. The previously observed
`20011115-1.c` undefined-symbol case still reports `link_fail`, not
an invented success. Five registered PDP-6 KCC negative-source
tests also still **PASS** with genuine diagnostic rejection. These
focused compatibility rechecks are not added to the distinct-cell
sweep totals above.

## Stable restart directories

Under `${TMPDIR:-$HOME/tmp}`:

* `pdp10-testkit-gcc-negative-4cpu-o0o2-v1` (prior, 296 pass)
* `pdp10-testkit-gcc-negative-4cpu-o1os-20261117-v1` (296 pass)
* `pdp10-testkit-gcc-codegen-pdp6-o0o2-20261117-v1` (1,803 cells)
* `pdp10-testkit-gcc-codegen-pdp6-o1os-20261117-v1` (1,800 cells)
* `pdp10-testkit-kcc-codegen-pdp6-noopt-20261117-v3` (962 cells, final KCC invocation)

These are current tool-execution directories on the user system;
no generator runs in the background or changes compiler source.
The table and TSV are pinned to these checkpoint states. Failed
cells can be independently rerun using the same `--out-dir` and
filters. The runner skips completed passes and retries failures.

For example, recheck only unsuccessful cells of the original GCC
`-O0`/`-O2` codegen batch (with the green checkpoints retained):

```sh
export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
./run-tests.sh --compiler gcc --family native --cpu pdp6 \
    --opt o0,o2 --kind codegen -j 4 \
    --out-dir "$TMPDIR/pdp10-testkit-gcc-codegen-pdp6-o0o2-20261117-v1"
```

A nonzero top-level exit is expected while genuine compiler and
assembler-policy failures remain. For KCC, use the corresponding
`pdp10-testkit-kcc-codegen-pdp6-noopt-20261117-v3` directory with
`--compiler kcc --family native --cpu pdp6 --opt noopt --kind codegen`.

## Still open

* Other GCC codegen CPUs/target families and KCC optimization/CPU
  profiles; complete semantic and ISA matrices; large special-suite
  runtime validation, including DAS/KCC-host prerequisites.
* The 269 already classified deferred upstream semantic sources and
  historical GCC C deferred sources, whose original prerequisite
  decisions remain unchanged.
* Exact original DejaGNU expected-diagnostic pattern matching.
* Compiler ICEs, codegen/policy violations, unsupported language
  constructs and runtime failures. These **must be addressed as
  separate compiler tasks only when expressly authorized**; no such
  compiler task was attempted during this harness/test sweep.

The next execution step is to resume the untested GCC cross-CPU
codegen selections and KCC remaining native optimized/codegen or
semantic profiles, preserving failures rather than turning off tests.

## Final testkit integration acceptance

The complete registered host `verify` group finished **15/15 PASS**,
including the new byte-preserving KCC special diagnostic test, the
GCC/KCC rejection checks, runner restart/result accounting and
special-suite dispatch. The static inventory verified 2,105 compiler
matrix source registrations, 247 special-suite entries (233 enabled
direct owners), 50 reviewed duplicate pairs, all 19 original PDP-10
GCC targets, and zero unowned test sources or script registrations.

The historical 679-source GCC identity audit also passed without
modifications: 560 retained original snapshots and 119 reviewed
inapplicable tombstones. Python syntax compilation, ASCII checks of
new scripts/reports and Git whitespace checks passed. The reported
227 nonpassing compiler cells are intentional, unresolved findings,
**not failures of these host integration checks**.
