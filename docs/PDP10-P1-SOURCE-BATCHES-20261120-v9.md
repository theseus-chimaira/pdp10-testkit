# P1 source batches v9: one closed original in Batch 4

The six frozen original-source batches remain 10+10+10+10+10+9,
with all historical identities, batch slots and original SHA256s
unchanged. One live status changes since v8: Batch 4 slot 1
`builtin-prefetch-6.c` is **covered**, with its native-width
invalid-address companion and four actual PDP-6 GCC PASS reports.

The status of 59 frozen historical originally open identities
is now **31 covered, 0 partial, 28 blocked**. Batch 4 is
1 covered, 0 partial and 9 blocked. Across all 67 P1 obligations
the status is **39 covered, 0 partial and 28 blocked**.

See `PDP10-P1-PREFETCH-INVALID-CLOSURE-20261120-v1.md`.
The machine-readable ledger is
`PDP10-P1-SOURCE-BATCHES-20261120-v9.tsv`, verified by
`tools/audit-p1-source-batches-v9.py`.
