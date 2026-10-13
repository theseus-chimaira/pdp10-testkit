# Six further KCC regressions (v8)

Normalized `adjbp-helper-shared-scratch-v1`,
`dimode-direct-abi-shifts`, `dimode-div-one-scratch`,
`dimode-div-reuse-bit-temp`, `dimode-div-helper-cost`, and
`oldstyle-const-arg`. Original instruction counts, register reuse,
helper-size comparisons and diagnostic restrictions are retained.
All selected installed-KCC profiles pass.

The `dimode-mod-no-quotient` and `dimode-div-helper-selection`
wrappers remain because the former fails its register-residency
assertion and the latter additionally depends on runtime source files
that are absent from the installed KCC prefix.
# Five more KCC regressions and GCC cross-coverage (v7)

Normalized `dimode-incdec-lvalues`, `sidiv-helper`,
`exact-width-16-32`, `dimode-div-borrow-noscratch`, and
`dimode-div-single-sign`. All selected KCC native optimized cells
passed; the exact-width test also passed all seven base/PDP10-family
optimized profiles. Borrow SUB/SUBI counts and order, and the exact
function-local SETZ/XOR counts were retained.

Four of these five sources also passed GCC compilation on four native
processors under all four optimization levels. Their 64 GCC codegen
compilation checks are matrix-enabled using KCC-only instruction
policies. The `exact-width-16-32` fixture remains KCC-only because
GCC does not compile its KCC-specific integer/character type syntax.
# GCC cross-compiler compilation coverage (v1)

An exhaustive native GCC compilation audit was performed for all 70
migrated KCC source fixtures across PDP-6, KA10, KI10, KS10 and
`-O0`, `-O1`, `-O2`, `-Os`. All 16 combinations compiled for
66 fixtures, giving 1056 new GCC matrix code-generation cells.

`codegen-kcc-policy-only: yes` retains all existing KCC instruction
assertions for KCC and suppresses only these KCC-specific directives
for GCC. The existing generic architecture opcode restrictions still
apply. GCC coverage currently validates successful assembly generation,
not equivalence of KCC's instruction-selection policies or runtime
correctness.

The remaining four fixtures were not enrolled because GCC compilation
failed: `gnu-packed-copy-stream-codegen`,
`mixed-byte-struct-static-init`, `narrow-cast-conversion`, and
`subbp-byte-size-range`. Keep their KCC-only checks and investigate
compiler extension compatibility separately.
# Four verified KCC matrix migrations (v6)

The `indexed-store-forward`, `indirect-call-byteptr`,
`subbp-byte-size-range`, and `dimode-mul-pair-lifetime` regressions
are now matrix-backed. Original assembly requirements and bans are
preserved; the SUBBP case preserves compilation in native, base and
PDP10-family profiles. The indirect-call test was verified with KCC
`-n` and optimized base profiles. All selected checks passed.

`dimode-signed-wide-power2` was also investigated but remains in the
legacy directory: the current KCC output fails the original restriction
on divider state/stack operations across all four CPUs.
# Five KCC optimizer regressions: v5

The five shell regressions `rotate-idiom`, `signed-power2-div`,
`straight-const-prop`, `dimode-div-one` and
`return-register-chain` are registered as matrix code-generation fixtures.
Function-local required and forbidden instructions, exact rotate/remainder
counts, and required call evaluation were preserved. Installed KCC
optimized cells passed on the relevant PDP-6, KA10, KI10, KS10 and
PDP10-family profiles.

`kl10-section0-codegen` was investigated and independently compiled
successfully, but its wrapper remains: the matrix has no KL10 processor
column, so deleting it would lose the explicit `-x=kl10` check.
# Five KCC PDP-6 code-generation regressions

The original sources and assembly assertions from
`gnu-packed-copy-stream-codegen`, `shift-scratch-reg`,
`unsigned-constant-compare`, `tail-memory-arg`, and
`narrow-cast-conversion` are now matrix-registered. All five
installed KCC PDP-6 optimized cells passed. Required, forbidden,
and exact-count patterns were carried over from the legacy scripts.
# Five additional KCC instruction regressions

The C sources and original assertions from `direct-deref-tail`,
`redundant-shift-mask`, `return-fallthrough`,
`dimode-compare-fallback-scratch`, and
`mixed-byte-struct-static-init` are now matrix-registered.
All eight applicable optimized KCC cells passed. The direct/indirect
call, redundant mask, and return fallthrough assertions remain explicit.
`dimode-compare-registers` was also investigated but retained as a
legacy regression: its existing no-spill assertion fails across four
KCC CPU profiles.
# Five additional KCC compile and address-fold regressions

The original sources from `abi-consumed-pair-lifetime-v24`,
`dimode-scalar-arg-pressure`, `dimode-vrallspill-audit`,
`dimode-push-address-fold`, and `fp-cast-vrnarrow` have been
migrated to matrix code-generation cases. The floating-point shell
script becomes two fixtures, each checked in both KCC optimized and
`-n` profiles. The push-address fixture retains the forbidden
three-instruction copy-and-push sequence; other cases require successful
assembly generation. All selected cells passed with the installed KCC.
# Six additional KCC DImode regressions

The matrix now includes `dimode-mul-ac-operands`,
`dimode-register-pair-fold`, `dimode-wide-identity`,
`dimode-dead-rhs-scratch`, `dimode-exhaustion`, and
`dimode-nested-peer-pressure`. Original C fixtures were preserved.
The first four retain their instruction policies, while the last two
retain their multi-CPU compile-success requirements. All 19 selected
native optimized KCC cells passed.
# Additional DImode regressions

Five shell regressions were transferred into native matrix codegen checks:
`dimode-signed-mod-power2`, `dimode-unsigned-div-no-sign-flags`,
`dimode-wide-literal`, `dimode-addsub-no-scratch`, and
`dimode-bitwise-registers`. Original required, forbidden, and exact
instruction-count constraints were retained. Each passed installed KCC
optimized PDP-6, KA10, KI10, and KS10 profiles (20 passing cells).

Three further candidates remain in the legacy harness because their
original assembly limits currently fail with the installed KCC:
`dimode-unsigned-wide-power2`, `dimode-negative-power2` (stack
PUSH/POP), and `dimode-mul-no-snapshots` (MOVE count on PDP-6/KA10).
# Six-regression DImode and left-half optimization batch

Six KCC shell regressions were migrated into matrix code-generation checks:
`left-half-constant-fold`, `reverse-dmovem-fold`,
`dimode-zero-compare`, `dimode-low-mask-direct`,
`dimode-negate-inplace`, and `dimode-signed-div-power2`.
The original test C is preserved, including exact minimum counts for
SKIPN/SKIPE, MOVN and the signed power-of-two division instructions.
All 19 selected installed-KCC native optimized CPU cells passed.
# Six-regression halfword and folding batch

The following KCC-only regression sources were normalized into the standard
code-generation matrix: `duplicate-andi-fold-v1.c`,
`halfword-memory-fold-v1.c`, `halfword-store-fold-v1.c`,
`hllz-late-fold-v1.c`, `hrlz-late-fold-v1.c`, and
`move-negation-fold-v1.c`. Their original C programs and required/forbidden
assembly patterns are preserved, including the exact two-mask count and
function-local instructions. All six pass on installed KCC PDP-6 optimized.
GCC-specific semantic compatibility is not established by these tests.
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

## DImode wide constant folding

`dimode-wide-fold-v1.c` preserves eight original function-local instruction
assertions on `l34`, `l70`, `r35` (two checks), `ar35`, `ar70`, `ceq`, and
`clt`, as well as the global prohibition against runtime `LSHC`/`ASHC`
shifts. Installed optimized KCC passed native PDP-6, KA10, KI10, KS10
matrix cells. These are KCC-specific folding expectations.

## Small negative byte-pointer offsets

`adjbp-small-negative-{pdp6,ka10,ki10,ks10}-v1.c` each retain
function-local assertions for all five offsets. PDP-6/KA10/KI10 require
PDP-6-safe HRRZ addressing and disallow the ADJBP helper in each
function; KS10 requires native ADJBP in each function. All four KCC
optimized profiles passed. The original PDP-6 execution test is preserved
separately as `tests/semantic/kcc-ported-v1/adjbp-small-negative-runtime-v1.c`
and passed the matching KCC semantic runner. The duplicate source content
is intentional: code-shape and runtime checks have different profiles.

## Late skip/jump folding

`late-skip-jump-v1.c` preserves the required JUMPE and prohibits an
adjacent same-register SKIPN/JRST pair. The native optimized PDP-6 KCC
matrix cell passed. The former shell wrapper is retired.

`dimode-div-register-fast.sh` was investigated separately, but remains in
the original KCC regression directory: the compiled divider functions
currently spill registers before the `%DIDIV` label, failing the original
non-spill assertion. Do not weaken or retire that assertion without a fix.

## DImode address-copy folding

`dimode-address-copy-fold-v1.c` requires DImode addition (`DIADD`) and
forbids redundant stack-pointer-address materialization through SETM/MOVEI
on KA10 and KI10. Both installed KCC optimized native matrix cells pass.

## Five-regression instruction-selection batch

The `constant-negation-fold`, `dead-store-fold`, `dimode-constant-shift`,
`dimode-div-minus-one`, and `dimode-div-negate-inplace` C fixtures were
extracted unchanged from their KCC shell scripts. All positive/negative
assembly checks and the original exact-one indexed store count are
expressed as matrix code-generation directives. Tested with installed KCC:
PDP-6, PDP-6, KI10, KA10, and PDP-6/KA10/KI10/KS10 respectively; all
selected native optimized cells PASS. These checks are intentionally
KCC-specific, not GCC code-shape requirements.
