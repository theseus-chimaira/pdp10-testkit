# P1 live semantic resolution v9 (source replacement)

This v9 ledger supersedes live v8. All 67 original historical
identities and their original hashes remain recorded, and the P1
counts are still **38 covered, 1 partial and 28 blocked**.

The single changed decision is Batch 6 slot 3: its imported
`old.tort.c` is now **deleted**, not merely deferred. Its operating
system-specific checks have been replaced by the native, freestanding
`tests/semantic/regression/pdp10-byte-pointer-torture-v1.c`
directly registered in `COMPILER_MATRIX.tsv`.
The new test fails all six observed PDP-6 KCC/GCC profiles; its
current follow-up is `pdp10-byte-pointer-abi`.
Historic compiler statuses and source hashes still identify the
removed import and cannot be reinterpreted as new test results.

The companion test and migration audit are detailed in
`PDP10-P1-NATIVE-BYTEPTR-REPLACEMENT-20261120-v1.md`.
The authoritatively generated v9 table is
`PDP10-P1-SEMANTIC-RESOLUTION-20261120-v9.tsv`.
The old v8 snapshot remains immutable historical evidence.
