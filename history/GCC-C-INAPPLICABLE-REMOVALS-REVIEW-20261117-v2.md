# Historical GCC inapplicable-source deletion update (2026-11-17 v2)

The version-2 tombstone manifest
`manifests/GCC-C-INAPPLICABLE-REMOVALS-20261117-v2.tsv` retains all 89
unaltered historical decisions from version 1 and appends exactly
**five** batch-10 inapplicable original sources. The original v1 TSV
and its accompanying review document remain unchanged as an
independently auditable earlier state.

| Review batch | Inapplicable originals | Cumulative deletions |
| --- | ---: | ---: |
| 01 | 23 | 23 |
| 02 | 23 | 46 |
| 03 | 21 | 67 |
| 04 | 20 | 87 |
| 05 | 1 | 88 |
| 06 | 1 | 89 |
| 07-09 | 0 | 89 |
| **10** | **5** | **94** |

Batch10 deletes `gcc.dg/cpp/tr-sign.c`, whose original DejaGNU
preprocessor action is guarded to i386 and assumes 32-bit traditional
CPP integers, plus `gcc.dg/dll-1.c` through `dll-4.c`, whose source
oracles explicitly require ARM/Thumb Windows PE DLL import/export
attributes, `.drectve` output or `__imp_` symbol conventions. None
has equivalent PDP-10 object-format semantics. See
`history/GCC-C-BATCH10-REVIEW-20261117-v1.md` and the 50-row batch
original-oracle review for detailed, per-source explanations.

The v2 manifest records source path, original SHA256, source snapshot
path, historical `batchXX-inapplicable` decision and original rejection
reason. The unchanged 679-row source ledger and preflight retain the
identity/provenance of **all 679** historical sources. The original
`refs/gcc-c-unmirrored-v1/` now has **585 retained C snapshots**;
**94 inapplicable C originals are absent**. The 25 preserved local
include companions remain untouched. There are no removed active
matrix owners, deferred tests, or other source files.

The static verifier compares the first 89 v2 tombstone records to the
complete v1 manifest, checks all 94 against original preflight hashes
and the individual batch decisions, rejects any reappearing source,
and checks retained hashes, companions and matrix registrations.
An explicit `--import-sources` rebuild from pinned GCC revision
`b0f5374f6d4462bb8759160ece635e306d90998f` reconstructs ledger
metadata but never recreates tombstoned source snapshots.

Only static source/hash/ownership checks were performed. No compiler,
assembler, emulator or runtime test was executed.
