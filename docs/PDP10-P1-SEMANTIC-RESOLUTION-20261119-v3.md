# PDP10 P1 semantic source resolution: immutable history, live v3

Date: 2026-11-19. This file is a progression from v1 (the immutable
59-source actionable baseline) and v2 (three completed original-source
intents). No original source or existing ledger was modified.

## Authoritative current state

- Historical original semantic sources: **67**, all still retained as
  hash-pinned imported sources with their original `activation=deferred`.
- Frozen v1 actionable source obligations: **59** (five work batches of
  ten sources and one batch of nine, immutable positions).
- Current exact live v3 states: **14 covered, 10 partial, 43 blocked**.
- Actionable P1 original-source obligations: **53**, not 67 or 59.
- Batch 1: **6 covered, 4 partial, 0 unexamined** original sources.
- AAP architectural correctness and timing expansion is **P3**.

The source of truth is `PDP10-P1-SEMANTIC-RESOLUTION-20261119-v3.tsv`,
validated by `tools/build-p1-semantic-resolution-v3.py`. It reads the
unchanged historical original source hashes, source-classification
manifest, all earlier companion ledgers and the source/profile-linked
40-result Batch 1 archive. A source can be marked P1-covered while
GCC or KCC still fails a valid regression; this does not fix or hide
compiler defects. A missing helper, unsupported enum-field policy or
unobservable simulator timeout is **not** a completed oracle.

## Batch 1 new closures

In addition to `arith-ll.c` and the two 32-character-alignment
originals already covered in v2, three source intents are newly
covered by normal-matrix GCC/KCC PDP-6 tests:

1. `20010924-1.c`: both GNU flexible array initializer forms execute
   correctly under GCC in all four modes. The separate ordinary string
   pointer/array baselines execute under KCC and GCC; KCC passes both
   modes and GCC fails its pointer assertion in all four modes. Both
   independent obligations are recorded rather than allowing the
   baseline GCC regression to conceal the passing GNU feature.
2. `20020227-1.c`: the packed unaligned complex-float write/readback
   checks both real/imaginary components and adjacent char; GCC fails
   actual readback assertions in all four modes. KCC does not implement
   the source's GNU packed complex feature.
3. `20020411-1.c`: complex-float array conjugation and promotion to
   complex-double with independent real/imaginary expectations; GCC
   O0/O1/O2/Os all fail the imaginary component assertion. KCC GNU
   complex support is not assumed.

These three **P1 construction** closures are not compiler PASS claims.

## Four still-partial original-source intents

- `20000914-1.c`: retain the original enum declaration chains and
  eight-bit `enum tree_code` bitfield. `AMBIG_CONV=222` is derived
  independently. GCC passes; KCC fails readback. The field's signedness
  and implementation-defined conversion need a target policy oracle.
- `920302-1.c`: original label-address subtraction/computed-goto intent
  has a registered source companion, but all four GCC modes time out
  in SIMH without an observable guest exit. Diagnose before closure.
- `920501-2.c`: real GCD/power-modulo checks exist; GCC fails modular
  exponentiation and KCC requires genuine `__kcc_umoddi3` linkage.
  The original Pollard factorization is not yet exercised.
- `920501-6.c`: integer square-root, decimal parsing and bounded prime
  checks are registered; only GCC Os passes the bounded companion.
  KCC opt fails the integer-sqrt assertion, KCC noopt exhausts its
  instruction budget, and GCC O0/O1/O2 fail decimal conversion.
  The original larger prime interval remains an open separate oracle.

Full evidence and precise failure categories:
`docs/PDP10-P1-BATCH1-ADMISSION-20261119-v1.md`.

## Stable ownership and next stage

The updated fixed-batch map is
`PDP10-P1-SOURCE-BATCHES-20261119-v2.tsv`, checked by
`tools/audit-p1-source-batches-v2.py`. Every one of the frozen 59
original source positions remains represented exactly once with its
original SHA256. The corresponding human readable list is
`PDP10-P1-SOURCE-BATCHES-20261119-v2.md`.

Resolve the remaining four Batch 1 prerequisites before Batch 2
policy/diagnostic admission. Do not merge duplicate original source
identities, silently reclassify a timeout as an abort, or introduce
test-only libc/ABI workarounds. No benchmark or compiler repair is
part of this P1 status transition.
