# PDP10 P1 semantic resolution and immutable work batches - version 2

Date: 2026-11-19. This is an update to the immutable v1 resolution,
not a replacement for the original historical source manifests.

## Current exact progress

- Original imported sources: **67**; eight were covered before this
  work stage, and their original bytes, SHA256, and deferred import
  statuses remain preserved.
- Original P1 obligations open at the v1 baseline: **59**, grouped into
  **five batches of 10 and one batch of 9**, with exactly one stable
  assigned position per original source.
- New P1 closures this stage: **three** of those 59 sources.
- Current v2 status across all 67: **11 covered**, **6 partial**,
  **50 blocked**; thus **56 actionable P1 obligations remain**.

The authoritative assignment is
`PDP10-P1-SOURCE-BATCHES-20261119-v1.tsv` and its human-readable
companion `PDP10-P1-SOURCE-BATCHES-20261119-v1.md`. The authoritative
current source status is
`PDP10-P1-SEMANTIC-RESOLUTION-20261119-v2.tsv`.

## Batch 1 completed source intents (3/10)

`tests/todo/generic/arith-ll.c` uses hosted `printf` only to report
mismatched integer arithmetic; that diagnostic I/O is not needed to
exercise the original arithmetic semantics. The separate and active
`pdp10-wide-arithmetic-operators-v1.c` checks all fifteen original
operand pairs across add/sub/mul/div with independently calculated
expectations, volatile input values, and an abort checkpoint per
operation. **GCC O0/O1/O2/Os: 4 PASS; KCC opt/noopt: 2 real assertion
failures** at octal checkpoint 013. This closes the tested PDP-6
arithmetic *intent* while retaining the historical hosted diagnostic
for original-source provenance. The original source was not rewritten.

`tests/semantic/upstream/extensions/20010904-1.c` and
`20010904-2.c` only assert 32-character array strides under a
preprocessor guard that can skip their test on PDP-10. A single
`pdp10-aligned32-array-strides-v1.c` companion tests both original
array layouts without that guard, including the 32-addressable-char
alignment, the struct member offsets, the actual consecutive array
address delta, and array field readbacks. **GCC PDP-6 O0/O1/O2/Os:
4 real runtime assertion failures** at checkpoint 3. KCC rejects the
GNU aligned-typedef form and is not marked as a passing compiler.
The original two source files and their historical compiler
observations are unchanged.

Evidence and exact source SHA256 links are in
`PDP10-P1-ARITHLL-MATRIX-RESULTS-20261119-v1.tsv` and
`PDP10-P1-ALIGN32-RESULTS-20261119-v1.tsv`, with complete original
compiler and guest logs in the matching versioned archives under
`refs/`. Registered independent auditors validate original source
identities and all **ten** observed PDP-6 compiler profiles, and
reject fabricated passing results.

## Batch scheduling invariants

The six groups are deliberately fixed by source identity and blocker
prerequisites. Do **not** move completed entries to the next batch,
shrink the 59-row assignment, or treat an expected compiler failure
as incomplete test construction. The first batch remains ten assigned
sources with three completed and seven remaining.

`tools/audit-p1-source-batches-v1.py` regenerates and verifies all
59 source SHA256 assignments, exactly one batch per original, the
per-batch sizes 10/10/10/10/10/9, and their current completion states.
`tools/build-p1-semantic-resolution-v2.py` separately verifies all
67 original identities, the complete original-to-companion linkage,
normal matrix admissions, and existing source-hash-pinned execution
ledgers. The v1 verifier and ledger remain unchanged as the dated
baseline. Neither verifier fixes compilers, substitutes libc stubs,
or promotes the original historical source to a passing test.

Compiler implementation investigation and performance benchmarks
remain outside this P1 testkit construction phase.
