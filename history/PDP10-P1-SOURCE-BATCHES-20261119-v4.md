# PDP10 P1 frozen 59-source work batches: live v4

Date: 2026-11-19. The original v1 assignment and source SHA256s
remain immutable; this is a current-progress projection of v5
semantic original-source resolution.

| Batch | Work focus | Assigned | Covered | Partial | Blocked |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | Compiler matrix admission A | 10 | 10 | 0 | 0 |
| 2 | Compiler policy and diagnostic admission | 10 | 5 | 1 | 4 |
| 3 | Width and partial original-oracle work | 10 | 0 | 5 | 5 |
| 4 | ABI, assembler and first hosted prerequisites | 10 | 0 | 1 | 9 |
| 5 | Hosted runtime and library dependencies A | 10 | 0 | 0 | 10 |
| 6 | Hosted runtime and library dependencies B | 9 | 0 | 0 | 9 |
| **Frozen total** | | **59** | **15** | **7** | **37** |

Eight previously completed source intents are not part of
this frozen 59-source list, so the 67 historical originals now
have 23 covered, 7 partial and 37 blocked cases (44 P1 open).

## Batch 1: Compiler matrix admission A

| Slot | Frozen original source | Historical blocker | Live P1 state |
| ---: | --- | --- | --- |
| 1 | `tests/todo/generic/arith-ll.c` | hosted-runtime | **covered** |
| 2 | `tests/todo/generic/20000914-1.c` | compiler-investigate | **covered** |
| 3 | `tests/semantic/upstream/extensions/20010904-1.c` | compiler-investigate | **covered** |
| 4 | `tests/semantic/upstream/extensions/20010904-2.c` | compiler-investigate | **covered** |
| 5 | `tests/todo/generic/20010924-1.c` | compiler-investigate | **covered** |
| 6 | `tests/semantic/upstream/extensions/20020227-1.c` | compiler-investigate | **covered** |
| 7 | `tests/semantic/upstream/extensions/20020411-1.c` | compiler-investigate | **covered** |
| 8 | `tests/todo/generic/920302-1.c` | compiler-investigate | **covered** |
| 9 | `tests/todo/generic/920501-2.c` | compiler-investigate | **covered** |
| 10 | `tests/todo/generic/920501-6.c` | compiler-investigate | **covered** |

## Batch 2: Compiler policy and diagnostic admission

| Slot | Frozen original source | Historical blocker | Live P1 state |
| ---: | --- | --- | --- |
| 1 | `tests/semantic/upstream/extensions/921007-1.c` | compiler-investigate | **covered** |
| 2 | `tests/todo/generic/931002-1.c` | compiler-investigate | **covered** |
| 3 | `tests/semantic/upstream/wide-int/961122-1.c` | compiler-investigate | **covered** |
| 4 | `tests/semantic/upstream/generic/nestfunc-3.c` | compiler-investigate | **blocked** |
| 5 | `tests/semantic/upstream/extensions/20010122-1.c` | feature-policy-decision | **blocked** |
| 6 | `tests/todo/generic/bf-sign-2.c` | feature-policy-decision | **partial** |
| 7 | `tests/semantic/upstream/extensions/eeprof-1.c` | feature-policy-decision | **blocked** |
| 8 | `tests/semantic/upstream/extensions/991228-1.c` | compiler-ice-priority | **blocked** |
| 9 | `tests/todo/generic/index-1.c` | linker-investigate | **covered** |
| 10 | `tests/semantic/upstream/extensions/20020108-1.c` | header-integration | **covered** |

## Batch 3: Width and partial original-oracle work

| Slot | Frozen original source | Historical blocker | Live P1 state |
| ---: | --- | --- | --- |
| 1 | `tests/todo/generic/980526-2.c` | width-or-source-adaptation | **blocked** |
| 2 | `tests/todo/generic/991118-1.c` | width-or-source-adaptation | **blocked** |
| 3 | `tests/todo/generic/arith-rand.c` | width-or-source-adaptation | **blocked** |
| 4 | `tests/todo/generic/bf64-1.c` | width-or-source-adaptation | **blocked** |
| 5 | `tests/semantic/upstream/extensions/cbrt.c` | width-or-source-adaptation | **blocked** |
| 6 | `tests/todo/generic/921215-1.c` | nonasserting | **partial** |
| 7 | `tests/todo/generic/960416-1.c` | nonasserting | **partial** |
| 8 | `tests/semantic/upstream/extensions/builtin-prefetch-1.c` | nonasserting | **partial** |
| 9 | `tests/semantic/upstream/extensions/builtin-prefetch-2.c` | nonasserting | **partial** |
| 10 | `tests/semantic/upstream/extensions/builtin-prefetch-3.c` | nonasserting | **partial** |

## Batch 4: ABI, assembler and first hosted prerequisites

| Slot | Frozen original source | Historical blocker | Live P1 state |
| ---: | --- | --- | --- |
| 1 | `tests/semantic/upstream/extensions/builtin-prefetch-6.c` | nonasserting | **partial** |
| 2 | `tests/semantic/upstream/extensions/20010518-2.c` | libc-linkage | **blocked** |
| 3 | `tests/todo/generic/991112-1.c` | libc-linkage | **blocked** |
| 4 | `tests/semantic/upstream/pdp10/pdp10/conversion.c` | libc-linkage | **blocked** |
| 5 | `tests/todo/generic/20020412-1.c` | varargs-abi | **blocked** |
| 6 | `tests/todo/generic/920501-8.c` | varargs-abi | **blocked** |
| 7 | `tests/todo/generic/920726-1.c` | varargs-abi | **blocked** |
| 8 | `tests/semantic/upstream/support/920428-1.s` | isa-harness | **blocked** |
| 9 | `tests/todo/generic/20020406-1.c` | hosted-runtime | **blocked** |
| 10 | `tests/todo/generic/920810-1.c` | hosted-runtime | **blocked** |

## Batch 5: Hosted runtime and library dependencies A

| Slot | Frozen original source | Historical blocker | Live P1 state |
| ---: | --- | --- | --- |
| 1 | `tests/todo/generic/930513-1.c` | hosted-runtime | **blocked** |
| 2 | `tests/todo/generic/941014-2.c` | hosted-runtime | **blocked** |
| 3 | `tests/todo/generic/960327-1.c` | hosted-runtime | **blocked** |
| 4 | `tests/todo/generic/960521-1.c` | hosted-runtime | **blocked** |
| 5 | `tests/todo/generic/980605-1.c` | hosted-runtime | **blocked** |
| 6 | `tests/todo/generic/980707-1.c` | hosted-runtime | **blocked** |
| 7 | `tests/todo/generic/980709-1.c` | hosted-runtime | **blocked** |
| 8 | `tests/todo/generic/990628-1.c` | hosted-runtime | **blocked** |
| 9 | `tests/todo/generic/990826-0.c` | hosted-runtime | **blocked** |
| 10 | `tests/todo/generic/builtin-noret-1.c` | hosted-runtime | **blocked** |

## Batch 6: Hosted runtime and library dependencies B

| Slot | Frozen original source | Historical blocker | Live P1 state |
| ---: | --- | --- | --- |
| 1 | `tests/todo/generic/comp-goto-1.c` | hosted-runtime | **blocked** |
| 2 | `tests/todo/generic/gofast.c` | hosted-runtime | **blocked** |
| 3 | `tests/semantic/upstream/extensions/old.tort.c` | hosted-runtime | **blocked** |
| 4 | `tests/todo/generic/pdp10/strct-varg-1b.c` | hosted-runtime | **blocked** |
| 5 | `tests/semantic/upstream/extensions/stdio-opt-1.c` | hosted-runtime | **blocked** |
| 6 | `tests/semantic/upstream/extensions/stdio-opt-2.c` | hosted-runtime | **blocked** |
| 7 | `tests/semantic/upstream/extensions/stdio-opt-3.c` | hosted-runtime | **blocked** |
| 8 | `tests/todo/generic/generic/struct-ret-1.c` | hosted-runtime | **blocked** |
| 9 | `tests/semantic/upstream/extensions/va-arg-21.c` | hosted-runtime | **blocked** |

## Next actions

Resolve Batch 2 first: independent unsigned long-long bitfield
promotion policy, the return-address feature, GCC function
instrumentation, DEC native floating sign-bit representation,
and the original nested-closure/captured-sum policy. Do not
treat a native compiler failure or SIMH timeout as a passing
test. Consult `history/PDP10-P1-BATCH2-FIRST-20261119-v1.md`.
