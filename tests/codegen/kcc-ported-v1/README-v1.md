# KCC-specific code generation regressions

Sources in this directory replace shell-only assembly-pattern checks.
Patterns are expressed as `codegen-require-regex` and
`codegen-forbid-regex` directives consumed by `run-tests.sh`.

- `aoja-fold-v1.c`: requires AOJA loop-folding and prohibits the
  redundant ADDI/JRST pair.
- `bitwise-literal-v1.c`: requires immediate IORI, ANDI, XORI and
  high-half TLO forms, and prohibits intermediate MOVEI literal loads.

The original shells ran KCC optimized on PDP-6. Matching matrix cells
were verified PASS using the installed compiler. They are deliberately
KCC-only because the instruction shape is compiler-specific; the C
semantics themselves are not asserted by these compile-only tests.

## Terminal return and DImode-zero folding

`terminal-return-fold-v1.c` retains all three required PDP-6 return
instruction patterns (HLRZ, MOVNI, SETZ) and prohibits the redundant
MOVE into AC1. `dimode-sub-zero-fold-v1.c` prohibits unresolved `%DISUB`
when subtracting a 72-bit zero on PDP-6, KA10, KI10 or KS10.

All five selected installed-KCC matrix cells passed. They are KCC-only
because they assert KCC optimizer shape, not language semantics.

## Signed-zero comparison

`signed-zero-compare-v1.c` preserves the five required SKIP instruction
patterns and the prohibition against SETZ/CAM zero materialization.
KCC PDP-6 optimized matrix test passed using the installed compiler.

## Small-constant byte pointer adjustment

`adjbp-small-constant-pdp6-v1.c` requires exactly two `IBP` instructions
for `p + 2` and forbids the `%ADJBPH` helper. The exact instruction count
is enforced by one multiline regular expression. The distinct
`adjbp-small-constant-ks10-v1.c` requires native `ADJBP`. Both cases
passed their respective installed-KCC native optimized matrix cells.
The old script contained no additional assertions.

## DImode canonical complement

`dimode-complement-canonical-v1.c` checks **exactly four** `SETCA`
instructions for a pair of signed/unsigned 72-bit complements, rejecting
alternate XOR/AND masks that lose the duplicated low-word sign-bit
invariant. All four optimized KCC CPU profiles (PDP-6, KA10, KI10, KS10)
passed the normalized regular-expression policy.

## Peephole conditional return

`peephole-return-v1.c` preserves the original negative assertion against
consecutive `SKIPA 1,[-1]` and `JRST` instructions after unsigned comparison.
KCC native PDP-6 optimized code generation passed the normalized check.
