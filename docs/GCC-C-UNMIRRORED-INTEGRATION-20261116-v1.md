# Historical GCC C-test integration and assertion ownership (2026-11-16 v1)

## Scope, constraints and source provenance

Only `pdp10-testkit` is modified. No compiler, assembler, emulator, or test
case has been executed in this integration stage. No pass/fail evidence has
been inferred from registration, source identity or a static audit.

The original GCC 3.2 testsuite was removed from the live GCC checkout.
Its revision `b0f5374f6d4462bb8759160ece635e306d90998f` still contains
the historical original sources. The prior preflight excluded every
byte-identical `tests/*.c` copy and inventoried 693 remaining sources:
14 separately reviewed `gcc.target/pdp10/` sources and **679 other** C
sources. The 679 original blobs are now preserved byte-for-byte under
`refs/gcc-c-unmirrored-v1/`, retaining their group/subdirectory names and
recorded SHA-256 hashes. Total source payload is approximately 657 KB.
Original whitespace and line endings, including historical trailing
whitespace, are retained deliberately. Reformatting would invalidate
the source hashes and compromise the archival provenance.

The authoritative per-file static inventory is
`docs/GCC-C-UNMIRRORED-OWNERSHIP-20261116-v1.tsv`. Every row identifies
the original GCC path, original SHA, testkit reference snapshot, broad
oracle type, `dg-do` behavior, original diagnostic/final directives,
target restrictions, earlier risk hints, same-name central candidates,
and a conservative assertion-level review status. This is an ownership
inventory, **not** a 679-test execution schedule.

The existing `verify` group now owns
`tools/inventory-gcc-unmirrored-v1.py`. The default action compares all
679 retained source hashes against the preflight and verifies the ledger,
source-to-adaptation paths and active registrations. An explicit
`--import-sources` restores the original snapshots from the historical GCC
Git object database; the ordinary verifier requires no GCC checkout.

The archived C sources also have test-local quoted-include dependencies.
The recursive source inventory preserves 25 companion files, including
`gcc.dg/format/format.h` (used by 53 historical C tests), preprocessor
`mi*` headers and `unc1.c`. The versioned
`docs/GCC-C-SOURCE-COMPANIONS-20261116-v1.tsv` pins their original hashes,
referencers and reachability. One historical `#include "silly\\` from the
preprocessor diagnostic corpus names a file absent from the original GCC
tree; this is recorded as absent, not replaced with a synthetic header.
None of this installs hosted/system headers or implements DejaGNU execution.

## Already integrated or partially adapted

Six original GCC tests have source-level adaptations already registered
in the testkit (five execution cases and one compile-only case):

| Original GCC basename | Actual ownership / adaptation |
| --- | --- |
| `20000403-1.c` | `tests/semantic/upstream/generic/`: replace 8-bit assumption by `CHAR_BIT` in sign-boundary expressions |
| `20011126-1.c` | `tests/semantic/upstream/wide-int/`: failed negative-value assertion becomes nonzero status |
| `20020216-1.c` | `tests/semantic/upstream/generic/`: replace vacuous 8/16/32-bit guard by native 9/18/36-bit signed XOR expectation |
| `960311-3.c` | `tests/semantic/upstream/generic/`: move `stdio.h` inside `DEBUG`; assertion unchanged |
| `920711-1.c` | `tests/semantic/upstream/generic/`: retain decrement/branch comparison and return status, but the original 32-bit signed boundary becomes an interior positive PDP-10 value |
| `20020304-1.c` | `tests/codegen/upstream-gcc/compile/`: retained large compile-only source with shortened PDP-10 linker symbols |

Two additional source adaptations are present **but deferred**:
`20020402-3.c` (the main return now asserts the expected pointer), and
`920728-1.c` (assembler label renamed). These are not active executions.
The existing `921202-1.c` compile-only stress case contains part of the
original large-array code shape, but **does not preserve the runtime
oracle**. It is therefore recorded as *partial*, not fully equivalent.

The original `gcc.dg/builtin-prefetch-1.c` requires warnings for invalid
argument values, whereas the current same-named semantic version checks
valid argument combinations. The latter cannot replace the former
negative diagnostic oracle. A same-named source is not automatically a
duplicate, and a common 10-token `main` that returns zero is not evidence
of shared compiler regression coverage.

A static six-token structural comparison of all 679 original sources
against the testkit C sources is recorded in
`docs/GCC-C-STRUCTURAL-OVERLAPS-20261116-v1.tsv`. It is reproduced with
`tools/inventory-gcc-unmirrored-v1.py --report-overlaps`. Of its 21
potential source-shape leads, 13 are newly registered copies of the
original sources. Seven of the eight remaining leads correspond to
adapted sources independently reviewed above. The eighth,
`gcc.dg/format/attr-2.c` versus `compile/20010701-1.c`, is a false
equivalence: shared attribute syntax does not preserve the original
format-warning diagnostics and `format.h` dependency. Heavily rewritten
or very short adaptations can escape this structural scan.

## Newly integrated runtime sources (not yet executed)

Thirteen original PDP-10-oriented `gcc.c-torture/execute/pdp10/` tests
have nonvacuous, directly observable results and no established equivalent
testkit registration. Their **original source bytes** were copied under
`tests/semantic/gcc-historical-v1/` and registered once in
`COMPILER_MATRIX.tsv` with group `semantic-gcc-historical`.

The only scheduled profiles are GCC PDP-6 `-O0`, `-O1`, `-O2`, and `-Os`,
all `pending` (52 cells). No KCC cells or other CPU profiles are enabled
without language/ABI suitability review. Cases cover aligned automatic
byte-pointer offsets; 16-bit exact-width pointer round trips and calls;
packed byte-pointer indexing, decay, global store/reload and arithmetic;
cross-word 6/9/18/8/16-bit packed aggregates; packed character stores;
packed function/pointer objects; and a sibling-call fallthrough hazard.
The individual names are in the TSV ledger. `pending` means unexecuted,
**not** known-good.

Three other historical GCC execution sources were not promoted:

* `20000717-4.c` has an unused regression function and returns zero
  unconditionally; a runnable assertion must first be designed.
* `kl10-static-pointer-init-1.c` needs an appropriate KL10 target profile,
  which the current matrix does not have.
* The independent `pdp10-dimode-div71-1.c` lives directly under
  `gcc.c-torture/execute/`, not its `pdp10/` subdirectory. Its original
  71-bit quotient/remainder assertion requires a distinct
  `-mlong-long-71bit` compiler profile before it can be scheduled as such.

## Remaining review: original GCC assertions, not filenames

The current source-level ledger accounts for 679 records as follows:

| Review state | Sources |
| --- | ---: |
| Confirmed existing active source-level adaptations | 6 |
| Existing adapted copies, deferred | 2 |
| Existing partial compile-only overlap | 1 |
| Source overlap with different assertion | 2 |
| Newly registered GCC-only runtime regressions, pending | 13 |
| Other same-name cases, assertion equivalence unverified | 64 |
| Remaining sources requiring manual assertion review | 591 |
| **Total** | **679** |

`gcc.dg` contains diagnostic, preprocessing, assembler-scan, CPU-gated,
and runtime tests with different obligations. Importing all files as
ordinary positive runtime cells would silently lose most original GCC
assertions. Sources requiring target-specific non-IEEE floats, 36-bit
arithmetic/9-bit byte adaptations, unavailable libc, foreign ISA or
hosted dependencies must be reviewed before they can become active.

The next integration stage should compare original `dg-error` and
`dg-warning` patterns with existing negative/diagnostic policies, then
review preprocessor/assembler oracles. Any source whose original
assertion cannot be represented by the current runner should remain an
owned reference, not a fake passing test. Avoid deleting an active
KCC/GCC cross-compiler test merely because it originated in GCC.

## Batch 01 update (2026-11-16)

The next 50 unresolved original sources, all from
`gcc.c-torture/execute`, have now received source-level compatibility
decisions. Seventeen new GCC-only PDP-6 semantic sources are registered
under `tests/semantic/gcc-historical-b01-v1/` with 68 `pending` cells;
ten sources are deferred and 23 original assertions are inapplicable
to this PDP-10 environment. The source-hash-pinned audit trail is
`docs/GCC-C-BATCH01-20261116-v1.tsv`, explained in
`docs/GCC-C-BATCH01-REVIEW-20261116-v1.md`. The preceding table is
the historical pre-batch snapshot; after batch 01, the current ledger
has **553 unreviewed plus 52 same-name review** sources (605 unresolved).
No tests have been executed in this batch.

## KCC eligibility follow-up (2026-11-17)

The 17 batch-01 tests and the 13 prior registered GCC PDP-10 runtime
regressions now have per-source KCC applicability decisions in
`docs/GCC-C-KCC-CROSS-COMPILER-20261117-v1.tsv`. All 17 batch-01
adaptations and three earlier cases have KCC semantic contracts and
are enabled as `pending` for KCC PDP-6 native and base profiles
(40 new matrix cells). The other ten retain GCC-only exact-width/packing
semantics. No tests were executed. The static inventory checks eligibility.
Future 50-source review batches must classify both compilers.

## Batch 02 update (2026-11-17)

The next 50 unresolved original GCC C tests are now classified in
`docs/GCC-C-BATCH02-20261117-v1.tsv` and
`docs/GCC-C-BATCH02-REVIEW-20261117-v1.md`. Eleven are newly registered
as pending (eight runtime, three compile-only): eight KCC/GCC-shared,
two GCC-only and one KCC-only in the current compiler profiles. The
other 39 have explicit defer/inapplicable rationales, especially for
compiler-option and diagnostic oracles. The matrix gained 40 pending
GCC and 18 pending KCC PDP-6 cells. **555 original sources are still
unresolved** (37 same-name candidates, 518 unreviewed). Neither compiler
nor emulator tests were executed.
