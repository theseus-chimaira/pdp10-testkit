# GCC packed by-value nine-bit field extraction regression v26

Date: 2026-11-24

## Baseline and failure signature

`tests/semantic/kcc-ported/gnu-packed-byvalue.c` failed all 44
GCC profiles after the v23 copy-loop repair, although every
profile now terminated normally. It passes four sizes of packed
structure through maker, caller and by-value sum functions.
The earliest failing sum was `sum3`: generated O0 assembly loaded
its input word three times, although the fields should be read
as three distinct unsigned nine-bit values.

The reduced reproducer `packed3-diagnose-v26.c` distinguished five
stages. Local fields and pointer-argument fields were correct;
only `sum3(struct p3 p)` failed, returning a packed 36-bit word
rather than the integer sum 6. The original RTL for all three
parameter components was `(mem/s/j:SI frame-offset) [p.aN+0 S1 A9]`:
same effective address and machine mode, but distinct MEM_EXPR.
O1/O2 could legally CSE the indistinguishable MEM operations.

## Compiler correction

`gcc-pdp10/gcc/config/pdp10/pdp10.c`, `pdp10.md` and
`pdp10-protos.h` now recognize exact nine-bit fields of by-value
PARM_DECL aggregates. Their early MOVSI and ADDSI expanders
produce zero or signed extracts from the containing-word MEM,
with the bit position expressed in RTL before CSE and combine.
The late ADD/MOVE output fallback uses LDB and, if the field is
signed, the established 9-bit sign-extension sequence. Attribute
lengths match the resulting one-, two-, three-, or four-instruction
forms. The helper excludes ordinary word fields, indirect
pointers and cross-word accesses.

## Permanent tests

`tests/semantic/regression/pdp10-packed-byvalue-field-extract-v26.c`
is C89 plus target-supported GNU packed/noinline attributes.
It independently verifies 3, 6, 11 and 20-byte unsigned fields
passed by value to non-inlined sum functions, plus a negative
signed 9-bit parameter where the expected sum is -32. On the
previous installed GCC, it failed at first octal ID 0100 at
both O0 and O2. A first intermediate repair passed the unsigned
original but failed 18 O1/Os cells at signed-field ID 0500,
because a late ADD source lacked 9-bit sign extension. The
final compiler corrects that case without changing the oracle.

With the final installed GCC and an independent checkpoint dir,
the official semantic runner reported:

| Source | GCC cells | PASS | FAIL |
| --- | ---: | ---: | ---: |
| Original `gnu-packed-byvalue.c` | 44 | 44 | 0 |
| New `pdp10-packed-byvalue-field-extract-v26.c` | 36 | 36 | 0 |
| **Total** | **80** | **80** | **0** |

Exit policy was strict; no previously green checkpoints were
skipped. The checkpoint output is
`workdir/pdp10-packed-byvalue-v26-final`, and the local build,
pre-repair compiler backup and run logs are at
`$TMPDIR/pdp10-packed-byvalue-v26/` on the development host.

Eight neighboring GCC regression sources were independently rerun:
v17 unsigned div/mod, v18 short16 pointer scaling, v19 indexed
byte pointers, v20 reverse short16 pointer adjustment, v23
packed argument-copy termination, and three historical
wide-integer/control-flow sources. Their **312/312 GCC cells PASS**
under strict exit policy with no skipped old successes.
Combined verification comprises **392/392** fresh GCC cells.
The adjacent checkpoint is
`workdir/pdp10-packed-byvalue-v26-adjacent`.

The rebuilt installed `cc1` has SHA256
`752a3c6a33e112dddcb83822c59a33222f8b8017163229d30550a9a4d055fbea`.

The 44 original runtime failures are closed, but this is not a
full source/CPU optimization sweep and does not resolve unrelated
KS10 optimized byte-pointer assertions.
