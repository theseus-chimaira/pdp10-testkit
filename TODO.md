# PDP-10 testkit — outstanding work

Status: 2026-10-15. This is the central checklist for **open** testkit work.
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
- [x] Complete the `review-width` suitability classifications for 36-bit
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
  manifest: zero candidates, zero extensions, zero width reviews, 276 deferred,
  442 active, 1 nonportable stress, and 55 removed; **277 classified C sources
  remain outside mandatory active coverage**.
  First deferred-batch follow-up activated three GCC-PDP-6 validated tests;
  see `docs/SEMANTIC-DEFERRED-BATCH-20261014-v2.md` for the remaining
  policy questions and actual implementation work still required.
  Apply the explicit feature decisions in
  `docs/KCC-EXTENSION-SUPPORT-POLICY-20261014-v1.md` when reviewing extension
  cases. Do not interpret unsupported GNU features as required KCC work.
  Eight width cases were dispositioned in
  `docs/SEMANTIC-WIDTH-BATCH-20261014-v4.md`; two were activated and six
  deferred for later work under the classification-only policy.
  The next eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v5.md`:
  one activated, seven deferred without non-ICE debugging.
  The third eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v6.md`:
  two activated and six deferred.
  The fourth eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v7.md`:
  one activated and seven deferred.
  The fifth eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v8.md`:
  one activated and seven deferred.
  The sixth eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v9.md`:
  two activated, five deferred, one reclassified for extension review.
  The seventh and final eight are in `docs/SEMANTIC-WIDTH-BATCH-20261014-v10.md`:
  all eight deferred for later work. Width suitability classification is
  complete; deferred test execution and correction are separate tasks.
  The first extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v1.md`:
  eight classified, all deferred; optimizer-disabled paths are not passes.
  The second extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v2.md`:
  eight classified, all deferred; library linkage and vacuous guards recorded.
  The third extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v3.md`:
  eight classified, all deferred; the `CHAR_BIT=9` shift-test pass is vacuous.
  The fourth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v4.md`:
  eight classified, all deferred; GNU labels/nested functions and built-ins.
  The sixth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v6.md`:
  two activated and six deferred; KCC/GCC PDP-6 execution checked.
  The fifth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v5.md`:
  eight classified, all deferred; packed attributes pass without assertions.
  The seventh extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v7.md`:
  eight classified, all deferred; bitfield extensions and built-ins.
  The eighth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v8.md`:
  eight classified, all deferred; complex and compiler-only built-ins.
  The ninth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v9.md`:
  eight classified, all deferred; computed goto, complex arithmetic and GNU initializers.
  The tenth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v10.md`:
  one activated, seven deferred; nested functions intentionally unsupported by KCC.
  The eleventh extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v11.md`:
  one activated, seven deferred; PDP-10 copies and policy decisions recorded.
  The twelfth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v12.md`:
  eight classified, all deferred under KCC extension and libc-linkage policy.
  The thirteenth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v13.md`:
  one activated, seven deferred; pointer arithmetic passes and libc linking remains separate.
  The fourteenth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v14.md`:
  one activated, seven deferred; meaningful packed-field checks distinguished from vacuous stores.
  The fifteenth extension bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v15.md`:
  nine classified, all deferred; shared string-libc linkage remains separate from built-ins.
  The final ninth-case bundle is in `docs/SEMANTIC-EXTENSION-BATCH-20261014-v16.md`:
  one activated and eight deferred; all extension reviews are now classified.

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
  Deferred-test rule: when a test has an unresolved ordinary libc routine,
  integrate the installed assembler libc into the test link and rerun before
  classifying it as a compiler problem or removing it. A direct PDP-6/GCC
  retest of `generic/string-opt-13.c` with installed `strcpy`/`strlen`
  assembler sources passes; see `docs/P10-FREESTANDING-LIBC-20261014-v3.md`.
  This is a link-integration rule, not an assembly-only implementation rule:
  shared libc functions may be written in C or assembly; select assembly
  only when measured code-size/RAM or execution-speed benefits justify it.
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
- [ ] **After GCC/shared-libc completion:** evaluate assembler-backed
  "poor man's built-ins" for KCC and GCC. Factor suitable optimized libc
  routines into one authoritative assembler body with a callable wrapper and
  optional small inline fragments; explicitly specify register inputs,
  clobbers, labels, alignment, byte-pointer semantics, and ABI constraints.
  Prefer the shared callable libc implementation by default. Only inline
  zero-work eliminations or small, known-size operations where measurements
  show lower RAM/code footprint or execution cost, without duplicating
  algorithms in either compiler. Benchmark against calls on PDP-6 and test
  both compilers. This is post-classification work, not a prerequisite for
  activating imported extension tests.

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

## P1 — PDP-6 AAP logical-tick optimization coverage (next chat)

**Decision:** optimize against `pdp6-aap` logical pulse-delay ticks, not
unverified historical microseconds. Physical-time calibration is optional
research, **not** a prerequisite. Keep SIMH exact opcode dispatch counts
independently; never apply invented hardware timing weights.

**Completed and pushed through `5396c8f`:** the AAP logical clock and
optional `IT0`/`ET0A` traces; APR device-layout regression fix; live guest
tests for `MOVEI`, `ADDI`, halting `JRST`, direct/indirect `JRST` and
`XCT` executing `MOVEI`; strict instruction-start-to-next-start interval
extraction; nested `XCT` opcode attribution; JSON profiles and matched
workload/model tick-cost comparison. Relevant details:
`docs/PDP6-AAP-LOGICAL-TICK-OPTIMIZATION-20261015-v1.md` and
`docs/PDP6-AAP-TIMING-STAGE1-MILESTONES-20261015-v1.md`.

- [x] Validate initial conditional branches and loop termination: real AAP guest
  cases cover taken `JUMPE`, untaken `JUMPN`, taken `SKIPE`, repeated
  `AOBJN` with termination, and taken `AOBJP`. Assert executed PCs,
  opcodes and monotonic complete tick intervals. See
  `misc/compat/test-aap-branches-v2.sh`. Broader branch predicates,
  negative skip paths and independent guest-state checks remain open.
- [x] Validate initial direct, indexed, single-level indirect, multilevel
  indirect and indexed-indirect core-memory accesses using real AAP guest
  tests, final memory results and complete tick intervals. See
  `misc/compat/test-aap-addressing-v1.sh`.
- [x] Compare AC-reference, core-reference, indexed, and two-level indirect
  MOVE guests with 16K `cmem161C` and 256K `moby` core plus the same
  fast-memory configuration. Eight guests pass result and timing checks;
  see `misc/compat/test-aap-memory-paths-v1.sh`.
- [x] Add core-bank mapping checks with two separate 16K modules, including
  a guest load from address 040010 in bank 1 and an independent result check;
  see `misc/compat/test-aap-memory-map-v1.sh`.
- [x] Correct absent-fast-memory dispatch in the AAP emulator (`pdp6`
  `44f3dc1`), and validate eight no-fast-memory guest cases with 16K and
  256K core. The regression is `misc/compat/test-aap-memory-no-fast-v1.sh`.
- [ ] Expand memory path tests to altered fast-memory attachment or mapping
  and exceptional/unmapped memory behavior; do not infer universal physical timing.
- [x] Extend `SKIPE` and `AOBJP` fixtures to both outcomes, and validate
  AOBJN loops with one, two, and four increments. The v3 suite checks
  final 36-bit guest memory results independently of timing traces.
- [ ] Cover remaining JUMP/SKIP predicates and additional AOBJN/AOBJP
  boundaries, including overflow and deliberately incorrect guest states.
- [ ] Validate repeated loops, variable trip counts, and branch-heavy
  control flow; ensure the final instruction and startup/stop overhead do
  not contaminate complete-interval comparisons.
- [x] Validate real nested `XCT`, `XCT` of `MOVE`, and `XCT` of a taken
  `JRST` with single-outer-interval attribution, nested opcode chains,
  correct PCs and independent guest memory results. Reject unfinished
  and PC-mismatched nesting in extractor unit tests. See
  `misc/compat/test-aap-xct-v2.sh`.
- [ ] Extend `XCT` to unusual/failing targets, interrupt boundaries and
  exceptional execution without assigning ambiguous interval costs.
- [x] Add the first 10-case synthetic exceptional-trace batch: reject
  missing, orphaned, ambiguous, nonprogressing, and malformed AAP
  milestones. This validates the extractor, not real guest exceptions;
  see `misc/compat/test-aap-exception-traces-v1.py`.
- [ ] Audit exceptional execution: interrupts, PI cycles, indirect/index
  faults, I/O and overlapping or aborted instructions. Add explicit
  exclusions and tests rather than silently assigning bogus tick costs.
- [ ] Build broader PDP-6 opcode fixtures, prioritizing frequent instructions
  in observed SIMH profiles (e.g. `AOBJN`, `JRST`, `ADDI`, `ADDM`), then
  arithmetic, logic, shifts, memory transfers, stack, and control flow.
  Record operand/addressing dependence; do not claim one constant cost per
  opcode when the model varies.
- [ ] Verify instrumentation transparency and reproducibility: same guest
  result with tracing on/off, repeated identical tick intervals, no
  unbounded instrumentation RAM use, counter overflow/reset behavior.
- [ ] Expand the versioned cost schema with provenance, emulator revision,
  complete memory configuration, workload correctness evidence and measured
  coverage. Only compare equivalent passing workloads and matched models;
  reject incomplete or incompatible cost summaries.
- [ ] Integrate AAP tick-cost profiles and matched baseline/candidate
  comparisons with testkit matrix reporting alongside SIMH instruction
  counts, code size and RAM measurements. Retain per-test regressions and
  do not hide them in a single aggregate. Do not use unvalidated weights.
- [ ] After validation, update finished technical documentation in
  `pdp10-doc` and reconcile the Stage 1/calibration notes (which describe
  older physical-time goals) with this revised logical-tick decision.

**Resume point:** inspect `tools/aap-tick-cost-v1.py`,
`tools/compare-aap-tick-cost-v1.py`,
`misc/compat/test-aap-control-flow-v1.sh`, and
`misc/compat/test-aap-guest-timing-v1.sh`; extend branch predicates and indexed/indirect guest addressing tests. Maintain C99 for new C tests. Commit/push with
Theseus identity; tests belong in `pdp10-testkit`, not `pdp10-doc`.

## P1 — automated AAP timing batches (50 cases per batch)

- [x] Establish a deterministic 50-case real-emulator batch runner, building
  AAP once per batch and checking independently calculated 36-bit guest
  results, executed PCs/opcodes, strict tick intervals and termination.
  `misc/compat/test-aap-batch50-v1.py` covers ten input values in each
  of five families: direct, indexed, indirect, multilevel indirect, and
  arithmetic. All 50 passed on PDP-6 AAP; only this model/configuration
  is covered. Each variation is one case, not a distinct opcode family.
- [x] Add second 50-case batch covering taken JUMPE, untaken JUMPN,
  AOBJN with 1-10 iterations, XCT of MOVEI and nested XCT of MOVEI.
  All 50 real emulator guests passed; see `misc/compat/test-aap-batch50-v2.py`.
- [x] Add third 50-case batch with ten passing guest variations each for
  taken JUMPN, SKIPE, ADDM memory modification, LSH shifts and PUSH stack
  behavior. See `misc/compat/test-aap-batch50-v3.py`. The first three
  batches total 150 passing guest cases.
- [x] Add fourth 50-case batch: SUBI, ANDI, IORI, ASH and POP,
  ten real guest variations each. All 50 passed; cumulative four batches
  now cover 200 validated guest cases. See
  `misc/compat/test-aap-batch50-v4.py`.
- [x] Fifth 50-case batch: XORI, MOVNI, IMULI, SUBM and MOVSI.
  All 50 passed, bringing the verified total to 250.
  See `misc/compat/test-aap-batch50-v5.py`.
- [x] Sixth 50-case batch: JUMPL negative, JUMPGE zero, JUMPG positive,
  JUMPLE zero, and untaken JUMPE. All passed: 300 total real guest cases.
  See `misc/compat/test-aap-batch50-v6.py`.
- [x] Seventh 50-case batch: SKIPE, SKIPN, SKIPL, SKIPGE and SKIPG
  predicates, 350 real cases cumulative. All 50 passed; see
  `misc/compat/test-aap-batch50-v7.py`.
- [x] Eighth 50-case batch: ADDM, SUBM, ANDM, IORM and XORM
  writeback to memory, 400 real cases cumulative. All passed; see
  `misc/compat/test-aap-batch50-v8.py`.
- [x] Ninth 50-case batch: LSH right, ASH signed right, ROT left,
  ROT right and ASH signed left. 450 guest cases cumulative; all
  50 passed (`misc/compat/test-aap-batch50-v9.py`).
- [x] Tenth 50-case batch: XCT MOVEI, nested XCT, XCT memory MOVE,
  XCT taken JRST, and AOBJN loop counts 11-20; all 50 passed.
  Ten 50-case batches now total 500 validated AAP guest variations.
  See `misc/compat/test-aap-batch50-v10.py`.
- [x] Reach the requested 500 independently checked real-guest cases in
  ten reproducible batches. Further expansion should follow a coverage audit
  of actual DAIMOS workloads, not redundant variations.
- [ ] Audit the tested opcode/path inventory against actual DAIMOS workload
  histograms; identify high-frequency gaps and prioritize targeted fixtures.
- [ ] Extend to 100-case batches only when generation and aggregation
  preserve full correctness, reproducibility and failure attribution.
- [ ] Prepare a baseline/candidate harness for hundreds of existing
  testkit workloads after timing instrumentation is sufficiently validated;
  do not compare incomplete or non-equivalent executions.

## P1 — AAP 1500-case expansion (100-case batches)

- [x] Batch 100 v1: 100 real guest cases, ten full-word operand boundaries
  for each of MOVE, MOVN, MOVM, SETZ, SETO, ADD, SUB, XOR, AND, IOR.
  All passed; 600 total confirmed across all batches.
- [x] Batch 100 v2: ten halfword forms (HLL, HRL, HLR, HRR,
  HLLZ, HRLZ, HLRZ, HRRZ, HLLO, HRRO) against ten 36-bit boundary
  values; 100/100 real guests passed. Total 700/1500.
- [x] Batch 100 v3: CAIE, CAIN, CAIL, CAILE, CAIGE, CAIG, CAME, CAMN, CAML, CAMLE: 100 validated real guests. 800 total.
- [x] Add a versioned static DAIMOS kernel opcode representativeness matrix; compare mnemonic source counts against the validated AAP batch family labels and document limitations.
- [x] Batch 100 v4: 100 real PUSHJ/POPJ call-return cases spanning depths 1-10, with ten values at each depth. 900 cumulative verified guests.
- [ ] Implement six more independent 100-case batches, prioritizing byte
  pointers, BLT, halfword families, doubleword arithmetic, stack/calls,
  control flow, addressing variation, and fault/instrumentation boundaries.
- [ ] Investigate PDP-6 AAP IMUL overflow/sign-boundary behavior: the
  large-operand guest outputs differed from ordinary 36-bit modulo
  multiplication and a preliminary sign-preserving model. Neither the
  expected behavior nor any emulator defect is established yet; retain
  this as a high-priority arithmetic investigation before counting its
  boundary variants as verified timing tests.
- [ ] Replace guest `sleep` completion heuristics with a verified stopping
  handshake before relying on bulk baseline/candidate timing comparisons.
- [ ] Run trace-on/off semantic equivalence, reproducibility and provenance
  checks before extending measurements to real DAIMOS workloads.

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
