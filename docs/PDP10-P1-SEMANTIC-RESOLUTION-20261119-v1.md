# PDP10 P1 deferred semantic-source resolution, version 1

Date: 2026-11-19. Source of truth:
`PDP10-P1-SEMANTIC-RESOLUTION-20261119-v1.tsv`.

## Two distinct meanings of deferred

**Historical import state:** 67 upstream sources still have the original
`activation=deferred` in
`SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv`, and remain
source-hash-pinned in
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv`. These records
preserve the original test and classification history. Changing a
companion or confirming a compiler failure must **not** silently
change an original source's historical status, suppress its failures,
or claim that its original assertions pass.

**Current actionable P1 test-construction state:** the new ledger is
an independently audited, exhaustive one-row-per-original resolution
of those same 67 sources. A source can be historically deferred but
have its *specific tested intent* covered by an active standalone
compiler-matrix source.

| P1 resolution | Original identities | P1 obligation |
| --- | ---: | --- |
| `covered` | **8** | Completed for the explicitly tested PDP-6 intent; original retained for history |
| `partial` | **6** | More source-specific test construction needed |
| `blocked` | **53** | Missing runtime, source oracle, ABI, test harness, or active compiler-matrix registration |
| **Historical total** | **67** | **59 actionable P1 entries (6 partial + 53 blocked)** |

These categories are **not compiler acceptance statuses**. Among the
14 sources with recorded companions, five have real failing-assertion
compiler profiles, while one GNU nested-closure case exhibits a
SIMH timeout without a readable guest exit. That timeout remains a
simulator/harness diagnosis, not a proven compiler assertion defect.

## Eight completed P1 intent obligations

| Original source | Independent registered PDP-6 companion |
| --- | --- |
| `920415-1.c` | GNU nested-label/computed-goto call and effect check |
| `931110-1.c` | Nonzero signed-short bitfield-array write and readback |
| `960117-1.c` | Packed union pointer and short member readback |
| `align-1.c` | Independently checked aligned typedef and member offsets |
| `builtin-prefetch-5.c` | 9-bit byte-offset prefetch address and no side effects on stored bytes |
| `inst-check.c` | Actual loop function execution with seven integer reference values |
| `packed-2.c` | Packed whole-word field and neighboring-short readback |
| `strct-pack-2.c` | Aligned packed array-pointer identity and readback |

These obligations are **closed only for the stated tested intent**.
They are not guarantees that the original source, every historical
compiler profile, or every CPU architecture passes or is behaviorally
identical. The original source must be tested separately if exact
original-source compatibility becomes a later requirement.

## Six partial source obligations

- `921215-1.c`: nested-closure callback assertion present, but GCC
  optimized modes time out in SIMH; no guest result can be inferred.
- `960416-1.c`: native 36-bit-limb/71-bit multiplication is covered;
  original 32/32 union-overlay/71-bit ABI semantics remain unverified.
- `builtin-prefetch-1.c`: address side effects tested, but complete
  original locality/read-write forms and exact codegen policy remain.
- `builtin-prefetch-2.c`: global/local pointer-expression subset
  tested; remaining original address forms require review.
- `builtin-prefetch-3.c`: volatile pointer effects tested, but not all
  original volatile-expression forms.
- `builtin-prefetch-6.c`: null-address no-fault tests run, but all
  original invalid-pointer expression forms remain unproven.

## Fifty-three blocked test-construction obligations

The original-source classes are retained rather than rebranded as
compiler bugs:

| Historical reason | Sources | P1 admission condition |
| --- | ---: | --- |
| Hosted runtime | 22 | Real malloc/stdio/math/formatting or other original runtime dependencies |
| Compiler investigation | 13 | Verify an original source's nonvacuous assertion and activate a source-pinned normal matrix cell, or justify and register a companion |
| Width/source adaptation | 5 | Resolve original architecture-specific width and representation assumptions |
| Feature policy | 3 | Decide actual supported GNU/target feature semantics |
| Freestanding libc linkage | 3 | Install and link genuine target library implementations |
| Variadic ABI | 3 | Independently validate varargs, structure passing and runtime contracts |
| Header integration | 1 | Verify original target header assumptions and assertion reachability |
| ISA/assembler harness | 1 | Build a real KL10 assembler diagnostic, not a PDP-6 C compile attempt |
| Compiler internal error | 1 | Retain a valid source-pinned matrix/diagnostic regression for future repair |
| Linker relocation investigation | 1 | Distinguish the genuine relocation overflow from unrelated test infrastructure |
| **Total** | **53** | **Not equivalent to 53 independently proven compiler bugs** |

In particular, an original source that happens to fail at runtime but
has **no active canonical compiler-matrix registration** is **not**
a completed compiler-regression test. The existing 134 PDP-6 baseline
observations remain diagnostic evidence, not automatic activation.
The compiler fixes themselves are intentionally outside P1.

## Reproducibility and fail-closed checks

`tools/build-p1-semantic-resolution-v1.py` regenerates and audits the
67-row status ledger. Its host verification mode checks every original
SHA256, the original deferred/activation classifications, all 14
source-to-companion links, source identities in all six companion
execution ledgers, active matrix registration and exact supported
compiler profile status. It refuses to promote a partial or blocked
source, or to treat a simulator timeout as a compiler assertion failure.
Existing individual companion evidence verifiers additionally validate
the actual archived compiler/guest logs against SHA256.

The newly closed `covered` obligations should no longer appear as
unresolved P1 **test-construction** work. The 67 historical original
sources are nevertheless preserved, and the compiler failure evidence
remains visible in the ordinary matrix.
