# PDP-10 testkit — outstanding work

Current ownership and registration baseline (2026-11-17): 2,108 compiler
matrix sources, 280 special entries (230 enabled direct, 44 manual,
6 nested), and 421 owned script paths. The authoritative counts come
from `COMPILER_MATRIX.tsv`, `SPECIAL_TESTS.tsv`, and their registered
audits. Checked milestones below are dated historical records, not
current inventory totals. The ownership split is documented in
`docs/TESTKIT-SCOPE-MIGRATION-20261117-v3.md`.

## PDP-6 Type 166 floating-point hardware fidelity (updated 2026-10-21)

- [x] Recover original DEC `FD-D-166-0-EMNF` normalization drawing and
  archive the relevant sheet in `refs/hardware`.
- [x] Reconstruct the disputed case-9 NRT shifts independently and compare
  the eleven state checkpoints with the original AAP pulse trace.
- [x] Verify the case-9 FAT alignment/register entry independently against
  the DEC floating-add and shift-datapath drawings.
- [x] Add a separate hardware-accurate case-9 guest oracle (AAP and SIMH,
  both KCC modes). Retain the unchanged, manual 24-case mathematical
  diagnostic, which now disagrees with the DEC hardware result at case 9.
- [x] Correct the isolated SIMH PDP-6 36-bit AR/MQ FAT/NRT path
  (SIMH commit `828459c`). Validate native-float/D-format, KPCODE2,
  negative-halfway, hardware case 9, independent AAP, and test inventory
  under both KCC modes as applicable.
- [ ] Characterize all 24 arithmetic boundaries against DEC hardware,
  recording any additional differences from the mathematical oracle.
- [ ] Characterize KA10/KI10/KS10/KL10 floating-point semantics separately.

Current verified state: `docs/PDP6-FP-SIMH-FIDELITY-20261021-v1.md`.
Original drawing/trace evidence:
`docs/PDP6-FP-NRT-HARDWARE-RESULT-20261020-v1.md`.

Status: 2026-10-21. This is the central checklist for **open** testkit work.

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
  The first PDP-6-only repair (`sims` commit `2e6612e`) was grounded in
  Stanford SAIL `10TO6.TED`; eight negative-halfway cases passed on AAP
  and SIMH. At that intermediate revision, SIMH also passed all 24
  *mathematical* boundary cases. The subsequent Type 166 AR/MQ hardware
  correction (`828459c`) supersedes its arithmetic implementation while
  retaining the passing negative-halfway regressions. The original
  `kcc-pdp6-negative-fp-runtime-v1` remains enabled.
- [x] Establish the original DEC Type 166 behavior for
  `-134217728.0F + 1.0F`: AAP and corrected SIMH both produce
  `0544000000003`, consistent with independent FDAS/EMNF reconstruction;
  the mathematical oracle produces `0544000000001`. The separate
  case-9 hardware regression passes on both emulators with KCC optimized
  and unoptimized. The 24-case mathematical test is **unchanged and
  manual**; its case-9 disagreement is not an AAP defect. The other 23
  cases are **not yet hardware-characterized**. See
  `docs/PDP6-FP-SIMH-FIDELITY-20261021-v1.md`.
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

- [x] Classify and individually check the first **ten** formerly deferred
  sources, connecting nine active matrix tests with exact observed
  GCC/KCC results. Two original 9-bit char sources require only the
  target macro spelling adaptation `__PDP10__` while preserving their
  assertions. One nested-function source passes only GCC PDP-6
  `-O0`; its three optimized GCC runtime failures remain recorded
  and scheduled. One other source requires hosted `malloc` and stays
  deferred; **none were dropped**. This was only a bounded first
  group, not a broad compiler sweep.
  See `docs/PDP10-DEFERRED-INTEGRATION-FIRST10-20261118-v8.md` and
  its ten-row SHA256-pinned TSV.
- [x] Review the next **ten** from the v2 deferred manifest. Six
  GCC PDP-6 compiler regressions were connected with exact,
  independently checked optimization applicability; three failing
  originals remain deferred. The sole removed original was an
  Alpha-only kernel/SIGBUS alignment test which executes only an
  empty helper and `exit(0)` on PDP-10; the reason was provided
  **before** deletion. Source hashes and 20 baseline/18 optimized
  cell outcomes are recorded in
  `docs/PDP10-DEFERRED-INTEGRATION-NEXT10-20261118-v9.md` and TSV.
- [x] Reconcile the newly active `20010124-1.c` with its exact
  PDP-10 duplicate without promoting the latter or scheduling its
  identical assertions twice. Source-review/census v3/v2 entries
  preserve the separately deferred KCC compiler limitation;
  the ownership auditor now accepts either source as the canonical
  active owner **only** with matching source activation and a
  compiler-specific deferred gate. All 50 pairs remain reviewed.
- [x] Review ten new deferred identities in batch 3 (v10). Seven
  source owners are connected, with GCC PDP-6 22 passing and six
  failing optimization cells; three KCC native PDP-6 sources also
  pass optimized and unoptimized. Three original GNU alignment and
  flexible-array-initializer runtime tests stay deferred, **none
  dropped**. The `20010904` `nonasserting` classifications were
  corrected because installed GCC defines `__PDP10__`, not the
  source's lowercase `__pdp10__`; the real assertions execute and
  fail. The weak `20010925` oracle is expressly not claimed as
  memcpy-content validation. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH03-20261118-v10.md` and
  its SHA256-pinned ten-row ledger.
- [x] Reconcile the promoted `20011113-1.c` GCC source with its
  byte-identical deferred PDP-10 copy in the versioned v4/v5
  duplicate census/review, retaining its independent KCC compiler
  gate and preventing two matrix registrations. All 50 pairs
  remain accounted for.
- [x] Review ten new source identities in batch 4 (v11). Five
  were connected with native PDP-6 GCC passing and failing
  optimization profiles; five retained deferred without deletion.
  KCC optimized failures on `20020219-1.c` and `20020402-3.c`
  are preserved without hiding their noopt successes. The
  `20020108-1.c` shift-test header problem is explicit: GCC's
  installed `limits.h` advertises 8-bit `CHAR_BIT` because
  it checks the wrong target macro, despite 9-bit target units;
  KCC instead skips all original cases with `CHAR_BIT=9`.
  No misleading passing shift coverage was registered.
  See `docs/PDP10-DEFERRED-INTEGRATION-BATCH04-20261118-v11.md`
  and its SHA256-pinned decision ledger.
- [x] Reconcile the active GCC `20020314-1.c` regression with
  its byte-identical deferred PDP-10 copy. The v6/v7 duplicate
  records preserve the separately blocked KCC `alloca` linkage
  without a second GCC registration. All 50 source pairs audited.
- [x] Review the next ten **unique, not previously reviewed** source
  identities in batch 5 (v12). Connect five meaningful compiler
  oracles with precise PDP-6 GCC profile results; retain five
  unresolved sources and remove none. Preserve the three genuine
  optimized GCC memcpy failures in `20020828-3.c`. Explicitly
  classify `920302-1.c` as a simulator timeout, not an asserted
  `strcmp` mismatch. `920428-1.s` remains a KL10 assembler
  auxiliary requiring its own harness; do not falsely treat a C
  compiler rejection as an ISA failure. Original `920415-1.c`
  GCC passes are vacuous (computed jump and abort optimized away);
  scratch-only stronger oracles expose a linker label defect, so
  no test was promoted. Removing unused `stdio.h` from a scratch
  `920501-6.c` still fails the original prime assertions. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH05-20261118-v12.md`
  and SHA256-pinned v12 decision ledger.
- [x] Review the next ten **unique, not previously reviewed** sources
  in batch 6 (v13). Seven original semantic oracles are connected
  with 28/28 passing GCC PDP-6 optimizer profiles. Correct only
  the target preprocessor condition for `920603-1.c` to recognize
  `__PDP10__` or historical `__pdp10__`; its real 18-bit
  signed-char conversion assertion now passes KCC native optimized
  and unoptimized as well as GCC O0/O1/O2/Os. Three hosted
  `printf/sprintf`/allocation tests stay deferred; no source
  was deleted. Avoid overstating the weak captured-variable and
  zero-length-array oracles. A real six-way computed goto and
  recursion/nonlocal jump were verified in GCC assembly and
  simulator execution. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH06-20261118-v13.md`
  and its original/current SHA256-pinned decision ledger.
- [x] Reconcile the promoted original `920721-4.c` extension
  source with its byte-identical PDP-10 duplicate in the v10/v11
  census/review; leave the latter deferred for the unsupported
  KCC nested label dialect and prevent duplicate GCC scheduling.
  All 50 source pairs retain their original hash identities.
- [x] Review the seventh group of ten unreviewed deferred sources
  (v14). Connect eight original compiler regressions with exact
  GCC/KCC PDP-6 outcomes; retain two without deletion.
  `920908-2.c` required only the `__PDP10__` or `__pdp10__`
  macro condition, preserving its original nine-bit bitfield
  numeric assertion; both compilers now pass. `921117-1.c`
  exposes GCC O1/O2/Os runtime failures and KCC optimized
  unresolved `strcmp` despite a KCC noopt pass. Preserve the
  KCC `930111-1.c` internal compiler error (`sizetype: null
  type`). The narrow default-only `920909-1.c` and
  `930111-1.c` switch oracles must not be described as full
  case-table coverage. `921215-1.c` stays deferred: the
  original passing O0 trampoline has no callback success
  assertion and its optimized modes fail. Source-pinned evidence
  and individual decisions:
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH07-20261118-v14.md`
  and its TSV.
- [x] Reconcile the three promoted generic GCC sources with
  byte-identical deferred PDP-10 copies (`920909-1.c`,
  `930106-1.c`, `930111-1.c`). The v12 census/v13 review
  preserves all 50 source hashes and separately retains the
  KCC linker, runtime and compiler-ICE blockers without
  duplicate GCC matrix registrations.
- [x] Review the eighth group of ten previously unreviewed
  deferred sources (v15). Six original source owners are now
  connected with 21 passing and three failing GCC PDP-6 profiles
  and six passing KCC profiles. `930725-1.c` passes GCC O0
  but fails O1/O2/Os with the original actual `strcmp` oracle;
  KCC noopt and optimized pass. `930921-1.c` retains its
  original reciprocal constant and independently checks 10,000
  small input values, not the entire native 36-bit unsigned range.
  `930406-1.c` has only a local-label termination oracle.
  `950221-1.c` tests long argument ABI but not its unreachable
  `strcpy` path. Four cases stay deferred: `930513-1.c`
  and `941014-2.c` need hosted formatting/allocation;
  `931002-1.c` times out in the simulator without an observed
  callback success; and `931110-1.c` stores zeros to already-zero
  globals without asserting the result. No source was modified or
  dropped. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH08-20261118-v15.md`
  and the original-source SHA256-pinned ten-row ledger.
- [x] Review ten previously unreviewed deferred sources in batch 9
  (v16). Connect eight original source owners with 28 verified
  passing and four failing GCC PDP-6 optimization profiles; KCC
  adds six passing and eight conservatively failing native profiles.
  The original tests `950605-1.c` and `950704-1.c` both had
  a lowercase-only `__pdp10__` guard; use either the installed
  `__PDP10__` or historical lowercase spelling to retain the
  exact original 9-bit unsigned-char and 71-bit signed-overflow
  numeric expectations. GCC passes all four modes for
  `950605-1.c` but KCC fails both. Conversely, KCC passes both
  modes for `950704-1.c` while GCC fails all four. KCC
  optimized-only failures in `950607-2.c` and `960321-1.c`
  are preserved separately from successful unoptimized runs.
  The empty GNU asm barrier `960312-1.c` is registered for
  compiler register/liveness behavior, **not ISA execution**.
  `960117-1.c` remains deferred without a readback assertion
  and `960327-1.c` still requires hosted `sprintf`. No
  source was removed, and no original expected result was changed.
  See `docs/PDP10-DEFERRED-INTEGRATION-BATCH09-20261118-v16.md`
  and its original/current SHA256 source ledger.
- [x] Review ten new deferred identities in batch 10 (v17).
  Connect six source owners with **24 passing native PDP-6 GCC
  profiles** and **four passing / four conservatively failing KCC
  profiles**. Adapt the lowercase-only `__pdp10__` guard in
  `961017-2.c` to also recognize installed `__PDP10__`; the
  unchanged 36-bit wraparound loop and original limit now pass
  both GCC/KCC optimized and unoptimized. Preserve KCC optimized
  failure in `961206-1.c` despite its passing noopt test, and
  both KCC failures in `970217-1.c`. Register
  `980506-3.c` only for actual `strlen`/`memset` call and
  return-value behavior, **not** memset content verification.
  `960416-1.c` remains deferred because its union-layout
  predicates can bypass both assertions, `960521-1.c` because
  real hosted `malloc` is missing, and `961122-1.c` because
  its genuine signed-wide shift/add assertions fail in GCC/KCC.
  Remove only `960830-1.c`: its x86-only inline `mull` and
  all assertions are behind `__i386__`, with only `exit(0)`
  on PDP-10. The reason was explicitly provided before removal;
  source is preserved in Git history. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH10-20261118-v17.md`
  and the original/current SHA256-pinned ten-row TSV.
- [x] Review ten new deferred identities in batch 11 (v18):
  five connected owners, four retained deferred, one explicitly
  explained removal. `980526-1.c` actually executes both
  GNU-label computed-goto paths, checked in emitted assembly and
  through simulator execution. `990106-2.c`'s original unsigned
  36-bit modular arithmetic value 1008 is preserved by recognizing
  the installed `__PDP10__` macro as well as historical lowercase;
  KCC noopt/optimized pass but GCC O0/O1/O2/Os all fail.
  The identical deferred PDP-10 copy receives the same one-line
  correction, is hash-reconciled in v14 duplicate census/v15
  duplicate review, and remains unscheduled. `990127-2.c`
  has a KCC optimized-only floating equality failure despite
  unoptimized pass. `990130-1.c` tests GNU empty extended-asm
  operand evaluation, not any PDP-10 ISA opcode.
  `990324-1.c` tests a native 9-bit signed-char cast: KCC
  both modes and GCC O1/O2/Os pass, while GCC O0 fails.
  `980526-2.c` remains deferred for its fixed Linux 32-bit
  device-number encoding; `980605-1.c` requires actual
  `sprintf`; `980707-1.c` requires actual `isspace` and
  `ctype.h`; `980709-1.c` requires actual math headers
  and `pow`. Remove only `990413-2.c`, whose x87
  `fpatan`/`fsqrt` register-stack constraints have no PDP-10
  implementation or executable target assertion. This exact
  reason was provided before deletion; original remains in Git.
  See `docs/PDP10-DEFERRED-INTEGRATION-BATCH11-20261118-v18.md`
  and its exact original/current SHA256-pinned ten-row ledger.
- [x] Review the next ten unreviewed deferred source identities in
  batch 12 (v19). Connect five original tests, retaining five
  without deletion. `990513-1.c` passes both KCC modes and all
  GCC modes with real `memset`/backward fill assertion.
  `990525-1.c` exercises the for-loop update's struct copy:
  GCC all modes and KCC noopt pass, KCC optimized fails.
  `991014-1.c` exercises huge-type size and field-offset
  calculations, **not large physical allocation**; GCC all
  modes pass and KCC both fail. Reconcile its identical
  PDP-10 copy to active GCC/deferred KCC in v16 duplicate census
  and v17 review. `991030-1.c` tests the original hexadecimal
  floating initializer; GCC all pass, KCC both fail.
  Connect `991216-3.c` specifically as an **all-failing GCC**
  old-style varargs/long-long ABI regression with real
  `va_arg` assertions and eight original call sites; KCC
  old-style varargs syntax remains unsupported.
  Retain `990628-1.c` for real `malloc`, `990826-0.c` for
  real `floor`/libm, `991112-1.c` for actual `isprint`,
  `991118-1.c` for independent native 71-bit bitfield
  expectations, and `991228-1.c` for the GCC O0
  `instantiate_virtual_regs_1` ICE. Its apparent optimized
  passes bypass `signbit` and are not promoted.
  See `docs/PDP10-DEFERRED-INTEGRATION-BATCH12-20261118-v19.md`
  and original-source SHA256-pinned decision ledger.
- [x] Review the thirteenth group of ten previously unreviewed
  deferred sources (v20). Connect five GCC owners:
  `ashldi-1.c` and `ashrdi-1.c` pass O0/O1/O2/Os using
  their unchanged 71-bit target reference tables, including
  variable/constant shift and sign-extension checks.
  `bcp-1.c` passes O0/O1/O2/Os; only optimized modes execute
  its `__OPTIMIZE__`-specific `__builtin_constant_p` checks.
  Preserve KCC's noopt internal `dodecl: scope mismatch`
  errors for later compiler repair. `bf-layout-1.c` passes
  only the asserted bitfield aggregate `sizeof` equality,
  not field readback. `bf-pack-1.c` is deliberately connected
  as **four failing GCC profiles**, since the source reads back
  both packed fields and aborts on mismatch.
  Retain `align-1.c` (its aligned typedef is never asserted),
  `arith-ll.c` (requires real `printf`), `arith-rand.c`
  (8-bit-width generator assumptions and potential zero divisors),
  `bf-sign-2.c` (32-bit-int promotion assumptions), and
  `bf64-1.c` (71-bit signed bitfield sign-extension oracle
  not independently derived). No source edited or deleted.
  Reconcile all five byte-identical active/deferred source pairs
  in duplicate census v18/review v19, including the two
  wide-int copies where the active owner is the B side.
  Original SHA256 and all native PDP-6 outcomes are recorded in
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH13-20261118-v20.md`
  and its ten-row v20 TSV.
- [x] Consolidate **all 97** byte-identical upstream source pairs:
  50 containing a deferred copy and 47 active/active pairs whose
  complete compiler matrix profile vectors are equal. Retain one
  canonical source, eliminate 97 redundant files and 47 duplicate
  active test registrations, and reduce the live deferred list by
  50 aliases without eliminating any distinct assertion. The
  versioned v21 provenance table pins both original import paths,
  classifications, compiler profile status and exact source SHA256,
  with all removed bytes recoverable in Git history.
  Preserve **13 KCC and three GCC** independently recorded
  compiler blockers as 16 actionable compiler gates, and merge
  four distinct alternate deferred dispositions into the canonical
  evidence. Replace the old active/deferred-only 50-pair audit with
  `tools/audit_consolidated_upstream_v21.py`, which now requires
  zero classified upstream duplicate hashes. Six focused native
  PDP-6 executions verified five expected passes and one expected
  `bf-pack-1.c` GCC runtime failure after the consolidation.
  Detailed record:
  `docs/UPSTREAM-DUPLICATE-CONSOLIDATION-20261118-v21.md`.
- [x] Review batch 14 (v22), the next ten canonical deferred
  source identities after duplicate consolidation. Connect six:
  `bitfld-2.c` for nonstandard short-bitfield structure `sizeof`
  equality; `built-in-setjmp.c` for real nonlocal transfer and
  stack string preservation (**GCC O0 passes, O1/O2/Os abort**);
  `builtin-abs-1.c` and `builtin-abs-2.c` for standard and
  explicit builtin absolute values over int/long/long-long/intmax;
  `builtin-complex-1.c` for volatile float/double/long-double
  complex conjugate/real/imag checks; and
  `builtin-prefetch-4.c` for **22 real side-effect assertions**
  evaluating the address argument to prefetch on a target lacking
  a prefetch instruction. Register **21 passing and three
  failing GCC native PDP-6 profiles**; KCC missing extension or
  hosted prerequisites remain `no_test`, not invented successes.
  Retain `builtin-noret-1.c` for nonportable hosted exit/noreturn
  linkage, and `builtin-prefetch-1.c` through `-3.c` because
  their successful GCC O0 no-prefetch executions contain **no
  observable assertions**. Original bytes and numeric assertions
  unchanged. Update the v21 consolidation auditor to permit
  hash-stable deferred-to-active canonical transitions while
  rejecting demotions or absent matrix registrations. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH14-20261118-v22.md`
  and its SHA256-pinned ten-row TSV.
- [x] Review batch 15 (v23), the next ten unique deferred tests
  after consolidation, and connect six. `builtin-types-compatible-p.c`
  verifies GNU constant-folded array-bound, qualifiers, enum, array,
  typedef and pointer type compatibility (GCC O0/O1/O2/Os pass).
  `cmpdi-1.c` has an original **640-entry** signed/unsigned
  long-long comparison oracle; independently recomputing all
  640 expected outcomes confirms the existing 71-bit PDP-10
  values. Adapt the single `__pdp10__` guard to also recognize
  installed `__PDP10__`, **without changing any expected value**:
  GCC O0/O1/O2/Os all pass; KCC noopt passes, optimized runtime
  fails, with conservative KCC matrix status `fail`.
  `comp-goto-2.c` executes a real recursive nested helper and
  indirect nonlocal `JRST` with O0/O2 assembly evidence;
  `complex-1.c` executes complex real/imag operations (GCC all
  pass). `complex-2.c` executes by-value complex addition with
  **GCC O0 failure** but O1/O2/Os passes. `complex-4.c` passes
  only constant-folded complex/scalar +/-0 comparison, **not**
  runtime FP behavior.
  Retain `builtin-prefetch-5.c` and `-6.c` as no-prefetch
  target smoke tests with no observable assertions or sound
  9-bit pointer-width oracle; retain `cbrt.c`, whose genuine
  PDP-10 exclusion would skip all cube-root assertions, and
  `comp-goto-1.c`, which requires real `malloc` and independent
  PDP-10 address/byte model validation. No source deleted.
  Register **23 passing / one failing GCC native PDP-6 profiles**
  plus KCC `cmpdi-1.c` as conservatively failing (actual mode
  split preserved). The complete ten-row original/current SHA256
  and compiler execution record is
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH15-20261118-v23.md`
  and accompanying v23 TSV.
- [x] Review batch 16 (v24), the next ten unique canonical deferred
  sources. Connect six: `complex-5.c` float-complex addition,
  `compndlit-1.c` compound-literal bitfield assignment and
  statement expression, `cvt-1.c` double/long conversions,
  `divconst-2.c` signed division/remainder recomposition against
  -2147483648 in a 36-bit signed long, `loop-3c.c` INT_MAX
  loop-bound/shift index writes, and full-size `memcpy-1.c`
  original copy/fill/readback loops. Register **23 passing and
  one failing GCC native PDP-6 profiles** (`memcpy-1.c` O0
  fails), and two passing/six failing selected KCC profiles:
  `divconst-2.c` passes both modes, `cvt-1.c` passes
  noopt only, `loop-3c.c` and `memcpy-1.c` fail both.
  Correct a **testkit harness defect** in `run-tests.py`:
  optimized GCC emits direct `JRST memcpy` instead of
  `PUSHJ 17,memcpy`; the freestanding archive dependency
  scanner must recognize **both** and select real memcpy, not
  a stub. The unchanged `memcpy-1.c` now passes GCC O2/Os
  on focused rerun; the original link failures and corrected
  results are separately documented in the v24 ledger.
  Retain `eeprof-1.c` for missing explicit
  `-finstrument-functions` invocation, `gofast.c` for real
  hosted `stdio/fprintf`, `index-1.c` for **dlink RH18
  relocation overflow** (GCC all levels and KCC optimized;
  KCC noopt passes), and `inst-check.c` because `main`
  never calls the purported sum function or checks any value.
  Preserve the v21 source-alias linker gate, source SHA256,
  and all original C bytes. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH16-20261118-v24.md`
  and accompanying ten-row v24 TSV.
- [x] Review batch 17 (v25), the next ten unreviewed canonical
  deferred tests. Connect seven sources with real assertions:
  `memcpy-2.c` (both-end alignment and length, return pointer,
  copied bytes and untouched prefix/suffix), `memcpy-bi.c`
  (80 lengths of memset/memcpy checked by actual memcmp),
  `memset-1.c` (three fill values and full prefix/filled/suffix
  readback), `nest-stdar-1.c` (GNU nested variadic double
  va_arg), `nestfunc-1.c` (nested function callback through
  pointer), `nestfunc-2.c` (seven-argument nested callback,
  global z and accumulated sum), and `20020507-3.c`
  (leading native 9-bit byte readback of a copied negative
  36-bit integer). Register **15 passing/13 failing native GCC
  PDP-6 profiles** and **six passing/two failing native KCC
  PDP-6 profiles**. `memcpy-bi.c` passes GCC O0 but aborts
  O1/O2/Os; `nestfunc-2.c` passes O0/O1 but aborts O2/Os.
  KCC passes both modes of all three memory-library tests,
  while GCC `memcpy-2.c` and `memset-1.c` abort all modes.
  Retain `nestfunc-3.c`, since GCC O0/O1/O2 SIMH execution
  times out with no examine status and Os reaches abort;
  do not label those three timeouts verified assertion failures.
  Retain `old.tort.c` for real hosted XKL/TOPS20 pointer and
  printf support (the native non-TOPS20 branch exits 256 even
  on apparent success), and `packed-2.c`, whose only action
  is storing zero into a packed member without any readback
  or packing-size oracle. No C source adaptation or deletion.
  Preserve source SHA256 and all exact compiler outcomes in
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH17-20261118-v25.md`
  and the matching ten-row v25 TSV.
- [x] Review batch 18 (v26), ten new original canonical sources.
  Connect five actual assertion-bearing regressions:
  `ll-1.c` checks a 71-bit-capable GNU `mode(DI)` value
  passed as the fourth function parameter (GCC 4/4 pass,
  KCC extension unsupported); `strct-1.c` checks three
  scalars followed by a two-field structure by value
  (GCC O0 abort, O1/O2/Os pass; KCC noopt passes, optimized
  aborts); `scope-1.c` checks inner-block `extern`
  resolution of an external file-scope object and
  `scope-2.c` the analogous **internal/static** object
  (GCC both 4/4 pass; KCC both modes abort); and
  `strcmp-1.c` checks actual sign/equality results from
  freestanding `strcmp` across two alignment offsets, lengths
  and native-9-bit 0251/0252 high bytes (KCC both modes
  and GCC all four modes pass).
  Register **19 passing/one failing GCC** and **two passing/
  six conservatively failing KCC** native PDP-6 profiles.
  Retain `pdp10/pdp10/conversion.c` (GCC undefined
  `__fixunssfsi`, KCC both modes abort; conversion ABI
  unresolved), `strct-varg-1b.c` (real hosted printf must
  work before two structure va_arg checks), and all three
  `stdio-opt-1.c` through `-3.c` hosted stdio/builtin
  transformation tests (missing or incompatible FILE/printf
  dependencies). No original source edited/deleted; no fake
  conversion routine or hosted formatter. Complete v26 source
  hashes, decisions and bounded compiler evidence in
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH18-20261118-v26.md`
  and its ten-row v26 TSV.
- [x] Review batch 19 (v27), the next ten unique canonical
  deferred sources. Connect nine: `strct-varg-1.c` exercises
  two structures and an intervening scalar passed through
  `va_arg` (KCC noopt/optimized and GCC O0/O1/O2/Os all
  pass after **only** a five-line PDP-10-only prefix selects
  the original existing `NO_VARARGS`/`stdarg.h` branch);
  `string-opt-1.c` checks `strstr` pointer identities
  (GCC all four modes abort); `string-opt-10.c` checks
  strncat destination, contents and pointer/scalar side
  effects (GCC four passes); `string-opt-11.c` checks
  strspn spans and side effects (GCC four aborts);
  `string-opt-12.c` checks strcspn and pointer side effects
  (GCC O0 pass, O1/O2/Os abort); `string-opt-13.c`
  tests strlen comparisons around zero (GCC four passes);
  `string-opt-14.c` tests **optimized-only** removal
  of zero-length memcpy/memset using the source's aborting
  local functions (GCC four passes, without claiming runtime
  memory readback); `string-opt-15.c` tests zero/one-byte
  memcmp sign checks (GCC O0 pass, O1/O2/Os abort);
  and `string-opt-16.c` tests constant-folding of three
  fixed memcmp results (GCC O0 passes, O1/O2/Os
  **LINK_FAIL** on intentionally undefined `link_error`,
  registered `error`, **not** runtime failure).
  New registrations: **19 GCC passes, 14 GCC runtime
  failures, three GCC compile/link errors**, plus **two
  KCC passes** for `strct-varg-1.c`.
  Retain `strct-pack-2.c` because its only assignment
  lacks an assertion of packing, alignment or pointer
  contents. Keep all original expected values. Preserve
  the historical v21 SHA256 for the canonical varargs
  source and the retired alias while verifying the exact
  v27 source-prefix reconstruction against both original
  and current SHA256s. Note the exploratory
  `profile.extra` GCC flag was not forwarded by the
  runner: actual edited-source executions, not that
  scratch result, support the passing compiler profiles.
  No deletion, broad CPU/compiler run, or manual special
  suite. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH19-20261118-v27.md`
  and its ten-row source-pinned TSV.
- [x] Review batch 20 (v28), all ten next unreviewed original
  canonical sources; all ten are activated with real original
  assertions and **zero C source changes/deletions**.
  `string-opt-2.c` (`strpbrk` exact returned pointer and
  argument side effects), `string-opt-3.c` (combined
  strlen/strcmp/strrchr/rindex results and increments),
  `string-opt-5.c` (multiple GNU string/memory builtins
  and x/y argument effects), `string-opt-6.c` (strcpy/memcpy
  return and memcmp buffer readback), and
  `string-opt-8.c` (generic strncmp sign/length/pointer/n
  increment checks) abort in GCC PDP-6 all O0/O1/O2/Os
  profiles despite genuine freestanding string library
  linkage. `string-opt-4.c` (strchr/index first/next/NUL
  pointer), `string-opt-7.c` (strncpy length/padding and
  two argument increments), and `string-opt-9.c` (strcat
  destination/contents and ++d2) pass GCC O0 but abort at
  O1/O2/Os. The source platform-conditional i386/pj/i370
  extra tests in `string-opt-8.c` remain excluded on PDP-6;
  real generic checks still execute. `strlen-1.c` loops
  over aligned source offsets and exact NUL-terminated
  lengths: KCC both modes pass, GCC all four modes abort.
  `strncmp-1.c` checks alignment, prefix length and signs
  including native 9-bit 0251/0252 characters: KCC both
  modes and GCC all four modes pass. Register exactly
  **seven GCC passes, 33 GCC runtime failures and four
  KCC passing** PDP-6 native profiles. KCC both modes of
  `string-opt-2.c` and `-4.c` link-fail with undefined
  GNU-specific `__builtin_strpbrk`/`__builtin_strchr`,
  even though actual ordinary libc routines link; retain
  those precise results but do not select unsupported
  GNU-builtin KCC profiles. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH20-20261118-v28.md`
  and its ten-row SHA256-pinned TSV.
- [x] Review batch 21 (v29): the next ten unique original
  canonical sources. Connect nine assertion-bearing tests.
  `struct-ini-4.c` checks original GNU `c:` field-designator
  initialization (GCC all four pass; KCC syntax unsupported).
  `tmp.c` checks original signed long-long **37-bit** field
  readback `0xc00000000` (GCC all four pass; KCC type
  extension unsupported). Independently validate all **36**
  expected signed-zero comparisons in `tstdi-1.c` against
  the original 71-bit PDP-10 constants; the lone source
  correction recognizes uppercase `__PDP10__` as well as
  historical lowercase, without touching any expected number.
  Corrected GCC O0/O1/O2/Os pass; KCC noopt passes but
  optimized aborts, registered conservatively as `fail`
  and prioritized for later compiler repair.
  `va-arg-10.c` and `va-arg-2.c` check sixteen different
  fixed/variadic argument splits; `va-arg-10.c` also uses
  `va_copy` and consumes both original and copied lists.
  Both fail GCC O0 but pass O1/O2/Os; KCC fails to compile
  the GNU `__SIZE_TYPE__` declaration, not a runtime test.
  `va-arg-15.c`, `-16.c`, `-17.c`, and `-19.c`
  check old-style va_alist/va_dcl alternated int/double,
  named and variadic double, nine double, and nine int
  values respectively. All four abort at all GCC modes
  and KCC lacks obsolete varargs.h/va_dcl; retain
  the original ABI oracle, not a fake stdarg conversion.
  The `NO_VARARGS` branch of `va-arg-19.c` is vacuous
  and deliberately not selected. Retain hosted
  `struct-ret-1.c`: KCC cannot link genuine `sprintf`,
  GCC cannot compile hosted stdio; the source only compares
  formatted arguments and does not check returned X fields.
  **18 passing and 18 failing GCC native profiles**, plus
  KCC `tstdi-1.c` conservatively two failing slots;
  all other KCC GNU/obsolete ABI modes unsupported.
  Exactly one original C line changed and no source deleted.
  See `docs/PDP10-DEFERRED-INTEGRATION-BATCH21-20261118-v29.md`
  and the ten-row, original/current source-hash TSV.
- [x] Review the final ten previously unreviewed canonical
  source identities in batch 22 (v30). Nine original tests
  now have registered native PDP-6 GCC profiles: `va-arg-22.c`
  verifies 21 GNU variadic aggregate sizes, each passed by
  value and read back via `va_arg(typeof)` (GCC four
  aborts); `va-arg-3.c` tests original 16-function old-style
  varargs register/stack splits (four aborts; do not enable
  vacuous NO_VARARGS exit); `va-arg-7.c` tests three
  trailing ints after seven ints and nine doubles (four
  aborts); `va-arg-8.c` checks trailing int and wide
  long-long arguments (four aborts). The deployed
  limits.h advertises `__LONG_LONG_MAX__ == 2^63-1`,
  while the compiler also defines `__LONG_LONG_71BIT__`;
  the original guarded test really executes, but is NOT
  evidence of an exclusively 64-bit ABI. `va-arg-9.c`
  forwards va_list through fap across the original 16
  call arrangements (GCC O0 abort, O1/O2/Os pass).
  `wchar_t-1.c` checks non-ASCII wide string and wide
  character literal size/values (GCC four aborts).
  The actual source character is **raw Latin-1 byte 0xC4**
  and was not transcoded; the original wide string
  has eight elements instead of two in compiled GCC
  code: original-byte scratch output confirms sizeof(x)=32
  and sizeof(wchar_t)=4. `widechar-2.c` checks four wide elements
  in L"foo" (GCC four passes). `zerolen-1.c` tests GNU
  zero-length member overlay (GCC four passes; intentionally
  not portable ISO C indexing), and `zerolen-2.c`
  checks GNU zero-length word-member sizeof/alignof
  (GCC four passes, a compile-time layout oracle).
  **15 GCC passes / 21 genuine guest aborts** are newly
  registered. KCC noopt cannot compile any of the nine
  supported GCC originals, so no KCC success is invented.
  `va-arg-21.c` remains deferred: real malloc/vprintf
  and hosted stdio are required to exercise its va_end
  pointer-side-effect assertion. No original C file
  changed and no source deleted. See
  `docs/PDP10-DEFERRED-INTEGRATION-BATCH22-20261118-v30.md`
  and its original/current SHA256-pinned ten-row ledger.
- [ ] **Next stage after completing all 22 bounded
  source reviews:** triage the **67 reviewed but deferred**
  canonical identities by underlying blocker, prioritizing
  reproducible assembler/compiler bugs over libc/header
  enablement and feature-policy debates. Preserve 16
  independently tracked consolidated compiler repair
  gates; zero deferred identities still await a first
  individual review. Do not silently drop nonportable
  tests or invent passing slots for unsupported compilers.
  Explain any proposed deletion first. Broad CPU/compiler
  sweeps and all 44 manually gated special suites remain
  separate work, not part of the completed first-review
  stage.

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
- [x] Review all 50 byte-identical deferred/source pairs and assign one
  canonical owner per identical source/assertion, preserving separate
  compiler/profile blockers and nonowner source snapshots. All 48
  deferred/deferred pairs remain deferred; both active/deferred pairs
  retain their existing matrix registrations and independently observed
  GCC PDP-6 runtime failures at `-O0`/`-O2` despite KCC passes.
  Six distinct disposition conflicts retain both original blockers.
  Exact source assertions, profiles, hash pins, owner decisions and
  prerequisite gates are in
  `docs/DEFERRED-SOURCE-DUPLICATES-20261117-v2.tsv` and the v2 review.
  No duplicate was removed, no deferred oracle was spuriously enabled.
- [x] Integrate a fail-closed static duplicate-source inventory into the
  existing registered `test-inventory-v1` verifier; reject new, stale or
  changed deferred/active source-collision evidence without executing tests.
  See `docs/DEFERRED-SOURCE-DUPLICATES-20261116-v1.md`.
- [ ] Verify deferred blockers with current target headers, libc, varargs,
  and supported GCC-only execution. Progress class by class; do not assign
  compiler defects to missing runtime prerequisites. Use the versioned
  disposition manifest for each follow-up. A first 10-source, 20-cell
  sample and immutable 269-row prerequisite grouping are recorded in
  `docs/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261117-v1.md` and
  `docs/PDP10-DEFERRED-BLOCKER-TRIAGE-20261117-v1.tsv`. A follow-up
  27-source, 54-cell libc/header batch is recorded in the 2026-11-18
  v2 report and source-pinned triage TSV. Preserve the newly exposed
  `malloc` hosted-runtime gaps, unresolved compiler built-ins,
  and actual run failures as independent issues.
  The v4 source-pinned ledger covers all 26 `varargs-abi` sources
  with operational PDP-6 KCC `-n` and GCC `-O0`: KCC 23 compile
  failures/three link failures; GCC two compile failures, one link
  failure and 23 runtime failures. None was activated. See
  `docs/PDP10-VARARGS-AND-GCC-ICE-20261118-v4.md`.
- [x] Reproduce and eliminate the genuine GCC compiler ICE for
  dynamically sized `va_arg` on original `20020412-1.c`.
  `pdp10-gcc` `66f5a15` computes runtime word-aligned argument
  size rather than aborting in the backend. The installed compiler
  passes a registered compile-only 4-CPU x 4-optimization (16/16)
  regression, preserving the separate failing runtime oracle.
- [ ] DEFER TO FULL COMPILER SWEEP: investigate the separately exposed GCC
  variadic VLA aggregate-copy ABI:
  unchanged `20020412-1.c` now executes with real freestanding
  `memcpy` but aborts at its first digit. Investigate raw word
  addresses versus 9-bit-byte-pointer arguments; do not weaken the
  C assertion or count ICE elimination as an execution pass. Focused
  scratch-only pointer-conversion experiments do not fix it: the
  outgoing-copy conversion can cause a long `memcpy` loop, so the
  correct stack extent, byte count and source/destination addresses
  must be traced together before changing GCC or libc. See
  `docs/PDP10-GCC-VLA-AGGREGATE-COPY-20261118-v6.md`.
  The original source stays deferred and its compiler/ABI runtime failure
  is recorded. Do **not** pursue this during harness and unconnected-test
  integration; other compiler failures can be triaged together in the
  subsequent full sweep.
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
  tests, KL10-specific `tests/semantic/upstream/support/920428-1.s`, varargs/header/runtime
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

- [x] Add exact-ID specialized test invocation for deliberately
  nonautomatic registered roots. `run-misc-tests.sh list-manual`
  enumerates all 44 manual tests; `run-id ID` executes only an enabled
  root, and `run-id ID --manual` explicitly opts in to a manual root.
  Nested DAS and prepared tools remain gated. Dispatch tests verify
  exact selection, manual/nested rejection and all listing identities;
  the selected host script-ownership auditor executes and passes.
  Static inventory still reports zero orphan sources/scripts.
  See `docs/PDP10-HARNESS-SELECTED-TESTS-20261118-v7.md`.

- [x] Preserve 18 reviewed GCC target artifacts outside the GCC source
  tree and register twelve independent compiler/codegen oracles in the
  DejaGNU-free `misc/validation/test-gcc-target-codegen-v2.py` runner.
  See `docs/GCC-DEJAGNU-REMOVAL-20261116-v2.md`.
- [x] Verify the four original GCC target shell assertions under their
  canonical enabled owners. The three source wrappers execute the
  original preserved shell probes, all PASS. The fourth, bare GCC BADL
  linking, is covered by the stronger already registered `badl-tables`
  test: direct GCC link and PDP-6/KA10 guest execution PASS. Fix only
  the harness's missing installed SIMH default path selection; preserve
  explicit simulator overrides. The two companion C files are not
  standalone semantic tests. See the GCC target ownership v2 review.

- [x] Review original GCC PDP-10 target C regression feasibility and drop the
  ITS-only CIRC case rather than inventing a false generic PDP-10 adaptation.
  See `docs/GCC-C-FEASIBILITY-REVIEW-20261116-v1.md` and its target TSV.
- [x] Retire the two central GCC-only codegen sources whose assertions are
  already GCC-owned (BSS zero aggregate and SIXBIT/indexing). Keep the
  cross-compiler copies that also exercise KCC. The GCC-owned suite must
  still receive independent DejaGNU execution/optimization validation.
- [x] Manually review the 679 non-PDP-10-target original GCC C sources in
  the feasibility preflight before proposing further imports or removals.
  Preserve the original assertion and derive native 36-bit/9-bit/non-IEEE
  expectations; do not mistake a successful compile for meaningful coverage.
  Of the 679 original source blobs, **560 are retained and hash-pinned** in
  `refs/gcc-c-unmirrored-v1/`; **119 reviewed inapplicable originals have been
  deleted**. All 679 remain indexed with per-file classification in
  `docs/GCC-C-UNMIRRORED-OWNERSHIP-20261116-v1.tsv`. First manual crosswalk:
  six existing active adaptations, two deferred adaptations, one partial
  compile-only overlap, one same-name but non-equivalent diagnostic test,
  13 newly registered PDP-10 GCC runtime tests awaiting execution, 64
  additional same-name reviews, two non-equivalent overlaps, and 591
  other initially unreviewed sources. Batch 01 subsequently reviewed 50:
  17 additional PDP-10 tests registered as pending, 10 deferred,
  and 23 inapplicable. Batch 02 reviewed 50 further sources: 11 tests
  registered, 16 deferred, 23 inapplicable. Batch 03 reviewed the next
  50 gcc.dg originals: seven registered, 22 deferred and 21 inapplicable.
  Batch 04 reviewed another 50 gcc.dg originals: five registered,
  25 deferred and 20 inapplicable. Batch 05 reviewed another 50:
  four registered, 45 deferred and one inapplicable.
  Batch 06 reviewed another 50: 12 registered, 37 deferred and
  one x86 ISA-specific inapplicable case. Batch 07 reviewed the next
  50 CPP originals: 11 registered, 39 deferred, none inapplicable.
  Batch 08 reviewed another 50 CPP originals, with seven pending tests,
  43 deferred and none inapplicable. Batch 09 reviewed 50 more CPP
  originals: 19 registered, 31 deferred, none inapplicable.
  Batch 10 reviewed 50 more CPP/debug/GCC diagnostic/PE originals:
  three registered, 42 deferred, five inapplicable and deleted.
  Batch 11 reviewed 50 `gcc.dg/format` originals: all 50 deferred
  pending exact diagnostic and language-mode oracles, with no new
  registrations or deletions. Batches 12-14 finished the remaining
  105 originals (50/50/5): ten registered, 70 deferred, 25
  inapplicable and deleted. **No source remains unreviewed or
  same-name-review.** Do not
  count preserved reference files as activated tests.
- [x] Delete all 89 inapplicable original GCC source snapshots classified
  in batches 01-06 (23, 23, 21, 20, 1, 1). Keep only review metadata,
  original SHA256 fingerprints and rationales in the versioned tombstone
  manifest `docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v1.tsv`.
  Re-imports must not restore deleted sources, and the static verifier
  rejects any reappearance. Preserve the 590 retained originals and all
  25 still-referenced local include companions. No active test removed.
- [x] Remove five more inapplicable original GCC snapshots from batch10:
  one i386 32-bit traditional CPP source and four ARM/Thumb PE DLL tests.
  Preserve the unchanged original 89-row tombstone v1 manifest and
  publish the complete **94-row** v2 tombstone manifest and review at
  `docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v2.tsv` and
  `docs/GCC-C-INAPPLICABLE-REMOVALS-REVIEW-20261117-v2.md`.
  Enforce removal on re-import; 585 C originals remain retained.
- [x] Complete a 50-source GCC integration batch with one recorded
  compatibility and oracle decision per source, 17 versioned adapted
  regressions and 68 pending PDP-6 GCC matrix cells. See
  `docs/GCC-C-BATCH01-REVIEW-20261116-v1.md` and its source-hash-pinned TSV.
- [x] Review KCC applicability of all 30 registered historical GCC runtime
  sources (17 batch-01 adaptations and 13 earlier PDP-10 regressions):
  20 retain KCC semantic oracles and gained PDP-6 native/base `pending`
  cells (40 added), while 10 remain GCC-only exact-width/packing tests.
  See `docs/GCC-C-KCC-CROSS-COMPILER-20261117-v1.md` and its TSV.
- [x] Review GCC integration batch 02, covering five torture execute,
  ten torture compile, and 35 gcc.dg original sources with 11 new PDP-10
  test cases (8 runtime and 3 compile-only). Register 40 new pending
  GCC optimization cells and 18 KCC native/base cells, each with a
  per-source compiler/ABI and oracle review. Sixteen deferred and 23
  inapplicable source records remain owned but inactive. See
  `docs/GCC-C-BATCH02-REVIEW-20261117-v1.md` and its TSV.
- [x] Review GCC integration batch 03: 50 gcc.dg sources, with seven
  adapted/registered pending test cases (3 runtime, 4 compile-only),
  22 deferred and 21 inapplicable originals. Share six tests with KCC
  and retain one GCC-only wide bitfield case; add 28 GCC and 12 KCC
  pending PDP-6 matrix cells. See
  `docs/GCC-C-BATCH03-REVIEW-20261117-v1.md` and its TSV.
- [x] Review GCC integration batch 04: 50 gcc.dg originals, five
  compile-only pending owners (two shared GCC/KCC and three GCC-only
  inline-asm sources, two with exact assembly-output regex oracles),
  25 deferred and 20 inapplicable. Register 20 new GCC and four KCC
  pending PDP-6 cells. See
  `docs/GCC-C-BATCH04-REVIEW-20261117-v1.md` and its TSV.
- [x] Review GCC integration batch 05: 50 original gcc.dg sources,
  four test owners (two KCC/GCC-shared C99, two GCC-only GNU extensions),
  45 deferred and one inapplicable original. Register ten PDP-6 GCC
  and four PDP-6 KCC pending cells, using exact original optimizer
  selections for forced-inlining `-O0` and choose-expression `-O1`.
  See `docs/GCC-C-BATCH05-REVIEW-20261117-v1.md` and its TSV.
- [x] Review GCC integration batch 06: 50 further gcc.dg/cpp originals,
  with 12 pending test sources (nine runtime, three compile-only),
  nine KCC/GCC-shared oracles and three GCC-only C99 lexical/object
  cases. Defer 37 original diagnostics/link/representation cases,
  classify one x86 assembler source inapplicable, and add 48 GCC plus
  18 KCC pending PDP-6 matrix cells. See
  `docs/GCC-C-BATCH06-REVIEW-20261117-v1.md` and its TSV.
- [x] Review GCC integration batch 07: 50 CPP originals, 11 new pending
  owners (ten compile-only, one runtime), eight GCC/KCC-shared cases
  and three GCC-only GNU extensions. Copy and hash two original
  recursively included headers; preserve source-line dependent
  assertions. Add 44 GCC and 16 KCC pending PDP-6 cells, defer 39
  diagnostics, dialect and output-text oracles. No new inapplicable
  tests (the previous 89 deletion tombstones remain enforced). See
  `docs/GCC-C-BATCH07-REVIEW-20261117-v1.md`, its TSV, and the
  batch07 companion-header TSV.
- [x] Review GCC integration batch 08: the next 50 historical CPP
  originals, seven new pending test owners (two runtime, five
  compile/preprocess), four shared GCC/KCC and three GCC-only.
  Preserve the original `mi1c.h` include as a hash-pinned test-local
  companion; add 28 pending GCC and eight pending KCC compiler cells.
  Defer 43 exact diagnostic, dialect, preprocessing-output and target
  width cases without weakening their assertions. No new inapplicable
  cases, so the 89 previous deletion tombstones remain enforced.
  See `docs/GCC-C-BATCH08-REVIEW-20261117-v1.md` and its review and
  companion TSVs.
- [x] Review GCC integration batch 09: another 50 historical CPP
  originals, registering 19 pending source owners (11 runtime, eight
  compile/preprocess), 14 GCC/KCC-shared and five GCC-only. Pin 11
  original include companions, including multi-level `mi2`, `mi3`
  and `mi6` source graphs; add 76 pending GCC and 28 pending KCC
  PDP-6 cells. Defer 31 originals requiring diagnostic matching,
  `-CC`/`-H` preprocessing output, or preprocessing-only compilation
  modes. No new inapplicable cases, and all 89 previous deletion
  tombstones remain enforced. See
  `docs/GCC-C-BATCH09-REVIEW-20261117-v1.md`, its decision TSV, and
  `docs/GCC-C-BATCH09-COMPANIONS-20261117-v1.tsv`.
- [x] Review GCC integration batch 10: 50 CPP, debug-info, general
  diagnostic and ARM/Thumb PE sources. Register three GCC-only pending
  source oracles (two runtime, one preprocessor/compile), adding 12
  GCC PDP-6 pending cells. Retain 42 deferred mode/diagnostic/debug
  cases, including four previously same-name candidates whose central
  oracles are unrelated. Delete five explicitly foreign-target
  originals using version-2 tombstones. See
  `docs/GCC-C-BATCH10-REVIEW-20261117-v1.md` and its TSV.
- [x] Review GCC integration batch 11: the next 50 original
  `gcc.dg/format` sources, individually documenting 940 positive
  warning, 33 error and 11 forbidden-diagnostic expectations,
  plus five tests of warning-free compiler-option behavior.
  Defer all 50: none can be meaningfully activated through current
  positive compile-only profiles. Preserve all original C sources,
  the hash-pinned `format.h` dependency, all 94 prior inapplicable
  deletion tombstones, and all existing pending matrix cells.
  See `docs/GCC-C-BATCH11-REVIEW-20261117-v1.md` and its 50-row TSV.
- [x] Finish historical source-level GCC compatibility review for
  batches 12-14, assigning an original assertion and separate KCC
  applicability decision for all remaining 105 originals. Register
  ten nonvacuous native tests, defer 70 intact oracles, and delete
  25 foreign-target originals with 119 cumulative versioned
  tombstones. See `docs/GCC-C-FINAL105-REVIEW-20261117-v1.md`.
  No original source remains `unreviewed` or `same-name-review`.
- [x] Restore the historical non-target GCC sources to a testkit-owned,
  reproducible reference inventory and add a registered static hash/ownership
  gate (`gcc-c-unmirrored-ownership-v1`). No compiler or emulator tests run.
- [x] Complete the remaining GCC historical assertion-level overlap review,
  especially `gcc.dg` warnings/errors/preprocessor checks. Existing semantic
  tests do not automatically exercise DejaGNU diagnostics. The preserved
  negative `builtin-prefetch-1.c` warnings are **not** covered by the current
  valid-argument semantic test with the same name. See
  `docs/GCC-C-UNMIRRORED-INTEGRATION-20261116-v1.md`.
  The 679-source ownership ledger now has zero unresolved source
  reviews; compiler warning/assembler oracles remain deferred pending
  actual source-rejection, output matching, or multi-file link tests.
- [x] Implement exact native assembler-output oracle matching for the
  original PDP-10 `pdp10-local-char-word-boundary-1.c` and
  `pdp10-lshr-subreg-plus-1.c` compile regressions. These directly
  concern backend correctness. The native GCC codegen tests now check
  both original positive and forbidden assembler regexes, at `-O2`
  for PDP-6, KA10, KI10 and KS10. All eight installed GCC 3.2
  compiler/assembler-output cells passed; eight deliberately mutated
  assembler files triggered 16 required/forbidden policy failures.
  The original batch12 v1 review stays unchanged; its v2 review
  activates exactly these two sources, updates the 679-source crosswalk,
  and retains the 119 tombstones. See
  `docs/GCC-C-PDP10-ASSEMBLER-REGRESSIONS-20261117-v1.md`.

- [x] Establish a reproducible static census across `pdp10-testkit`, KCC,
  GCC PDP-10, DAS, independent PDP10-TOOLS, and DAIMOS host tools. See
  `tools/census-cross-repo-v1.py` and the versioned 2026-11-16 report/TSV.
  This audits sources and references, not executed test results.
- [x] Compare all 19 historical GCC PDP-10 target-specific artifacts to
  their exact registered owners and real assertions: 12 codegen cases,
  four original shell contracts, two unscheduled C companions and one
  deliberately excluded ITS CIRC case. Audit original source hashes,
  GCC `dg-options`, positive/forbidden assembler assertions and wrapper
  delegation. Installed GCC 3.2 passes all 12 original codegen oracles;
  all four shell contracts PASS under their canonical owners. See
  `docs/GCC-PDP10-TARGET-OWNERSHIP-20261117-v2.tsv` and its review.
- [x] Review the six scripts formerly lacking discovered static callers.
  Four deterministic host checks are now enabled in the special registry;
  the speculative AAP JRST/ILLOP probe stays unregistered, and the obsolete
  monolithic ASCII-DXR DAS checker was retired in favor of the native
  phase/chain/guest gates. The census now distinguishes directly dispatched
  DAS tests from nested helpers. See
  `docs/SPECIAL-SCRIPT-OWNERSHIP-AUDIT-20261116-v2.md`.
- [x] Fix independent PDP10-TOOLS source/build selection. The suite now
  defaults to `../pdp10-tools`, builds a clean Git-archived source revision
  in temporary storage, and prints its source SHA. Real independent revision
  `fbef3d0334d9` passed DOBJ/DARC, p10fold/dlink, p10super CFG/rewrite,
  p10run KA10, CSIX, and install/uninstall checks (2026-11-16).
  Additional independent full-output/bad-input media-format regressions
  for `mkdt`, `mkstream` and `words2pt` also pass in the same isolated
  build. See `docs/PDP10-TOOLS-MEDIA-ENCODERS-20261116-v1.md`.
  This does not establish coverage of all independent tools or of the
  different DAIMOS host-tool sources.

- [x] Make `SPECIAL_TESTS.tsv` authoritative for DAS and independent tools.
  DAS `fast`/`full`/`native` profiles retain ordered independently timed
  entries; nested helpers are not redispatched. The independent tools
  suite now has nine individual registered test cases, each with its own
  timeout and PASS/FAIL status, sharing exactly one clean Git-archived
  source build. All nine original cases pass, and the source-independent
  dispatcher regression verifies failure isolation and cleanup. Preserve
  the separate `run-misc-tests.sh` interface: these are not CPU/opt cells.
  See `docs/PDP10-TOOLS-REGISTRY-20261116-v2.md`.
- [x] Restore the native DAS size gates without raising any limits:
  current DAS `6dfb707` emits 68/68 for `das_strip_c_comments`, 133/136
  for `das_read_line`, and fits both phase-image/BSS/process ceilings.
  Replacing the static relocation bitmap with bounded scratch storage
  removed the 2,731-word fixed bitmap from native DAS2 BSS. The new
  maximum-size disk-backed relocation mock and all 9 fast plus 2 full
  host DAS tests pass. See
  `docs/DAS-NATIVE-KCC-INTEGRATION-20261116-v3.md`.
- [x] Complete full native DAS guest execution. The guest now exercises
  read-write root FSINFO, an existing-file CHMOD, MKDIR/RMDIR, CREATE,
  DAS1/DAS2 scratch files, exact six-word DXR output and execution. All
  pass after fixing the resident D6FS free-FCB scan bound: it compared
  against `reader->super_block[0]` instead of `reader->fcb_count`.
  The original image had 295 populated nodes and 360 FCB slots, but
  could not allocate a file. The independent original PDP-6 allocator
  regression checks both too-small and too-large superblock addresses.
  See `docs/DAS-NATIVE-KCC-INTEGRATION-20261116-v5.md`.
- [x] Correct optimized KCC negative-one compound assignments and
  illegal immediate IDIV folding (KCC `22aedc8`). Test all eight CPU/mode
  combinations (PDP-6, KA10, KI10, KS10 x opt/noopt), including
  single-evaluation pointer lvalues, unsigned and float cases. Repair
  stale `terminal-return-chain` register-shape expectation and add a
  PDP-6 executed semantic assertion.
- [x] Verify all PDP10 testkit special-suite registrations against the
  actual dispatcher routes with a registered fail-closed host test:
  **232 enabled direct registrations at that earlier checkpoint** across verified ordered groups,
  11 suite entrypoints; nested DAS and manual entries not double-run.
  Keep `kcc-all` as both `kcc-regression` and `kcc-host`, with KCC host
  prerequisites validated separately when actually executing the suite.
  GCC target 19-artifact and 50-pair review is separately static-audited.
  The script-ownership inventory has no disconnected scripts. See
  `docs/REGISTERED-TEST-PREFLIGHT-20261117-v1.md`. This is dispatch
  validation, not execution of all special-test dependencies.
- [ ] Finish indirect/dynamic DAIMOS OS test-call ownership and actual
  runtime validation; the static cross-repository separation is already
  complete. Current PDP10 inventory has 2,108 compiler sources,
  280 specialized registrations, 421 owned scripts, 50 reviewed duplicate
  pairs and 19 original GCC target artifacts. The older DAIMOS census
  (1,680 scripts, 969 with no static caller) was a historical estimate
  and needs reassessment, not another compiler test relocation.
  Preserve ISA-specific test variation. See
  `docs/REGISTERED-TEST-PREFLIGHT-20261117-v1.md` and
  `docs/TEST-SCRIPT-OWNERSHIP-INTEGRATION-20261116-v4.md`.
- [x] Enforce the compiler/assembler versus DAIMOS OS test ownership
  boundary in both repositories: 127 GCC/KCC/DAS/DLINK source/fixture
  files formerly in `daimos-testkit` (99 moved, 28 deduplicated),
  23 DAIMOS boot/media/linked-kernel/guest execution sources moved
  into the OS testkit. Split the mixed OS recursive RM and KCC MAKE
  assertions; preserve all original C/ASM fixtures and independent
  source SHA256, and use prerequisite-gated **manual** registrations
  for boot-backed native compiler/assembler tests. Install a registered
  two-repository ownership guard, without running full sweeps. See
  `docs/TESTKIT-SCOPE-MIGRATION-20261117-v3.md`. The broader task of
  checking every dynamically invoked DAIMOS OS script remains open.
- [x] Enforce all registered declarative codegen assertion families:
  16 forbidden instruction forms, four required KCC double-helper
  symbols, two compiler target-macro conditions, plus the two original
  GCC `scan-assembler` checks previously hidden in multiline comments.
  The registered host auditor covers all 459 declared `codegen-*`
  directives and rejects new unknown/ignored assertions. Correct eight
  incorrectly registered native KI10/KS10 GCC generic-PDP10 macro
  cells to `no_test`, while preserving the KCC PDP10 missing-macro
  compiler regression. Host verify: **17/17 PASS**, including syntax of
  383 registered/owned Python and shell scripts and 313 local quoted
  positive-test C include edges with no missing fixture. The user will
  perform future full sweeps; none was run for this integration change.
  See `docs/PDP10-CODEGEN-DECLARED-ORACLES-20261117-v1.md`.
- [x] Audit and fix `run-tests.sh` / `tools/run-tests.py` negative-source
  rejection, restart checkpoints, sequential/parallel worker accounting,
  failure listing and summary status handling. Keep one compiler matrix
  runner and one special-suite dispatcher. KCC negatives retain their
  prior fail-closed ICE/rejection policy (814 KCC cells passed).
  GCC 3.2 now requires diagnosed source-located errors, never a warning,
  ICE, timeout, signal or launcher failure. Codes 125-127 are setup
  failures; unknown/missing/running checkpoints are counted and retried.
  The two registered host tests pass, along with six real GCC negative
  cells (three sources sequentially and under two-worker parallelism).
  The complete registered `verify` group now passes 13/13 checks.
  During the audit, two prior batch-01 compiler-conditioned test
  sources were classified semantic-only in the optimization manifest
  to prevent invalid cross-compiler performance comparisons. See
  `docs/GCC-NEGATIVE-RUNNER-ACCOUNTING-20261117-v1.md`.
- [ ] Extend the targeted GCC negative checks to the full set of
  applicable GCC negative sources, target CPUs and optimization
  profiles; prioritize any actual compiler ICEs. Exact original
  `dg-error`/`dg-bogus` diagnostic matching remains separate work.
- [ ] Review support for upstream GCC diagnostic directives (`dg-error`,
  expected warnings, target constraints) and decide which cases are worth
  importing as explicitly negative/diagnostic tests. Do not misclassify
  diagnostic tests as codegen tests. See `docs/parallel-cells.md`.
- [x] Establish a first-class `diagnostic` matrix kind in the existing
  compiler runner; preserve source line, original GCC `dg-error` /
  `dg-warning` regexp, compiler options and independent KCC equivalent
  text. Three byte-identical original GCC sources, four compiler oracle
  entries, and five PDP-6 pilot cells are covered: four PASS and one
  retained GCC original-warning-text mismatch. Register a fail-closed
  host policy/regression test. Reclassify GCC CPP `mi6.c` for KCC
  PDP-6 native/base only after four focused real PASS results; preserve
  the original batch09 v1 and add the single-decision v2 review.
  No full sweep; see
  `docs/PDP10-DIAGNOSTIC-KCC-INTEGRATION-20261117-v1.md`.
- [ ] Expand source-reviewed diagnostic cases from the historical GCC
  corpus, preserving each source-located positive/negative diagnostic,
  target restriction and original compiler options. DejaGNU target
  selectors, xfail branches, full format-warning policy, multitranslation
  unit link semantics and output/assembly scans need separate matching
  infrastructure; do not treat GCC-only features as KCC obligations.

## P2 — execution coverage and regression verification

- [ ] Execute representative tests from every special suite, including the
  newly added `kcc-host` scripts, with their actual KCC, make/bmake, DAS and
  installed-toolchain prerequisites; record actionable failures. Focused
  DAS fast (10/10), KCC-host, compatibility and validation pilots ran.
  Missing GNU/BSD make setup remains an operational prerequisite. The
  obsolete monolithic `KCC_RT` arguments were removed from 24
  compatibility and five KCC regression scripts; targeted reruns show
  21/24 compatibility checks passing (three real ABI/runtime assertion
  failures) and 5/5 KCC regression checks passing. The direct ABI test
  selects its genuinely required installed `$KDFAD` helper only when
  referenced. See
  `docs/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261118-v2.md`.
- [x] Investigate and correct the newly exposed compiler/ABI regressions:
  GCC packed-character pointer stepping (`__test_exit=010` octal).
  The mixed deep-call case (`__test_exit=4`) was an incorrect
  assembler expected value: decimal 52 is octal 64, not octal 52;
  the real preserved-register checks now pass. KCC's negative
  71-bit remainder interop case (`__test_exit=2`) was caused by
  AC10..AC14 clobbering in the inlined division before the later
  remainder call. This is repaired in KCC `948dd9f`, deployed into
  the operational prefix, and guarded by a new registered **10/10**
  passing five-target/two-mode ABI regression. GCC's packed array
  failure was corrected in `pdp10-gcc` `c099c40` by keeping a
  continuous 27-bit array stride and preserving true byte-pointer
  addresses for early packed field reads and writes, including pointers
  held on the stack. Its unmodified source and a new stronger pointer
  write/read regression pass 32/32 staged CPU/optimization cases,
  with six nearby byte-pointer tests also passing. See historical
  `docs/PDP10-ABI-COMPILER-REGRESSIONS-20261118-v3.md` and resolved
  `docs/PDP10-GCC-PACKED-RECORD-BYTEPOINTER-20261118-v5.md`.
- [x] Verify operational installed freestanding KCC/GCC header compilation,
  production DARC archive extraction, GCC libgcc dependency and genuine
  PDP-6 libc calls in a registered targeted test. Both compilers pass;
  no unrelated archive members are pulled into the image. This does not
  imply hosted libc or full compiler/CPU matrix coverage. See
  `misc/compat/test-installed-freestanding-archive-v1.sh`.
- [ ] Sweep the 37 negative tests across supported KCC/GCC CPU and
  optimization combinations; compare to the PDP-6 KCC pilot, and resolve
  compiler ICEs separately. KCC has executed **814/814 passing cells**:
  296 base-family and 518 native/PDP-10-family cells across all 22 KCC
  profiles. The post-ownership GCC native sweep now passes **592/592
  cells** (37 source oracles x PDP-6/KA10/KI10/KS10 x all four `-O0`,
  `-O1`, `-O2`, `-Os` settings). Remaining GCC base/PDP-10-family
  negative selections have not been executed as a complete matrix.
  The source/dispatcher preflight blockers are now closed in this testkit;
  do not interpret partial execution as full matrix coverage. See
  `docs/KCC-NEGATIVE-REJECTION-AUDIT-20261116-v1.md` and
  `docs/REGISTERED-TEST-PREFLIGHT-20261117-v1.md`.
- [ ] Complete codegen compilation sweeps for the 706 consolidated upstream
  GCC tests and the other codegen groups across all applicable CPUs,
  optimization levels and compiler target families. The first real
  PDP-6 native full-group selections now cover GCC `-O0`, `-O1`, `-O2`,
  `-Os` (**3,538/3,603 pass**) and KCC `noopt` (**800/962 pass**).
  Combined: **4,338/4,565 codegen cells pass; 227 fail**, including nine
  compiler ICE/signal cases, 151 compile failures and 67 codegen
  policy failures. All 227 are pinned with exact source/profile SHA256,
  diagnostic excerpts and unchanged failing status in
  `docs/PDP10-INITIAL-SWEEP-FAILURES-20261117-v1.tsv`.
  The harness-only repairs recovered four GCC and five KCC cells,
  corrected actual ICE classification, source-local header lookup,
  special diagnostic byte decoding and KCC's bounded output paths.
  **No compiler/assembler/simulator was modified; do not disable these
  failing cells to improve the score.** Continue cross-CPU GCC codegen,
  KCC optimized codegen and other profile families from their own
  versioned output roots. See
  `docs/PDP10-INITIAL-REGRESSION-SWEEPS-20261117-v1.md`.
  Per user request, further full sweeps are not part of harness
  preparation. The later native GCC macro test ownership correction
  removes eight inapplicable cells; archival results were not rerun.
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
- [x] Verify failure classifications (compiler ICE versus ordinary rejection,
  unsupported profile versus real failure, link failure versus test failure)
  and reproducible selected-cell summaries in the testkit runner.
  A preflight exposed a genuine harness classification defect:
  `p10run: link failed` was called `run_fail`. It now records
  `link_fail`, a real failing/restartable checkpoint, while guest
  aborts remain `run_fail`. Host synthetic tests and the real KCC
  `20011115-1.c` unresolved-symbol case prove the distinction.
  No compiler behavior was modified; deeper compiler/guest failures
  remain separately actionable. See the preflight v1 report.

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
- [x] Record a historical DAIMOS kernel assembly mnemonic inventory
  against verified AAP timing fixtures. The 2026-10-15 report records
  16184/16675 (97.1%) *static occurrences*, not runtime/path coverage.
  Its source-specific report is now owned by the OS testkit:
  `../daimos-testkit/tests/validation/DAIMOS-AAP-KERNEL-COVERAGE-MATRIX-20261117-v2.md`.
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


- [x] Correct the active `README.md` layout and migrate moved OS-specific
  source paths in the AAP documentation. Classified upstream semantic
  tests are under `tests/semantic/upstream/`; the existing
  `tests/todo/generic/` corpus holds retained candidates, not active cells.
- [ ] Continue historical document and source-manifest reviews; updating
  current ownership paths does not retroactively re-run earlier studies.
- [x] Confirm the obsolete `tests/todo/codegen` and `tests/todo/negative`
  placeholders are already absent. Preserve `tests/todo/generic/`.
- [x] Relink 125 historical compiler source paths to byte-identical
  retained files using Git blob/hash evidence; preserve the original
  outcomes and record each old/current source pair. Audit all local
  Markdown paths with four explicitly annotated retired-path exceptions.
  Correct five OS reports that pointed to DAIMOS production source
  as though it belonged to the testkit. See
  `docs/PDP10-HISTORICAL-DOC-PATH-AUDIT-20261117-v1.md`.
- [ ] Keep testkit-specific instructions near the tests; only update
  completed cross-project toolchain/ABI documentation in `pdp10-doc`.
- [ ] After the major review, rerun registry-source validation, shell/Python
  syntax checks, representative executions, and `git diff --check`; commit
  and push each logically complete change.

## Current baseline (not a completion claim)

- `COMPILER_MATRIX.tsv`: 2,210 unique source rows, ownership and
  source paths audited after removal of 47 identical registrations.
- `SPECIAL_TESTS.tsv`: 284 unique entries, including 234 enabled direct,
  44 manual and six nested; dispatch is statically verified, but full
  execution is not claimed.
- Script inventory: 426 owned shell/Python scripts; registered host
  verification passed 20/20 checks including historical documentation.
- `tests/codegen/upstream-gcc/`: 706 registered C sources.
- Upstream manifest: 551 active, 67 deferred, 58 removed and one
  nonportable stress source; 97 byte-identical retired aliases remain
  source-pinned in the v21 provenance map, and all current deferred
  entries have actionable blocker dispositions.
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
