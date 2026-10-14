# Upstream semantic import: eight batches of eight (2026-10-14, v8)

64 consecutive candidate sources, compiled with KCC for PDP-6 and executed where compilation succeeded. Compiler sources and imported test bodies were not modified. A passing run is not treated as an assertion unless the test actually checks a result.

## Batch 1: cases 1–8

| Test | Execution | Decision | Explanation |
| --- | --- | --- | --- |
| `900409-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920202-1.c` | pass | removed | No observed assertion in executed configuration |
| `920302-1.c` | compile_fail | review-extension | KCC rejects GNU computed-label pointer expressions |
| `920409-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920410-1.c` | pass | removed | No observed assertion in executed configuration |
| `920411-1.c` | run_fail | review-width | PDP-6 abort in byte-width dependent operation |
| `920428-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920429-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |

## Batch 2: cases 9–16

| Test | Execution | Decision | Explanation |
| --- | --- | --- | --- |
| `920501-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920501-2.c` | run_fail | deferred | Link unresolved __kcc_umoddi3 in long-long unsigned modulo |
| `920501-3.c` | compile_fail | review-extension | KCC rejects computed-label pointer arithmetic |
| `920501-4.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920501-5.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920501-6.c` | compile_fail | deferred | Missing stdio.h and stdio runtime |
| `920501-8.c` | compile_fail | deferred | Missing stdio.h and stdarg.h |
| `920506-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |

## Batch 3: cases 17–24

| Test | Execution | Decision | Explanation |
| --- | --- | --- | --- |
| `920520-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920603-1.c` | run_fail | review-width | Target-width expectation aborts on PDP-6 |
| `920604-1.c` | pass | removed | No observed assertion in executed configuration |
| `920612-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920612-2.c` | compile_fail | review-extension | GNU nested function rejected |
| `920618-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920625-1.c` | compile_fail | deferred | Missing stdarg.h in KCC include path |
| `920710-1.c` | run_fail | review-width | Unsigned-long-long floating conversion comparison aborts |

## Batch 4: cases 25–32

| Test | Execution | Decision | Explanation |
| --- | --- | --- | --- |
| `920721-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920721-2.c` | pass | removed | No observed assertion in executed configuration |
| `920721-3.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920726-1.c` | compile_fail | deferred | Missing stdio.h and stdarg.h |
| `920728-1.c` | compile_fail | review-extension | Zero-sized array GNU extension rejected |
| `920730-1.c` | compile_fail | deferred | Missing limits.h |
| `920731-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920810-1.c` | compile_fail | deferred | Missing stdio.h and related library headers |

## Batch 5: cases 33–40

| Test | Execution | Decision | Explanation |
| --- | --- | --- | --- |
| `920812-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `920829-1.c` | compile_fail | review-extension | KCC rejects long-long constant initializer expression |
| `920908-1.c` | compile_fail | deferred | Missing stdarg.h |
| `920908-2.c` | run_fail | review-width | PDP-6 abort in bitfield representation test |
| `920909-1.c` | run_fail | deferred | Dlink RH18 relocation overflow |
| `920929-1.c` | pass | removed | No observed assertion in executed configuration |
| `921006-1.c` | run_fail | deferred | Unresolved strcmp |
| `921013-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |

## Batch 6: cases 41–48

| Test | Execution | Decision | Explanation |
| --- | --- | --- | --- |
| `921016-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921017-1.c` | compile_fail | review-extension | KCC parser rejects nested function with VLA |
| `921019-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921019-2.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921104-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921110-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921112-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921113-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |

## Batch 7: cases 49–56

| Test | Execution | Decision | Explanation |
| --- | --- | --- | --- |
| `921117-1.c` | run_fail | deferred | Unresolved strcmp |
| `921123-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921123-2.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921124-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921202-1.c` | pass | removed | No observed assertion in executed configuration |
| `921202-2.c` | run_fail | review-width | Long-long byte extraction aborts |
| `921204-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921207-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |

## Batch 8: cases 57–64

| Test | Execution | Decision | Explanation |
| --- | --- | --- | --- |
| `921208-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921208-2.c` | pass | removed | No observed assertion in executed configuration |
| `921215-1.c` | compile_fail | review-extension | GNU nested functions and trampolines rejected |
| `921218-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `921218-2.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |
| `930106-1.c` | run_fail | deferred | Large-stack test aborts at runtime |
| `930111-1.c` | compile_fail | deferred | KCC compile errors in long-long calling test |
| `930123-1.c` | pass | active | PDP-6 KCC run PASS with meaningful assertion; other profiles unverified |

## Totals

39 execution passes, 15 compilation failures, 10 link/runtime failures. Seven passing tests were discarded as vacuous. 32 active, 25 pending review, seven removed.

{'active': 157, 'removed': 45, 'review-extension': 88, 'review-width': 38, 'deferred': 44, 'candidate': 402}
