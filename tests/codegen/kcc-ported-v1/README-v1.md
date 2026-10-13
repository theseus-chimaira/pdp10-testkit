# Five further KCC migrations and obsolete placeholder cleanup (v19)

`dimode-direct-abi-pairs` now retains its direct-AC/stack-snapshot
instruction checks across PDP-6, KA10, KI10 and KS10.
`shared-fixed-epilogue-v1` has separate code-generation and runtime
fixtures on all four CPUs, enforcing one shared fixed-frame epilogue and
correct return values.
`ka10-double-add-runtime` retains the floating-point arithmetic runtime
assertions on KA10/KI10 native, base and PDP10 compiler profiles.

`kl10-section0-codegen` uses a per-cell compiler-invocation check for
the actual KL10 target, including ADJBP, ADJSP, DFAD and DMOVE instruction
requirements and the prohibition on the ADJBP helper.
`local-dse-v1` likewise retains the baseline dead-store instruction
restriction and runtime execution under all four CPU personalities.
The special checks live in `tools/kcc_special_checks_v1.py`.

All selected KCC checks passed. The four source-based fixtures registered
64 GCC native profile cells (PDP-6/KA10/KI10/KS10 multiplied by
`-O0`, `-O1`, `-O2`, `-Os`), and all passed. GCC cell registration
is independent of pass/fail results: a failing compiler stays a failing
cell, not `unsupported`.

The original `terminal-return-chain` and `runtime-helper-fragments`
scripts were rechecked and remain legacy tests: both currently fail,
the former on its conservative terminal-copy requirement and the latter
on the installed assembler's command-line handling. Neither assertion
has been relaxed.

The text-only future object, linker, and loader specification files
under `tests/object/base`, `tests/link/base`, and `tests/loader/base`
were deleted together with their three inert `TEST_MATRIX.tsv` rows.
The empty directories were removed; no executable test was lost.

# Five compiler-interface and diagnostic migrations (v18)

The legacy wrappers `invalid-subscript-recovery`,
`gnu-attribute-classification`, `vla-v13`,
`output-path-dotdot-v8`, and `target-variants` are represented by
22 matrix fixtures. Installed KCC passed the 22 selected matrix checks.
The negative fixtures retain explicit rejection and diagnostic checks,
including the 12 unsupported GNU attributes, invalid subscripting and
three illegal VLA constructs. The two positive VLA programs run through
the semantic executor.

The compiler invocation tests use `codegen-kcc-special` and the
per-cell, parallel-safe implementation in
`tools/kcc_special_checks_v1.py`. They preserve the original checks for
`-R=../out/result`, `klx`, ITS CPU variants, and `CIRC` instruction
selection and rejection outside ITS mode.

## Failed compiler cells remain active

`no_test` means an unassigned test, while `unsupported` is reserved
for a configuration that cannot support the test. **A compiler
compilation failure, runtime failure or incorrect acceptance of a negative
test must be recorded as a failing matrix cell**, not omitted because it
failed an initial eligibility audit.

Accordingly, 144 native GCC cells previously omitted after compilation
failures were activated for `gnu-function-attributes`,
`gnu-packed-copy-stream-codegen`,
`mixed-byte-struct-static-init`, `narrow-cast-conversion`,
`subbp-byte-size-range`, `exact-width-16-32`, and the semantic programs
`compound-literals`, `designated-initializers` and
`flexible-array-members`. Another 128 GCC cells were enabled for the
applicable new invalid-subscript, GNU-attribute and VLA fixtures.
Compiler-specific instruction and diagnostic assertions still apply only
to the compiler to which they belong. Compiler-neutral negative fixtures
use `codegen-expect-compile-fail`.

GCC is known to fail the compound-literal and designated-initializer
runtime checks and the flexible-array-member compilation checks in the
original 16 native profiles. The VLA scope checks produce mixed GCC
results, including an incorrect acceptance of a switch entering VLA scope
on PDP-6 at `-O2`. These remain visible as failures.

# Preprocessor, peephole, language, and packed-pointer migrations (v13–v16)

Seventeen further shell regressions were converted into native test-matrix
fixtures without discarding their original assertions:

- **Preprocessor:** `pp-undef`, `pp-long-macro`, `pp-pool`. The preprocessor
  runner verifies macro expansion and dynamically generates the original
  4096-character macro identifier and 400000-character string-token stress
  inputs, rather than storing large permanent fixture files.
- **Peephole cleanup:** `local-idempotent-cleanup-v1` and `-v2`. Seven
  matrix fixtures include the original common test sources and enforce the
  duplicate-TLZ, duplicate-sign-extension, zero-immediate, and self-MOVE
  checks. All four KCC base processors passed.
- **Language semantics and diagnostics:** `compound-literals`,
  `designated-initializers`, `flexible-array-members`,
  `statement-expressions`, and `variadic-macros`. Five PDP-6 KCC runtime
  tests passed, along with their separate expected-rejection diagnostics;
  variadic macro stringization is also checked in preprocessor output.
- **GNU packed pointers:** `gnu-packed-bitptr-local`,
  `gnu-packed-bitptr-aggregate`, `gnu-packed-bitptr-voidqual`,
  `gnu-packed-bitptr-casts`, `gnu-packed-bitptr-static`,
  `gnu-packed-bitptr-stream`, and `gnu-packed-internal-stream`. The matrix
  covers original runtime programs, rejected logical-pointer escapes,
  compile-only qualifier/cast tests, static `POINT` instructions, `IBP`/`ILDB`
  streaming, absence of `ADJBPH`, and the four-CPU `SETM`/`ILDB` count checks.

Expected compilation failures now have explicit matrix policies requiring
their diagnostic patterns, rejecting compiler internal errors and rejecting
compiler crashes. Runtime fixtures run under the normal semantic runner.

The initial GCC coverage enabled only successful cells: 112 native compilation
cells for the seven cleanup inputs, 16 for `pp-undef`, and 32 runtime
semantic cells for `statement-expressions` and `variadic-macros` (160 total).
All sixteen native GCC profiles failed the `compound-literals` and
`designated-initializers` runtime programs, while `flexible-array-members`
failed GCC compilation. Their GCC cells were subsequently enabled in v18
to report these regressions directly.
# Three optimizer-regression migrations (v12)

`identical-pure-fold-v1`, `cheap-optimizer-pass` and
`cheap-optimizer-final` now use matrix-backed C inputs with structured
KCC instruction/count checks. All twelve native KCC optimized cells
and 48 GCC native compilation cells passed. The latter do not apply
KCC-specific instruction policies.

`cheap-optimizer-1-6` was investigated but remains a legacy test:
current KCC emits `SETZB 2,0(1)` followed by `SETM 1,2` in
`storezero`, contrary to the original requirement `SETZB 1,...`.
# Ten KCC regression migrations (v11)

Migrated `dimode-addsub-registers`, `dimode-corpus-survey`,
`loop-induction-address`, `register-overwrite-fold`,
`memory-result-fold`, `scratch-member-elision`,
`double-store-forward`, `kcc-null-pointer-static-init-20261005-v1`,
`kcc-absolute-pointer-store-20261005-v1`, and
`gnu-function-attributes`. All 28 selected KCC optimized matrix
cells passed. The first seven use structured assembly checks translated
from the original shell/AWK assertions. The pointer regressions retain
KCC GNU99/GAS options and assembly requirements. The GNU attribute
fixture checks the original one noinline warning, two noreturn warnings,
and an out-of-line `helper` assembly symbol.

Nine of the ten sources also compiled under all four native GCC CPU
targets and four optimization levels, adding 144 GCC compilation-only
cells. The function-attributes source did not compile under GCC during
that audit; its failing GCC cells were enabled in v18. GCC cells do not
inherit KCC-specific assembly or
diagnostic assertions. The `preserved-blt` wrapper was investigated but
retained because the installed compiler does not satisfy its original
instruction-sequence assertions.
# Five KCC ABI, store, and absolute-value regressions (v10)

Normalized `abi-first-call-lifetime`, `abi-query-liveness`,
`direct-assignment-store`, `live-abi-index`, and `abs-store-movm`
from their legacy wrappers. All selected KCC optimized cells passed.
KCC-specific instruction policies remain in force; the two-word direct
store checker accepts the original MOVEM pair on PDP-6/KA10 and DMOVEM
on KI10/KS10. All five source programs also compiled in the 16 native
GCC combinations (four CPUs and four optimization levels), giving 80
additional GCC compile-only codegen checks.
# Five more shared C / KCC policy regressions (v9)

The regressions `constant-branch-chain`, `abs-query-movm`,
`abs-query-movm-extended`, `dead-local-store`, and
`store-forward-gap` now use matrix C fixtures. Original KCC
function-local required/forbidden assembly checks are preserved.
All five passed on native PDP-6, KA10, KI10, and KS10 optimized KCC.

All five also compiled successfully with GCC at `-O0`, `-O1`,
`-O2`, and `-Os` on each of the four native CPUs (80 cells).
The six fixtures from migration v8 were likewise confirmed as GCC
compile-compatible in all 96 combinations and enabled in the matrix.
GCC is exempt only from KCC-specific instruction expectations;
these cross-compiler cells validate assembly generation, not runtime.
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
policies. The `exact-width-16-32` fixture did not compile under GCC
during that audit; its failing GCC cells were enabled in v18.
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

Four fixtures were originally excluded because GCC compilation failed:
`gnu-packed-copy-stream-codegen`,
`mixed-byte-struct-static-init`, `narrow-cast-conversion`, and
`subbp-byte-size-range`. Their GCC cells were restored in v18.
The existing KCC instruction checks remain KCC-specific.
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
