# PDP-10 testkit before the full sweep: source-integrated v2

Date: 2026-11-20. Scope: **`pdp10-testkit` only**. This is an updated
pre-sweep checkpoint, not a claim of compiler/CPU acceptance. No full
compiler, optimization, ISA, special-manual or DAIMOS OS sweep ran.
The v1 report remains a historical snapshot.

## Branch, scope and registries

Only the ordinary `main` and `origin/main` branches are present. Review
refs under `refs/devspace/review/` are not branches to merge; **no branch
merge is necessary**. No sibling repository was edited. Generic compiler,
assembler, linker, ABI and CPU tests stay here; OS/kernel/booted-guest
tests remain outside this repository. The existing strict test-boundary
audit is the ownership gate; no additional migrations were justified.

The live inventory/script audits after this versioned integration record:

| Item | Status |
| --- | ---: |
| Unique compiler sources | 2296 |
| Special registrations | 353 |
| Owned script paths | 519 |
| Unowned compiler/assembler test files | 0 |
| Unconnected owned scripts | 0 |
| Retired identical historical aliases | 97 |
| Historical deferred original identities | 67 |
| P1 original-source intents covered / partial / blocked | 47 / 0 / 20 |
| Frozen 59-source batch intents covered / blocked | 39 / 20 |

The historical upstream import/disposition table still contains 551
active, 67 deferred, 58 removed, one nonportable source. These words
describe imported-source ownership, **not a count of compiler passes**.
The latest P1 authorities are
`PDP10-P1-SEMANTIC-RESOLUTION-20261120-v18.tsv` and
`PDP10-P1-SOURCE-BATCHES-20261120-v17.tsv`.

## Newly completed source-intent coverage

All historical originals remain unchanged. In addition to the earlier
verified `930513-1.c` and `struct-ret-1.c` closures, two more source
intentions now have real registered and archived PDP-6 compiler evidence:

| Original | Independently checked assertion | Actual outcome |
| --- | --- | --- |
| `980605-1.c` | Exact 100000-byte live 9-bit stack array; 20 calls, nested 10-argument call, float conversion and buffered formatting | Original 3 PASS, companion 6 PASS |
| `920501-8.c` | All 13 integer `va_arg` slots, exact 16-field float/decimal string and real `sprintf` return/output | Companion 6 `run_fail` at exit 41; original KCC timeout and GCC link failure |

The `980605` test has an exact-size local array occupying 25000
36-bit data words, 391 spaced volatile entries plus the final byte,
and asserts a separately calculated checksum. It does not reduce
the original's memory commitment to a token-size stack fixture.
The nine original/companion reports, maps and assembly are SHA-pinned;
11 negative controls pass.

The `920501` companion is **not a compiler PASS**: all six PDP-6
KCC/GCC profiles finish their thirteen real `va_arg` reads, then
reach a negative `sprintf` return at default-precision `%f` and
HALT with nonzero exit 41 (octal 051). Its unchanged original still
times out on KCC and currently link-fails in GCC with the exact
`dlink: duplicate global: vsprintf` diagnostic. A scratch differential
with `%.0f` passes KCC but fails GCC O0, suggesting distinct format
handling and ABI/argument-count causes; it was not counted as a new
published PASS. The selected real GCC formatter source has one visible
`vsprintf` definition, so investigate the selected linker object set
and symbol handling rather than suppressing the linker failure.
The eight results, real companion maps and emitted assembly are
SHA-pinned; ten negative controls pass. Neither `printf` nor `vsprintf`
has been stubbed. Reproductions are in the two focused source-closure
reports (`PDP10-P1-980605-STACK-CLOSURE-20261120-v1.md` and
`PDP10-P1-920501-MANYARGS-CLOSURE-20261120-v1.md`).

## Remaining 20 P1 source-intent TODOs

These are test-construction obligations, **not 20 proved compiler
bugs**. All previously accepted failing compiler matrix cells remain
scheduled; original import dispositions and source SHA pins stay frozen.

| Work class | Source names | Next required action |
| --- | --- | --- |
| Real hosted allocation/runtime and timeouts | `20020406-1.c`, `920810-1.c`, `941014-2.c`, `990628-1.c` | Real target allocator/hosted ABI, completed guest or independent asserted test |
| Stack/representation pressure | `960521-1.c` | Separate feasible memory-contract oracle; avoid interpreting 64K stack exhaustion as compiler arithmetic failure |
| ctype/math/stdio hosts | `980707-1.c`, `980709-1.c`, `990826-0.c` | Real headers/functions; retain linker duplicate and native-width distinctions |
| Noreturn and computed goto | `builtin-noret-1.c`, `comp-goto-1.c` | Resolve actual builtin/ABI or language/oracle contracts; no test-only `_eexit`/malloc stubs |
| Real stderr/varargs/formatting | `gofast.c`, `strct-varg-1b.c`, `stdio-opt-1.c`, `stdio-opt-2.c`, `stdio-opt-3.c`, `va-arg-21.c` | Complete independent target oracles and genuine hosted I/O support |
| Historical replaced pointer-torture intent | historical `old.tort.c` | Repair/check six active native byte-pointer compiler failures on the replacement, not the deleted import |
| libc functions | `991112-1.c`, `conversion.c` | Real UTF-9/ctype `isprint` and unsigned FP helper `__fixunssfsi`, plus executed conversion assertions |
| KL10 assembly | `920428-1.s` | Real KL10 assembler/ISA oracle; no assembly-only fixture counted as a runtime PASS |

The categories above are disjoint: 17 `hosted-runtime`, two
`libc-linkage` and one `isa-harness` source. The 67-original
source-specific v18 ledger is authoritative if later progress changes.

## Exact missing symbols versus incomplete services

The following are actual historical or current linker failures,
not hypothetical API requests:

| Symbol | Source/cell | Action |
| --- | --- | --- |
| `__builtin_abort` | GCC PDP-6 noreturn regression O0/O1/O2/Os | Correct compiler builtin lowering; four current `link_fail` |
| `__fixunssfsi` | GCC `conversion.c` | Provide/verify the real conversion helper; KCC has a separate executed assertion failure |
| `isprint` | Both PDP-6 compilers, `991112-1.c` | Post-1.0 UTF-9-aware real ctype implementation |
| `isspace` | `980707-1.c` input symbol census | Real ctype and separate `dlink` duplicate-`exit` diagnosis |
| `_eexit` | GCC `builtin-noret-1.c` | Original macro/target policy and noreturn codegen; not a fake stub |
| `__builtin_printf` | KCC `stdio-opt-2.c` | Builtin lowering/real output contract |
| `putchar` | GCC `stdio-opt-2.c` | Real console-output implementation |
| `stdout`, `stderr` | KCC `stdio-opt-1.c`, `gofast.c` | Hosted FILE stream **objects**, not functions |

**Distinct failures, not missing functions:** `dlink: duplicate global:
exit` in original `980707-1.c`, new current `dlink: duplicate global:
vsprintf` in original `920501-8.c`, and genuine negative return from
the linked `sprintf` `%f` path in six companion profiles. Their
fixes belong to the actual compiler/linker/runtime, not fabricated
testkit substitutes. `malloc`, `calloc`, `memcpy`, `sprintf`,
`strcmp`, `printf` and `vprintf` have linked for other selected
profiles; do **not** label them globally missing just because specific
test profiles time out or fail.

The nine codegen compiler ICE/signal observations in the 2026-11-17
initial-sweep manifest (six GCC, three KCC) are historical failure
evidence. They were **not** all revalidated in this preflight and
must not be declared repaired.

## Further work before permitting the large sweep

1. Resolve or properly classify each of the 20 blocked source-oracle
   intentions, with priority for real compiler/assembler/linker bugs.
2. Review negative/diagnostic expected-output matching, actual
   compile/link failures and target-specific assembler fixture contracts.
3. Finish restart/timeout/ICE/report identity audits with host-only
   synthetic tests and a small set of independently selected cells.
4. Run final source/fixture provenance, ownership, script-dispatch,
   syntax and negative-control checks after any additional integrations.
5. Keep new AAP emulator correctness and boot-linked kernel tracing
   at their documented P3 priority; they do not authorize OS-suite
   activity or a generic testkit full sweep here.

**STOP: the full compiler/CPU/optimization sweep has not been run and
must remain operator-selected.** No branch consolidation, external
toolchain fix or sibling-repository modification occurred in this work.
