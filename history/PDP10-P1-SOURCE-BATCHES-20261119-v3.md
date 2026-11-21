# PDP10 P1 immutable 59-source batches: current state v3

Date: 2026-11-19. The original v1 assignment remains immutable.
This version reflects the v4 live source resolution.
Compiler errors, missing runtime symbols, and SIMH step limits
remain visible even when valid P1 test construction is complete.

| Batch | Focus | Assigned | Covered | Partial | Blocked |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | Compiler matrix admission A | 10 | 10 | 0 | 0 |
| 2 | Compiler policy and diagnostic admission | 10 | 0 | 0 | 10 |
| 3 | Width and partial original-oracle work | 10 | 0 | 5 | 5 |
| 4 | ABI, assembler and first hosted prerequisites | 10 | 0 | 1 | 9 |
| 5 | Hosted runtime and library dependencies A | 10 | 0 | 0 | 10 |
| 6 | Hosted runtime and library dependencies B | 9 | 0 | 0 | 9 |
| **Total frozen** | | **59** | **10** | **6** | **43** |

The other eight covered sources were already closed before the
original 59-source frozen baseline. Thus the complete 67-source
**live status is 18 covered, 6 partial, 43 blocked (49 actionable P1)**.

## Batch 1: Compiler matrix admission A (10 sources)

| Slot | Immutable original source | Historic reason | Live state |
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

## Batch 2: Compiler policy and diagnostic admission (10 sources)

| Slot | Immutable original source | Historic reason | Live state |
| ---: | --- | --- | --- |
| 1 | `tests/semantic/upstream/extensions/921007-1.c` | compiler-investigate | **blocked** |
| 2 | `tests/todo/generic/931002-1.c` | compiler-investigate | **blocked** |
| 3 | `tests/semantic/upstream/wide-int/961122-1.c` | compiler-investigate | **blocked** |
| 4 | `tests/semantic/upstream/generic/nestfunc-3.c` | compiler-investigate | **blocked** |
| 5 | `tests/semantic/upstream/extensions/20010122-1.c` | feature-policy-decision | **blocked** |
| 6 | `tests/todo/generic/bf-sign-2.c` | feature-policy-decision | **blocked** |
| 7 | `tests/semantic/upstream/extensions/eeprof-1.c` | feature-policy-decision | **blocked** |
| 8 | `tests/semantic/upstream/extensions/991228-1.c` | compiler-ice-priority | **blocked** |
| 9 | `tests/todo/generic/index-1.c` | linker-investigate | **blocked** |
| 10 | `tests/semantic/upstream/extensions/20020108-1.c` | header-integration | **blocked** |

## Batch 3: Width and partial original-oracle work (10 sources)

| Slot | Immutable original source | Historic reason | Live state |
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

## Batch 4: ABI, assembler and first hosted prerequisites (10 sources)

| Slot | Immutable original source | Historic reason | Live state |
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

## Batch 5: Hosted runtime and library dependencies A (10 sources)

| Slot | Immutable original source | Historic reason | Live state |
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

## Batch 6: Hosted runtime and library dependencies B (9 sources)

| Slot | Immutable original source | Historic reason | Live state |
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

## Next active work

Begin Batch 2, preserving the original 10 source positions.
Consult `history/PDP10-P1-BATCH1-FINAL-20261119-v1.md` for P2/P3
follow-up on historical Batch 1 toolchain and simulator defects.
Do not treat a missing KCC runtime helper as completed runtime
repair, or a label-offset SIMH timeout as a proven compiler ICE.
