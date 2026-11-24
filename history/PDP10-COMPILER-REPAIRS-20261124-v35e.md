# v35e historical compiler repair results

2026-11-24; scope is original v28 failures plus targeted regressions only.

## Installed repairs

| Repair | Historical cells passing |
| --- | ---: |
| GCC/DAS strong aliases | 8 |
| GCC local effective addresses | 44 |
| GCC strict C99 mode | 12 |
| KCC control scopes | 8 |
| KCC compound literals | 4 |
| KCC literal token pasting | 4 |
| KCC GNU void return | 22 |
| KCC GNU alignment | 22 |
| KCC GNU void pointer arithmetic | 2 |
| Total | 126 |

Code commits: GCC 4a71edc, DAS 0a3542a, KCC 178dac0.
Installed binaries (SHA256):

- cc1: 386ae2060f92b631e07b8e40593e0e6cc2421f3e06a2a62a734a17a234e885bf
- das: 2a22c152088a9cee6d3085ce787c0796d46b1b9e903217dc760b343c4997cfa1
- kcc: 61784964a4044ffdc7fca2906f070fdebe44ea207ddd51c45cba7c70950f3a9c

Strict installed evidence: `workdir/v28-repairs-installed-v35e` 126/126
and `workdir/new-regressions-installed-v35e` 132/132; no skipped cells.
The manifests `PDP10-V28-REPAIR-RESULTS-20261124-v35e.tsv` and
`PDP10-NEW-REGRESSION-RESULTS-20261124-v35e.tsv` pin source, assembly
and report SHA256. The original selection manifests retain historical
observations; the 22 KCC floating exponent cells in the original compile
list are retired and must not be rescheduled. Use the exact verified or
feature-gap manifests instead. Additional staged VLA/macro checks 88/88,
DAS DOBJ/DARC/DLINK integration including exported aliases, and installed
KCC overflow diagnostics 2/2 pass.

## Historical v28 reconciliation

Of the 3889 v28 failures, 184 cumulatively passed and 66 retired as
native-exponent-inapplicable (not passes). Remaining: GCC compile 852,
GCC run 2614, KCC compile 44, KCC run 129 = 3639. No linker failures.
The 852 KCC-specific type errors remain separate. Four weak alias cells
are in the runtime category. Neither new regression counts against v28.

## Limits

Hosted compiler and assembler verified only. Native compiler phases,
full 62-bit host constant precision, and native DAS execution remain
unverified/not implemented as applicable. No new DOBJ weak binding,
zero-sized aggregate semantics or full wide-character storage has been
introduced. Existing parallel native KGEN edits were preserved.
