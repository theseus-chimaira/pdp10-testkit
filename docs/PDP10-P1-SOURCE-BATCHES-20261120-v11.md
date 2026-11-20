# Frozen P1 source batches v11

Exactly one state differs from the frozen-assignment status v10:
Batch 4 slot 5, `20020412-1.c`, is covered as a substantive
original GNU variable-sized `va_arg` test. The original is
unchanged and its real GCC failures are retained.

All 59 historically open identities remain in the same batches
(10+10+10+10+10+9), with original source SHA256 unchanged.
The frozen set now has **33 covered, 0 partial, 26 blocked**;
Batch 4 has **3 covered, 0 partial, 7 blocked**.
Across all 67 P1 obligations: **41 covered, 0 partial, 26 blocked**.

See `PDP10-P1-VARIADIC-VLA-ORIGINAL-20261120-v1.md`.
The v11 TSV is verified by
`tools/audit-p1-source-batches-v11.py`.
