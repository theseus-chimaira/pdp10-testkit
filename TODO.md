# PDP-10 testkit — outstanding work

Status: 2026-10-14. This is the central checklist for **open** testkit work.
The repository tests bare-metal CPU/toolchain behavior; DAIMOS/OS, peripheral,
and filesystem regressions belong in their respective testkits. Completed
imports are not repeated as tasks. Update this file as items are resolved.

Execution infrastructure progress and observed blockers are recorded in
`docs/TEST-EXECUTION-STATUS-20261014-v1.md`. The four KCC P0 parser
diagnostic regressions were fixed and validated on PDP-6; further compiler
and test coverage continues below.

## P0 — completed parser diagnostics

The two KCC ICEs (`init-2.c`, `init-3.c`) and two incorrectly accepted
invalid declarations (`920824-1.c`, `voidparam-1.c`) are fixed in KCC.
`misc/validation/test-kcc-p0-diagnostics-v1.sh` checks all four preserved
upstream negatives plus legal control declarations. This is a PDP-6 host
compiler check, not a full compiler/CPU/optimization sweep.

## P1 — complete upstream semantic test integration

- [ ] Review the 635 remaining `candidate` sources in `tests/semantic/upstream/` for
  PDP-10 integer/byte widths, supported C dialect, ABI, runtime requirements,
  duplicate coverage, and genuinely asserted results. Run useful candidates
  at least once before entering them in `COMPILER_MATRIX.tsv`; delete
  unsuitable or vacuous tests. Do not silently convert tests into unrelated
  semantics. PDP-6 KCC execution passed for `20000205-1.c` and
  `20000217-1.c`; both are now active, with other matrix cells unverified.
- [ ] Review the 27 remaining `review-width` cases individually for 36-bit
  `int`/`long`, 36/72-bit integer handling, 7-/9-bit byte conventions,
  shifts, numeric boundary assumptions, and `sizeof`. Establish the right
  PDP-10 expectation; then run/activate useful tests or delete inapplicable
  tests. Investigate `pdp10/pdp10/990106-2.c`, whose PDP-10 expectation failed
  under PDP-6 KCC. See `docs/SEMANTIC-WIDTH-VALIDATION-20261014-v2.md`.
- [ ] Review the 73 `review-extension` sources by feature (builtins,
  attributes, packing/alignment, local labels, setjmp, prefetch, stdio,
  complex types). Register only supported, meaningful KCC/GCC combinations;
  remove unsupported tests rather than masking failures. Do not assume GCC
  extensions are portable C99.
- [ ] Resolve the eight `deferred` sources (seven inline-assembly C tests and
  `support/920428-1.s`). Move suitable target-specific coverage to ISA/DAS
  test ownership with real assembler/link dependencies; delete inappropriate
  CPU or host-OS cases. The `.s` file requires KL10 and external symbols.
- [ ] Make existing GCC torture `abort()`/`exit()` assertions executable by a
  correctly designed bare-metal test harness, rather than treating missing
  `__test_exit` as a compiler/runtime failure. Preserve assertion semantics;
  avoid a generic stub that turns failure into success. Confirm the runner
  distinguishes compilation, linking, execution and actual test failure.
- [ ] Keep `docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261014-v2.tsv` and
  `COMPILER_MATRIX.tsv` synchronized with each per-test decision. Current
  manifest: 635 candidates, 73 extensions, 27 width reviews, eight deferred,
  four active, and 27 removed; **742 classified C sources remain inactive**.

## P1 — registry and runner consolidation

- [ ] Make `SPECIAL_TESTS.tsv` authoritative for DAS and tools execution.
  Currently `tools/run-misc-suites.py` retains hardcoded `DAS_FAST`, explicit
  DAS build/run lists, and a tools aggregate. Preserve prerequisite builds,
  ordering, per-test environment, timeouts, and error reporting when migrating
  individual registry rows. Do not remove the useful separate
  `run-misc-tests.sh` interface: these are not CPU/optimization cells.
- [ ] Audit the specialized suite registry for other hardcoded dispatch and
  misleading/informational entries; verify each enabled registration really
  executes in its advertised suite, and decide whether `kcc-all` should
  include host regressions as well as `kcc-regression`.
- [ ] Audit all registered tests for exactly-once ownership, duplicate source
  or redundant coverage, obsolete scripts, missing prerequisites, and correct
  statuses. Preserve intentional CPU/ISA-specific test variation.
- [ ] Audit `run-tests.sh` / `tools/run-tests.py` execution, resume, parallel
  result aggregation, statuses and negative-test crash detection. Maintain a
  single compiler matrix runner and a separate special-suite runner, without
  duplicating execution logic.
- [ ] Review support for upstream GCC diagnostic directives (`dg-error`,
  expected warnings, target constraints) and decide which cases are worth
  importing as explicitly negative/diagnostic tests. Do not misclassify
  diagnostic tests as codegen tests. See `docs/parallel-cells.md`.

## P2 — execution coverage and regression verification

- [ ] Execute representative tests from every special suite, including the
  newly added `kcc-host` scripts, with their actual KCC, make/bmake, DAS and
  installed-toolchain prerequisites; record actionable failures.
- [ ] Sweep the 37 negative tests across supported KCC/GCC CPU and
  optimization combinations; compare to the PDP-6 KCC pilot, and resolve
  compiler ICEs first. Do not infer results from a `--list-only` check.
- [ ] Complete codegen compilation sweeps for the 706 consolidated upstream
  GCC tests and the other codegen groups. Previously only focused KCC PDP-6
  samples were run; in particular, GCC and cross-CPU/optimization coverage
  remains unverified. Review any imported tests that depend on unsupported
  GCC-only constructs or compiler options.
- [ ] Run the full semantic/ISA matrix across applicable PDP-6, KA10, KI10,
  KS10, KCC/GCC and optimization profiles; check 71-bit variants where
  supported. The two newly enabled width regressions were validated on
  PDP-6 only (KCC unoptimized/optimized, GCC `-O0`).
- [x] Resolve unlisted upstream GCC differential-helper inventory entries.
  Seven imported sources were classified in `OPTIMIZATION_RESULT_ONLY.tsv`,
  and the strict common-source verifier now passes (86 entries).
- [ ] Review differential KCC/GCC ABI coverage, including the documented
  non-symmetric GCC-to-KCC wide-varargs direction; only add the reciprocal
  case if it provides a meaningful additional assertion.
- [ ] Verify failure classifications (compiler ICE versus ordinary rejection,
  unsupported profile versus real failure, link failure versus test failure)
  and ensure test outcome summaries are reproducible.

## P2 — documentation and repository hygiene

- [ ] Update `README.md` and older audit documents that still describe active
  upstream semantic sources as living in `tests/todo/`. The classified but
  mostly inactive collection is now `tests/semantic/upstream/`.
- [ ] Check all docs, path references, suite names, matrix group labels and
  source manifests after the upstream GCC codegen directory merge into
  `tests/codegen/upstream-gcc/`.
- [ ] Determine whether the empty `tests/todo/codegen` and
  `tests/todo/negative` placeholders are still needed; remove obsolete empty
  directories when safe.
- [ ] Keep testkit-specific instructions near the tests; only update
  completed cross-project toolchain/ABI documentation in `pdp10-doc`.
- [ ] After the major review, rerun registry-source validation, shell/Python
  syntax checks, representative executions, and `git diff --check`; commit
  and push each logically complete change.

## Current baseline (not a completion claim)

- `COMPILER_MATRIX.tsv`: 1,534 source rows; verified source paths present.
- `SPECIAL_TESTS.tsv`: 91 entries; source/script paths present, but not every
  special row is yet independently dispatched.
- `tests/codegen/upstream-gcc/`: 706 registered C sources.
- `tests/semantic/upstream/`: 746 C sources plus one assembly support file;
  two C sources enabled; the remainder need review or harness integration.
- Main entry points: `run-tests.sh` (compiler/CPU/optimization cells) and
  `run-misc-tests.sh` (specialized suites).

**Acceptance criteria:** every retained source is owned by a documented
matrix or special-suite test, or is explicitly marked deferred with a reason;
all active tests meaningfully assert their intended behavior; invalid tests
are rejected without compiler crashes; supported execution profiles have
recorded results; and registry entries agree with actual runner dispatch.
