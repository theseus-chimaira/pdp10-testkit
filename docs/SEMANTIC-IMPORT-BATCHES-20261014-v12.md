# Upstream semantic import: eight batches of eight (2026-10-14, v12)

64 consecutive candidates from the classification manifest were compiled targeting PDP-6 KCC. Compilable programs were executed with the bare-metal termination contract. Original sources and compilers were not edited. TODO destinations retain category namespaces to avoid basename collisions.

## Batch 1 (cases 1–8)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/pdp10/pdp10/ll-1.c` | compile_fail | review-extension | "ll-1.c", line 1: GNU attribute mode is not supported; "ll-1.c", line 6: [Note] Call to undeclared function "abort" |
| `tests/semantic/upstream/pdp10/pdp10/loop-2b.c` | compile_fail | deferred | "loop-2b.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/limits.h"; "loop-2b.c", line 7: Undefined identifier: "INT_MAX" |
| `tests/semantic/upstream/pdp10/pdp10/packed-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/pdp10/pdp10/packed-2.c` | pass | removed | Passing execution with no observable assertion |
| `tests/semantic/upstream/pdp10/pdp10/ptr-arith-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/pdp10/pdp10/strct-1.c` | run_fail | deferred | FAIL: __test_exit: got 000000000001 expected 000000000000; see report: /home/theseus/tmp/semantic-64-v7/06-strct-1/run/strct-1.report.txt |
| `tests/semantic/upstream/pdp10/pdp10/strct-2.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/pdp10/pdp10/strct-3.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |

## Batch 2 (cases 9–16)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/pdp10/pdp10/strct-4.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/pdp10/pdp10/strct-pack-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/pdp10/pdp10/strct-pack-2.c` | pass | removed | Passing execution with no observable assertion |
| `tests/semantic/upstream/pdp10/pdp10/strct-pack-3.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/pdp10/pdp10/strct-pack-4.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/pdp10/pdp10/strct-stdarg-1.c` | compile_fail | deferred | "strct-stdarg-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "strct-stdarg-1.c", line 17: Undefined identifier: "va_list" |
| `tests/semantic/upstream/pdp10/pdp10/strct-varg-1.c` | compile_fail | deferred | "strct-varg-1.c", line 7: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "strct-varg-1.c", line 13: Declaration without storage class or type-spec |
| `tests/semantic/upstream/pdp10/pdp10/strct-varg-1b.c` | compile_fail | deferred | "strct-varg-1b.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "strct-varg-1b.c", line 8: Undefined identifier: "va_list" |

## Batch 3 (cases 17–24)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/pdp10/pdp10/string-opt-15.c` | compile_fail | review-extension | "string-opt-15.c", line 10: Expected token (semicolon) not found; "string-opt-15.c", line 11: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/pdp10/pdp10/string-opt-3.c` | compile_fail | review-extension | "string-opt-3.c", line 9: Expected token (semicolon) not found; "string-opt-3.c", line 21: [Note] Call to undeclared function "strlen" |
| `tests/semantic/upstream/pdp10/pdp10/string-opt-5.c` | compile_fail | review-extension | "string-opt-5.c", line 9: Expected token (semicolon) not found; "string-opt-5.c", line 13: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/pdp10/pdp10/string-opt-6.c` | compile_fail | review-extension | "string-opt-6.c", line 9: Expected token (semicolon) not found; "string-opt-6.c", line 10: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/pdp10/pdp10/string-opt-7.c` | compile_fail | review-extension | "string-opt-7.c", line 9: Expected token (semicolon) not found; "string-opt-7.c", line 10: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/pdp10/pdp10/string-opt-8.c` | compile_fail | review-extension | "string-opt-8.c", line 9: Expected token (semicolon) not found; "string-opt-8.c", line 10: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/pdp10/pdp10/tmp.c` | compile_fail | deferred | "tmp.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "tmp.c", line 10: Undefined identifier: "va_list" |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-1.c` | compile_fail | deferred | "va-arg-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-1.c", line 6: Undefined identifier: "va_list" |

## Batch 4 (cases 25–32)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-10.c` | compile_fail | deferred | "va-arg-10.c", line 5: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-10.c", line 9: Expected token (semicolon) not found |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-19.c` | compile_fail | deferred | "va-arg-19.c", line 10: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-19.c", line 15: No type-specifier for parameter decl, assuming int |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-2.c` | compile_fail | deferred | "va-arg-2.c", line 8: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-2.c", line 8: Expected token (semicolon) not found |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-22.c` | compile_fail | deferred | "va-arg-22.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-22.c", line 24: array dimension const must be > zero |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-3.c` | compile_fail | deferred | "va-arg-3.c", line 16: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-3.c", line 16: Expected token (semicolon) not found |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-4.c` | compile_fail | deferred | "va-arg-4.c", line 6: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-4.c", line 14: Undefined identifier: "va_list" |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-5.c` | compile_fail | deferred | "va-arg-5.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-5.c", line 5: Undefined identifier: "va_list" |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-6.c` | compile_fail | deferred | "va-arg-6.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-6.c", line 5: Undefined identifier: "va_list" |

## Batch 5 (cases 33–40)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-7.c` | compile_fail | deferred | "va-arg-7.c", line 5: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-7.c", line 10: No type-specifier for parameter decl, assuming int |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-8.c` | compile_fail | deferred | "va-arg-8.c", line 4: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-8.c", line 6: Can't open include file, last tried "/usr/local/lib/kcc |
| `tests/semantic/upstream/pdp10/pdp10/va-arg-9.c` | compile_fail | deferred | "va-arg-9.c", line 6: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-9.c", line 6: Expected token (semicolon) not found |
| `tests/semantic/upstream/generic/pending-4.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/generic/ptr-arith-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/generic/regstack-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/generic/scope-1.c` | run_fail | deferred | FAIL: __test_exit: got 000000000001 expected 000000000000; see report: /home/theseus/tmp/semantic-64-v7/39-scope-1/run/scope-1.report.txt |
| `tests/semantic/upstream/generic/scope-2.c` | run_fail | deferred | FAIL: __test_exit: got 000000000001 expected 000000000000; see report: /home/theseus/tmp/semantic-64-v7/40-scope-2/run/scope-2.report.txt |

## Batch 6 (cases 41–48)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/wide-int/strcmp-1.c` | compile_fail | deferred | "strcmp-1.c", line 9: Can't open include file, last tried "/usr/local/lib/kcc/include/string.h"; "strcmp-1.c", line 11: Can't open include file, last tried "/usr/local/lib/kcc |
| `tests/semantic/upstream/varargs/strct-stdarg-1.c` | compile_fail | deferred | "strct-stdarg-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "strct-stdarg-1.c", line 17: Undefined identifier: "va_list" |
| `tests/semantic/upstream/varargs/strct-varg-1.c` | compile_fail | deferred | "strct-varg-1.c", line 7: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "strct-varg-1.c", line 13: Declaration without storage class or type-spec |
| `tests/semantic/upstream/generic/string-opt-13.c` | compile_fail | review-extension | "string-opt-13.c", line 10: Expected token (semicolon) not found; "string-opt-13.c", line 11: Expected token (semicolon) not found |
| `tests/semantic/upstream/generic/string-opt-14.c` | compile_fail | review-extension | "string-opt-14.c", line 8: Expected token (semicolon) not found; "string-opt-14.c", line 9: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/generic/string-opt-15.c` | compile_fail | review-extension | "string-opt-15.c", line 10: Expected token (semicolon) not found; "string-opt-15.c", line 11: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/generic/string-opt-16.c` | compile_fail | review-extension | "string-opt-16.c", line 12: Expected token (semicolon) not found; "string-opt-16.c", line 13: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/generic/string-opt-5.c` | compile_fail | review-extension | "string-opt-5.c", line 9: Expected token (semicolon) not found; "string-opt-5.c", line 13: No type-specifier for parameter, assuming int |

## Batch 7 (cases 49–56)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/wide-int/strlen-1.c` | compile_fail | deferred | "strlen-1.c", line 9: Can't open include file, last tried "/usr/local/lib/kcc/include/string.h"; "strlen-1.c", line 11: Can't open include file, last tried "/usr/local/lib/kcc |
| `tests/semantic/upstream/wide-int/strncmp-1.c` | compile_fail | deferred | "strncmp-1.c", line 9: Can't open include file, last tried "/usr/local/lib/kcc/include/string.h"; "strncmp-1.c", line 11: Can't open include file, last tried "/usr/local/lib/k |
| `tests/semantic/upstream/generic/struct-ini-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/generic/struct-ini-2.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/generic/struct-ini-3.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/generic/struct-ini-4.c` | compile_fail | deferred | "struct-ini-4.c", line 7: Undefined identifier: "c"; "struct-ini-4.c", line 7: Integer constant required as initializer |
| `tests/semantic/upstream/generic/struct-ret-1.c` | compile_fail | deferred | "struct-ret-1.c", line 2: Can't open include file, last tried "/usr/local/lib/kcc/include/stdio.h"; "struct-ret-1.c", line 4: Can't open include file, last tried "/usr/local/l |
| `tests/semantic/upstream/wide-int/tmp.c` | run_fail | review-extension | dlink: undefined symbol: main; p10run: link failed |

## Batch 8 (cases 57–64)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/generic/unroll-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles unverified |
| `tests/semantic/upstream/varargs/va-arg-1.c` | compile_fail | deferred | "va-arg-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-1.c", line 6: Undefined identifier: "va_list" |
| `tests/semantic/upstream/varargs/va-arg-10.c` | compile_fail | deferred | "va-arg-10.c", line 5: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-10.c", line 9: Expected token (semicolon) not found |
| `tests/semantic/upstream/varargs/va-arg-11.c` | compile_fail | deferred | "va-arg-11.c", line 5: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-11.c", line 8: Undefined identifier: "va_list" |
| `tests/semantic/upstream/varargs/va-arg-12.c` | compile_fail | deferred | "va-arg-12.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-12.c", line 7: Undefined identifier: "va_list" |
| `tests/semantic/upstream/varargs/va-arg-13.c` | compile_fail | deferred | "va-arg-13.c", line 5: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-13.c", line 7: No type-specifier for struct member, assuming int |
| `tests/semantic/upstream/varargs/va-arg-14.c` | compile_fail | deferred | "va-arg-14.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-14.c", line 3: Declaration without storage class or type-spec |
| `tests/semantic/upstream/varargs/va-arg-15.c` | compile_fail | deferred | "va-arg-15.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-15.c", line 6: No type-specifier for parameter decl, assuming int |

## Totals

17 execution passes, 43 compilation failures, four link/runtime failures. 15 tests activated, two vacuous tests removed, 47 retained for review.

{'active': 378, 'removed': 55, 'review-extension': 128, 'review-width': 56, 'deferred': 139, 'candidate': 18}
