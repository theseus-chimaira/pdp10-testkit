# Upstream semantic import: eight batches of eight (2026-10-14, v12)

64 consecutive candidates compiled on PDP-6 KCC; compiled files executed with bare-metal harness. No compiler sources or original test bodies changed.

## Batch 1 (cases 1–8)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `align-2.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `anon-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `arith-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `arith-ll.c` | run_fail | deferred | "arith-ll.c", line 70: [Note] Call to undeclared function "printf" |
| `arith-rand.c` | run_fail | review-width | "arith-rand.c", line 59: [Note] Call to undeclared function "abort" |
| `bf-layout-1.c` | compile_fail | review-extension | "bf-layout-1.c", line 1: Bit-field must be int, unsigned int, or _Bool |
| `bf-sign-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `bf-sign-2.c` | compile_fail | review-extension | "bf-sign-2.c", line 18: Bit-field must be int, unsigned int, or _Bool |

## Batch 2 (cases 9–16)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `bf64-1.c` | run_fail | review-extension | "bf64-1.c", line 3: Bit-field must be int, unsigned int, or _Bool |
| `bitfld-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `bitfld-2.c` | compile_fail | review-extension | "bitfld-2.c", line 7: Bit-field must be int, unsigned int, or _Bool |
| `builtin-abs-1.c` | compile_fail | deferred | "builtin-abs-1.c", line 8: Can't open include file, last tried "/usr/local/lib/kcc/include/limits.h" |
| `builtin-noret-1.c` | compile_fail | deferred | "builtin-noret-1.c", line 55: [Note] Call to undeclared function "_exit" |
| `comp-goto-1.c` | compile_fail | review-extension | "comp-goto-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdlib.h" |
| `complex-3.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `compndlit-1.c` | compile_fail | review-extension | "compndlit-1.c", line 11: Undefined identifier: "b" |

## Batch 3 (cases 17–24)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `cvt-1.c` | run_fail | review-width | "cvt-1.c", line 17: [Note] Call to undeclared function "abort" |
| `dbra-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `divconst-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `divconst-2.c` | run_fail | review-width | "divconst-2.c", line 22: [Note] Parameter "denom" not used |
| `divconst-3.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `divmod-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `enum-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `enum-2.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |

## Batch 4 (cases 25–32)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `func-ptr-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `gofast.c` | compile_fail | deferred | "gofast.c", line 9: Can't open include file, last tried "/usr/local/lib/kcc/include/stdio.h" |
| `index-1.c` | run_fail | deferred | "index-1.c", line 18: [Note] Call to undeclared function "abort" |
| `inst-check.c` | compile_fail | deferred | "inst-check.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h" |
| `int-compare.c` | compile_fail | deferred | "int-compare.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/limits.h" |
| `loop-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-10.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-11.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |

## Batch 5 (cases 33–40)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `loop-2.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-2b.c` | compile_fail | deferred | "loop-2b.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/limits.h" |
| `loop-2c.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-2d.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-3.c` | compile_fail | deferred | "loop-3.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/limits.h" |
| `loop-3b.c` | compile_fail | deferred | "loop-3b.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/limits.h" |
| `loop-3c.c` | compile_fail | deferred | "loop-3c.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/limits.h" |
| `loop-4.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |

## Batch 6 (cases 41–48)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `loop-4b.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-5.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-6.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-7.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-8.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `loop-9.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `memcpy-1.c` | compile_fail | deferred | "memcpy-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/string.h" |
| `memcpy-2.c` | compile_fail | deferred | "memcpy-2.c", line 10: Can't open include file, last tried "/usr/local/lib/kcc/include/string.h" |

## Batch 7 (cases 49–56)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `memset-1.c` | compile_fail | deferred | "memset-1.c", line 10: Can't open include file, last tried "/usr/local/lib/kcc/include/string.h" |
| `mod-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `nest-stdar-1.c` | compile_fail | review-extension | "nest-stdar-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h" |
| `nestfunc-1.c` | compile_fail | review-extension | "nestfunc-1.c", line 16: Expected token (semicolon) not found |
| `nestfunc-2.c` | compile_fail | review-extension | "nestfunc-2.c", line 14: Expected token (semicolon) not found |
| `nestfunc-4.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `20000412-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `20000412-3.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |

## Batch 8 (cases 57–64)

| Source | Observed | Classification | Explanation |
| --- | --- | --- | --- |
| `20000528-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `20000707-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `20000717-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `20000717-4.c` | pass | removed | Passes, but main returns zero without observing any computed value |
| `20000717-5.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `20000819-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `20001130-2.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |
| `20010106-1.c` | pass | active | PDP-6 KCC semantic execution PASS; further compiler/CPU profiles unverified |

## Summary

38 passes, 20 compilation failures, six link/runtime failures. One vacuous pass removed; 37 activated; 26 retained unchanged in `tests/todo/generic/`. Tests with partial assembly or missing library support must not be treated as confirmed runtime compiler failures.

{'active': 332, 'removed': 52, 'review-extension': 103, 'review-width': 52, 'deferred': 89, 'candidate': 146}
