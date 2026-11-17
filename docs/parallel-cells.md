# Parallel test runs

`run-tests.sh` supports native parallel execution with `-j` / `--jobs`.
Use this path instead of replaying old `cell.log` commands.

## Full matrix

```sh
./run-tests.sh -j 32 --compiler all --family all --cpu all --opt all
```

The default remains sequential:

```sh
./run-tests.sh
```

Equivalent environment variable:

```sh
P10_SWEEP_JOBS=32 ./run-tests.sh --compiler all --family all --cpu all --opt all
```

## Focused examples

Rerun only GCC `-Os` cells:

```sh
./run-tests.sh -j 32 --compiler gcc --family all --cpu all --opt os
```

Rerun only GCC base PDP-6 codegen cells:

```sh
./run-tests.sh -j 32 --compiler gcc --family base --cpu pdp6 --opt os --kind codegen
```

Rerun only semantic/runtime-like cells selected by the matrix:

```sh
./run-tests.sh -j 32 --kind semantic
```

Skip known failures as well as already-green cells:

```sh
./run-tests.sh -j 32 --skip-failures
```

## Specialized test suites

`run-tests.sh` runs only traditional compiler/CPU/optimization cells from
`COMPILER_MATRIX.tsv`. Standalone compiler ABI, assembler, and tools tests
live under `misc/` and are dispatched by `run-misc-tests.sh`:

KCC negative compiler cells and the standalone KCC expected-rejection
regressions now share one fail-closed diagnostic policy. A nonzero compiler
exit is not sufficient: a real KCC source error or its documented
maximum-error limit must be present, and internal errors, timeouts and
signals remain failures. All 814 KCC negative cells were executed and
passed. GCC 3.2 negative compiler cells now also require a diagnosed,
source-located error; warnings, setup errors, ICEs and abnormal exits
cannot pass. A focused real GCC and host test audit is recorded in
`docs/GCC-NEGATIVE-RUNNER-ACCOUNTING-20261117-v1.md`. The broader GCC
negative sweep and exact upstream diagnostic-pattern assertions remain
separate work. See `docs/KCC-NEGATIVE-REJECTION-AUDIT-20261116-v1.md`.

```sh
./run-misc-tests.sh verify
./run-misc-tests.sh compat
./run-misc-tests.sh das-fast
./run-misc-tests.sh das
./run-misc-tests.sh das-native
./run-misc-tests.sh gcc-bare-libgcc
./run-misc-tests.sh pdp10-tools
./run-misc-tests.sh kcc-regression
./run-misc-tests.sh kcc-host
./run-misc-tests.sh kcc-semantic
./run-misc-tests.sh clean
```

`SPECIAL_TESTS.tsv` registers individual compatibility tests, standalone
KCC regressions, 17 host-side KCC source/build regressions, and validation
tests, together with DAS/tools entries. The `kcc-host` suite runs scripts
under `misc/kcc-host/`; set `KCC_REPO` to the KCC source checkout (defaults
used by some scripts to `$HOME/git/kcc`). Individual scripts may also need
`BMAKE`, `MAKESYSPATH`, or a host C compiler. These are not CPU/ISA/optimization
matrix cells.
The DAS dispatcher reads ordered, independently timed `fast`, `full`, and
`native` entries directly from `SPECIAL_TESTS.tsv`. `das` runs all eight
`fast` entries before the two `full` entries; `das-native` runs the native
phase-build entry. Entries marked `nested` belong to their parent scripts
and are not repeated. The manual native chain probe is registered but not
part of the default suite. Native execution remains subject to its genuine
code-size and guest-execution gates.

The independent `pdp10-tools` suite now has twelve individually registered
test entries in `SPECIAL_TESTS.tsv`: DOBJ/DARC, objdump, p10fold/dlink,
p10super CFG, p10super rewrites, p10run/KA10, CSIX, media encoders, and
install/uninstall cleanup, plus three UTF-9 interchange checks formerly
invoked only by the independent Makefile's optional `check-utf9` target.
The dispatcher snapshots and builds the source
**once** before running the registered entries, each with an independent timeout
and PASS/FAIL result. The same source revision and artifacts are used by
every test, with guaranteed cleanup on test or setup failure. See
`docs/PDP10-TOOLS-REGISTRY-20261116-v2.md` and the media-format contract
in `docs/PDP10-TOOLS-MEDIA-ENCODERS-20261116-v1.md`.
Five original standalone PDP-6 KCC regression runners are also now
registered under `kcc-regression`, separately from their compiler-matrix
wrappers. The static ledger `docs/TEST-SCRIPT-OWNERSHIP-20261116-v4.tsv`
records every currently discovered shell/Python script's owner; the
`verify` suite has a fail-closed static ownership audit. These are
integration changes only: the newly registered cases have **not yet
been executed**, pending the remaining disconnected-source audit.

Three distinct historical GCC target shell checks now have `validation`
registrations selecting preserved reference scripts. The fourth GCC
shell probe is intentionally deduplicated against the stronger existing
BADL runtime/link test. A legacy assembler smoke test now has a DAS
`fast` registration using binary DXR, not the removed `--start`/deposit
interface. See `docs/GCC-TARGET-SHELL-OWNERSHIP-20261116-v3.md`.

`pdp10-tools` selects the **independent** `../pdp10-tools` checkout by
default (override with `PDP10_TOOLS_REPO`). It rejects uncommitted source
edits, prints the selected Git revision, and builds an isolated archive of
that revision. This avoids accidentally exercising DAIMOS's distinct host
tools or reusing prebuilt executables. The generic tool regression and
installation probes operate on the same isolated revision.

The compiler runner retains `list`, `list-kcc`, `list-gcc`, `reset`, `test`,
`test-parallel`, parallelism (`-j N`), and restart checkpoints.

## Restart behavior

The runner is still restartable.  Every test cell owns its own directory under:

```text
workdir/full-sweep-current/cells/
```

Each worker writes only its own cell directory.  The final summary files are
written after all workers finish.

Existing `pass` and `compile_only` cells are skipped by default.  Existing
failures are retried unless `--skip-failures` is given.
Missing, `running`, and unknown checkpoints are always retried, even
with `--skip-failures`. Every nonpassing selected cell appears in
`failures.tsv` and the final failure count. Worker exceptions in
sequential and parallel execution persist a `setup_fail` checkpoint
and an explanatory `WORKER_EXCEPTION` log.
Semantic cell failures now distinguish `link_fail` (p10run reports
`p10run: link failed`) from `run_fail` (actual guest assertion or
termination failure). Both remain failures and are retried normally.
An isolated KCC PDP-6 test exposed this issue, and the existing
runner-accounting host verifier now checks both classifications.
See `docs/REGISTERED-TEST-PREFLIGHT-20261117-v1.md`.

Native GCC 3.2 can return exit 1 with a source-located *internal compiler
error*, not just an ordinary syntax rejection. The semantic and codegen
runner now checks the emitted diagnostic against the existing `ICE_RE`
and records `compiler_ice`, even for exit 1. Codegen test suites do not
silently treat these cases as passing compile-only cells. See
`docs/PDP10-INITIAL-REGRESSION-SWEEPS-20261117-v1.md`.

KCC has a historical 169-character filename limit. The runner compiles
synthetic preprocessor `input.c` from the private per-cell directory,
and normal KCC source files using a short `-R=unit` output basename
in the same directory. It then atomically renames `unit.s` to the
expected stable per-cell assembler filename. KCC receives its input
source directory and installed support includes explicitly, without
relying on the launch CWD. This preserves unique parallel checkpoints
even with deeply nested `--out-dir` values. GCC uses separate
`codegen-gcc-extra` source-specific include options where necessary.

The codegen source directive parser recognizes both one-line `/* */`
and directive lines inside multiline C comments. This preserves two
historical GCC `scan-assembler` assertions that the prior parser
silently ignored. The matrix runner also checks all declared operand-
form, helper-symbol and compiler target-macro assertions. Macro
checking uses a private per-cell preprocessor probe under the
**selected** KCC/GCC target options, with distinct policy, ICE,
timeout and setup-failure statuses. The registered host
`test-codegen-declared-oracles-v1.py` audits all registered codegen
declarations and their runner dispatch. See
`docs/PDP10-CODEGEN-DECLARED-ORACLES-20261117-v1.md`.

## Why not replay `cell.log`?

The retired parallel-cell helper tried to replay shell commands
extracted from previous `cell.log` files.  That is brittle: the saved commands
may depend on the old checkout path, environment, or `PATH`.  If the toolchain
commands cannot be found, every cell can fail immediately with return code 127.

The compatibility wrapper has been removed. Runs should call `run-tests.sh -j N` directly.

## Original GCC/KCC diagnostic oracles

`--kind diagnostic` uses the **same matrix runner**, per-cell restart
checkpoints, parallel worker accounting, source ownership and failure
reports as `semantic`, `negative` and `codegen`. The source-specific
`DIAGNOSTIC_ORACLES_V1.tsv` registry pins the original file hash and
declares per-compiler expected success/rejection, original option
string, source line, severity, required regexp and count.

Unlike `--kind negative`, ordinary rejection alone cannot pass a
diagnostic cell. Exact source-located messages must satisfy the
declared original GCC requirement or an independently reviewed KCC
equivalent. Warnings on wrong lines or from unrelated source files,
launcher errors, ICEs and timeouts cannot satisfy the oracle.

Use `--kind diagnostic --list-only` to inspect the tiny initial set.
The registered `test-diagnostic-oracles-v1.py` host verifier checks
source identity and fake/mutated diagnostic output before any larger
suite is attempted. See
`docs/PDP10-DIAGNOSTIC-KCC-INTEGRATION-20261117-v1.md`.

## Negative compilation tests

The `tests/negative/` category contains imported invalid-source tests that
must be rejected by the selected compiler, rather than assembled or run.
Use `./run-tests.sh --kind negative --compiler kcc` or `--compiler gcc`.
Both compilers are scheduled on supported CPU/ISA profiles and optimization
settings. Successful compilation is a regression, as are a compiler ICE,
process signal, missing diagnostic output, and timeout. Ordinary diagnostic
failure passes only after the compiler-specific rejection policy
confirms a source error. GCC 3.2 often omits modern `error:` prefixes,
so its policy recognizes source-file/line errors while rejecting
warning-only messages, compiler crashes and driver/setup errors.
Launcher exits 125-127 are `setup_fail`, not source rejection. Each
case retains its own restart checkpoint.

The original GCC `dg-error` annotations are preserved but not yet interpreted
as diagnostic-pattern assertions for KCC: the initial contract is rejection
without an ICE. A KCC acceptance must be reviewed, not silently classified as
unsupported; compiler-specific exclusions need an explicit matrix decision.

### Initial KCC PDP-6 check (2026-10-14)

All 37 imported negatives were exercised with unoptimized KCC targeting
PDP-6 through the restartable runner: 33 rejected as expected, 2 wrongly
accepted (`920824-1.c`, `voidparam-1.c`), and 2 generated KCC internal
errors (`init-2.c`: `pushsztype: bad top type 13`; `init-3.c`:
`vlabindtype_v11: missing metadata`). All four remain failing cells; no
unsupported marker or compiler workaround was introduced. Full GCC and
multi-target optimization sweeps are still pending.
