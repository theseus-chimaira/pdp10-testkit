# Migrated KCC shell regression tests

Sources here are owned by `COMPILER_MATRIX.tsv` and `run-tests.sh`, rather
than the transitional legacy KCC-script dispatcher. A source is moved only once its assertions are
preserved and the obsolete corresponding shell runner can be retired.

## Migration 1: semantic-optimizer-runtime

The existing C test was moved without changing its checks for assignment,
compound assignment, array indexing, constant subtraction, reused indexed
loads, and unsigned-remainder negation.

The former `semantic-optimizer-runtime.sh` ran the same source via KCC on
PDP-6, KA10, KI10, KS10. The matrix now schedules both GCC and KCC over
supported CPU/family/optimization combinations. It uses the standard crt0
`__test_exit=0` assertion. Focused verified: GCC PDP-6 `-O0` and KI10
`-O2`, KCC PDP-6 optimized and KA10 unoptimized, all PASS.

No other KCC shell script has been retired. Remaining compiler-internal and
assembly-shape tests require a separate assessment before migration.

## Migration 2: character pointers and Boolean semantics

`standard-char-pointer-boundary.c` preserves pointer round-trips through
locals and functions and checks null pointers. The separate `nullinit.c`
compilation check moved to `tests/codegen/kcc-ported/`.

`bool-semantics.c` preserves original `_Bool` initialization, packed
fields, conversions, increments, and arithmetic assertions. Focused run:
KCC PDP-6 optimized and KA10 unoptimized PASS; GCC PDP-6 -O0 and KI10
-O2 RUN_FAIL (retained as a discovered regression, not repaired).

The character-pointer semantic test passed in all four sampled profiles.
`anonymous-aggregates.sh` was removed because both referenced C tests
were already scheduled in the matrix and the wrapper added no independent
assertion. All other KCC scripts remain until evaluated.

## Migration 3: DImode fullword conversion

`dimode-fullword-conversion.c` preserves the shell script's exact
72-bit integer to 36-bit signed/unsigned narrowing checks. KCC PDP-6
optimized and KA10 unoptimized PASS. GCC PDP-6 -O0 and KI10 -O2
RUN_FAIL: left as discoverable compiler regressions, not corrected.
The old KCC-only execution shell wrapper has no independent assertions.

## Migration batch: ten exact-width/packed-layout regressions

Extracted the complete embedded C test sources and preserved the original
assertions. Their shell wrappers performed only KCC compile/run with
`__test_exit=0`, and have been retired. Each source is now matrix-registered
for both compilers and legal CPU/optimization profiles.

PDP-6 native KCC optimized: **10/10 PASS**. PDP-6 native GCC -O0:
**7 compile failures** on KCC-specific type declarations and **3 runtime
failures** on packed C layout/aggregate semantics. These GCC outcomes need
classification against the supported GCC ABI before treating them as bugs;
no sources or compilers have been changed to hide the failures.

Tests: `exact-width-layout-stride`, `exact-width-32-semantics`, `gnu-packed-array-decay-bitptr`, `gnu-packed-array-members`, `gnu-packed-bitfield-mixed`, `gnu-packed-bitfield`, `gnu-packed-byvalue`, `gnu-packed-char-layout`, `gnu-packed-union`, `gnu-packed-array-bitoffset`.

## Migration batch 2: packed byte pointers and aggregates

Ten self-contained C sources imported without changing assertions, including
bit-pointer call arithmetic, increment/decrement, storage/subtraction, packed
local members, chained assignment and nested/by-value/whole-copy aggregates.
Former KCC-only shell wrappers retired after preserving their sole compile/run
assertions. PDP-6 KCC optimized: **10/10 PASS**. PDP-6 GCC -O0:
**10 compile failures**, attributable to unsupported or incompatible
KCC-specific packed-type constructs pending individual ABI classification.
No compiler modifications. Full matrix sweep remains pending.

Sources: `gnu-packed-bitptr-callabi`, `gnu-packed-bitptr-callarith`, `gnu-packed-bitptr-callincdec`, `gnu-packed-bitptr-callstore`, `gnu-packed-bitptr-callsub`, `gnu-packed-bitptr-localmember`, `gnu-packed-chained-assignment`, `gnu-packed-mixed-layout`, `gnu-packed-nested-byvalue`, `gnu-packed-nested-wholecopy`.

## Migration batch 3: narrow conversions and alignment (two sources)

`dimode-narrow-conversion` and `gnu-aligned-layout` retain all embedded
C assertions. PDP-6 KCC optimized passed both. GCC PDP-6 -O0 gave a
compile failure for narrow KCC-specific types and a runtime failure for
layout; neither was fixed. The original two shell wrappers were removed.

## Migration batch 4: pointer/void round trip

`pointer-void-roundtrip.c` preserves KCC's explicit 6/9/18-bit pointer
casts through `void *`, storage access and pointer subtraction checks.
Sample PDP-6 optimized KCC PASS, GCC -O0 compile failure because of
KCC-specific exact-width type declarations. Original script exercised base
mode in both optimization profiles; these are scheduled in the matrix but
not yet verified individually. The old wrapper has been removed.

`ka10-double-add-runtime.sh` remains pending: its multi-machine floating
runtime checks use a special KA10 runtime fragment; do not delete until
those auxiliary execution prerequisites are reproduced by the matrix.
