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

The 679 historical non-target-specific GCC sources not byte-identical to
existing tests are now preserved under `refs/gcc-c-unmirrored-v1/`, pinned
to GCC revision `b0f5374`. The per-source assertion/ownership inventory is
`docs/GCC-C-UNMIRRORED-OWNERSHIP-20261116-v1.tsv`. Its registered static
verifier is `tools/inventory-gcc-unmirrored-v1.py`. Archived local include
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
20 found inapplicable. **455 original sources remain unresolved**.
No compiler or emulator tests were executed.

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
