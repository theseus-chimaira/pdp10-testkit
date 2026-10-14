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

```sh
./run-misc-tests.sh verify
./run-misc-tests.sh compat
./run-misc-tests.sh das-fast
./run-misc-tests.sh das
./run-misc-tests.sh das-native
./run-misc-tests.sh gcc-bare-libgcc
./run-misc-tests.sh pdp10-tools
./run-misc-tests.sh kcc-regression
./run-misc-tests.sh kcc-semantic
./run-misc-tests.sh clean
```

`SPECIAL_TESTS.tsv` registers individual compatibility tests, standalone
KCC regressions, and validation tests, together with DAS/tools entries.
The DAS and tools aggregators retain their original ordered execution and
build prerequisites; their individual registry entries are informational
until those suites are fully migrated to per-test execution.

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

## Why not replay `cell.log`?

The retired parallel-cell helper tried to replay shell commands
extracted from previous `cell.log` files.  That is brittle: the saved commands
may depend on the old checkout path, environment, or `PATH`.  If the toolchain
commands cannot be found, every cell can fail immediately with return code 127.

The compatibility wrapper has been removed. Runs should call `run-tests.sh -j N` directly.

## Negative compilation tests

The `tests/negative/` category contains imported invalid-source tests that
must be rejected by the selected compiler, rather than assembled or run.
Use `./run-tests.sh --kind negative --compiler kcc` or `--compiler gcc`.
Both compilers are scheduled on supported CPU/ISA profiles and optimization
settings. Successful compilation is a regression, as are a compiler ICE,
process signal, missing diagnostic output, and timeout. Ordinary diagnostic
failure is a passing result. Each case retains its own restart checkpoint.

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
