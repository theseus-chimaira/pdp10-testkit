# P1 semantic resolution v11: packed original accepted

The latest live P1 semantic ledger covers 67 historical obligations.
Only the packed-aggregate original
`tests/semantic/upstream/extensions/20010518-2.c` changes state
since v10: **blocked to covered**. Its original source remains
identical and executable, with two real PDP-6 compiler assertion
failures and all required libc symbols resolved. The testkit
oracle is substantive; the compiler failures are retained.

Current P1: **40 covered, 0 partial, 27 blocked**. Every other
historical identity, original SHA256, and closure state remains
unchanged. The v11 table is produced and verified by
`tools/build-p1-semantic-resolution-v11.py`; the source-specific
evidence and its limits are described in
`PDP10-P1-PACKED-ORIGINAL-ORACLE-20261120-v1.md`.
