# P1 Batch ledger v8 (single source replacement)

The source assignments remain the frozen 10+10+10+10+10+9 scheme.
Batch 6 slot 3 still records the historical deleted source path
and legacy SHA256 for reproducibility; its *remaining action*
resolves to the new native test at
`tests/semantic/regression/pdp10-byte-pointer-torture-v1.c`.
Active batch runs use that source rather than a missing legacy file.

The 59 original obligations and all P1 covered/partial/blocked
statuses are unchanged. Exactly one live action text differs from
Batch v7. The checks `tools/audit-p1-source-batches-v8.py`
and `tools/test-p1-native-byteptr-replacement-v1.py` enforce
the replacement and state. See the native byte-pointer replacement
report for source identity, six actual PDP-6 guest results and
exact historical SHA handling.
