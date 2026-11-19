# Upstream semantic import: eight batches of eight (2026-10-14, v11)

> **Source-path maintenance (2026-11-19):** 31 paths in this dated 2026-10-14 test report were relinked to byte-identical files in the current tree. Original paths, SHA256 and historical Git blobs are preserved in `docs/HISTORICAL-SEMANTIC-SOURCE-RELINK-20261119-v2.tsv`. Recorded results and classification labels are **historical**; this path correction is not a new test run or a claim of current activation.

64 consecutive candidates (mostly PDP-10-specific copies) compiled under PDP-6 KCC and executed when compilable. No compiler sources or imported test bodies modified. Retained paths under `tests/todo/generic/pdp10/` disambiguate the original target-specific variants.

## Batch 1 (cases 1–8)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/generic/20010118-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/extensions/20010122-1.c` | compile_fail | deferred | "20010122-1.c", line 26: Bad syntax - function parameters without body; "20010122-1.c", line 38: [Note] Call to undeclared function "__builtin_return_address" |
| `tests/semantic/upstream/generic/20010123-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/todo/generic/20010124-1.c` | compile_fail | deferred | "20010124-1.c", line 5: Expected token (semicolon) not found; "20010124-1.c", line 42: [Note] Parameter "p" not used |
| `tests/semantic/upstream/generic/20010206-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/20010224-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/extensions/20010518-2.c` | run_fail | deferred | dlink: undefined symbol: memcpy; p10run: link failed |
| `tests/semantic/upstream/generic/20011109-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |

## Batch 2 (cases 9–16)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/todo/generic/20011113-1.c` | compile_fail | deferred | "20011113-1.c", line 1: Expected token (semicolon) not found; "20011113-1.c", line 2: No type-specifier for parameter, assuming int |
| `tests/semantic/upstream/generic/20011217-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/20011219-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/20020206-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/20020206-2.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/todo/generic/20020314-1.c` | run_fail | deferred | dlink: undefined symbol: alloca; p10run: link failed |
| `tests/semantic/upstream/wide-int/20020404-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/todo/generic/20020406-1.c` | compile_fail | deferred | "20020406-1.c", line 10: Bad syntax - function parameters without body; "20020406-1.c", line 10: Duplicate parameter: "__SIZE_TYPE__" |

## Batch 3 (cases 17–24)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/pdp10/pdp10/20020507-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/pdp10/pdp10/20020507-2.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/todo/generic/pdp10/20020507-3.c` | run_fail | deferred | dlink: undefined symbol: memcpy; p10run: link failed |
| `tests/semantic/upstream/pdp10/pdp10/20020527-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/pdp10/pdp10/20020617-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/todo/generic/920302-1.c` | compile_fail | review-extension | "920302-1.c", line 14: Pointer operand for + or - must point to valid object; "920302-1.c", line 18: Pointer operand for + or - must point to valid object |
| `tests/semantic/upstream/extensions/920415-1.c` | compile_fail | review-extension | "920415-1.c", line 2: Undefined identifier: "__label__"; "920415-1.c", line 2: [Note] Discarding expression without side effects |
| `tests/semantic/upstream/generic/920501-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |

## Batch 4 (cases 25–32)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/generic/920501-5.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/varargs/920625-1.c` | compile_fail | deferred | "920625-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "920625-1.c", line 7: Undefined identifier: "va_list" |
| `tests/semantic/upstream/extensions/920721-4.c` | compile_fail | review-extension | "920721-4.c", line 3: Undefined identifier: "__label__"; "920721-4.c", line 3: [Note] Discarding expression without side effects |
| `tests/todo/generic/920909-1.c` | run_fail | deferred | dlink: RH18 relocation overflow; dlink: link failed |
| `tests/todo/generic/930106-1.c` | run_fail | review-width | FAIL: __test_exit: got 000000000001 expected 000000000000; see report: /home/theseus/tmp/semantic-64-v6/29-930106-1/run/930106-1.report.txt |
| `tests/todo/generic/930111-1.c` | compile_fail | deferred | "930111-1.c", line 3: [Note] Call to undeclared function "wwrite"; "930111-1.c", line 4: [Note] Call to undeclared function "abort" |
| `tests/semantic/upstream/generic/930123-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/todo/generic/930513-1.c` | compile_fail | deferred | "930513-1.c", line 4: Can't open include file, last tried "/usr/local/lib/kcc/include/stdio.h"; "930513-1.c", line 14: Undefined identifier: "sprintf" |

## Batch 5 (cases 33–40)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/semantic/upstream/generic/930930-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/931004-5.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/varargs/931004-6.c` | compile_fail | deferred | "931004-6.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "931004-6.c", line 14: Undefined identifier: "va_list" |
| `tests/semantic/upstream/generic/931017-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/931102-2.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/extensions/960117-1.c` | pass | removed | Passing run does not check an observable result |
| `tests/semantic/upstream/generic/960513-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/961223-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |

## Batch 6 (cases 41–48)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/todo/generic/980526-2.c` | run_fail | review-width | FAIL: __test_exit: got 000000000001 expected 000000000000; see report: /home/theseus/tmp/semantic-64-v6/41-980526-2/run/980526-2.report.txt |
| `tests/semantic/upstream/generic/981206-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/990106-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/990117-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/990208-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/extensions/990326-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/990531-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |
| `tests/semantic/upstream/generic/990811-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |

## Batch 7 (cases 49–56)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/todo/generic/991014-1.c` | run_fail | review-width | FAIL: __test_exit: got 000000000001 expected 000000000000; see report: /home/theseus/tmp/semantic-64-v6/49-991014-1/run/991014-1.report.txt |
| `tests/todo/generic/991112-1.c` | run_fail | deferred | dlink: undefined symbol: isprint; p10run: link failed |
| `tests/todo/generic/arith-ll.c` | run_fail | deferred | dlink: undefined symbol: printf; p10run: link failed |
| `tests/todo/generic/arith-rand.c` | run_fail | review-width | FAIL: __test_exit: got 000000000001 expected 000000000000; see report: /home/theseus/tmp/semantic-64-v6/52-arith-rand/run/arith-rand.report.txt |
| `tests/semantic/upstream/extensions/bcp-1.c` | compile_fail | review-extension | "bcp-1.c", line 5: [Note] Call to undeclared function "__builtin_constant_p"; "bcp-1.c", line 6: [Note] Call to undeclared function "__builtin_constant_p" |
| `tests/todo/generic/bf-layout-1.c` | compile_fail | review-extension | "bf-layout-1.c", line 1: Bit-field must be int, unsigned int, or _Bool; "bf-layout-1.c", line 1: Bit-field must be int, unsigned int, or _Bool |
| `tests/semantic/upstream/extensions/bf-pack-1.c` | compile_fail | review-extension | "bf-pack-1.c", line 4: Bit-field must be int, unsigned int, or _Bool; "bf-pack-1.c", line 10: [Note] Call to undeclared function "abort" |
| `tests/semantic/upstream/generic/bf-sign-1.c` | pass | active | PDP-6 KCC PASS with asserted behavior; other profiles not verified |

## Batch 8 (cases 57–64)

| Source | Observed | Decision | Explanation |
| --- | --- | --- | --- |
| `tests/todo/generic/bf-sign-2.c` | compile_fail | review-extension | "bf-sign-2.c", line 18: Bit-field must be int, unsigned int, or _Bool; "bf-sign-2.c", line 19: Bit-field must be int, unsigned int, or _Bool |
| `tests/semantic/upstream/extensions/built-in-setjmp.c` | run_fail | review-extension | dlink: undefined symbol: strcmp; p10run: link failed |
| `tests/semantic/upstream/extensions/builtin-complex-1.c` | compile_fail | review-extension | "builtin-complex-1.c", line 4: Expected token (semicolon) not found; "builtin-complex-1.c", line 5: Symbol "_Complex" previously declared with different type "" |
| `tests/todo/generic/comp-goto-1.c` | compile_fail | review-extension | "comp-goto-1.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdlib.h"; "comp-goto-1.c", line 4: [Note] Undefined identifier "STACK_SIZE" - substituting |
| `tests/semantic/upstream/extensions/complex-1.c` | compile_fail | review-extension | "complex-1.c", line 6: [Note] Parameter "x" not used; "complex-1.c", line 12: [Note] Parameter "x" not used |
| `tests/semantic/upstream/extensions/complex-2.c` | compile_fail | review-extension | "complex-2.c", line 2: Declaration without storage class or type-spec; "complex-2.c", line 2: Expected token (semicolon) not found |
| `tests/todo/generic/gofast.c` | compile_fail | deferred | "gofast.c", line 9: Can't open include file, last tried "/usr/local/lib/kcc/include/stdio.h"; "gofast.c", line 51: [Note] Call to undeclared function "fprintf" |
| `tests/todo/generic/index-1.c` | run_fail | deferred | dlink: RH18 relocation overflow; dlink: link failed |

## Totals

32 passes, 20 compilation failures, 12 linking/runtime failures. 31 activated, one vacuous removed, 32 retained for review.

{'active': 363, 'removed': 53, 'review-extension': 115, 'review-width': 56, 'deferred': 105, 'candidate': 82}
