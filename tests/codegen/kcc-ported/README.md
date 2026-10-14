# Migrated KCC regressions — current test policy

This directory contains C fixtures moved from `misc/kcc-regression/` into
`COMPILER_MATRIX.tsv`. The matrix is the source of truth for enabled processor,
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
`tools/kcc_special_checks.py`; instruction-count and register-liveness
rules run through `tools/kcc_assembly_checks.py`.

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
`misc/kcc-regression/`. Examples include `terminal-return-chain`
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

## Five additional KCC migrations (October 2026)

`dimode-div-register-fast`, `dimode-mod-no-quotient`,
`adjbp-helper`, `preserved-blt`, and `cheap-optimizer-1-6` now
use matrix C fixtures and stateful assembly checks. The previous shell
scripts have been removed after preserving the substantive assertions.

The divider checks detect stack operations regardless of assembler mnemonic
case. This exposes KCC instruction-policy failures that the original
case-sensitive shell assertions missed. `preserved-blt` and
`cheap-optimizer-1-6` likewise remain failing regressions; the test
expectations were not relaxed. `adjbp-helper` passes on PDP-6.
All five sources are enabled for 16 native GCC compilation profiles,
including the 16 expected compilation failures for the KCC-specific
ADJBP type syntax. A compiler failure remains a failed matrix cell,
never an unsupported cell.

All new tests belong in `pdp10-testkit`; do not introduce inert test-spec
text files or fictional `COMPILER_MATRIX.tsv` entries for planned loader, linker
or object-format features. Remove legacy wrappers only after validation,
including applicable runtime tests, and update matrix and documentation
in the same commit. The historical migration log is available in Git.

## DImode code-generation migrations (October 2026)

Five KCC regression scripts were migrated as paired-compiler codegen
fixtures: `dimode-compare-registers`, `dimode-mul-no-snapshots`,
`dimode-negative-power2`, `dimode-signed-wide-power2`, and
`dimode-unsigned-wide-power2`. Their C sources are preserved; the
stateful instruction checks are in `tools/kcc_assembly_checks.py`.

The legacy shell scripts matched some opcodes case-sensitively even though
KCC emits both upper- and lowercase mnemonics. The migrated checkers handle
case consistently. Against the installed KCC this reveals **18 policy
failures and 2 passes** over four native CPUs, rather than five misleading
legacy-script successes. These are genuine failing matrix cells, not
unsupported configurations. The five programs compile on all 16 GCC
native optimization/CPU profiles, adding 80 compilation cells. GCC is not
subject to the KCC-specific instruction policy.
