# PDP10 P1: 59 original-source obligations in six fixed batches (v1)

The baseline for these assignments is the **67-source resolution v1**. Exactly eight historical original-source intents were already covered there; the remaining 59 identities are assigned once each. The batches are five groups of ten and one group of nine. The later resolution v2 tracks closure **without renumbering any source**.

Compiler test construction and matrix admission are P1; compiler repairs and benchmarks remain deferred. A failing correct regression is useful testkit evidence. Hosted dependencies must be genuine target libraries, not test-only stubs. All original source bytes and failures remain preserved.

## Batch overview

| Batch | Focus | Sources | Covered so far | Open |
| ---: | --- | ---: | ---: | ---: |
| 1 | Compiler matrix admission A | 10 | 3 | 7 |
| 2 | Compiler policy and diagnostic admission | 10 | 0 | 10 |
| 3 | Width and partial original-oracle work | 10 | 0 | 10 |
| 4 | ABI, assembler and first hosted prerequisites | 10 | 0 | 10 |
| 5 | Hosted runtime and library dependencies A | 10 | 0 | 10 |
| 6 | Hosted runtime and library dependencies B | 9 | 0 | 9 |

The live snapshot has 3 of 59 finished (`arith-ll.c`, `20010904-1.c`, `20010904-2.c`), 6 partial, and 50 blocked. Each source is checked against its historical SHA256 and evidence; these counts are expected to change as the testkit progresses.

## Batch 1 - Compiler matrix admission A (10 sources)

| # | Historical source | Blocker class | Live P1 |
| ---: | --- | --- | --- |
| 1 | `tests/todo/generic/arith-ll.c` | hosted-runtime | covered |
| 2 | `tests/todo/generic/20000914-1.c` | compiler-investigate | blocked |
| 3 | `tests/semantic/upstream/extensions/20010904-1.c` | compiler-investigate | covered |
| 4 | `tests/semantic/upstream/extensions/20010904-2.c` | compiler-investigate | covered |
| 5 | `tests/todo/generic/20010924-1.c` | compiler-investigate | blocked |
| 6 | `tests/semantic/upstream/extensions/20020227-1.c` | compiler-investigate | blocked |
| 7 | `tests/semantic/upstream/extensions/20020411-1.c` | compiler-investigate | blocked |
| 8 | `tests/todo/generic/920302-1.c` | compiler-investigate | blocked |
| 9 | `tests/todo/generic/920501-2.c` | compiler-investigate | blocked |
| 10 | `tests/todo/generic/920501-6.c` | compiler-investigate | blocked |

## Batch 2 - Compiler policy and diagnostic admission (10 sources)

| # | Historical source | Blocker class | Live P1 |
| ---: | --- | --- | --- |
| 1 | `tests/semantic/upstream/extensions/921007-1.c` | compiler-investigate | blocked |
| 2 | `tests/todo/generic/931002-1.c` | compiler-investigate | blocked |
| 3 | `tests/semantic/upstream/wide-int/961122-1.c` | compiler-investigate | blocked |
| 4 | `tests/semantic/upstream/generic/nestfunc-3.c` | compiler-investigate | blocked |
| 5 | `tests/semantic/upstream/extensions/20010122-1.c` | feature-policy-decision | blocked |
| 6 | `tests/todo/generic/bf-sign-2.c` | feature-policy-decision | blocked |
| 7 | `tests/semantic/upstream/extensions/eeprof-1.c` | feature-policy-decision | blocked |
| 8 | `tests/semantic/upstream/extensions/991228-1.c` | compiler-ice-priority | blocked |
| 9 | `tests/todo/generic/index-1.c` | linker-investigate | blocked |
| 10 | `tests/semantic/upstream/extensions/20020108-1.c` | header-integration | blocked |

## Batch 3 - Width and partial original-oracle work (10 sources)

| # | Historical source | Blocker class | Live P1 |
| ---: | --- | --- | --- |
| 1 | `tests/todo/generic/980526-2.c` | width-or-source-adaptation | blocked |
| 2 | `tests/todo/generic/991118-1.c` | width-or-source-adaptation | blocked |
| 3 | `tests/todo/generic/arith-rand.c` | width-or-source-adaptation | blocked |
| 4 | `tests/todo/generic/bf64-1.c` | width-or-source-adaptation | blocked |
| 5 | `tests/semantic/upstream/extensions/cbrt.c` | width-or-source-adaptation | blocked |
| 6 | `tests/todo/generic/921215-1.c` | nonasserting | partial |
| 7 | `tests/todo/generic/960416-1.c` | nonasserting | partial |
| 8 | `tests/semantic/upstream/extensions/builtin-prefetch-1.c` | nonasserting | partial |
| 9 | `tests/semantic/upstream/extensions/builtin-prefetch-2.c` | nonasserting | partial |
| 10 | `tests/semantic/upstream/extensions/builtin-prefetch-3.c` | nonasserting | partial |

## Batch 4 - ABI, assembler and first hosted prerequisites (10 sources)

| # | Historical source | Blocker class | Live P1 |
| ---: | --- | --- | --- |
| 1 | `tests/semantic/upstream/extensions/builtin-prefetch-6.c` | nonasserting | partial |
| 2 | `tests/semantic/upstream/extensions/20010518-2.c` | libc-linkage | blocked |
| 3 | `tests/todo/generic/991112-1.c` | libc-linkage | blocked |
| 4 | `tests/semantic/upstream/pdp10/pdp10/conversion.c` | libc-linkage | blocked |
| 5 | `tests/todo/generic/20020412-1.c` | varargs-abi | blocked |
| 6 | `tests/todo/generic/920501-8.c` | varargs-abi | blocked |
| 7 | `tests/todo/generic/920726-1.c` | varargs-abi | blocked |
| 8 | `tests/semantic/upstream/support/920428-1.s` | isa-harness | blocked |
| 9 | `tests/todo/generic/20020406-1.c` | hosted-runtime | blocked |
| 10 | `tests/todo/generic/920810-1.c` | hosted-runtime | blocked |

## Batch 5 - Hosted runtime and library dependencies A (10 sources)

| # | Historical source | Blocker class | Live P1 |
| ---: | --- | --- | --- |
| 1 | `tests/todo/generic/930513-1.c` | hosted-runtime | blocked |
| 2 | `tests/todo/generic/941014-2.c` | hosted-runtime | blocked |
| 3 | `tests/todo/generic/960327-1.c` | hosted-runtime | blocked |
| 4 | `tests/todo/generic/960521-1.c` | hosted-runtime | blocked |
| 5 | `tests/todo/generic/980605-1.c` | hosted-runtime | blocked |
| 6 | `tests/todo/generic/980707-1.c` | hosted-runtime | blocked |
| 7 | `tests/todo/generic/980709-1.c` | hosted-runtime | blocked |
| 8 | `tests/todo/generic/990628-1.c` | hosted-runtime | blocked |
| 9 | `tests/todo/generic/990826-0.c` | hosted-runtime | blocked |
| 10 | `tests/todo/generic/builtin-noret-1.c` | hosted-runtime | blocked |

## Batch 6 - Hosted runtime and library dependencies B (9 sources)

| # | Historical source | Blocker class | Live P1 |
| ---: | --- | --- | --- |
| 1 | `tests/todo/generic/comp-goto-1.c` | hosted-runtime | blocked |
| 2 | `tests/todo/generic/gofast.c` | hosted-runtime | blocked |
| 3 | `tests/semantic/upstream/extensions/old.tort.c` | hosted-runtime | blocked |
| 4 | `tests/todo/generic/pdp10/strct-varg-1b.c` | hosted-runtime | blocked |
| 5 | `tests/semantic/upstream/extensions/stdio-opt-1.c` | hosted-runtime | blocked |
| 6 | `tests/semantic/upstream/extensions/stdio-opt-2.c` | hosted-runtime | blocked |
| 7 | `tests/semantic/upstream/extensions/stdio-opt-3.c` | hosted-runtime | blocked |
| 8 | `tests/todo/generic/generic/struct-ret-1.c` | hosted-runtime | blocked |
| 9 | `tests/semantic/upstream/extensions/va-arg-21.c` | hosted-runtime | blocked |

## Audit and workflow

`tools/audit-p1-source-batches-v1.py` reproduces the TSV and fails on missing or duplicated sources, changed original source hashes, unreviewed baseline changes, or stale v2 statuses. The plan is a work-ownership index, **not** a new compiler pass/fail oracle. For each batch, validate any new source in the normal matrix, retain real toolchain logs, update the live source resolution and batch state, then commit and push. Do not silently shift sources between groups as they complete.
