# PDP-10 bare-metal processor testkit

This repository tests the PDP-10 processor architecture and its bare-metal
software toolchain: compiler semantics and code generation, assembler, ISA,
ABI, object format, linker, and CPU execution. CPU variants include PDP-6,
KA10, KI10, KS10, and later supported implementations.

Tests must not require DAIMOS, an operating-system runtime, filesystems,
boot images, or emulated peripheral devices. Tests of device controllers and
other hardware beyond the processor do not belong here. DAIMOS-dependent
regressions belong in `daimos-testkit`; generic host-tool regression tests
may remain here if they exercise processor-oriented tooling only.

Set `PDP10_PREFIX` to the installed toolchain prefix. Use
`./run-misc-tests.sh verify` for specialized compatibility checks, `./run-tests.sh -j 6`
for the matrix, `./run-tests.sh list` to enumerate cells, and
`./run-misc-tests.sh clean` to remove generated artifacts. The compiler matrix is
`COMPILER_MATRIX.tsv`; specialized suites are listed in `SPECIAL_TESTS.tsv` and
run by `./run-misc-tests.sh`. Runner usage is described in `docs/parallel-cells.md`.
The `pdp10-tools` special suite tests the independent `../pdp10-tools`
repository at its explicitly reported Git revision; it does not silently
substitute the different `DAIMOS/tools/host` source tree.
The DAS `das-fast`, `das`, and `das-native` suites select ordered `fast`,
`full`, and `native` entries in the special registry. Nested helper tests
are not dispatched a second time; see
`docs/DAS-REGISTRY-INTEGRATION-20261116-v1.md` for the original registry
conversion. The native scanner, phase-size checks and complete DAIMOS
guest assemble/compare/execute acceptance now pass after correction of
the D6FS free-FCB allocation bound; see
`docs/DAS-NATIVE-KCC-INTEGRATION-20261116-v5.md`. The previous
`docs/DAS-COMMENT-COMPACTION-20261116-v2.md` records the intermediate
72-instruction scanner before the final four-word reduction.

For a read-only inventory across the KCC, GCC, DAS, and PDP10-TOOLS source
repositories, run `python3 tools/census-cross-repo-v1.py`. The versioned
report and manifest are `docs/CROSS-REPO-TEST-CENSUS-20261116-v1.*`.
This static census does not build or run tests or claim execution coverage.

Before importing new upstream GCC C tests, apply the PDP-10 feasibility gate
in `docs/GCC-C-FEASIBILITY-REVIEW-20261116-v1.md`. The companion TSVs record
original assertions, PDP-10-specific restrictions, and an initial source-risk
queue. After removal of GCC's DejaGNU suite, reviewed GCC-only codegen
cases are maintained in `refs/gcc-pdp10-target-v2/` and validated by
`misc/validation/test-gcc-target-codegen-v2.py`. See
`docs/GCC-DEJAGNU-REMOVAL-20261116-v2.md` for source provenance.

Of the 679 historical non-target-specific GCC sources not byte-identical to
existing tests, **585 source snapshots remain** in `refs/gcc-c-unmirrored-v1/`,
pinned to GCC revision `b0f5374`. The other **94 reviewed inapplicable sources
were deleted** (89 from batches 01-06 and five from batch 10). Their original
hashes, rejection reasons, and source paths remain recorded in
`docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v2.tsv`, with the original
89-row v1 manifest preserved for audit history.
The per-source assertion/ownership inventory for all 679 original entries is
`docs/GCC-C-UNMIRRORED-OWNERSHIP-20261116-v1.tsv`. Its registered static
verifier is `tools/inventory-gcc-unmirrored-v1.py`; inventory re-imports
cannot restore deleted tests. Archived local include
dependencies are tracked in `docs/GCC-C-SOURCE-COMPANIONS-20261116-v1.tsv`.
The reviewed first batch of 13 additional PDP-10-specific runtime
regressions is in
`tests/semantic/gcc-historical-v1/`, initially with GCC PDP-6 optimization
cells marked `pending` in the compiler matrix. Three now also have KCC
pending PDP-6 coverage. These have **not been executed**.
The historical snapshots are *not* automatically active test cases; consult
`docs/GCC-C-UNMIRRORED-INTEGRATION-20261116-v1.md` before promoting more.

The first 50-source assertion-level compatibility review is recorded in
`docs/GCC-C-BATCH01-20261116-v1.tsv` and
`docs/GCC-C-BATCH01-REVIEW-20261116-v1.md`. It integrated 17 PDP-10
pending semantic regressions, deferred 10 cases and identified
23 incompatible historical assertions. Source ownership is checked by
the existing GCC inventory verifier. No tests were run for this batch.
All 17 adapted batch cases also apply to KCC. See
`docs/GCC-C-KCC-CROSS-COMPILER-20261117-v1.md` and its per-source TSV
for the 40 additional pending KCC PDP-6 native/base matrix cells.

The second 50-source original GCC review is recorded in
`docs/GCC-C-BATCH02-REVIEW-20261117-v1.md` and its source-hash-pinned TSV.
It registers 11 more tests (eight runtime and three compile-only): eight
shared KCC/GCC cases, two GCC-only, and one KCC-only until an explicit
71-bit GCC compiler profile is provided. The remaining 39 cases are
explicitly deferred or inapplicable. New registrations comprise 40
pending GCC and 18 pending KCC PDP-6 matrix cells. No tests were run.

The third 50-source review is documented in
`docs/GCC-C-BATCH03-REVIEW-20261117-v1.md` and its per-original TSV.
Seven more source oracles (three runtime, four compile-only) are
registered: six shared with KCC and one GCC-only wide bit-field case.
They add 28 pending GCC and 12 pending KCC PDP-6 matrix cells;
22 sources are deferred, 21 inapplicable. All checks for this batch
were static; no tests ran.

The fourth 50-source review is documented in
`docs/GCC-C-BATCH04-REVIEW-20261117-v1.md` and its source-hash TSV.
It registers five compile-only sources: two shared GCC/KCC C language
cases and three GCC-only GNU inline-asm cases, including two exact
assembler percent-escape regex oracles. This adds 20 pending GCC and
four pending KCC PDP-6 compiler cells; 25 sources were deferred and
20 found inapplicable. No compiler or emulator tests were executed.

The fifth 50-source review is documented in
`docs/GCC-C-BATCH05-REVIEW-20261117-v1.md` and its full 50-row TSV.
It adds four pending tests: two shared KCC/GCC C99 source-level cases,
and two GCC-only extension cases (forced inlining and choose-expression
runtime behavior). Exact compiler profile selections enable 10 GCC
and four KCC pending PDP-6 cells. Forty-five original cases were
deferred (mostly strict C90/C99 mode or diagnostic assertions) and
one IEEE-specific 64-bit layout was inapplicable. **405 original sources
remain unresolved**. This batch has not executed compiler tests.

The sixth 50-source review is documented in
`docs/GCC-C-BATCH06-REVIEW-20261117-v1.md` and its 50-row TSV.
It registers 12 new pending sources (nine runtime, three compile-only),
including nine shared KCC/GCC C99 or preprocessor assertions and three
GCC-only cases. The compiler matrix adds 48 pending GCC and 18 pending
KCC PDP-6 cells. Thirty-seven sources were deferred and one x86
inline-assembly test is inapplicable. **355 original sources now remain
unresolved** (12 same-name and 343 unreviewed). Neither compilation
nor emulator tests were run.

The seventh 50-source review is documented in
`docs/GCC-C-BATCH07-REVIEW-20261117-v1.md`, its individual 50-source
TSV and a two-header companion hash ledger. Eleven preprocessor-focused
tests are registered pending (ten compile-only and one runtime), eight
shared with KCC and three GCC-only. This adds 44 pending GCC and 16
pending KCC PDP-6 cells; 39 tests were deferred because they require
explicit diagnostics, preprocessing-only flags or output-text checks.
No new tests were classified inapplicable, so the prior 89 deletions
remain unchanged. **305 original source reviews remain unresolved**
(nine same-name candidates and 296 unreviewed). No tests were executed.

The eighth 50-source CPP review is documented in
`docs/GCC-C-BATCH08-REVIEW-20261117-v1.md`, its 50-source decision TSV,
and the hash-pinned `mi1c.h` companion record. Seven source tests are
newly registered pending (five compile/preprocessor and two runtime),
four shared between GCC/KCC and three GCC-only. Another 43 original
diagnostic, language-mode or preprocessing-output cases were deferred;
none was classified inapplicable. The matrix gains 28 pending GCC and
eight pending KCC PDP-6 cells. **255 original sources remain unresolved**
(nine same-name candidates and 246 unreviewed). No compiler or
emulator tests were executed.

The ninth 50-source historical CPP review is in
`docs/GCC-C-BATCH09-REVIEW-20261117-v1.md`, its 50-row source review
TSV, and an 11-companion SHA256 ledger. It registers 19 pending
test sources (11 runtime and eight compile/preprocess): 14 with both
GCC and KCC eligibility, and five GCC-only GNU extensions. The
matrix adds 76 pending GCC and 28 KCC PDP-6 cells. Thirty-one
original sources remain deferred for diagnostic, output-text,
include-trace or preprocessing-only assertions; none was classified
inapplicable. The 89 deleted original sources remain absent.
**205 source reviews remain unresolved** (nine same-name and 196
unreviewed). No compiler or emulator tests were executed.

The tenth 50-source review spans GNU CPP, debug-info generation,
ordinary GCC diagnostics, and ARM/Thumb PE targets, as detailed in
`docs/GCC-C-BATCH10-REVIEW-20261117-v1.md` and its original SHA256
decision TSV. Three GCC-only source tests are registered pending:
two runtime and one compile/preprocessor, adding 12 GCC PDP-6 cells.
Forty-two original sources remain deferred for required dialect,
diagnostic, linker or DWARF-mode assertions. Five inapplicable i386
or ARM/Thumb PE sources were deleted and appended to the new
94-row tombstone v2 manifest. **155 original source reviews remain**
(five same-name candidates, 150 unreviewed). No compiler or
emulator tests were executed.

The eleventh 50-source review covers only the historical
`gcc.dg/format/` suite. See
`docs/GCC-C-BATCH11-REVIEW-20261117-v1.md` and the hash-pinned,
per-source TSV. Its **940 required warning**, **33 required error**,
and **11 forbidden diagnostic** assertions (plus five cases relying
on warning-free option-specific acceptance) cannot be exercised by
ordinary compile-success registrations. Accordingly all 50 sources
remain preserved but deferred; none was registered or deleted.
The original `format.h` companion remains preserved and verified.
**105 source reviews remain unresolved** (four same-name and 101
unreviewed). The 585 retained originals and 94 deleted-source
tombstones remain unchanged. No tests were executed.

DAIMOS C language and ABI measurements are maintained in the `TOOLCHAIN/DAIMOS-*.MD` documentation under the separate `pdp10-doc` repository. The KCC KL10 EXTEND decision is recorded in `TOOLCHAIN/KCC-EXTEND-DECISION.MD` there. This testkit keeps executable tests and test-specific operating policies.

Active matrix-registered compiler sources are organized under `tests/semantic/`,
`tests/codegen/`, `tests/negative/`, and `tests/isa/`. Upstream GCC execution
sources awaiting review are classified under `tests/semantic/upstream/`, not
`tests/todo/`; classification does not imply successful execution. Upstream
GCC code-generation sources live under `tests/codegen/upstream-gcc/`.
Supporting sources included by registered tests remain next to their owning
tests. The dated import batch was consolidated into `tests/semantic/imported/`
and `misc/kcc-host/`.

## PDP-6 Type 166 floating-point fidelity

The original DEC Type 166 FDAS/EMNF normalization logic differs from
mathematically rounded floating-point results at some boundaries. The
dedicated case-9 hardware regression expects octal `0544000000003` and
passes under both SIMH PDP-6 and AAP with KCC optimized and unoptimized.
The original 24-case mathematical regression retains its independent
oracle and is **manual**, not hardware acceptance. Hardware behavior for
its other 23 cases and floating-point semantics of later PDP-10 CPU
families remain to be verified. See
`docs/PDP6-FP-SIMH-FIDELITY-20261021-v1.md` and `TODO.md`.

The retired codegen import collection was reviewed and selectively migrated;
see `docs/CODEGEN-IMPORT-AUDIT-20261014.md`.

Upstream GCC execution tests are now individually classified beneath
`tests/semantic/upstream/`. Their per-file activation state and rationale are
recorded in `docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261014-v2.tsv`.
They are not automatically active compiler-matrix entries.

The deferred upstream inventory includes identical retained sources with
distinct original paths and sometimes different compiler evidence. The
static source-ownership gate `tools/audit-test-inventory-v1.py` checks the
50 source pairs pinned in
`docs/DEFERRED-SOURCE-DUPLICATES-20261116-v1.tsv`, including two copies
that match already active tests. See
`docs/DEFERRED-SOURCE-DUPLICATES-20261116-v1.md`. This tracks pending
ownership review; it does not execute the tests or establish pass status.
