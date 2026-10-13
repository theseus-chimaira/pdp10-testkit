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
