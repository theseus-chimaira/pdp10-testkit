# Migrated KCC shell regression tests

Sources here are owned by `TEST_MATRIX.tsv` and `run-tests.sh`, not by
`run-kcc-regressions.sh`. A source is moved only once its assertions are
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

`standard-char-pointer-boundary-v1.c` preserves pointer round-trips through
locals and functions and checks null pointers. The separate `nullinit.c`
compilation check moved to `tests/codegen/kcc-ported-v1/`.

`bool-semantics-v1.c` preserves original `_Bool` initialization, packed
fields, conversions, increments, and arithmetic assertions. Focused run:
KCC PDP-6 optimized and KA10 unoptimized PASS; GCC PDP-6 -O0 and KI10
-O2 RUN_FAIL (retained as a discovered regression, not repaired).

The character-pointer semantic test passed in all four sampled profiles.
`anonymous-aggregates-v7.sh` was removed because both referenced C tests
were already scheduled in the matrix and the wrapper added no independent
assertion. All other KCC scripts remain until evaluated.

## Migration 3: DImode fullword conversion

`dimode-fullword-conversion-v1.c` preserves the shell script's exact
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
