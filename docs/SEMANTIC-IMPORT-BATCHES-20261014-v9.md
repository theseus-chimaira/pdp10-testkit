# Upstream semantic import: eight batches of eight (2026-10-14, v9)

64 consecutive candidates compiled under PDP-6 KCC and executed where possible with the bare-metal termination harness. Compiler and imported test sources were not edited.

## Batch 1 (cases 1–8)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `930126-1.c` | compile_fail | review-extension | KCC rejects nonstandard bitfield types |
| `930208-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930408-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930429-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930429-2.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930513-1.c` | compile_fail | deferred | missing stdio.h and associated runtime |
| `930513-2.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930518-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |

## Batch 2 (cases 9–16)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `930526-1.c` | pass | removed | Passing execution without a meaningful assertion or observable expected result |
| `930527-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930529-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930603-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930603-2.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930603-3.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930608-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930614-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |

## Batch 3 (cases 17–24)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `930614-2.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930621-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930622-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930622-2.c` | run_fail | deferred | KCC fatal vrwiden reg already wide; incomplete assembly and unresolved main |
| `930628-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930630-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930702-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930713-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |

## Batch 4 (cases 25–32)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `930718-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930719-1.c` | pass | removed | Passing execution without a meaningful assertion or observable expected result |
| `930725-1.c` | run_fail | deferred | link fails: unresolved strcmp |
| `930818-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930916-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930929-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930930-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `930930-2.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |

## Batch 5 (cases 33–40)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `931002-1.c` | compile_fail | review-extension | KCC parser rejects source syntax |
| `931004-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931004-10.c` | compile_fail | deferred | missing stdarg.h in test environment |
| `931004-11.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931004-12.c` | compile_fail | deferred | missing stdarg.h in test environment |
| `931004-13.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931004-14.c` | compile_fail | deferred | missing stdarg.h in test environment |
| `931004-2.c` | compile_fail | deferred | missing stdarg.h in test environment |

## Batch 6 (cases 41–48)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `931004-3.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931004-4.c` | compile_fail | deferred | missing stdarg.h in test environment |
| `931004-5.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931004-6.c` | compile_fail | deferred | missing stdarg.h in test environment |
| `931004-7.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931004-8.c` | compile_fail | deferred | missing stdarg.h in test environment |
| `931004-9.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931005-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |

## Batch 7 (cases 49–56)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `931009-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931012-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931017-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931018-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931031-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931102-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931102-2.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931110-1.c` | compile_fail | review-extension | KCC rejects nonstandard bitfield types |

## Batch 8 (cases 57–64)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `931110-2.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931208-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `931228-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `940115-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `940122-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `941014-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |
| `941014-2.c` | compile_fail | deferred | missing stdio.h in test environment |
| `941015-1.c` | pass | active | PDP-6 KCC PASS with asserted result; other cells not verified |

## Summary

50 passes, 12 compilation failures, two link/runtime failures. Two vacuous tests removed; 48 activated and 14 retained for review.

{'active': 205, 'removed': 47, 'review-extension': 91, 'review-width': 38, 'deferred': 55, 'candidate': 338}
