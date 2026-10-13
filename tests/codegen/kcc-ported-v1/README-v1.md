# Migrated KCC regressions — current test policy (v1)

This directory contains C fixtures moved from `tests/kcc-regression/` into
`TEST_MATRIX.tsv`. The matrix is the source of truth for enabled processor,
compiler, optimization and test-kind combinations. The original scripts are
removed only after their substantive compile, instruction, diagnostic and
runtime checks are represented by matrix fixtures or the runner's explicit
special-check modules.

## Executing the tests

```sh
PDP10_PREFIX=/usr/local ./run-tests.sh -j 6
PDP10_PREFIX=/usr/local ./run-tests.sh list-kcc
PDP10_PREFIX=/usr/local ./run-tests.sh list-gcc
```

`codegen` cells check generated assembly, preprocessor output or explicit
compiler diagnostics; `semantic` cells compile and execute programs with
`p10run`. Some original scripts require separate `codegen` and `semantic`
fixtures. The special KCC invocation tests run through
`tools/kcc_special_checks_v1.py`; instruction-count and register-liveness
rules run through `tools/kcc_assembly_checks_v1.py`.

## Compiler-specific and shared checks

- `codegen-require-regex` / `codegen-forbid-regex` express assembly or
  preprocessor constraints. `codegen-kcc-policy-only` suppresses KCC-specific
  regex assertions when the same C source runs under GCC.
- `codegen-kcc-check` invokes a stateful KCC assembly checker, with the CPU
  profile supplied when a target-specific instruction sequence is required.
- `codegen-kcc-extra` selects required KCC options such as `-m=gas`, `-O`,
  or `-Pgnu99`. `codegen-kcc-preprocess` selects preprocessing tests.
- `codegen-expect-compile-fail` requires rejection on either compiler.
  Compiler-specific diagnostic requirements remain separate so a correct
  rejection does not require identical wording on GCC and KCC.
- `codegen-kcc-special` runs multi-invocation tests for target selection,
  compiler output paths, or KL10-specific code generation.

**A failed compile, incorrect execution or incorrect acceptance of invalid
source is a failed cell, not an unsupported cell.** Keep such GCC and KCC
matrix cells enabled. `no_test` denotes a test not assigned to that profile;
`unsupported` must not be used to conceal known compiler failures.

## Known remaining regressions

Legacy wrappers with unsatisfied original assertions remain under
`tests/kcc-regression/`. Examples include `terminal-return-chain`
(the compiler currently omits the temporary AC1 copy demanded by the test),
`runtime-helper-fragments` (the installed assembler rejects that script's
command-line invocation), and `cheap-optimizer-1-6` (the emitted SETZB
register disagrees with the required register). Their checks must not be
weakened merely to retire shell scripts.

The GCC compiler also currently fails compilation of the SUBBP
index-arithmetic source using KCC exact-width types. The associated GCC
cells remain active and report this failure. KCC and GCC need not emit
identical register allocations or assembly patterns, but each compiler must
meet its applicable correctness and execution expectations.

## Maintenance

All new tests belong in `pdp10-testkit`; do not introduce inert test-spec
text files or fictional `TEST_MATRIX.tsv` entries for planned loader, linker
or object-format features. Remove legacy wrappers only after validation,
including applicable runtime tests, and update matrix and documentation
in the same commit. The historical migration log is available in Git.
