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
sources. The 679 original blobs were initially preserved byte-for-byte under
`refs/gcc-c-unmirrored-v1/`, with their group/subdirectory names and
SHA-256 hashes. The initial source payload was approximately 657 KB.
On 2026-11-17, the 89 inapplicable originals from batches 01-06,
five from batch 10, and 25 from batches 12-13 were deleted; **560** source
snapshots remain byte-for-byte unchanged. All 679 source
identities and SHA-256 fingerprints remain in the provenance ledger.
Whitespace and line endings of retained sources are not reformatted.

The authoritative per-file static inventory is
`manifests/GCC-C-UNMIRRORED-OWNERSHIP-20261116-v1.tsv`. Every row identifies
the original GCC path, original SHA, testkit reference snapshot, broad
oracle type, `dg-do` behavior, original diagnostic/final directives,
target restrictions, earlier risk hints, same-name central candidates,
and a conservative assertion-level review status. This is an ownership
inventory, **not** a 679-test execution schedule.

The existing `verify` group now owns
`tools/inventory-gcc-unmirrored-v1.py`. The default action checks all
**560 retained source hashes** against preflight, verifies the full
679-row decision ledger, confirms absence of the 119 deleted originals,
and audits source-to-adaptation paths and active registrations. Explicit
`--import-sources` restores **only eligible** snapshots from the historical
GCC Git object database, deleting inapplicable snapshots if present;
the ordinary verifier requires no GCC checkout.

The archived C sources also have test-local quoted-include dependencies.
The recursive source inventory preserves 25 companion files, including
`gcc.dg/format/format.h` (used by 53 historical C tests), preprocessor
`mi*` headers and `unc1.c`. The versioned
`manifests/GCC-C-SOURCE-COMPANIONS-20261116-v1.tsv` pins their original hashes,
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

A refreshed static six-token structural comparison of the **560 retained**
original sources against the testkit C sources is recorded in
`manifests/GCC-C-STRUCTURAL-OVERLAPS-20261116-v1.tsv`. It is reproduced with
`tools/inventory-gcc-unmirrored-v1.py --report-overlaps`. The refreshed
scan after the assembler-oracle activations has **113 potential
source-shape leads** (compared to 111 after the final source-review
batches, 101 after batch 10, 99 after batch 09, 83 after batch 08,
78 after batch 07, 69
immediately after initial inapplicable-source deletion, and 21 at
initial import). These are merely token-level hints:
matching source shape does not prove an equivalent test oracle. The
historically identified `gcc.dg/format/attr-2.c` versus
`compile/20010701-1.c` is still not equivalent because its required
format diagnostics and `format.h` dependency are not preserved.

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
`manifests/GCC-C-BATCH01-20261116-v1.tsv`, explained in
`history/GCC-C-BATCH01-REVIEW-20261116-v1.md`. The preceding table is
the historical pre-batch snapshot; after batch 01, the current ledger
has **553 unreviewed plus 52 same-name review** sources (605 unresolved).
No tests have been executed in this batch.

## KCC eligibility follow-up (2026-11-17)

The 17 batch-01 tests and the 13 prior registered GCC PDP-10 runtime
regressions now have per-source KCC applicability decisions in
`manifests/GCC-C-KCC-CROSS-COMPILER-20261117-v1.tsv`. All 17 batch-01
adaptations and three earlier cases have KCC semantic contracts and
are enabled as `pending` for KCC PDP-6 native and base profiles
(40 new matrix cells). The other ten retain GCC-only exact-width/packing
semantics. No tests were executed. The static inventory checks eligibility.
Future 50-source review batches must classify both compilers.

## Batch 02 update (2026-11-17)

The next 50 unresolved original GCC C tests are now classified in
`manifests/GCC-C-BATCH02-20261117-v1.tsv` and
`history/GCC-C-BATCH02-REVIEW-20261117-v1.md`. Eleven are newly registered
as pending (eight runtime, three compile-only): eight KCC/GCC-shared,
two GCC-only and one KCC-only in the current compiler profiles. The
other 39 have explicit defer/inapplicable rationales, especially for
compiler-option and diagnostic oracles. The matrix gained 40 pending
GCC and 18 pending KCC PDP-6 cells. **555 original sources are still
unresolved** (37 same-name candidates, 518 unreviewed). Neither compiler
nor emulator tests were executed.

## Batch 03 update (2026-11-17)

Another 50 original gcc.dg C files have source-level classifications,
separate KCC decisions, original-oracle descriptions and source hashes
in `manifests/GCC-C-BATCH03-20261117-v1.tsv`, explained in
`history/GCC-C-BATCH03-REVIEW-20261117-v1.md`. Seven sources became
pending matrix owners (three runtime, four compile-only; six share
KCC/GCC scope and one has GCC-only `unsigned long long` bitfields).
The other 43 remain archived, of which 22 are deferred and 21 are
inapplicable. This adds 28 pending GCC and 12 pending KCC PDP-6 cells.
**505 originals remain without assertion-level decisions** (21
same-name review and 484 unreviewed). No compilation, linker,
emulator or runtime tests were executed in this batch.

## Batch 04 update (2026-11-17)

The next 50 unresolved gcc.dg originals have explicit PDP-10 and KCC
compatibility decisions, preserved compiler/link/diagnostic oracles,
and SHA256 fingerprints in `manifests/GCC-C-BATCH04-20261117-v1.tsv`, with
the detailed review in `history/GCC-C-BATCH04-REVIEW-20261117-v1.md`.
Five are registered as compiler-matrix codegen tests: two shared C
compile-only regressions and three GCC-only inline-assembly regressions.
The two percent-escape sources preserve their `dg-final` assertions via
the native assembler regex policy; the third originally had no active
`dg-final`. Twenty-five cases are deferred and twenty inapplicable,
especially foreign ISA and positive/negative diagnostic cases.
Twenty GCC and four KCC PDP-6 `pending` cells were added.
**455 originals remain unresolved** (14 same-name candidates and
441 unreviewed). No compilation or execution tests were run.

## Batch 05 update (2026-11-17)

Fifty further original gcc.dg tests were reviewed source-by-source,
including strict C90 and C99 language-mode contracts, required and
forbidden diagnostics, and GNU compiler extension assertions. Details
and individual KCC compatibility decisions are in
`history/GCC-C-BATCH05-REVIEW-20261117-v1.md` and
`manifests/GCC-C-BATCH05-20261117-v1.tsv`. Four tests are registered:
`attr-alwaysinline.c` (GCC `-O0` assembly omission),
`builtin-choose-expr.c` (GCC `-O1` runtime), and C99 array
decay/boolean oracles shared with KCC. Another 45 are deferred
pending strict C90/C99 compiler-mode and diagnostics mapping; the
IEEE64 double packed-union test is inapplicable to PDP-10.
The matrix gained **10 pending GCC** and **four pending KCC** cells.
**405 original sources remain unresolved** (12 same-name candidates,
393 unreviewed). No compilation, simulator or runtime tests were run.

## Batch 06 update (2026-11-17)

The next 50 original GCC C sources were inspected for their C99
run/compile, preprocessor, diagnostic and link assertions, and for
separate KCC PDP-10 eligibility. Per-original SHA256 fingerprints,
portability decisions, original options and exact active compiler
profiles are in `manifests/GCC-C-BATCH06-20261117-v1.tsv`, explained in
`history/GCC-C-BATCH06-REVIEW-20261117-v1.md`. Twelve source oracles are
newly registered pending (nine runtime, three compile-only); nine
are shared with KCC, three are GCC-only. The matrix gains 48 pending
GCC and 18 pending KCC PDP-6 cells. Thirty-seven others are deferred
for strict C99 mode, diagnostic, representation, or link assertions,
and the x86 physical-register clobber case is inapplicable.
**355 original sources remain unresolved** (12 same-name candidates,
343 unreviewed). No compiler, emulator or runtime tests were executed.

## Inapplicable original source removal (2026-11-17)

Per the explicit cleanup request, **89 original C source snapshots**
classified `inapplicable` across batches 01-06 have been deleted from
`refs/gcc-c-unmirrored-v1/`. Counts by batch are 23, 23, 21, 20, 1,
and 1 respectively. Only **590 original C snapshots are retained**;
all 679 historical source identities, hashes, original assertions and
review decisions remain auditable in the preflight, six batch TSVs and
ownership ledger. The deleted-source tombstone manifest is
`manifests/GCC-C-INAPPLICABLE-REMOVALS-20261117-v1.tsv`, explained in
`history/GCC-C-INAPPLICABLE-REMOVALS-REVIEW-20261117-v1.md`.

Static verifier and `--import-sources` paths now enforce absence of
inapplicable source files; re-imports do not resurrect them. The
structural overlap index was refreshed for 590 retained originals.
The 25 preserved local include companions, all active/adapted tests,
all deferred tests, and the 355 unresolved originals were left intact.
No compiler, assembler or emulator tests were executed.

## Batch 07 update (2026-11-17)

The next 50 original `gcc.dg/cpp` sources were reviewed for their
preprocessor, compiler and diagnostic assertions, and separately
for KCC/PDP-10 applicability. Eleven sources gained pending native
test owners, of which eight can also be exercised with KCC and three
are GCC-only. The tests include `__LINE__` source-location behavior,
macro invocation and paste handling, unary preprocessor arithmetic,
recursive includes (with two SHA256-pinned original headers), GNU
varargs and predicate assertions, and runtime `@` stringization.
The exact 50-row review is in `manifests/GCC-C-BATCH07-20261117-v1.tsv`,
explained in `history/GCC-C-BATCH07-REVIEW-20261117-v1.md`; the two
headers are pinned in `manifests/GCC-C-BATCH07-COMPANIONS-20261117-v1.tsv`.
This adds **44 pending GCC** and **16 pending KCC** PDP-6 matrix cells.

Thirty-nine originals remain deferred because they require positive
or negative diagnostics, preprocessing output comparison, unsupported
language-mode flags, or distinct preprocessing-only contracts. No
new originals were classified inapplicable, so all 89 previous source
deletions remain enforced. **305 unresolved sources remain**
(nine same-name candidates and 296 unreviewed). All verification was
static; no compiler, assembler, simulator or runtime tests were run.

## Batch 08 update (2026-11-17)

Another 50 consecutive historical `gcc.dg/cpp` C sources were
reviewed, including GNU CPP diagnostics and language-mode differences,
preprocessed-output assertions, trigraphs, target-width-sensitive
preprocessor arithmetic, macro-expanded includes, and `#line`.
The 50 per-original assertion and KCC eligibility reviews are in
`manifests/GCC-C-BATCH08-20261117-v1.tsv` and explained in
`history/GCC-C-BATCH08-REVIEW-20261117-v1.md`. Seven positive original
source oracles are registered pending: two runtime and five
compile/preprocess tests; four also apply to KCC and three are GCC-only.
The `mi1c.h` include file used by the macro-expanded include test
is preserved and hash-pinned beside its owner, documented in
`manifests/GCC-C-BATCH08-COMPANIONS-20261117-v1.tsv`.

The matrix gains **28 pending GCC** and **eight pending KCC** PDP-6
cells. Forty-three sources are deferred for required diagnostics,
compiler dialect flags, preprocessing-only output, or PDP-10 width
semantics; **zero** are newly inapplicable, so all 89 previous source
deletions are unchanged. **255 unresolved original sources remain**
(nine same-name candidates, 246 unreviewed). All verification was
static; no compiler, assembler, emulator or runtime tests were run.

## Batch 09 update (2026-11-17)

The next 50 unresolved historical `gcc.dg/cpp` sources were reviewed
for original macro expansion, header inclusion, token paste and
stringization behavior, as well as preprocessor output and exact
warning/error assertions. Every original source has an explicit
independent PDP-10 and KCC eligibility decision recorded in
`manifests/GCC-C-BATCH09-20261117-v1.tsv` and explained in
`history/GCC-C-BATCH09-REVIEW-20261117-v1.md`.

Nineteen tests are registered pending: 11 runtime and eight
compile/preprocessor tests, 14 GCC/KCC shared and five GCC-only.
The matrix adds **76 pending GCC** and **28 pending KCC** PDP-6
cells. Four owners depend on real include graphs with 11 distinct
original companion files, all copied byte-for-byte and hash-pinned in
`manifests/GCC-C-BATCH09-COMPANIONS-20261117-v1.tsv`. `macro8.c` and
`mi6.c` originally requested compile-only, but their retained source
includes nonvacuous runtime abort checks; native registration additionally
exercises those, without claiming the original DejaGNU harness did so.
Any omitted strict -std language-mode flags are explicitly qualified.

Thirty-one cases remain deferred because the original Tcl output checks,
preprocessor-only actions, warning/error locations, -CC/-H include
traces or token/character assumptions cannot be represented by a
regular positive compiler test. No new inapplicable cases were found.
The 89 prior source-deletion tombstones and the retained 590 originals
are unchanged. **205 original sources remain unresolved**: nine
same-name reviews and 196 unreviewed. Static six-token comparison has
99 potential source-shape hints after batch09, not equivalence proofs.

No compiler, assembler, linker, emulator, simulator or runtime tests
were run during batch09; only source, hash, matrix, ownership and
repository-documentation checks were performed.

## Batch 10 update and deletion manifest v2 (2026-11-17)

The next 50 unresolved historical C sources span `gcc.dg/cpp`,
`gcc.dg/debug`, `gcc.dg` diagnostics and explicitly foreign target
DLL tests. Source and independent KCC compiler-scope decisions are
pinned in `manifests/GCC-C-BATCH10-20261117-v1.tsv`, explained in
`history/GCC-C-BATCH10-REVIEW-20261117-v1.md`.

Three GNU CPP source-level oracles are registered GCC-only pending:
`vararg1.c` (runtime argument counting/string newline), `vararg2.c`
(C99/GNU variadic preprocessor guards), and `wchar-1.c` (compiler/
CPP agreement on wide-character signedness). There are **12 new
pending GCC** PDP-6 optimizer cells, no new KCC cells. Original
`-std=gnu99` and `-w` options are not reproduced by the generic
compiler matrix; the exact retained source-level checks, not full
original option-mode conformance, are registered. All original C
bytes, including one trailing whitespace line, remain unchanged.

Forty-two sources remain deferred: traditional preprocessor and
warning output, 9-bit/36-bit tokenization and Unicode diagnostics,
plus debug-specific DWARF generation, link and annotated assembler
scan requirements. A default successful compile cannot establish
those original assertions, and the same-name central testkit sources
are not equivalent by name alone.

Five newly inapplicable originals have been deleted: the original
32-bit i386 `tr-sign.c` and `gcc.dg/dll-1.c` through `dll-4.c`,
which are explicitly ARM/Thumb Windows PE import/export tests. Their
original fingerprints and precise PDP-10 incompatibility reasons were
appended to the complete version-2 tombstone manifest
`manifests/GCC-C-INAPPLICABLE-REMOVALS-20261117-v2.tsv`, separately
explained in the v2 removal review document. The first **89** deletion
records remain byte-for-byte identical to the v1 manifest; all
**94** inapplicable original snapshots remain absent. The retained
archive now has **585 C originals**, while the preflight and ownership
ledger still account for all **679 original source identities**.
The 25 original include companions remain retained.

The structural overlap report was regenerated against 585 retained
sources, producing 101 token-level similarity leads, not assertions
of equivalence. **155 unresolved source reviews remain** (150
unreviewed and five same-name). No compiler, assembler, linker,
emulator, simulator or runtime tests were executed.

## Batch 11 update: GCC format-diagnostic corpus (2026-11-17)

Batch 11 reviews the next 50 unresolved historical sources, all from
`gcc.dg/format/`. Their per-original assertion and PDP-10/KCC
compatibility decisions are recorded in
`manifests/GCC-C-BATCH11-20261117-v1.tsv` and explained in
`history/GCC-C-BATCH11-REVIEW-20261117-v1.md`.

The original 50 sources have **940** required `dg-warning`, **33**
required `dg-error`, and **11** forbidden `dg-bogus` annotations.
Five others contain no explicit diagnostic annotation but exercise
warning-free acceptance only in a specified C94/GNU89/GNU99 dialect
or with a particular `-Wformat` warning-suppression option.
None has a meaningful positive compile-success oracle with generic
optimizer flags. All **50 are deferred**, zero registered pending,
zero inapplicable and zero removed. The namesake central `array-1.c`
is unrelated source content and does not satisfy its format checker.

The original `format.h` dependency remains byte-for-byte preserved
and hash-pinned; 48 of the 50 sources include it, while `attr-5.c`
and `attr-6.c` deliberately omit it to check default built-in or
implicit format attributes. KCC GCC-format-warning equivalence is
not established. The static inventory now checks the 50 SHA256
fingerprints, exact `dg-do`/`dg-options`, per-source diagnostic
annotation counts, header dependencies and inactive matrix ownership.

The historical source archive still retains **585** C originals, with
**94** inapplicable originals absent under unchanged version-2
tombstones. The structural overlap index is unchanged from batch 10:
585 retained sources and 101 token-shape hints, not equivalent
assertions. **105 unresolved originals remain**, with 101
unreviewed and four same-name candidates. No compiler, assembler,
linker, emulator or runtime tests were executed.

## Final 105 originals: batches 12-14 complete (2026-11-17)

The last 105 unresolved original GCC C sources were reviewed together
in 50/50/5 source-order groups. Complete, individual PDP-10 and KCC
compatibility decisions, source hashes, DejaGNU assertions, original
options and exact matrix scopes are recorded in
`manifests/GCC-C-BATCH12-20261117-v1.tsv`,
`manifests/GCC-C-BATCH13-20261117-v1.tsv`, and
`manifests/GCC-C-BATCH14-20261117-v1.tsv`. A combined explanation is
`history/GCC-C-FINAL105-REVIEW-20261117-v1.md`.

Ten original source-level tests are newly pending: seven runtime
(GNU89/GNU99 aggregate initialization, alias/weak-alias symbol
resolution, optimizer/linker structure alias behavior, and 64
by-value aggregate sizes), plus three compile-only (long long/short
conversions and optimized pointer arithmetic). Two compile-only
sources also receive KCC native and base coverage. The matrix has
**31 new pending GCC PDP-6** and **four pending KCC PDP-6** cells.
All adapted source bytes are identical to their original snapshots;
none has been executed. The native runtime registrations for three
historical link-only tests strengthen their original source-level
oracles without claiming the upstream DejaGNU suite originally ran
them. Exact C89/GNU89/GNU99 mode gating is not inferred from default
compiler profiles.

Seventy sources are retained but deferred because they require an
original warning/error/suppression oracle, multi-translation-unit
link graph, `#pragma pack` behavior not yet verified on PDP-10,
64-bit-specific results, or exact native assembler output. The
PDP-10-specific `pdp10-local-char-word-boundary-1.c` and
`pdp10-lshr-subreg-plus-1.c` have especially high priority, but
`scan-assembler` checks are mandatory: compile success is insufficient.

Twenty-five explicitly foreign architecture/ABI originals were
marked inapplicable and deleted, with their exact SHA256 and reasons
appended to the version-3 deletion manifest
`manifests/GCC-C-INAPPLICABLE-REMOVALS-20261117-v3.tsv`, described in its
v3 review. All earlier 94 v2 tombstones and earlier 89 v1 entries
remain unchanged. The original 679-source preflight and ownership
ledger still preserve every source identity, but only **560 C
original source snapshots** remain archived, together with all 25
archived include companions. **119** inapplicable originals remain
absent. The static six-token overlap index covers 560 retained C
sources with 111 source-shape hints, none a proof of equivalent
compiler coverage.

**All 679 historical C originals now have a source-level ownership
classification: zero `unreviewed` or `same-name-review` entries**.
This completes the review and registration process, not the pending
execution of enabled cases, nor the genuine diagnostic, debugger,
linker and assembler checks for deferred tests. No compiler,
assembler, linker, emulator, simulator or runtime tests were run.

## Original PDP-10 assembler regressions activated (2026-11-17)

The two historically deferred PDP-10 GCC assembler regressions
`pdp10-local-char-word-boundary-1.c` and
`pdp10-lshr-subreg-plus-1.c` now have native codegen owners under
`tests/codegen/gcc-historical-b12-v1/`. These files preserve the
original C bytes and prepend only the existing codegen runner's
`codegen-require-regex` / `codegen-forbid-regex` directives.
The required and forbidden regexes match the four original
`dg-final scan-assembler`/`scan-assembler-not` assertions exactly.

The unchanged original 50-row source review is preserved at
`manifests/GCC-C-BATCH12-20261117-v1.tsv`. The separately versioned
`manifests/GCC-C-BATCH12-20261117-v2.tsv` promotes only these two
originals to `batch12-pending` in the authoritative 679-source
crosswalk, and activates exactly eight GCC O2 codegen matrix cells
(PDP-6, KA10, KI10, KS10). No KCC or non-O2 profiles are added.
Batch12 now counts five pending, 23 deferred and 22 inapplicable.
The final 105-source review has 12 pending, 68 deferred and 25
inapplicable; the other source identities remain unchanged.

Installed GCC 3.2 compiled both original source bodies at `-O2`
for all four target architectures and the native runner checked
both the required and forbidden assembler predicates. **All eight
real codegen cells passed**. Eight separate deliberately corrupted
assembler examples were rejected by the same policy checker with
16 expected positive/negative match failures. No emulator or
runtime test was executed. The full procedure, execution results,
reproduction guidance and limitations are in
`history/GCC-C-PDP10-ASSEMBLER-REGRESSIONS-20261117-v1.md`.

All 560 historical C snapshots remain byte-identical; the 119
inapplicable original deletions and 25 preserved include companions
remain unchanged. The uncommitted GCC negative-policy and runner
worktree changes belong to a different task and are not part of
this assembler regression activation.
The recomputed structural overlap index has 113 token-level leads
after adding these two near-identical active source copies; these
are not independent new assertions or additional original sources.
