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

## Named test suites

```sh
./run-tests.sh verify
./run-tests.sh das-fast
./run-tests.sh das
./run-tests.sh das-native
./run-tests.sh gcc-bare-libgcc
./run-tests.sh pdp10-tools
./run-tests.sh kcc-regression
./run-tests.sh kcc-semantic
./run-tests.sh kcc-all
```

The entry point also supports `list`, `list-kcc`, `list-gcc`, `reset`,
`clean`, `test`, and `test-parallel`. The latter two are aliases for the
normal matrix runner, including `-j N`. The `all` alias runs `verify`. External DAS compilation still uses
DAS's own Makefile.

The ordered `group=compat` rows of `TEST_MATRIX.tsv` select all standalone
compatibility scripts executed by `verify`. Their machine/compiler columns are
`no_test` because each script independently selects its compilers, CPU, and
runtime checks; these are *not* ordinary compiler cells and are not run by the
parallel cell runner. The layout verifier rejects missing, duplicate, and
unregistered `tests/compat/test-*.sh` scripts. To add a compatibility test,
register its script in the matrix, rather than editing the suite dispatcher.

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
