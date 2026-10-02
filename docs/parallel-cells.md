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

## Makefile shortcut

```sh
make test JOBS=32
```

`make test-parallel JOBS=32` is an alias for the same command.

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

The old helper `tools/p10tk-parallel-cells.py` tried to replay shell commands
extracted from previous `cell.log` files.  That is brittle: the saved commands
may depend on the old checkout path, environment, or `PATH`.  If the toolchain
commands cannot be found, every cell can fail immediately with return code 127.

`tools/p10tk-parallel-cells.py` is now only a compatibility wrapper.  New runs
should call `run-tests.sh -j N` directly.
