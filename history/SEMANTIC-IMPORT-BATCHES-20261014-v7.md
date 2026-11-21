# Upstream semantic import: eight batches of eight (2026-10-14, v7)

64 consecutive candidates were compiled targeting PDP-6 KCC and, when compilable, run under the bare-metal test harness. The compilers were not modified. A successful exit alone does not qualify as a semantic assertion.

## Batch 1 (sources 1–8)

| Source | Execution | Classification | Explanation |
| --- | --- | --- | --- |
| `20010924-1.c` | compile_fail | deferred | KCC rejects flexible array initializer |
| `20010925-1.c` | run_fail | deferred | unresolved memcpy symbol |
| `20011008-3.c` | run_fail | review-width | runtime abort; integer/byte width semantics need review |
| `20011019-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20011109-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20011109-2.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20011113-1.c` | compile_fail | review-extension | KCC rejects __SIZE_TYPE__-dependent source |
| `20011114-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |

## Batch 2 (sources 9–16)

| Source | Execution | Classification | Explanation |
| --- | --- | --- | --- |
| `20011115-1.c` | pass | removed | No effective assertion or observable expected result |
| `20011126-2.c` | pass | removed | No effective assertion or observable expected result |
| `20011128-1.c` | pass | removed | No effective assertion or observable expected result |
| `20011217-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20011219-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20011223-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020103-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020118-1.c` | pass | removed | No effective assertion or observable expected result |

## Batch 3 (sources 17–24)

| Source | Execution | Classification | Explanation |
| --- | --- | --- | --- |
| `20020127-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020129-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020201-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020206-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020206-2.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020213-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020215-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020225-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |

## Batch 4 (sources 25–32)

| Source | Execution | Classification | Explanation |
| --- | --- | --- | --- |
| `20020225-2.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020226-1.c` | compile_fail | deferred | missing limits.h |
| `20020307-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020314-1.c` | run_fail | deferred | unresolved alloca symbol |
| `20020320-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020321-1.c` | pass | removed | No effective assertion or observable expected result |
| `20020402-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020402-2.c` | pass | removed | No effective assertion or observable expected result |

## Batch 5 (sources 33–40)

| Source | Execution | Classification | Explanation |
| --- | --- | --- | --- |
| `20020402-3.c` | run_fail | review-width | runtime abort in wide integer/ABI case |
| `20020404-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020406-1.c` | compile_fail | review-extension | KCC declaration/parser error |
| `20020412-1.c` | compile_fail | review-extension | missing stdarg.h; varargs support unresolved |
| `20020413-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020613-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020613-2.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020613-3.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |

## Batch 6 (sources 41–48)

| Source | Execution | Classification | Explanation |
| --- | --- | --- | --- |
| `20020617-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020813-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020813-2.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020813-3.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020813-4.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020814-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020814-2.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020821-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |

## Batch 7 (sources 49–56)

| Source | Execution | Classification | Explanation |
| --- | --- | --- | --- |
| `20020823-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020826-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020827-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20020828-1.c` | run_fail | deferred | unresolved memset symbol |
| `20020828-2.c` | run_fail | deferred | unresolved memset symbol |
| `20020828-3.c` | run_fail | deferred | unresolved memcpy symbol |
| `20020830-1.c` | run_fail | deferred | unresolved memset symbol |
| `20020903-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |

## Batch 8 (sources 57–64)

| Source | Execution | Classification | Explanation |
| --- | --- | --- | --- |
| `20020907-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20021022-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20021022-2.c` | compile_fail | deferred | KCC rejects pointer arithmetic expression |
| `20021101-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20021127-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20021127-2.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20030120-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |
| `20030202-1.c` | pass | active | PDP-6 KCC PASS with observable assertions; other profiles unverified |

## Summary

Original execution: 50 passed, 6 compilation failures, 8 linking/runtime failures. Final classification: 44 activated, 6 vacuous tests removed, 14 retained for review.

{'active': 125, 'removed': 38, 'review-extension': 81, 'review-width': 33, 'deferred': 31, 'candidate': 466}
