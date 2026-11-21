# Upstream semantic import: eight batches of eight (2026-10-14, v10)

The next 64 candidates were compiled with PDP-6 KCC and run when compilable. No compiler or imported test body changes were made. Exit status assertions were counted as meaningful.

## Batch 1 (cases 1–8)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `941021-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `941025-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `941031-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `941101-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `941110-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `941202-1.c` | compile_fail | deferred | KCC rejects stray null declaration after function; also alloca dependency |
| `950221-1.c` | run_fail | deferred | unresolved strcpy from libc |
| `950322-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |

## Batch 2 (cases 9–16)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `950426-1.c` | run_fail | deferred | unresolved strlen from libc |
| `950503-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950511-1.c` | run_fail | review-width | PDP-6 runtime abort in width-sensitive integer test |
| `950512-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950605-1.c` | run_fail | review-width | PDP-6 runtime abort; inspect arithmetic and target assumptions |
| `950607-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950607-2.c` | run_fail | review-width | PDP-6 runtime abort; inspect byte/word width assumptions |
| `950612-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |

## Batch 3 (cases 17–24)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `950621-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950628-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950706-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950710-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950714-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950809-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `950906-1.c` | pass | removed | Passing execution lacks observable assertion |
| `950915-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |

## Batch 4 (cases 25–32)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `950929-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `951003-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `951115-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `951204-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960209-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960215-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960218-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960219-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |

## Batch 5 (cases 33–40)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `960301-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960302-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960311-1.c` | compile_fail | deferred | missing stdio.h |
| `960311-2.c` | compile_fail | deferred | missing stdio.h |
| `960317-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960321-1.c` | run_fail | review-width | PDP-6 runtime abort; check target width and signed arithmetic |
| `960326-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960327-1.c` | compile_fail | deferred | missing stdio.h |

## Batch 6 (cases 41–48)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `960405-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960416-1.c` | compile_fail | review-extension | KCC rejects GNU integer-to-union cast extension and fixed-width assumptions |
| `960419-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960419-2.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960513-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960521-1.c` | compile_fail | deferred | missing stdlib.h |
| `960608-1.c` | compile_fail | review-extension | KCC rejects nonstandard bitfield types |
| `960801-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |

## Batch 7 (cases 49–56)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `960802-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `960909-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `961004-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `961017-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `961026-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `961112-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `961122-2.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `961125-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |

## Batch 8 (cases 57–64)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `961213-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `961223-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `970214-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `970214-2.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `970217-1.c` | run_fail | review-width | PDP-6 runtime abort in target-sensitive argument test |
| `970923-1.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |
| `980205.c` | compile_fail | deferred | missing stdarg.h |
| `980223.c` | pass | active | PDP-6 KCC execution PASS; asserted condition or exit status; other profiles pending |

## Summary

49 execution passes, eight compilation failures, seven link/runtime failures; 48 activated, one removed as vacuous, 15 retained for review.

{'active': 253, 'removed': 48, 'review-extension': 93, 'review-width': 43, 'deferred': 63, 'candidate': 274}
