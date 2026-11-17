# Deletion of inapplicable historical GCC C test sources (2026-11-17 v1)

## Action and scope

The assertion-level reviews in GCC C batches 01 through 06 classified
**89 of the 679 original source files as inapplicable** to the supported
PDP-10 GCC/KCC test profiles. Those 89 actual C snapshots have now been
removed from `refs/gcc-c-unmirrored-v1/`; they are not active tests and
never had a compiler-matrix owner. Their classifications were already
reviewed individually and are not inferred from their filenames.

| Classification batch | Deleted original C files |
| --- | ---: |
| 01 | 23 |
| 02 | 23 |
| 03 | 21 |
| 04 | 20 |
| 05 | 1 |
| 06 | 1 |
| **Total** | **89** |

The removed source payload was **66,348 bytes**. The remaining original
reference inventory contains **590 C snapshots**, out of the initial
679. All **25 previously archived and still-referenced quoted include
companions** were retained. No adapted, pending, deferred, otherwise
unreviewed, or shared central compiler test source was removed.

Examples of deleted source conditions include x86/Alpha/PowerPC/ARM
specific assembly, vector or fixed-register ISA checks, IEEE binary64
layout or floating semantics not native to PDP-10, and tests whose
original condition was vacuous outside a foreign ABI. These are
**inapplicable**, not merely unsupported pending tests. Cases deferred
for diagnostic, dialect, compiler-optimization flag, or link support
remain preserved for later review.

## Provenance and reproducibility

`docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v1.tsv` is an explicit
**89-row tombstone manifest**. Each row records the GCC original path,
original SHA256 hash, `batchXX-inapplicable` classification, deleted
snapshot path, precise PDP-10 rejection rationale, and deletion action.
The six original batch decision TSVs and the
`docs/GCC-C-UNMIRRORED-OWNERSHIP-20261116-v1.tsv` ledger still contain
all **679 original identities**. The 679-row preflight remains the
immutable source-order and original-hash baseline, so subsequent
50-source reviews do not silently shift their position.

The verifier `tools/inventory-gcc-unmirrored-v1.py` checks that the
manifest set exactly equals every `inapplicable` decision in batches
01-06, that statuses, paths, reasons and hashes match the original
preflight and ownership ledger, that all **89 deleted snapshot paths are
absent**, that all 590 retained snapshots still match their pinned
hashes, and that the remaining compiler-matrix registrations have the
same owners. The `--import-sources` action obtains original data from
the pinned GCC Git revision for ledger reconstruction, but deliberately
**does not restore removed sources**. If a tombstoned file is present,
the import removes it after checking its original content fingerprint;
the normal verifier fails until it is gone.

The optional structural overlap report was refreshed against the **590
retained originals only**. It now has 590 rows and 69 token-level leads;
these are shape hints, not oracle equivalences. The removed sources do
not reappear as potential structural integration candidates.

After removal, **355** remaining original source assertions have not yet
received full individual decisions: 343 unreviewed and 12 same-name
review candidates. The other classifications remain in the original
historical audit, which distinguishes removal from deferred work.

No compiler, assembler, linker, emulator, or runtime tests were run as
part of the deletion. All verification described here is static.
