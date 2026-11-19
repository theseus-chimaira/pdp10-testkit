# PDP10 P1 semantic original-source resolution: live v7

Date: 2026-11-19. This report is a live projection; all 67 original
sources, their SHA256s and historical `activation=deferred` statuses are
preserved unchanged. These statuses describe imported originals, **not**
whether an independent PDP-6 regression test is already constructed.

## Current source-construction status

| Item | Count |
| --- | ---: |
| Historical original source identities | 67 |
| **Covered intent** | **38** |
| **Partially covered intent** | **1** |
| **Blocked intent** | **28** |
| **Actionable P1 originals** | **29** |
| Immutable 59-source initial work plan | 10+10+10+10+10+9 |
| Finished fixed batches | **1, 2 and 3: 10/10 each** |

Eight intents were covered before the frozen 59-source work plan.
Another 30 have now completed P1 source construction in three fixed
batches. This is **not** 38 passing compilers. Detailed real failure
checkpoints are still tracked and will be repaired in P2.

## Newly closed Batch 3 intents

The ten exact original source owners are `980526-2.c`, `991118-1.c`,
`arith-rand.c`, `bf64-1.c`, `cbrt.c`, `921215-1.c`, `960416-1.c`,
`builtin-prefetch-1.c`, `builtin-prefetch-2.c`, and
`builtin-prefetch-3.c`. All now have explicit, independently checked,
normal-matrix source companions with actual native PDP-6 execution
and source-hash-pinned evidence. `980526-2.c` excludes original
undefined pointer arithmetic but checks real callback arguments;
`cbrt.c` uses correct target D-format numerical arithmetic instead
of the unreachable IEEE bit overlay. `builtin-prefetch-2.c` avoids
executing its uninitialized local pointer expression and instead
preserves the defined expression with an initialized live pointer.

The untouched original sources may still fail or be vacuous under
native target widths. The new tests are independent and nonvacuous.
Their semantics and exact 42-profile results are explained in
`docs/PDP10-P1-BATCH3-FINAL-20261119-v1.md`.

## Immutable ownership and remaining work

The actual source-level ledger is
`docs/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v7.tsv`. The fixed
source-hash-pinned assignment projection is
`docs/PDP10-P1-SOURCE-BATCHES-20261119-v6.tsv`. Their independently
registered host auditors enforce original source hashes, unmodified
batch numbers, real source/profile evidence and explicit P1 closure
criteria. The 42 newly observed source/profile logs are archived and
SHA256-pinned; the earlier original/companion ledgers remain intact.

**Next:** Batch 4 (10 sources: one partial GNU invalid-address prefetch,
three libc-linkage, three variadic ABI, one assembler/ISA harness, two
hosted runtime prerequisites). The other 19 scheduled originals are
in Batches 5 and 6. Keep compiler/assembler defects P2 and AAP
architecture correctness P3; do not treat a real failing compiler
regression as missing test construction.
