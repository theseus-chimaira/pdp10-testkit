# Frozen P1 batch ledger v7: corrected live blocker text

Date: 2026-11-20. Assignment order and original SHA256 values remain
identical to the frozen v6 batch ledger. The current live resolution is
`docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v8.tsv`.

| Batch | Sources | Covered | Partial | Blocked |
| --- | ---: | ---: | ---: | ---: |
| 1 | 10 | 10 | 0 | 0 |
| 2 | 10 | 10 | 0 | 0 |
| 3 | 10 | 10 | 0 | 0 |
| 4 | 10 | 0 | 1 | 9 |
| 5 | 10 | 0 | 0 | 10 |
| 6 | 9 | 0 | 0 | 9 |
| **Total** | **59** | **30** | **1** | **28** |

Only Batch 4 slot 2, original `20010518-2.c`, changes its
remaining-action wording: it is now an observed compiler packed-aggregate
blocker rather than an unresolved libc prerequisite. It stays blocked
until actual installed compiler results justify a change.

The versioned source batch checker detects source edits, reorderings,
omissions and unexpected state changes. It neither executes a sweep nor
promotes staged compiler runs to production passes.
