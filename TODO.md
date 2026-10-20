# PDP-10 testkit — outstanding work

Status: 2026-10-20. This is the central checklist for **open** testkit work.

## Freestanding search dependency update (2026-10-19)

- [x] Implement `strstr`, `strpbrk`, and `strspn` as separately loadable,
  stack-free PDP-6 assembler library members. Test on SIMH PDP-6 under
  KCC optimized and unoptimized and GCC `-O0/-O1/-O2/-Os`, with 9-bit and word-crossing
  cases. See `docs/FREESTANDING-SEARCH-ASSEMBLER-20261019-v1.md`.
- [x] Correct the GCC initialized 9-bit data section flush defect and
  validate with a dedicated PDP-6 regression at `-O0/-O1/-O2/-Os`.
- [x] Fix the reproducible GCC `-O1` `put_addressof_into_stack` ICE
  for 9-bit locals already represented by a stack subword. The registered
  compiler regression compiles at `-O0/-O1/-O2/-Os`; all four GCC PDP-6
  search-library executions pass with the installed compiler.
- [x] Compare PDP-6 executed SIMH instruction steps for all three assembler
  routines with equivalent C references, using identical KCC `-n` workloads.
  See `docs/FREESTANDING-SEARCH-ASSEMBLER-20261019-v1.md`.
- [ ] Measure modeled AAP logical ticks and compare additional short/long
  search workloads and processor targets before generalizing runtime speedups.
- [ ] Diagnose the still-deferred GNU `string-opt-1`, `string-opt-2`, and
  `string-opt-11` builtin/optimization failures separately from the
  now-available libc API routines. They are reclassified as compiler-feature
  investigations rather than missing libc links.
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

## Current compiler priority: signed 71-bit / D-format casts

- [x] Reproduce and eliminate KCC `vrwiden: reg already wide` on the unchanged
  `930622-2.c` under both KCC PDP-6 optimization modes. The original
  upstream test is now an active **PDP-6-native-only** matrix regression,
  with independently passing GCC PDP-6 `-O0/-O1/-O2/-Os` executions.
- [x] Fix and independently validate signed 71-bit automatic-load sign
  normalization and PDP-6 D-format double negation. Both tests pass
  optimized/unoptimized on PDP-6; the two tests are registered in
  `kcc-dimode-storage-v1`.
- [x] Implement a bounded-RAM signed 71-bit/software D-format conversion
  using **PDP-6 integer instructions only**, with nearest/even rounding
  and truncation toward zero, without scalar-widening a DImode pair.
  Original upstream execution and the separate 17-case bit-pattern test
  pass under KCC optimized and `-n`. The installed KCC and GCC archive
  members are byte-identical. See
  `docs/KCC-PDP6-SOFTWARE-DFORMAT-20261020-v1.md`.
- [x] Validate the PDP-6 software conversion independently on AAP using
  the complete linked original and 27-case boundary guests, each with both
  KCC optimization modes. The oracle verifies a nonzero `__test_exit`
  sentinel before execution and its change to zero via `exit(0)`; an
  immediate-HALT negative control cannot pass. No removed `cpustatus` or
  timing instrumentation was restored. See
  `misc/validation/test-kcc-aap-dimode-float-pdp6-v1.py`.
- [ ] Independently determine native PDP-6 floating-point, KA10 and later
  PDP-10 D-format conversion semantics before enabling these CPU profiles.
- [x] Fix signed DImode/36-bit float conversion on PDP-6, including
  correct round-to-nearest-even narrowing (not scalar FLTR of high36),
  and verify 21 independent floating bit patterns with both KCC modes on
  SIMH and AAP. Fix the separate host-IEEE-float literal precision loss
  and verify nine target single-float literal words under both profiles.
  See `docs/KCC-PDP6-NATIVE-FLOAT-CORRECTIONS-20261020-v1.md`.
- [x] Audit and repair hosted KCC compile-time `TS_FLOAT` arithmetic and
  cast folding. Preserve the target's 27-bit precision through the exact
  KPCODE2 stream, verify 20 static cases and both optimization modes on
  SIMH/AAP PDP-6, and prevent unsafe floating reassociation. See
  `docs/KCC-PDP6-TARGET-FLOAT-FOLDING-20261020-v1.md`.
- [x] Repair SIMH PDP-6 native negative-halfway FADR/FSBR rounding.
  The PDP-6-only fix is grounded in Stanford SAIL `10TO6.TED` and
  verified on SIMH and AAP with eight negative-halfway cases, with
  24 theoretical boundary cases also passing corrected SIMH. The
  original `kcc-pdp6-negative-fp-runtime-v1` is now enabled.
- [ ] Establish the original PDP-6 hardware behavior for
  `-134217728.0F + 1.0F` at the exponent edge. AAP emits
  `0544000000003`; SIMH emits the mathematically expected
  `0544000000001`. **Do not assume AAP is wrong**: `10TO6.TED`
  explicitly documents low-word information loss in some PDP-6
  normalization cases. The complete 24-case AAP run remains manual
  and fails on case 9 until checked against DEC 166 circuitry.
  Investigation plan: `docs/PDP6-FP-NEXT-STEPS-20261020-v1.md`.
- [x] Fix the strict four-phase KCC output mismatch in `cccse.c`
  at `-n`: DAIMOS KGEN previously had 64 PCODE peephole slots while
  DAIMOS KCC1/integrated KCC had 256, changing register selection at
  the first flush. Consistent 64-entry DAIMOS rings now produce
  byte-identical `-n` output over all 27 compiler translation units;
  `kcc-phase-byte-identity-20261006` is an enabled regression.
  Optimized KPARSE's extra `bindopt` means optimized KIR1 output
  need not be byte-identical; optimized KCC/KCC1 identity and the
  KPCODE2 executable float suite both pass.

## P1 — complete upstream semantic test integration

- [x] Reconcile the physical and registered test inventory: 1,979 unique
  matrix C sources, 194 unique special registrations, 13 explicitly owned
  companion sources, zero unowned `tests/` C/assembly sources, zero missing
  registered files. Remove duplicate AAP instrumentation registration and
  register the existing GCC multidimensional-char test script. Introduce
  fail-closed `tools/audit-test-inventory-v1.py`.
- [x] Assign a primary actionable blocker/disposition and retain source hash
  plus prior evidence for **all 276 deferred upstream tests**. See
  `docs/SEMANTIC-DEFERRED-DISPOSITION-20261019-v1.tsv` and the fail-closed
  verifier; this is classification for subsequent work, **not** activation,
  independent target validation, or successful compiler execution.
- [ ] Review the 48 pairs of identical deferred test content, including
  the two deferred sources identical to already active copies; consolidate
  test ownership only when the target profiles and intended assertions agree.
- [ ] Verify deferred blockers with current target headers, libc, varargs,
  and supported GCC-only execution. Progress class by class; do not assign
  compiler defects to missing runtime prerequisites. Use the versioned
  disposition manifest for each follow-up.
- [x] Complete KCC P0 `vrwiden` ICE for the original upstream
  `tests/semantic/upstream/wide-int/930622-2.c` without altering its source
  or accepting any other processor's unverified floating-point behavior.

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
- [x] Review the 129 `review-extension` sources by feature (builtins,
  attributes, packing/alignment, local labels, setjmp, prefetch, stdio,
  complex types). Register only supported, meaningful KCC/GCC combinations;
  remove unsupported tests rather than masking failures. Do not assume GCC
  extensions are portable C99. The classification sweep completed in
  `docs/SEMANTIC-EXTENSION-BATCH-20261014-v16.md`; remaining *execution*
  requirements are inventoried in the deferred-disposition v1 table.
- [ ] Resolve the 269 currently `deferred` sources (seven inline-assembly C
  tests, KL10-specific `support/920428-1.s`, varargs/header/runtime
  dependencies, GNU extension feature decisions, width-sensitive cases and
  independently observed compiler failures). Earlier deferred
  `20000314-3.c` and `20000519-1.c` were already activated; incompatible
  pointer-aliasing `20000603-1.c` is tracked separately as nonportable stress.
  The full current source-by-source worklist is in
  `docs/SEMANTIC-DEFERRED-DISPOSITION-20261019-v1.tsv`.
  Move suitable target-specific coverage to ISA/DAS
  test ownership with real assembler/link dependencies; delete inappropriate
  CPU or host-OS cases. The `.s` file requires KL10 and external symbols.
- [x] Make existing GCC torture `abort()`/`exit()` assertions executable by a
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
  manifest: zero candidates, zero extensions, zero width reviews, 269 deferred,
  449 active, 1 nonportable stress, and 55 removed; **270 classified sources
  remain outside mandatory active coverage**. The current new activation is
  PDP-6-native-only; KA10/KI10/KS10 and alternative floating formats have
  no test coverage from it.
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
- [x] Audit the static DAIMOS PDP-6 kernel assembly mnemonic inventory against registered, verified AAP timing fixtures, including generated family mappings. The resulting source occurrence proxy is 16034/16675 (96.2%), *not* runtime or path coverage; see `docs/PDP6-AAP-KERNEL-COVERAGE-MATRIX-20261015-v1.md`.
- [ ] Audit against actual linked DAIMOS kernel workload opcode histograms (and C-generated code), identify high-frequency gaps and prioritize new fixtures.
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
- [x] Batch 100 v5: 100 BLT guest cases (1-10 words, ten data patterns), every destination word checked, including repeated ET0A accounting. 1000 cumulative verified guests.
- [x] Batch 100 v6: 100 PDP-6 LDC/DPC byte load/deposit cases across 3/6/9/12/18-bit sizes, ten pointer positions/data variants each; strict byte ET0A continuation accounting. 1100 cumulative verified guests.
- [x] Batch 100 v7: 100 pre-increment LDCI/DPCI cases (ILDB/IDPB), all pointer updates and byte results checked. 1200 cumulative guests.
- [x] Batch 100 v8: 100 standalone IBP pointer-increment cases with width 1-18 and position variation. 1300 cumulative real guests.
- [x] Batch 100 v9: ten right-half test/modify forms (TRNE/TRNN/TRNA/TRZE/TRZN/TRZA/TRCE/TRCN/TROE/TRON), two skip outcomes, independent AC result. 1400 cumulative.
- [x] Resolve apparent TLNE discrepancy: exploratory fixture had incorrect 612/616 opcodes; correct TLNE/TLNN encoding and verify 100 TL* cases in batch100 v15.
- [ ] Implement one more independent 100-case batch, prioritizing byte
  pointers, BLT, halfword families, doubleword arithmetic, stack/calls,
  control flow, addressing variation, and fault/instrumentation boundaries.
- [x] Batch 100 v11: ten halfword-memory destination forms, 100/100 real emulator cases with independent 36-bit memory readback. 1600 cumulative.
- [x] Batch 100 v12: 100 AOJ/SOJ conditional-jump cases crossing signed zero boundaries, both outcomes. 1700 cumulative guests.
- [x] Batch 100 v13: unconditional AOJ/SOJ and AOS/SOS memory-update variants across signed boundary values, 100/100 passing; 1800 cumulative.
- [x] Introduce explicit 19-criterion broad functional/timing coverage acceptance matrix, with a fail-closed `--require-broad` gate. Initially 9/19 resolved; passing raw case counts or high source occurrence coverage does NOT satisfy it. See `docs/PDP6-AAP-BROAD-COVERAGE-GATE-20261015-v1.tsv` and `tools/check-aap-broad-coverage-v1.py`.
- [x] Batch100 v14: 100 verified preincrement byte-pointer word-crossing cases (LDCI/DPCI), cumulative 1900 guests.
- [x] Batch100 v15: 100 verified TL* left-half logical test/modify guest cases, cumulative 2000.
- [x] Batch100 v16: 100 doubleword LSHC/ROTC guests with independent 72-bit output validation, cumulative 2100.
- [ ] Establish correct PDP-6 ASHC two-sign-bit doubleword shift reference semantics; exploratory generic 72-bit expectation failed. Do not mark doubleword shift gate verified yet.
- [x] Record and regression-check real AAP guest provenance: source SHA/revision, executable, machine configuration, complete guest word image and trace (`aap-profile-provenance-v1.py`).
- [x] Add read-only APR_CLASS_V1 exception/PI state diagnostic and fail-closed final-snapshot classifier (pdp6 266ee75), with five real guest baseline checks and ten parser cases. Does not establish fault/PI timing coverage.
- [ ] Beyond the 1500-case milestone, achieve genuinely broad functional/timing coverage against the DAIMOS kernel inventory. Remaining gaps include signed/division arithmetic, doubleword operations, left-half logical tests, exceptional I/O/interrupt events, pointer word crossing, deterministic guest completion and dynamic kernel frequency profiles.
- [x] Batch100 v19: verify 100 nonoverflow PDP-6 IMUL guests, with independently calculated product, output and tick intervals. Cumulative 2400 passing real guests; overflow remains open.
- [x] Batch100 v20: 100 positive IDIV guests checking both independent quotient and remainder values, cumulative 2500 passing real guest cases.
- [x] Batch100 v21: 100 signed IDIV quotient/remainder cases covering all dividend/divisor sign combinations with independent signed validation; 2600 cumulative guests.
- [x] Batch100 v22: 100 large-positive IMUL products exceeding 35 bits, independently checking 35-bit magnitude truncation and positive sign. Total 2700 passing real guests.
- [x] Batch100 v23: 100 signed negative nonoverflow IMUL results checked, 2800 cumulative.
- [x] Batch100 v24: 100 negative overflow IMUL results independently modeled as negated low 35 product-magnitude bits, total 2900 guests.
- [x] Add read-only synchronous APR_FLAGS_V1 emulator diagnostic (pdp6 `7fc1727`) and real guest regression verifying OV=0 for normal division, OV=1 for division by zero.
- [ ] Validate quotient overflow independently; the initial minimum-negative / minus-one signed-boundary probe did not set OV, and cannot be treated as a validated architectural overflow fixture.
- [ ] Validate divide-by-zero and quotient overflow exception semantics before closing arithmetic gate: the
  large-operand guest outputs differed from ordinary 36-bit modulo
  multiplication and a preliminary sign-preserving model. Neither the
  expected behavior nor any emulator defect is established yet; retain
  this as a high-priority arithmetic investigation before counting its
  boundary variants as verified timing tests.
- [x] Replace fixed sleep completion in all 23 registered Python AAP timing batches with a simulator-thread `cpustatus`/HALTED handshake (PDP-6 emulator `ac0e7a0`). Revalidate all 1800 cases and compare old/new interval vectors; all identical.
- [ ] Migrate older shell guest fixtures to the deterministic completion handshake where practical.
- [x] Add 20-case, 60-execution AAP trace-on/off guest-result and identical repeat-tick instrumentation regression (`test-aap-instrumentation-v1.py`).
- [ ] Add provenance and broader trace transparency checks before extending measurements to real DAIMOS workloads.

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

- `COMPILER_MATRIX.tsv`: 1,986 source rows; verified source paths present.
- `SPECIAL_TESTS.tsv`: 210 unique entries (including manual probes); paths present, but not every
  special row is yet independently dispatched.
- `tests/codegen/upstream-gcc/`: 706 registered C sources.
- Upstream manifest: 449 active, 269 deferred, 55 removed and one nonportable
  stress source (all deferred entries have explicit blocker dispositions).
- Main entry points: `run-tests.sh` (compiler/CPU/optimization cells) and
  `run-misc-tests.sh` (specialized suites).

**Acceptance criteria:** every retained source is owned by a documented
matrix or special-suite test, or is explicitly marked deferred with a reason;
all active tests meaningfully assert their intended behavior; invalid tests
are rejected without compiler crashes; supported execution profiles have
recorded results; and registry entries agree with actual runner dispatch.

- [x] Determine the SIMH PDP-6 opcode register query (`examine OPCOUNT[0-511]`), run bounded disposable-media DAIMOS boot probe, and reject its three-opcode bootstrap-only profile using a fail-closed validator.
- [ ] Achieve genuine linked DAIMOS KCORE/MRES execution evidence: complete boot to authenticated kernel milestone, bound execution PC to linked maps, gather reproducible opcode counters and associate with boot/build revisions; bootstrap counters alone are inadequate.

- [x] Diagnose invalid SIMH `step N` profile start (missing `deposit PC 020`), preserve distinct copied disk/drum media directories, and obtain a bounded DAIMON-to-BSET boot-stage opcode profile (8,346,188 dispatches, 112 active opcode values). Add a fail-closed boot-stage classifier.
- [ ] Capture representative post-boot DAIMOS linked KCORE/MRES workloads with module execution/address provenance, supported stage milestones, and source/binary/configuration fingerprints before marking full hotpath coverage.

- [x] Add reproducible fresh-media setup for bounded SIMH kernel profiling, preserving disk/drum paths and hashes and rejecting reused snapshots; regression in `test-pdp6-fresh-media-profile-v1.py`.
- [ ] Investigate DAIMOS bounded full-boot HALT at PC `071470` after `BSET LOADED` (fresh 12M-step run); do not promote that run to full hotpath coverage.

- [x] Attribute fresh-media HALT at PC 071470 to fatal DAIMOS `?RT` (root mounting or regular `/SYSTEM/INIT` check) using the exact `kinit_boot.c` diagnostic; add a fail-closed root failure classifier and regression.
- [ ] Isolate which copied disk root image or boot selection differs from the previously successful interactive boot; obtain successful reproducible `INIT V1` on fresh media before claiming full linked hotpath coverage.

- [x] Validate original versus disposable D6FS root disk byte-for-byte (four matching member hashes) and record same selected DIRTY superblock; distinguish permissible DIRTY boot state from an established root-mount failure cause.
- [ ] Establish whether fresh-profile `?RT` arises during root selection, D6FS mount or `/SYSTEM/INIT` stat; compare truly identical media revisions with prior successful boot before implementing a kernel fix.

- [x] Capture `?RT` KINIT memory state from linked-map addresses: valid root handoff, nonzero active D6FS reader, but `vfs_namespace_root=VFS_NODE_NONE`. Add fail-closed linked-root snapshot regression.
- [ ] Trace the D6FS boot mount failure/rollback to a specific return site, then fix the underlying defect and verify `INIT V1` using isolated fresh media.

- [x] Confirm all four linked `vfs_mount_root` slots remain zero at `?RT` and extend the linked-map snapshot regression to detect contradictory mounted state.
- [ ] Verify SIMH execution-breakpoint behavior independently before inferring that `vfs_mount` was never reached; isolate the failing D6FS pre-mount validation/rollback site.

- [x] Add opt-in pulse-level AAP traces for NXM, ILLOP, PDLOV and PI-cycle entry; verify normal guest execution and fail-closed event parser (emulator 07e9ed3).
- [ ] Trigger and verify each fault/PI event using actual PDP-6 guests, classify device-I/O and aborted cycles at event time, and only then reconsider the broad AAP coverage gates.

- [x] Exercise real AAP NXM event with an out-of-range read on 16K `cmem161C` core and reject it through the event classifier; verify ordinary 256K reads did not trigger NXM.
- [ ] Extend real AAP positive event coverage to ILLOP, PDLOV, and PI entry; reject/categorize device I/O and aborted timing traces.

- [x] Exclude IOT opcode starts (0700–0777) from ordinary CPU timing using AAP instruction-start milestones; retain mandatory PI/device-I/O coverage as incomplete pending real device and PI event tests.

- [x] Execute an actual privileged APR CONI guest on AAP, confirm the following IT0 trace contains opcode 700, and verify the CPU-only classifier rejects it.
- [ ] Test genuine PI entry, relocation ILLOP and PDLOV events with bounded deterministic guests before closing the remaining event gates.

- [x] Add conservative AAP instruction-PC attribution against a linked symbol map, refusing absent and malformed timing traces.
- [ ] Obtain a provenance-matched KCORE/MRES live instruction-PC trace with verified text/module bounds before resolving linked-kernel-hotpaths.

- [x] Add fail-closed linked-image deposit PC-overlap candidate check with duplicate-address and bootstrap-only rejection.
- [ ] Demonstrate AAP loading of the *same hashed* DXR image and MRES text ranges before accepting kernel hotpath measurements.

- [x] Load all 9,635 words of an isolated linked KCORE image in AAP; verify real HALT instruction fetch, memory readback, and instruction-start PC at octal 013436 (not kernel hotpath coverage).
- [ ] Trace ordinary boot into multiple linked KCORE text routines and loaded MRES, with genuine image/module provenance and event exclusions.

- [x] Reproduce AAP paper-tape mount and launch of DAIMOS stage-one bootstrap (limited RUNNING/readback smoke; no boot or kernel coverage claim).
- [ ] Bridge AAP and DAIMOS boot-media/controller requirements and trace genuine KCORE/MRES execution with verified loaded module bounds.

## AAP coverage dependency: boot testing resumed (2026-10-15)

- [x] Lift the earlier TSFS-root boot-test hold at user direction on 2026-10-15. This is authorization to test, not evidence of a successful root mount or fixed TSFS implementation.
- [x] Resume bootstrap integration smoke testing using the available built DAIMOS stage1-dsk.pt; AAP tape mount/launch smoke passed, but full boot remains unverified.
- [ ] Verify successful kernel entry, root mount and build/image provenance before treating linked-KCORE/MRES runtime trace as actual kernel execution; existing image/HALT evidence is not a live KCORE/MRES profile.

- [x] Require strictly increasing AAP logical timing milestones in event classifier, rejecting missing, malformed, tied or reversed traces; verify with standalone AAP normal, NXM and IOT guests while TSFS boot is blocked.

- [x] Validate cross-stream chronological ordering of AAP exception/PI pulse events and timing milestones, with standalone regression cases for inverted event order.

- [x] Expand AAP static coverage inventory from kernel-only to all maintained DAIMOS assembler under system/ and userland/; count generated build output separately and report unclassified tokens, without claiming runtime coverage.
- [x] Verify genuine standalone PDP-6 PUSHJ pushdown overflow and clean stack-pointer control, with emitted PDLOV event and APR latch checks.
- [ ] Classify remaining unknown assembler tokens and expand real AAP opcode/mode fixtures across all DAIMOS source; resume boot-linked KCORE/MRES profiling when an actual kernel-entry trace is captured.

- [x] Classify 1,035 formerly unrecognized mnemonic-like references: 951 conventional instruction forms plus 84 UUO/HALT special-form references; zero unknown tokens remain in maintained assembler snapshot.
- [ ] Add exact opcode/form fixtures for the newly enumerated DAIMOS instructions; do not equate a family-level match with verified encoding or execution modes.

- [x] Add five real standalone AAP SETZM opcode-402 cases, checking destination memory, accumulator preservation and complete timing intervals; register exact-form coverage only.
- [ ] Continue missing exact DAIMOS assembler opcode/mode fixtures (HRLI, SOJG, AOJA, TLC, IDIVI, SETOM and others), excluding boot-dependent tests.

- [x] Verify five real standalone AAP HRLI opcode-505 cases with independent expected 18-bit halves, source-memory preservation and timing intervals.
- [ ] Add targeted exact-form AAP tests for SOJG, AOJA, TLC, IDIVI, SETOM and remaining DAIMOS mnemonics.

- [x] Verify seven standalone exact SOJG opcode-367 decrement/branch/timing cases with signed boundary inputs; confirm encoding against PDP-6 assembler table.
- [ ] Continue AOJA, TLC, IDIVI, SETOM and other exact forms without DAIMOS boot.

- [x] Verify exact AAP AOJA opcode-344 increment and unconditional-branch timing across seven boundary inputs.
- [ ] Continue exact-form TLC, IDIVI, SETOM and remaining DAIMOS assembler instruction tests without DAIMOS boot.

- [x] Verify five real standalone TLC opcode-641 immediate left-half XOR cases and timing intervals.
- [ ] Continue IDIVI, SETOM and remaining unverified exact instruction forms without DAIMOS boot.

- [x] Verify nine real standalone AAP IDIVI opcode-231 signed immediate division cases, checking quotient, remainder, source memory and timing.
- [ ] Verify IDIVI divide-by-zero and signed-overflow behavior separately before claiming boundary-complete IDIVI coverage.
- [ ] Continue exact SETOM and other unverified DAIMOS assembler forms without booting DAIMOS.

- [x] Verify exact SETOM opcode-476 with five standalone AAP memory-set-ones, accumulator-preservation and timing cases.
- [ ] Continue exact-form AAP tests prioritized by remaining DAIMOS source counts; verify kernel entry/root mount before claiming a successful boot.

- [x] Correct AAP exact-form fixture registry discovery: standalone registered tests now count, with a regression to prevent missing-script evidence.
- [x] Verify five real standalone TLZ opcode-621 left-half bit-clear semantics and timing cases.
- [ ] Continue the current all-assembler frequency ranking with TLO, CAMGE and subsequent exact forms; boot-dependent testing remains suspended.

- [x] Verify standalone TLO opcode-661 exact-form semantics and timing with five boundary masks.
- [ ] Continue CAMGE/CAMG exact-form timing and branch tests; separately advance resumed linked-image boot profiling.

- [x] Verify exact CAMGE opcode-315 signed skip semantics across positive, negative, equality and full 36-bit sign-boundary cases, plus timing intervals.
- [ ] Continue CAMG/HRROI/SETZB exact-form tests alongside live KCORE/MRES kernel-entry investigation.

- [x] Verify exact CAMG opcode-317 signed strict-greater comparison and skip behavior in thirteen real AAP boundary cases; compare equality vs CAMGE semantics.
- [ ] Continue HRROI and SETZB exact opcode evidence, alongside resumed live KCORE/MRES kernel profiling.

- [x] Verify standalone HRROI opcode-561 immediate right-half/left-ones semantics and timing across five cases.
- [ ] Continue SETZB and remaining exact-form AAP tests; progress kernel-entry runtime profiling independently.

- [x] Verify exact SETZB opcode-403 both-destination zero semantics (AC and memory) and complete timing across five standalone AAP guest cases.
- [ ] Continue exact-form TDNE, ANDCMI, TLOA and other source-frequency gaps; resume live KCORE/MRES boot profiling separately.

- [x] Add standalone TDNE opcode-612 tests covering both zero and nonzero AC-and-memory cases, skip PC trajectory, accumulator/memory preservation and timing.
- [ ] Continue ANDCMI and TLOA exact-form tests; separately address remaining 16/19 mandatory exception, PI/IOT and linked kernel profiling gaps.

- [x] Verify exact ANDCMI opcode-421 complemented-immediate-mask semantics and timing in five standalone AAP guests.
- [ ] Continue TLOA exact-form tests and remaining mandatory fault, PI/IOT, and live KCORE/MRES profiling work.

- [ ] Genuine ILLOP remains unverified: standalone JRST transition diagnostic runs did not generate an ILLOP event (normal controls halt; other candidate encodings do not halt). Determine the architecturally correct user-mode transition and protection-register setup before claiming fault-exclusions; do not interpret timeouts as valid faults.

- [ ] Resolve the protected user-mode ILLOP guest: JRST 1/JRST 2 direct-entry candidates have not halted; inspect the `et1` -> `mr_clr` mode latch and `ex_set` PR/RLR initialization before accepting a real fault pulse and aborted interval.

- [x] Reproduce actual PDP-6 user-protection ILLOP at PC 001001 with JRST 1 mode transition, verify fault-free control and reject exceptional traces in both event classifier and timing extractor. Fault-exclusions gate promoted after real NXM/PDLOV regressions.

- [x] Verify real AAP PI_CYCLE entry using correctly encoded `CONO PI` (`700600` high half), PI enabled/no-request control and genuine channel requests; reject PI and device-I/O instruction traces in ordinary timing. Interrupt/I/O exclusion gate verified.
- [ ] Separately exercise hardware device-asserted priority interrupts (as opposed to the verified software-posted channel request) for fuller per-device behavior, without conflating this extra coverage with the mandatory timing exclusion gate.

- [ ] AAP 19/19 linked-kernel-hotpaths: bounded real stage-one paper-tape trace remains in low-core PTR polling PC 000020–000022, even after >900 instruction starts; investigate tape bootstrap transfer/completion and kernel image entry before claiming KCORE/MRES dynamic execution.

- [ ] Debug the actual PDP-6 Type 760 paper-tape state machine/read-in: explicit `ptrmotor ptr on` and divisor 1 still leave AAP stage-one at PC 000021–000022. Confirm real reader flag transitions and bytes consumed before claiming linked-kernel execution.

- [x] Fix the AAP stage-one test's premature console EOF by keeping a FIFO open for bounded execution: genuine PTR bytes are consumed and stage-one PCs are reached.
- [ ] Investigate repeat loop at octal 000460–000465 after stage-one entry; actual KCORE/MRES image identity/entry remains unverified.

- [ ] AAP linked-kernel-hotpaths: the PDP-6 AAP emulator `emu/cmd.c` has no DSK270 controller implementation (`mkdev` has APR, PTR, DCT/DECtape and others, but not DSK). Disk `stage1-dsk.pt` loops waiting for DSK270/DCT readiness at PCs 000460–000465. For real KCORE/MRES execution, select a stage-one image for an actually implemented controller and matching image, or implement and verify DSK270 properly; do not treat this test's large instruction count as kernel work.

- [x] Build alternative AAP Stage-1 PTR and DECtape media without touching the DAIMOS checkout (`test-aap-alt-stage1-media-v1.sh`); produce PTR Stage-1, two counted KINIT payload tapes, DTC Stage-1 and DTC payload.
- [ ] For PTR: automate reliable Stage-1->payload1->payload2 media change with verified completion and KINIT entry; currently PTR wait-loop progresses only partially when swapping payload.
- [ ] For DECtape: validate DAIMOS DTC stream format and physical Type-136/551/555 transfer against the AAP model. Stage-1 executes but polls DTC data status; no KINIT entry observed.

- [ ] Implement and validate a proper SIMH-halfword-to-AAP-Type-555 raw DECtape encoder including mark track, block geometry and checksums. `mkdt` outputs 32-bit little-endian 18-bit halfwords, not the per-line transport data consumed by AAP; do not mount it directly.
- [ ] Complete the alternative paper-tape 3-media bootstrap with state-aware swaps and independently verified KINIT/KCORE/MRES entry and timing profile.

- [ ] AAP PTR alternative boot: `test-aap-ptr-handoff-v1.py` polls the relocated `stage_ptr` (000275) and refuses a second payload mount until the first counted payload really completes. The bounded initial run leaves `stage_ptr=0`; replace the initial fixed Stage-1-to-payload1 delay with an observed Stage-1 entry/wait condition, then verify transfer throughput and KINIT entry.

- [x] Replace fixed initial PTR Stage-1-to-payload1 delay with observed AAP IT0 at PC 000060 (`test-aap-ptr-handoff-v1.py`); fail closed if the entry is not seen.
- [ ] Diagnose incomplete PTR payload1 with instrumented byte count and transfer-state readback; Stage-1 entry is now confirmed before media switch, but `stage_ptr` has not advanced.

- [ ] AAP Type 760 PTR handoff diagnosis: DevSpace2 `/proc/<pid>/fdinfo` measurement confirms only 5 of 56825 bytes from first payload were consumed in 15 seconds after verified stage-one entry. Examine busy/flag and `DATAI` re-arm after the initial word; no KINIT entry proven.

- [ ] AAP PTR first-word failure: real trace ends at 000071 (read_word return), 000072 (MOVE 02,03), 000073 (CAIGE 02,4), 000272 (bad_tape HALT). Only 5 bytes consumed. Compare decoded count 026144 with AAP accumulator/byte shifting; do not treat as a reader-ready timeout.

- [ ] Investigate corrupt first PTR counted word: post-HALT `examine` confirms expected `000000026144` versus AC2/AC3 `500000000054`, AC5 `000000000054`. The signed CAIGE correctly rejects negative/corrupt AC2. Isolate DATAI byte transfer, AC write/read, or shift/IOR semantics using a minimal standalone AAP instruction test before changing emulator or loader.

- [x] Identify actual PTR count corruption: extra octal 0252 RIM trailer supplied a stale first byte. Preserve reference tape; generate `stage1-ptr-no-trailer-v2.pt`, which reaches Stage-1 and transfers all 56,825 first-payload bytes with a nonzero `stage_ptr`.
- [x] Verify five-byte LSH/IOR assembly independently with real AAP synthetic test (`test-aap-ptr-assemble-v1.py`).
- [ ] Capture first-payload `stage_ptr` transition reliably during the streaming run, mount payload2 only on real completion, and check second transfer and KINIT entry. Preliminary end-of-run readback shows `000275=000000135202` but online polling missed it.

- [x] Verify real AAP Stage-1 -> both PTR KINIT payloads -> decoder -> linked KINIT entry at `054074`, with exact linked-image instruction readbacks; profile actual early KCORE/MRES instruction-starts and ET0A opcodes (`aap-linked-runtime-profile-v2.py`).
- [ ] Close `linked-kernel-hotpaths` only after handling the observed real PI_CYCLE/PDLOV boundaries and obtaining representative, valid logical-tick hotpaths; startup opcode-frequency counts alone are insufficient. Full DAIMOS root boot is also unverified.
- [ ] Investigate final AAP boot HALT and PDLOV at `777777` and MRES `023774`, without assuming the Stage-1 AC17 pointer is erroneous (D6LZ36 actually advances AC12).

- [x] Isolated SIMH `ROOT=tape BOOT=ptr` startup with a populated TSFS root: real SIMH run exchanged both counted PTR payload tapes, displayed `DAIMON V0.5`, `DTC OK`, `DTFS LOADED`, `INIT V1`, and reached `LOGIN:` (`test-simh-ptr-tsfs-boot-v1.sh`). Uses existing documented temporary DSH_IMAGE_LIMIT=037000 exception only in its isolated build.
- [ ] Permanently recover DSH's 15 decimal words over the production `036000` image limit; the SIMH comparison did not solve this size regression.
- [ ] Verify root mount and login operation independently under SIMH and compare the exact linked KINIT image, kernel PI/PDLOV fault sequence and ordinary-tick costs against AAP.
