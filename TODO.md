# PDP-10 testkit — outstanding work

Status: 2026-10-14. This is the central checklist for **open** testkit work.
The repository tests bare-metal CPU/toolchain behavior; DAIMOS/OS, peripheral,
and filesystem regressions belong in their respective testkits. Completed
imports are not repeated as tasks. Update this file as items are resolved.

**Mandatory classification rule:** preserve and minimally adapt upstream tests
to PDP-10 byte/integer widths whenever the original regression still applies.
For each change, derive and document the target expectation independently;
retain the asserted operation and failure path. Do not delete a test solely
because it assumes 8/16/32/64-bit storage; prefer justified 9/18/36/72-bit
adaptations. Never rewrite expected values simply to make a test pass, or
activate a test without actual execution. Delete only tests whose intended
behavior genuinely cannot be tested on the target or that remain vacuous.

**Current classification scope:** decide only whether each retained source
can be a meaningful matrix test unchanged or with small, obvious PDP-10
adaptations. Record straightforward compile/execute outcomes, but do not
investigate non-obvious test bugs, ordinary compiler miscompilations, or
complex runtime failures in this phase. Defer such cases with their observed
failure and reason; do not disguise a failure as a pass. Compiler internal
errors (ICEs) are the sole immediate compiler-debugging exception and take
priority. Resume deeper debugging after classification is complete.

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

- [x] Initial review of all `candidate` sources in `tests/semantic/upstream/` completed. Reviewed for
  PDP-10 integer/byte widths, supported C dialect, ABI, runtime requirements,
  duplicate coverage, and genuinely asserted results. Run useful candidates
  at least once before entering them in `COMPILER_MATRIX.tsv`; delete
  unsuitable or vacuous tests. Do not silently convert tests into unrelated
  semantics. PDP-6 KCC execution passed for `20000205-1.c` and
  `20000217-1.c`; both are now active, with other matrix cells unverified.
  The next eight manifest candidates have been reviewed in
  `docs/SEMANTIC-IMPORT-BATCH-20261014-v1.md`; five more are now active,
  including the DAIMOS `strchr` test. The subsequent batch of eight is recorded
  in `docs/SEMANTIC-IMPORT-BATCH-20261014-v2.md`; six more are active.
  The third batch of eight is in `docs/SEMANTIC-IMPORT-BATCH-20261014-v3.md`;
  six more active, one deferred, and one removed. The fourth batch is
  documented in `docs/SEMANTIC-IMPORT-BATCH-20261014-v4.md`; six more
  active and two deferred. The fifth eight-test batch is documented in
  `docs/SEMANTIC-IMPORT-BATCH-20261014-v5.md`; all eight are active.
  Eight further batches (64 sources) are documented in
  `docs/SEMANTIC-IMPORT-BATCHES-20261014-v6.md`: 45 activated, three
  vacuous cases removed, and 16 retained for review. The following eight
  batches are in `docs/SEMANTIC-IMPORT-BATCHES-20261014-v7.md`: 44 active,
  six removed, 14 retained for review. Another eight batches are documented
  in `docs/SEMANTIC-IMPORT-BATCHES-20261014-v8.md`: 32 activated,
  seven removed, and 25 retained for review. The next eight batches are
  documented in `docs/SEMANTIC-IMPORT-BATCHES-20261014-v9.md`: 48
  activated, two removed, and 14 deferred or under review. The latest
  eight batches are in `docs/SEMANTIC-IMPORT-BATCHES-20261014-v10.md`:
  48 activated, one removed, 15 retained for review.
- [ ] Review the 24 remaining `review-width` cases individually for 36-bit
  `int`/`long`, 36/72-bit integer handling, 7-/9-bit byte conventions,
  shifts, numeric boundary assumptions, and `sizeof`. The byte-source case
  `20000227-1.c` and the oversized-shift case `20000403-1.c` are in
  `tests/todo/generic/`. Establish the right
  PDP-10 expectation; then run/activate useful tests or delete inapplicable
  tests. Investigate `pdp10/pdp10/990106-2.c`, whose PDP-10 expectation failed
  under PDP-6 KCC. See `docs/SEMANTIC-WIDTH-VALIDATION-20261014-v2.md`.
- [ ] Review the 129 `review-extension` sources by feature (builtins,
  attributes, packing/alignment, local labels, setjmp, prefetch, stdio,
  complex types). Register only supported, meaningful KCC/GCC combinations;
  remove unsupported tests rather than masking failures. Do not assume GCC
  extensions are portable C99.
- [ ] Resolve the 111 `deferred` sources (seven inline-assembly C tests,
  `support/920428-1.s`, void-return case `20000314-3.c`, and varargs
  `20000519-1.c` with a KCC `include_next` preprocessor ICE, plus
  `20000603-1.c` (incompatible pointer aliasing) and `20000622-1.c`
  (runtime failure)). Additional compiler/runtime blockers are listed
  in `docs/SEMANTIC-IMPORT-BATCHES-20261014-v6.md`.
  Move suitable target-specific coverage to ISA/DAS
  test ownership with real assembler/link dependencies; delete inappropriate
  CPU or host-OS cases. The `.s` file requires KL10 and external symbols.
- [ ] Make existing GCC torture `abort()`/`exit()` assertions executable by a
  correctly designed bare-metal test harness, rather than treating missing
  `__test_exit` as a compiler/runtime failure. Preserve assertion semantics;
  avoid a generic stub that turns failure into success. Confirm the runner
  distinguishes compilation, linking, execution and actual test failure.
  Eight additional PDP-10-specific candidate batches are recorded in
  `docs/SEMANTIC-IMPORT-BATCHES-20261014-v11.md`: 31 activated,
  one vacuous test removed, and 32 retained for review.
  The following 64 candidates are documented in
  `docs/SEMANTIC-IMPORT-BATCHES-20261014-v12.md`: 15 activated,
  two vacuous tests removed, and 47 retained for review.
  The final 18 candidates are documented in
  `docs/SEMANTIC-IMPORT-FINAL-20261014-v13.md`: one activated,
  17 deferred or under extension review.
- [ ] Keep `docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261014-v2.tsv` and
  `COMPILER_MATRIX.tsv` synchronized with each per-test decision. Current
  manifest: zero candidates, 129 extensions, 24 width reviews, 137 deferred,
  429 active, and 55 removed; **290 classified C sources remain inactive**.
  Eight width cases were dispositioned in
  `docs/SEMANTIC-WIDTH-BATCH-20261014-v4.md`; two were activated and six
  deferred for later work under the classification-only policy.
  The next eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v5.md`:
  one activated, seven deferred without non-ICE debugging.
  The third eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v6.md`:
  two activated and six deferred.
  The fourth eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v7.md`:
  one activated and seven deferred.

The next eight batches are documented in
  `docs/SEMANTIC-IMPORT-BATCHES-20261014-v11.md`: 42 activated, three
  vacuous tests removed, and 19 retained for later investigation.

The next eight batches are documented in
  `docs/SEMANTIC-IMPORT-BATCHES-20261014-v12.md`: 37 activated, one
  vacuous test removed, and 26 retained for review.

- [ ] Finish KCC target header integration: host KCC now implements
  `#include_next` and its install target packages headers under
  `$PDP10_PREFIX/lib/kcc/include` when installed with that PREFIX.
  The testkit honors `KCC_INCLUDE_DIR`, including for preprocessing tests.
  **Still open:** deploy the updated compiler/headers to the operational
  prefix, validate the actual varargs ABI and libc linkage, and re-run
  remaining deferred semantic tests before activation. A staged KCC
  compiler/header retest has activated 44 cases; 27 header-dependent
  sources still fail compilation and 25 others still fail linking or
  execution. See `docs/KCC-HEADER-SEMANTIC-RETEST-20261014-v3.md` and
  `docs/KCC-INCLUDE-NEXT-IMPLEMENTATION-20261014-v2.md`.

- [ ] Benchmark the BLT cutoff (currently four complete words) using
  calibrated PDP-6 timings and compare against short MOVE/MOVEM/byte paths.
  Verified aligned BLT copy/fill in `docs/P10-FREESTANDING-BLT-20261014-v3.md`;
  production archive extraction and other CPU profiles remain open.

- [ ] Complete production validation of the shared freestanding PDP-10 libc.
  KCC and GCC now stage identical `libp10c-v2.a` archives and pass the
  PDP-6 memory/string and explicit 6/7/8/9/18/36-bit byte-pointer tests.
  Deploy to the operational prefix, verify archive extraction with the
  production linker, benchmark whole-word paths against byte loops, and
  investigate remaining hosted I/O/allocation/varargs dependencies. See
  `docs/P10-FREESTANDING-LIBC-20261014-v2.md`.

## P1 — immediately after semantic classifications: libc ASM optimization verification

- [ ] As soon as the 111 deferred, 129 extension-review, and 56 width-review
  classifications are resolved, prioritize the DAIMOS libc assembly candidates
  recorded in `DAIMOS/TODO.MD`; do not interrupt classification work.
- [ ] Evaluate `qsort` first. Establish a correctness baseline with generic
  comparator and varying element sizes; compare current C and prospective
  assembly implementations for PDP-6 execution steps/time, executable words,
  and worst-case auxiliary RAM/stack. Prefer bounded-memory algorithms over
  straight translation. Store regression/benchmark programs in this testkit;
  implement production changes in DAIMOS, not in the testkit.
- [ ] Next benchmark `strcpy`, `strncpy`, `strcat`, `strncat`, `strchr`, and
  `strrchr`, including empty/short/long strings, alignment, byte-pointer
  boundaries, and length limits. Adopt assembly only with measured benefit
  and passing KCC/GCC-compatible semantic tests.
- [ ] Retain `strcspn`, `strtok`, `atoi`, `abs`, `calloc`, `brk`, `sbrk`,
  `stat`, `time`, `exit`, and heap allocation in C unless profiling shows a
  worthwhile improvement. Keep existing freestanding libc tests passing,
  including `memcpy`, `memmove`, `memset`, `memcmp`, `strlen`, `strcmp`, and
  `strncmp`. Do not modify compilers during semantic classification.

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
