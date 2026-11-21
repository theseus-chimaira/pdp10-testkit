# Historical GCC source-deletion tombstones (2026-11-17 v3)

The version-3 deletion manifest
`manifests/GCC-C-INAPPLICABLE-REMOVALS-20261117-v3.tsv` retains all
**94** prior tombstone records byte-for-byte and appends **25**
newly inapplicable foreign-target originals from the final batches
12 and 13. The earlier 89-row v1 and 94-row v2 manifests remain
unchanged and independently auditable.

| Review | New inapplicable | Total tombstones |
| --- | ---: | ---: |
| Batches 01-06 | 89 | 89 |
| Batches 07-09 | 0 | 89 |
| Batch 10 | 5 | 94 |
| Batch 11 | 0 | 94 |
| Batch 12 | 22 | 116 |
| Batch 13 | 3 | 119 |
| Batch 14 | 0 | **119** |

Seven originals exercise native x87/MMX/SSE intrinsics; four exercise
IA64 inline assembly, native atomics and GP relocations; seven
exercise RS6000/PowerPC/SPARC/MMIX/HPPA instruction sets or ABIs;
seven exercise i386 System V, Darwin, OSF/1 or Solaris-specific
pragma/alignment/symbol handling. See the exact 25 individual
PDP-10 rejection reasons in
`manifests/GCC-C-BATCH12-20261117-v1.tsv` and
`manifests/GCC-C-BATCH13-20261117-v1.tsv`.

Original source files are **deleted**, not transformed to trivial
PDP-10 no-op substitutes. The original 679-source preflight and
ownership ledger retain each deleted identity, SHA256 hash,
original action and rejection reason. The historical reference tree
contains **560 retained C originals**. All 25 archived local quoted
include companions remain untouched.

`tools/inventory-gcc-unmirrored-v1.py` validates both prefix
relationships v1 -> v2 -> v3, per-original SHA256 and review status,
and absence of all 119 sources. Its `--import-sources` rebuild
must not restore any tombstoned original. Static checks do not
establish whether the remaining pending tests pass a compiler or
emulator.
