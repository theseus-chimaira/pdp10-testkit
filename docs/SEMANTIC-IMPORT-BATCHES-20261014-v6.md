# Upstream semantic import: eight batches of eight (2026-10-14, v6)

All 64 consecutive candidate sources were compiled with KCC for PDP-6; those compiling were executed using the testkit `__test_exit=0` contract. No compiler sources or original imported test bodies were edited. A PASS was not sufficient to activate tests without observable assertions.

## Batch 1 (tests 1–8)

| Source | Observed | Decision | Reason |
| --- | --- | --- | --- |
| `20000717-4.c` | pass | removed | Executed but no runtime assertion/observable outcome; vacuous semantic regression |
| `20000717-5.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000722-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000726-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000731-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000731-2.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000801-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000801-2.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |

## Batch 2 (tests 9–16)

| Source | Observed | Decision | Reason |
| --- | --- | --- | --- |
| `20000801-3.c` | compile_fail | review-extension | GNU empty struct extension rejected by KCC |
| `20000801-4.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000808-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000818-1.c` | pass | removed | Executed but no runtime assertion/observable outcome; vacuous semantic regression |
| `20000819-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20000822-1.c` | compile_fail | review-extension | GNU nested functions/trampolines not accepted by KCC |
| `20000910-1.c` | compile_fail | deferred | Missing stdlib.h in current KCC test include search |
| `20000910-2.c` | compile_fail | deferred | Missing stdlib.h/string.h in current KCC test include search; strchr runtime requires linking |

## Batch 3 (tests 17–24)

| Source | Observed | Decision | Reason |
| --- | --- | --- | --- |
| `20000914-1.c` | compile_fail | deferred | KCC syntax diagnostic in external malloc declaration; compile fails |
| `20000917-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001009-1.c` | run_fail | review-width | PDP-6 KCC execution aborts in target-specific signed-char comparison |
| `20001011-1.c` | run_fail | deferred | Link fails: unresolved strcmp from DAIMOS libc |
| `20001013-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001017-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001017-2.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001024-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |

## Batch 4 (tests 25–32)

| Source | Observed | Decision | Reason |
| --- | --- | --- | --- |
| `20001027-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001031-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001101.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001108-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001111-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001112-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001121-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001124-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |

## Batch 5 (tests 33–40)

| Source | Observed | Decision | Reason |
| --- | --- | --- | --- |
| `20001130-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001130-2.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001203-1.c` | pass | removed | Executed but no runtime assertion/observable outcome; vacuous semantic regression |
| `20001203-2.c` | compile_fail | deferred | KCC type/parameter diagnostic on large nested aggregate source |
| `20001221-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20001228-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010106-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010114-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |

## Batch 6 (tests 41–48)

| Source | Observed | Decision | Reason |
| --- | --- | --- | --- |
| `20010116-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010118-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010123-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010124-1.c` | compile_fail | deferred | KCC rejects source with __SIZE_TYPE__ and GNU pointer arithmetic in memcpy checks |
| `20010129-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010206-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010209-1.c` | compile_fail | review-extension | GNU nested function with VLA argument not compiled by KCC |
| `20010221-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |

## Batch 7 (tests 49–56)

| Source | Observed | Decision | Reason |
| --- | --- | --- | --- |
| `20010222-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010224-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010325-1.c` | compile_fail | review-width | Wide string literal concatenation rejected by KCC parser |
| `20010329-1.c` | compile_fail | deferred | Missing limits.h in test compiler include search |
| `20010403-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010409-1.c` | compile_fail | deferred | KCC rejects __SIZE_TYPE__ typedef; missing strlen runtime |
| `20010422-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010518-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |

## Batch 8 (tests 57–64)

| Source | Observed | Decision | Reason |
| --- | --- | --- | --- |
| `20010520-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010604-1.c` | compile_fail | deferred | Missing stdbool.h in test include search |
| `20010605-1.c` | compile_fail | review-extension | GNU block-scope static inline function rejected by KCC |
| `20010711-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010717-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010723-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010910-1.c` | pass | active | PDP-6 KCC execution PASS with bare-metal assertions; other cells unverified |
| `20010915-1.c` | run_fail | deferred | Link fails: unresolved strcmp from DAIMOS libc |

## Totals

Original run: 48 PASS, 13 compile failure, 3 link/runtime failure. Of 48 PASS, three cases had no meaningful outcome and were removed. The remaining 45 were activated. The 16 failures are retained in `tests/todo/generic/` for later diagnosis.

Manifest after this batch: active=81, candidate=530, deferred=22, removed=32, review-extension=78, review-width=31; inactive=661.
