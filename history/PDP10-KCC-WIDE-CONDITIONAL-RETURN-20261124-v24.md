# KCC 71-bit relational conditional-return control-flow repair v24

Date: 2026-11-24

## Original failure

`tests/todo/generic/20020402-3.c` originally had 11 optimized
KCC simulator timeouts and 11 unoptimized PASS results. The source
searches a blockvector by comparing 71-bit addresses and returns the
blockvector pointer when an interval contains the requested PC.

An instrumented copy of the source showed that the optimized KCC
executed its second loop 26 times with `bot=0` and `top=1`, whereas
unoptimized KCC exited this loop and returned the expected pointer.
Removing the first search loop retained the opt-only timeout. A
source-level boolean temporary around `b->endaddr > pc` changed the
generated flow sufficiently to avoid the timeout; that was diagnostic
only, not used as the compiler repair or a relaxed test oracle.

## Root cause

KCC's `gdimode_signed_relop_skip` and
`gdimode_unsigned_relop_skip` in `ccgen2.c` emit the final true
comparison edge as a literal assembler instruction
`JUMPN flag,.+2` through `codestr()`. This flushes the peephole
buffer but does not represent the conditional skip in its PCODE
history. `gboolean()` then emits the false-edge `P_JRST` through
the buffered `code6()` path. Optimized `greturn()` calls
`deadjump()`, which sees only an unconditional buffered JRST and
therefore incorrectly discards a reachable `return bl;` statement.
The emitted program loops instead of returning.

## Compiler correction

`ccgen2.c:gboolean()` now flushes the buffered JRST at this exact
71-bit relational comparison boundary, before code generation of a
following conditional return. The real JUMPN and false-edge JRST
then remain ordered in the assembly output without exposing a fake
unconditional terminal instruction to the following PCODE dead-code
check. The common single-word comparison peephole patterns are
unchanged. This uses no additional target memory or runtime helper.

## Independent regression

`tests/semantic/regression/pdp10-kcc-wide-compare-return-v24.c`
contains the reduced two-word interval lookup, including both a
matching and a nonmatching PC. The previous KCC compiled its
optimized PDP-6 profile into a step-limit loop; the repaired KCC
passes it, including unoptimized compilation. The full original
`20020402-3.c` source passes **22/22 KCC matrix profiles** under
strict exit policy in the isolated v25 acceptance directory.

KCC remains tested independently of GCC's unrelated packed struct
runtime failures. The general `full-sweep-current` checkpoint was
not overwritten.
