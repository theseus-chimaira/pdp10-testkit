# Upstream semantic import: eight batches of eight (2026-10-14, v11)

64 consecutive candidates compiled with PDP-6 KCC and run when compilation produced assembly. Source bodies and compiler implementations were not modified. The run began after a concurrent manifest update; only the current 64 candidates were processed.

## Batch 1 (cases 1–8)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `980424-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980505-2.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980506-1.c` | pass | removed | Passing execution lacks a meaningful assertion |
| `980506-2.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980506-3.c` | run_fail | deferred | unresolved strlen in bare-metal runtime |
| `980526-2.c` | run_fail | review-width | runtime abort; needs semantic/target-width inspection |
| `980526-3.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980602-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |

## Batch 2 (cases 9–16)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `980602-2.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980604-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980605-1.c` | compile_fail | deferred | missing stdio.h |
| `980608-1.c` | compile_fail | deferred | missing stdarg.h |
| `980612-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980617-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980618-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `980701-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |

## Batch 3 (cases 17–24)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `980707-1.c` | compile_fail | deferred | missing stdio.h |
| `980709-1.c` | compile_fail | deferred | missing math.h |
| `980716-1.c` | compile_fail | deferred | missing stdarg.h |
| `980929-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `981001-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `981019-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `981130-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `981206-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |

## Batch 4 (cases 25–32)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `990106-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990117-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990127-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990127-2.c` | run_fail | review-width | runtime abort; target-specific assertion review |
| `990128-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990208-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990211-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990222-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |

## Batch 5 (cases 33–40)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `990324-1.c` | run_fail | review-width | runtime abort; target width assertion review |
| `990404-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990513-1.c` | compile_fail | deferred | missing string.h in compiler include search |
| `990524-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990525-1.c` | run_fail | review-width | runtime abort; target width assertion review |
| `990525-2.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990527-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990531-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |

## Batch 6 (cases 41–48)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `990604-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990628-1.c` | compile_fail | deferred | missing stdlib.h |
| `990804-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990811-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990826-0.c` | compile_fail | deferred | missing stdio.h |
| `990827-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990829-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `990923-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |

## Batch 7 (cases 49–56)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `991014-1.c` | run_fail | review-width | runtime abort; target width assertion review |
| `991016-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `991019-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `991023-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `991030-1.c` | run_fail | review-width | runtime abort; target width assertion review |
| `991112-1.c` | run_fail | deferred | unresolved isprint |
| `991118-1.c` | run_fail | review-extension | KCC rejects bitfield types; incomplete assembly and unresolved main |
| `991201-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |

## Batch 8 (cases 57–64)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `991202-1.c` | pass | removed | Passing execution lacks a meaningful assertion |
| `991202-2.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `991202-3.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `991216-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |
| `991216-2.c` | compile_fail | deferred | missing stdarg.h |
| `991216-3.c` | compile_fail | deferred | missing varargs.h |
| `991216-4.c` | pass | removed | Passing execution lacks a meaningful assertion |
| `991227-1.c` | pass | active | PDP-6 KCC execution PASS with assertion; other matrix profiles unverified |

## Summary

45 passes, ten compile failures, nine link/runtime failures. Of passes, three vacuous cases removed; 42 activated, 19 deferred for review. Note: the generated-assembly runner reports some KCC errors as link failures if it emits partial assembly.

{'active': 295, 'removed': 51, 'review-extension': 94, 'review-width': 49, 'deferred': 75, 'candidate': 210}
