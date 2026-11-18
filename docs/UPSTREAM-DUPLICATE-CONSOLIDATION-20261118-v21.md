# Upstream compiler test source consolidation (2026-11-18, v21)

## Decision

Use **one physical C source file per byte-identical upstream compiler
regression**. Retain the already registered active source when one
exists; for deferred/deferred copies, retain the canonical owner
selected by the v19 duplicate-source review. When two copies are
both active, retain the non-PDP10-import category source: a preflight
proved their complete KCC/GCC compiler/CPU/optimization status
vectors are identical, ignoring only source path, group and display
name. The original source bytes and assertions do not change.

The old "50 duplicate pairs" described only identical source pairs
involving a deferred test. An independent SHA256 scan found **47
additional active/active pairs**, so the complete upstream-source
cleanup covers **97** pairs.

| Inventory | Before | After | Change |
| --- | ---: | ---: | ---: |
| SHA256-identical upstream source pairs | 97 | 0 | -97 |
| Physical redundant C source files | 97 | 0 | -97 |
| Registered compiler matrix sources | 2,190 | 2,143 | -47 |
| Classified upstream paths | 774 | 677 | -97 |
| Active upstream test identities | 531 | 484 | -47 |
| Deferred upstream test identities | 184 | 134 | -50 |
| Previously removed source identities | 58 | 58 | 0 |
| Stress-nonportable source identities | 1 | 1 | 0 |
| Specialized test registrations | 284 | 284 | 0 |
| Intentionally manual special tests | 44 | 44 | 0 |

The lowered active/matrix counts mean that redundant **registrations**
have been removed, not that the underlying compiler test cases or
assertions have been discarded. No new passing compiler profile is
inferred, and recorded compiler failures are not rewritten.

## Permanent source/provenance and compiler evidence

`UPSTREAM-DUPLICATE-CONSOLIDATION-20261118-v21.tsv` records **97
SHA256-pinned mappings**, each with canonical and retired paths,
both historical import paths/categories, source classifications,
original evidence and next actions, original matrix registration
status, and complete prior compiler-profile vectors for registered
copies. The 47 active/active pairs have identical saved profile
vectors; this was checked before physical deletion.

`UPSTREAM-CONSOLIDATED-COMPILER-GATES-20261118-v21.tsv` preserves
**16 unresolved compiler-specific blockers** previously attached to
otherwise identical deferred copies: **13 KCC and three GCC**.
Each gate still identifies the surviving source, the retired
historical alias, its exact original assertion, tested profile
scope, compiler and required follow-up action. They are open
investigations for the later compiler sweep, **not another C source
to execute**. Consolidation does not count these as 16 independent
deferred C programs.

The four deferred/deferred pairs with *different recorded blocker
classes* also retain both original classifications in the v21
provenance table. The surviving deferred entry's evidence explicitly
mentions the alternate historical blocker; this prevents losing
the additional prerequisite when reviewing that test later.

All removed files were byte-for-byte compared to their canonical
copies and verified to exist in Git before removal. Their original
bytes are recoverable using the parent commit, and their hashes
are frozen in the provenance table. The earlier 50-pair v18/v19
census/review and all v8-v20 ten-source review ledgers remain
historical records; they need not point to currently existing
retired aliases.

## Auditing

`tools/audit_consolidated_upstream_v21.py` is a permanent,
fail-closed checker that verifies the 97 retained SHA256 values,
absence of retired aliases, canonical classifications/registrations,
historical source identity and blocker metadata, the archived
active/active profile equality, 16 active-compiler follow-up
gates, and **zero remaining duplicate classified upstream hashes**.
The main `tools/audit-test-inventory-v1.py` invokes this audit;
`tools/verify-deferred-disposition-v1.py` checks the 134 currently
deferred, source-pinned identities.
The helper is registered under the main inventory checker in the
versioned `TEST-SCRIPT-OWNERSHIP-20261118-v5.tsv`, preserving
the earlier script-ownership ledger as historical evidence.

One entry in `OPTIMIZATION_SEMANTIC_ONLY.tsv` was retired with its
duplicate `tests/semantic/upstream/wide-int/conversion.c`.
The remaining, equally compiler-conditioned canonical source at
`tests/semantic/upstream/pdp10/pdp10/conversion.c` stays in that
manifest. The 47 active/active sources still provide the same
compiler matrix profiles after deduplication.

Source review found no relative-quoted include paths or `__FILE__`
dependent predicates in any of the 97 chosen canonical tests.
One source contains fixed `#line 1 "20010206-1.c"` directives,
which are identical in both copies and do not depend on the
source-file directory.

### Focused post-consolidation execution

No full compiler/CPU sweep was run. Six representative PDP-6 cells
executed against *surviving canonical source paths*:

| Source | Compiler/optimization | Actual result |
| --- | --- | --- |
| `generic/20000412-1.c` | KCC noopt | pass |
| `generic/20000412-1.c` | GCC O0 | pass |
| `pdp10/pdp10/strct-pack-1.c` | KCC noopt | pass |
| `wide-int/ashldi-1.c` | GCC O2 | pass |
| `extensions/bcp-1.c` | GCC O2 | pass |
| `extensions/bf-pack-1.c` | GCC O0 | **run_fail**, matching its explicitly failing matrix profile |

Raw results are under
`$TMPDIR/p10tk-duplicate-consolidation-focused-20261118-v21`.
The observed `bf-pack-1.c` failure is intentional coverage of an
unresolved compiler regression, not a failure of this migration.

The source-inventory, SHA256 disposition, registered fixture integrity,
script ownership, special dispatcher and cross-repository boundary
audits pass. The new consolidation auditor additionally rejects
synthetic missing-pair, changed-hash and missing-compiler-gate
conditions without modifying any repository file. The independent
`verify-optimization-common-source.py` checker reports four
pre-existing missing differential-helper annotations
(`20000703-1.c`, `20000815-1.c`, `20001026-1.c` and
`20011121-1.c`). Those four original source paths and their
pre-consolidation optimization manifests are unchanged; this
separate checker cleanup is not represented as successful here.

## Remaining work

The next deferred ten-source batch remains **batch 14**, starting
at `tests/todo/generic/bitfld-2.c`. The canonical deferred list now
has **134 identities**, including **90 not yet individually
reviewed** and **44 previously reviewed, still blocked**.
Batch review must select *physical canonical identities* and exclude
previously reviewed canonical paths; it must not reintroduce
retired aliases. Independently, the 16 open compiler gates should be
included in the eventual compiler/assembler repair sweep.

The 44 manual special tests and broad compiler/CPU matrix remain
untouched. Do not restore a retired source to work around a compiler
failure; repair the implementation or update the canonical test's
verified profile status instead.
