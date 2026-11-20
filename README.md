# PDP-10 compiler, assembler and CPU testkit

This repository tests GCC and KCC compiler behavior, PDP-6/PDP-10
assembler and linker formats, ABI contracts, optimization and processor
ISA execution. Targets include PDP-6, KA10, KI10 and KS10. It is **not**
the DAIMOS operating-system test suite.

Twenty-two bounded, ten-entry deferred reviews are recorded in
`docs/PDP10-DEFERRED-INTEGRATION-FIRST10-20261118-v8.md`,
`docs/PDP10-DEFERRED-INTEGRATION-NEXT10-20261118-v9.md`, and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH03-20261118-v10.md`, plus
`docs/PDP10-DEFERRED-INTEGRATION-BATCH04-20261118-v11.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH05-20261118-v12.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH06-20261118-v13.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH07-20261118-v14.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH08-20261118-v15.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH09-20261118-v16.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH10-20261118-v17.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH11-20261118-v18.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH12-20261118-v19.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH13-20261118-v20.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH14-20261118-v22.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH15-20261118-v23.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH16-20261118-v24.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH17-20261118-v25.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH18-20261118-v26.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH19-20261118-v27.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH20-20261118-v28.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH21-20261118-v29.md` and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH22-20261118-v30.md`.
The thirteenth connected five GCC original sources, including two
verified 71-bit reference-table shift tests, optimized-only builtin
constant checks, a narrow bitfield-size comparison and four
failing packed-bitfield readback profiles. Five other sources
remain deferred for alignment-oracle, hosted-runtime or native
36/71-bit arithmetic expectations. KCC's `bcp-1.c` internal
compiler error remains documented. No source was edited or deleted.
After the 13 reviews, an additional versioned upstream-source
consolidation eliminated **97 exact duplicate source copies**:
50 involving deferred sources and 47 independently registered
active/active pairs with identical compiler profile vectors.
No distinct assertion or supported compiler profile was lost.
The canonical source and original SHA256/provenance for each pair
are recorded in
`docs/UPSTREAM-DUPLICATE-CONSOLIDATION-20261118-v21.md`
and its TSV. All **16 outstanding compiler-specific blockers**
from the retired deferred copies remain open in
`docs/UPSTREAM-CONSOLIDATED-COMPILER-GATES-20261118-v21.tsv`.
The fourteenth bounded review, after consolidation, connected
six original sources. GCC PDP-6 passes all checked optimization
levels except `built-in-setjmp.c`, which passes O0 and **fails
O1/O2/Os**. The three prefetch smoke tests with no assertions
remain deferred; only the side-effect-asserting `builtin-prefetch-4.c`
was connected. No source was modified or removed in this batch.
The fifteenth review connected six more sources, including
71-bit wide-comparison, GNU nested computed-goto, and complex
arithmetic checks. One line in `cmpdi-1.c` now recognizes the
installed uppercase `__PDP10__` target macro, selecting the
existing independently verified 640-result 71-bit reference
table. GCC passes every tested configuration; KCC passes noopt
but fails optimized. `complex-2.c` has the reverse GCC split:
O0 fails while O1/O2/Os pass. No source was removed.
The sixteenth review connected six more sources, including
KCC/GCC numeric conversions, a negative constant divisor,
complex addition, and a full-size `memcpy`/`memset` regression.
The testkit harness was corrected to select real freestanding
library fragments for direct `JRST memcpy` tail calls as well as
`PUSHJ` calls. GCC O2/Os `memcpy-1.c` now link and pass
without any change to the imported C source; GCC O0 and KCC
still fail and remain recorded as such. The unresolved RH18
relocation overflow in `index-1.c` remains deferred for
assembler/linker repair. No original C source was changed.
The seventeenth review connected seven additional meaningful
native PDP-6 tests: three original memcpy/memset/memcmp
readback regressions, nested variadic and nested function
callback ABI tests, and leading-byte memcpy verification.
The newly selected compiler profiles contain **15 GCC passes
and 13 GCC runtime failures**, plus **six KCC passes and two
KCC runtime failures**. `nestfunc-3.c` remains deferred:
GCC O0/O1/O2 simulator runs timed out without readable status,
while Os reached abort. At that time `old.tort.c` was
deferred for nonportable system assumptions, and `packed-2.c`
still had no checked packing assertion. No C source was
changed during batch 17. The former `old.tort.c` was
subsequently **deleted** and replaced by the native, hosted-I/O-free
`tests/semantic/regression/pdp10-byte-pointer-torture-v1.c`.
All six observed PDP-6 profiles are registered as real compiler
assertion failures, not silently skipped. See
`docs/PDP10-P1-NATIVE-BYTEPTR-REPLACEMENT-20261120-v1.md`.
The eighteenth review connected five original test sources
covering GNU 71-bit-capable fourth-argument passing, a
struct-by-value argument after three scalars, block-scope
`extern` resolution of external and internal file-scope
objects, and aligned/native-byte `strcmp` sign comparisons.
GCC PDP-6 passes 19 of the 20 newly registered native profiles;
`strct-1.c` fails only O0. KCC passes `strcmp-1.c` both modes,
and `strct-1.c` noopt, but fails the remaining supported
optimized/scope modes. Five other sources require genuine
conversion or hosted stdio support. No original source was
modified or deleted in batch 18.
The nineteenth review connected nine more tests: the native PDP-10
structure-through-varargs ABI source and eight GNU string builtin
optimization checks. The `strct-varg-1.c` original already had
an `stdarg.h` alternative, selected by `NO_VARARGS`. A five-line,
PDP-10-only preprocessor prefix selects that existing branch:
both KCC modes and all four GCC modes now pass. Its historical v21
SHA256 remains intact as evidence; the v27 provenance audit
requires that removing precisely those five lines reproduces
the original hash and that the current hash matches v27.
The eight GNU string source owners add optimized pass/fail
regressions, including three **link errors** for
`string-opt-16.c` where GCC fails to fold intentionally
unresolved `link_error` calls. `strct-pack-2.c` remains
deferred for lack of an assertion. No source was deleted.
The twentieth review connected ten original assertion-bearing
sources: eight GNU string optimization tests and two original
aligned native `strlen`/`strncmp` coverage sources. Previously
missing ordinary freestanding string library linkage is now
available, and all ten run under GCC. The new profiles contain
**seven GCC passes and 33 runtime aborts**; the alignment
`strncmp-1.c` passes all four GCC modes, whereas `strlen-1.c`
fails all GCC modes but passes KCC both ways. KCC additionally
links neither GNU `__builtin_strpbrk` nor `__builtin_strchr`
in either mode; those unsupported GNU-builtin KCC profiles
remain `no_test`, with observed link failures recorded.
No original C source was changed or removed in batch 20.
The twenty-first review connected nine more tests: GNU field
designated initialization, a 37-bit long-long bitfield,
71-bit signed-comparison boundaries and six variadic-argument
ABI tests. The signed-comparison `tstdi-1.c` guard was fixed
to recognize uppercase `__PDP10__` while preserving all
**36 independently verified original expected values**.
GCC passes all four modes; KCC passes noopt but fails
optimized, now conservatively registered as `fail`.
The two standard `stdarg.h` tests `va-arg-10.c` and
`va-arg-2.c` fail GCC O0 but pass O1/O2/Os; four
legacy `varargs.h` tests abort in all GCC modes.
The hosted `struct-ret-1.c` source remains deferred for
genuine `sprintf`, with no direct assertion of returned
structure fields. No source was deleted.
The twenty-second and final first-review batch connected nine
more original tests: GNU variadic aggregates, old-style and
standard variadic passing, wide-character literals, and GNU
zero-length members. The new 36 native GCC PDP-6 profiles
contain **15 passes and 21 genuine runtime aborts**.
`va-arg-9.c` fails O0 but passes O1/O2/Os; three wide/zero-length
source tests pass all GCC modes. The original Latin-1 `0xC4`
wide-string source fails its array-size assertion without any
source transcoding. The deployed `limits.h` incorrectly
advertises a 64-bit long-long maximum while the compiler also
defines `__LONG_LONG_71BIT__`; `va-arg-8.c` executes
its actual checks, but its width guard must not be interpreted
as proof of a 64-bit PDP-10 ABI. The hosted `va-arg-21.c`
remains deferred for genuine `malloc`/`vprintf` support.
All **surviving canonical original identities have now
received an individual first review**. No source was changed
or deleted in batch 22.
The current inventories are **2,261 matrix sources**,
**551 active / 67 deferred / 58 removed** upstream
tests, and
**293 specialized registrations**, including **18 intentionally
manual tests**. No broad sweep was started.
The current upstream and deferred classification manifests are
`SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv` and
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv`; older versions
remain historical snapshots.

## Test ownership

- **`pdp10-testkit`** owns GCC/KCC, DAS/DLINK, p10fold, ABI,
  compiler diagnostics/code generation and processor ISA tests
  that run without booting a DAIMOS guest.
- **`../daimos-testkit`** owns DAIMOS boot, kernel, filesystem,
  device, process, syscall, shell and guest-service tests, plus all
  25 guest-native KCC/DAS/DLINK toolchain integration suites.
- Native guest integration tests are explicitly selected in DAIMOS;
  no native suite enters this repository's normal compiler/CPU matrix.
- Generic AAP/PDP-6 instruction/timing fixtures remain here;
  DAIMOS-specific kernel-coverage inventories and runtime profiles
  belong in `daimos-testkit`.

**Priority policy (2026-11-19):** Complete the 59-source P1 semantic
construction backlog in six fixed work batches of 10/10/10/10/10/9.
Historical source hashes and completed batch positions stay stable.
AAP emulator architecture-correctness, exception/PI/device checks,
opcode-coverage expansion and logical-tick validation are **P3**;
they must not block P1 source admission or independently justified
compiler/ABI test oracles. Existing AAP results remain valid evidence,
but further AAP expansion is deferred until P3. See
`docs/PDP10-P1-SOURCE-BATCHES-20261119-v1.md` and `TODO.md`.

The historical 150-file split is recorded in the v3 manifest. The
71-file native re-home and current ownership rules are recorded in
`docs/TESTKIT-SCOPE-MIGRATION-20261119-v4.md` and
`docs/NATIVE-TOOLCHAIN-RETURN-20261119-v4.tsv`.

## Usage

Set `PDP10_PREFIX` to the installed toolchain root (containing `bin/`).
Set `TMPDIR` to a writable scratch area; if unset, prefer `$HOME/tmp`.
Optional source overrides include `KCC_REPO`, `DAS_ROOT`,
`DAIMOS_TESTKIT_REPO`, and `PDP10_TOOLS_REPO`.

```sh
export PDP10_PREFIX="$HOME/cross"
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
./run-tests.sh list
python3 tools/audit-test-inventory-v1.py
python3 tools/test-testkit-boundary-v1.py --require-cross
```

`./run-tests.sh` runs selected compiler, CPU and optimization cells;
its `list`, `list-kcc` and `list-gcc` commands only enumerate tests.
`COMPILER_MATRIX.tsv` defines compiler applicability and expectations.
Use `./run-tests.sh --help` and `docs/parallel-cells.md` for selector,
resume, output and timeout controls. A pending entry is not a passing
execution result. Full sweeps are operator-selected.

`SPECIAL_TESTS.tsv` records standalone specialized tests, including
21 deliberately manual roots. The 25 booted native toolchain tests are
registered exclusively in `daimos-testkit`. `./run-misc-tests.sh` is the
special-suite entry point; `verify` runs the broader verify/compatibility
and validation groups, **not** merely a fast static ownership audit.
Use `./run-misc-tests.sh list-manual` to enumerate manual roots without
executing them, or `./run-misc-tests.sh run-id TEST_ID` to execute
exactly one enabled registered test. A manual root additionally requires
`--manual`; nested DAS helpers and suite-prepared tools cannot be
launched by ID. This is explicitly selected execution, not a new
automatic suite. See `docs/PDP10-SPECIAL-RUNNER-20261119-v3.md`.
Use the individual Python auditors above for host-only preflight.
For named DAS groups use `das-fast`, `das`, or `das-native`.
The independent PDP10-TOOLS suite is sourced from `../pdp10-tools`;
it is not silently replaced by `DAIMOS/tools/host`.

## Directory ownership

| Location | Purpose |
| --- | --- |
| `tests/semantic/` | Compiler semantic/runtime tests; `upstream/` is individually classified |
| `tests/codegen/` | Compiler assembly/code-generation assertions and reviewed GCC imports |
| `tests/negative/` | Rejection and diagnostic source tests |
| `tests/isa/` | CPU instruction and machine-specific semantics |
| `misc/` | Registered special suites (`kcc-host`, `das`, `compat`, `validation`, `tools`) |
| `refs/` | Reviewed historical source snapshots, not automatically runnable tests |
| `docs/` | Test-specific policy, source decisions, historical evidence and versioned manifests |
| `tools/` | Matrix runners and static integrity/ownership audits |
| `tests/todo/generic/` | Retained historical generic candidates; some canonical compiler gates are active matrix tests |

## Current pre-sweep state (2026-11-20)

The active `pdp10-testkit` registration and source-ownership auditors
report **2,294 compiler-matrix sources**, **347 special registrations**
and **511 owned script paths**, with zero unowned test sources and zero
unconnected scripts. No full compiler/CPU/optimization sweep has run
in this preparation stage. The historical upstream classification
retains 551 active, 67 deferred, 58 removed and one nonportable source;
historical import disposition must not be read as present compiler PASS.

The live P1 source-specific construction ledger is
`docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v16.tsv`:
**45 covered, zero partial, 22 blocked**. The frozen 59-source batch
ledger now has 37 covered and 22 blocked; no original is deleted or
renumbered. Two additional intact deferred-source intentions have real,
archived PDP-6 evidence: `930513-1.c` (six native KCC/GCC PASS) and
`struct-ret-1.c` (four original GCC PASS with a separate asserting
aggregate-return companion retaining one run failure and two timeouts).
The pre-existing noreturn regression is scheduled, but all four
targeted GCC PDP-6 profiles currently link-fail on `__builtin_abort`.

For the current outstanding source names, genuinely missing runtime
symbols, test ownership, branch state and **explicit stop point before
the full sweep**, see `docs/PDP10-PRESWEEP-STATE-20261120-v1.md`.
The exact evidence and negative controls are in the adjacent
`PDP10-P1-930513-ORIGINAL-CLOSURE-20261120-v1.md` and
`PDP10-P1-STRUCTRET-HOSTED-CLOSURE-20261120-v1.md`.
The 21 manual roots are pinned in
`docs/PDP10-MANUAL-ROOTS-20261120-v1.tsv`; the dispatch regressions
compare exact IDs, groups and paths without executing those manual
tests. Historical admission v1-v6 audits also accept only the three
new source-pinned GCC profiles for `930513-1.c`, preserving all
previously prohibited registrations and negative controls.

## Historical static integration state (2026-11-19 snapshot)

- Compiler matrix: **2,261** sources, including forty-nine substantive
  companions for formerly vacuous or width-dependent upstream tests.
- Special registry: **293 entries** (**269** enabled direct, **18** manual,
  **6** nested). Native boot-backed suite identities: **0**.
- DAIMOS native toolchain registry: **25** explicitly selected roots with
  **71** restored source, wrapper and fixture files.
- The source and ownership checks pass; no native or full compiler sweep
  was run during the transfer.
- The full registered **host-only verify** group subsequently passed
  **21/21** on 2026-11-19 after reconciling two post-classification
  ownership decisions and four differential-helper annotations.  See
  `docs/PDP10-HOST-VERIFICATION-20261119-v1.md`.  The separate manual
  sweep remains 13 PASS / six not passing and is not a compiler-matrix
  acceptance claim.
- The 16 original consolidated compiler gates are now **normal matrix**
  cells (38 PDP-6 compiler/optimization profiles), rather than a parallel
  execution suite. All 38 profiles were run through `run-tests.sh`:
  36 still fail and the two KCC PDP-6 profiles of `20011113-1.c`
  pass. The separate mutation/negative-control validation tests both
  source call paths without changing the original C file. Full historical
  failure logs and checked hashes: `docs/PDP10-COMPILER-GATES-MATRIX-20261119-v1.md`.
- The current **24/24** registered host-only verification tests pass,
  including P1 deferred-source provenance, DEC floating-point oracle
  evidence coverage and the independent target-width shift-table check.
  The PDP-6 width-shift regression passes all six tested KCC/GCC modes;
  further CPU semantics and open P1 deferred-source obligations remain.
  See `docs/PDP10-P1-TEST-CONSTRUCTION-20261119-v1.md`.
- The full **67 x 2** deferred-source baseline is now captured, with
  original source SHA256 identities, exact GCC/KCC result distinctions,
  and 134 archived compiler/guest records. Five independently tested
  companion regressions are now in the normal matrix without promoting
  any vacuous historical source. See
  `docs/PDP10-P1-DEFERRED-ROUND2-20261119-v1.md`.
  All 26 new companion PDP-6 cells have archived, checksum-verified results
  in `docs/PDP10-P1-COMPANION-MATRIX-RESULTS-20261119-v1.tsv`.
- Four more assertion-bearing GNU/packed/bitfield companions are now
  registered in the matrix, with 18 actual PDP-6 executions and
  explicit distinction between failing assertions and SIMH timeouts.
  See `docs/PDP10-P1-NONASSERTING-COMPANIONS-20261119-v1.md`.
- GNU prefetch address side effects and independent 36-bit-word/71-bit
  multiplication now have ten more normal PDP-6 matrix executions;
  **14/14** original nonasserting sources have an explicit companion
  coverage classification (eight targeted, six partial) without changing
  or prematurely activating the originals. See
  `docs/PDP10-P1-PREFETCH-WIDE-20261119-v1.md`.
- The latest registered host verification sweep is **54/54 PASS**.
  Earlier 24/24 and 27/27 milestones are historical counts, not the
  current verifier inventory. **The historical 67 deferred sources
  are not all actionable P1 work.** The audited source-specific
  resolution v1 separated **8 covered**, **6 partial**, and **53 blocked**.
  The current v7 ledger records **38 covered**, **1 partial**, and
  **28 blocked**: **29 currently actionable P1 obligations**. The
  thirty-eight completed intents no longer count as unfinished test
  construction. The original 67 import entries and their compiler
  failures are preserved. The 59 baseline-open sources are assigned to
  fixed source-hash-pinned batches of **10, 10, 10, 10, 10, and 9**;
  Batch 1 is **10/10 covered for test construction**, with unresolved
  compiler, linker and simulator outcomes retained for P2/P3. See
  `docs/PDP10-P1-SOURCE-BATCHES-20261119-v3.md`,
  `docs/PDP10-P1-BATCH1-FINAL-20261119-v1.md` and
  `docs/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v4.md`.
  Batch 2 is **10/10 complete for P1 construction**, with 30
  additional source/profile executions (26 normal matrix, four
  genuine instrumentation-option special runs), including a
  preserved GCC O0 compiler ICE. Batches 1 and 2 are complete;
  Batch 3 is also **10/10 complete** with 42 actual new PDP-6
  source/profile executions, including the original 1,000-case
  generator, native D-format cube root, exact Karatsuba bodies and
  three original prefetch families. Batch 4 is next. See
  `docs/PDP10-P1-BATCH2-FINAL-20261119-v1.md`,
  `docs/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v6.md` and
  `docs/PDP10-P1-SOURCE-BATCHES-20261119-v5.md`.
  Current evidence and priorities:
  `docs/PDP10-P1-BATCH3-FINAL-20261119-v1.md`,
  `docs/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v7.md` and
  `docs/PDP10-P1-SOURCE-BATCHES-20261119-v6.md`.
- Native 36-bit Linux-style device-number encoding is tested by ten
  independent unsigned/modulo reference values on **all six** PDP-6
  KCC/GCC compiler profiles, without changing the original deferred
  32-bit source; see `docs/PDP10-P1-KDEV36-20261119-v1.md`.
- Target-width random arithmetic now has a deterministic **36-case**
  signed/unsigned 9/18/36-bit quotient/remainder oracle. Two KCC
  modes pass; all four GCC profiles reach the same real assertion
  failure. See `docs/PDP10-P1-DIVMOD-NATIVE-20261119-v1.md`.
- Signed 52/53-bit field XOR/OR and record-return paths now have
  independently calculated sign-extended expected values with actual
  GCC PDP-6 failures in all four optimization profiles. The original
  64-bit-assumption sources stay deferred. See
  `docs/PDP10-P1-BITFIELDS-OPERATIONS-20261119-v1.md`.

## Verified integration state (2026-11-17)

- Compiler matrix: **2,211 sources** with no unowned test sources
  and no duplicated classified upstream source bytes.
- Special registry: **284 entries**, including **234 enabled direct**,
  **44 manual** and **6 nested** registrations.
- Script ownership: **426** registered/delegated Python or shell scripts,
  including the v21 upstream consolidation auditor as a module helper.
- Registered host verification: **20/20 passed** after the documentation
  path audit (no full compiler or OS sweep).
- Cross-repository migration: **127** former DAIMOS compiler/assembler
  identities (99 relocated, 28 deduplicated) and **23** OS test files
  relocated into `daimos-testkit`. Both v3 source manifests match.
- Historical upstream classification: **449 active**, **269 deferred**,
  **55 removed**, and **one** nonportable stress source. Classification
  does not establish that all active tests have executed successfully.

No full GCC/KCC or DAIMOS suite was run as part of the ownership split.
The previously observed compiler failures remain recorded, without
weakening their original assertions, in
`docs/PDP10-INITIAL-REGRESSION-SWEEPS-20261117-v1.md` and its failure TSV.

Subsequent focused prerequisite validation (no full matrix sweep) is in
`docs/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261117-v1.md`, including
DAS fast **10/10**, a new installed KCC/GCC freestanding archive and
PDP-6 execution test, targeted KCC-host/compatibility fixes, and
20 pilot cells from the 269-source deferred inventory. The
SHA256-pinned outcomes and remaining gates are in
`docs/PDP10-DEFERRED-BLOCKER-TRIAGE-20261117-v1.tsv`.
The next **2026-11-18 v2** focused checkpoint is
`docs/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261118-v2.md`: split
KCC-runtime prerequisite migration, 21/24 affected compatibility
scripts passing (three real assertion failures retained), 5/5 KCC
regression scripts passing, and 54 more deferred-source cells from
libc/header batches. Its 269-row source-preserving results ledger is
`docs/PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v2.tsv`.
The focused ABI/compiler repair checkpoint is
`docs/PDP10-ABI-COMPILER-REGRESSIONS-20261118-v3.md`. KCC's
previously unpreserved DImode scratch ACs are repaired upstream
(`948dd9f`), and the new registered five-target/two-mode regression
passes **10/10** with the operational compiler. The mixed-call
fixture's erroneous octal constant is corrected. GCC's packed
record-array pointer/storage mismatch remains a reproduced compiler
failure, not a silently skipped test.
The `2026-11-18 v4` focused checkpoint is
`docs/PDP10-VARARGS-AND-GCC-ICE-20261118-v4.md`. The genuine GCC
variable-sized `va_arg` ICE is repaired in `pdp10-gcc` `66f5a15`;
the installed compiler passes a new 16-cell compile-only regression.
Its original dynamic-aggregate semantic execution still fails and
remains deferred. All 26 historically deferred `varargs-abi` sources
(52 operational PDP-6 cells) are recorded, without activation, in
`docs/PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v4.tsv`.
The `2026-11-18 v5` focused compiler repair is in
`docs/PDP10-GCC-PACKED-RECORD-BYTEPOINTER-20261118-v5.md`. GCC
`c099c40` corrects nonvolatile explicitly packed nine-bit record
strides and byte-pointer field reads/writes. The previously failing
original test and a new stricter companion pass all 32 staged
CPU/optimization cells **and** all 32 operational installed-toolchain
cells. This does not alter the deferred VLA-copy
runtime blocker or imply a full matrix sweep.
The unresolved VLA block-copy investigation is recorded separately in
`docs/PDP10-GCC-VLA-AGGREGATE-COPY-20261118-v6.md`. The original
runtime assertion still fails; scratch-only pointer conversion trials
were insufficient and no compiler/libc change was deployed for them.

## Detailed documentation

- `TODO.md`: **open work**, source classification follow-ups and testkit
  verification priorities. Dated checked-off entries are historical
  milestones, not current registration totals.
- `docs/REGISTERED-TEST-PREFLIGHT-20261117-v1.md`: original registration,
  dispatcher and host-check preflight (historical snapshot).
- `docs/GCC-C-FINAL105-REVIEW-20261117-v1.md`: completed historical GCC C
  classification; source-level TSVs preserve rejected/deferred decisions.
- `docs/GCC-C-INAPPLICABLE-REMOVALS-REVIEW-20261117-v2.md`: original
  source tombstone justification and provenance.
- `docs/PDP10-CODEGEN-DECLARED-ORACLES-20261117-v1.md` and
  `docs/PDP10-DIAGNOSTIC-KCC-INTEGRATION-20261117-v1.md`: implemented
  compiler oracle policy, distinct from runtime results.
- `docs/PDP6-FP-SIMH-FIDELITY-20261021-v1.md`: DEC Type 166 hardware
  evidence and the remaining floating-point characterization work.
- `docs/PDP6-AAP-LOGICAL-TICK-OPTIMIZATION-20261015-v1.md`: historical
  processor timing work; DAIMOS-specific kernel coverage is now under
  `../daimos-testkit/tests/validation/`.
- `docs/PDP10-HISTORICAL-DOC-PATH-AUDIT-20261117-v1.md`: source-path
  reconciliation, historical-provenance crosswalk and missing-link
  regression policy (125 unchanged original source identities).

Dated integration reports remain evidence of what was checked at the
stated time; the current status of registrations comes from the TSVs
and their audits, **not** from historical counts in those reports.
