# PDP10 P1: native 9/18/36-bit division and remainder oracle (2026-11-19 v1)

## Historical source and relevant bug boundary

The original `tests/todo/generic/arith-rand.c` is unchanged and
remains in the `width-or-source-adaptation` deferred category. Its
`random_bitstring()` termination condition uses `8*sizeof(long)`
even though the PDP-10 has nine-bit bytes and a 36-bit native word.
The signed char and signed short division paths do not check a zero
divisor. As a result, observed runtime failure is not a legitimate
reference for the native signed division behavior without further
analysis. The historical random generator, 1000 iterations and its
original assertions have **not** been changed or reclassified.

## Independent deterministic arithmetic reference

New `tests/semantic/regression/pdp10-divmod-native-widths-v1.c`
provides an executable **36-case** quotient/remainder oracle: six
cases each for signed/unsigned 9-bit char, 18-bit short and 36-bit int.
Source operands come through volatile target-typed variables, not
compile-time constant expressions. Each case has an independently
calculated quotient and remainder literal, plus a numbered failure
checkpoint. The independent host verifier computes

`q = trunc_toward_zero(a/b)` and `r = a-q*b`

using arbitrary-precision host integers, with explicit checks that
all arguments and expectations fit their native signed/unsigned
widths. Zero divisors and signed MIN/-1, for which mathematical
quotients are not representable in the source type, are excluded.
The case corpus includes near-boundary signed values, negative
numerators, negative denominators, unsigned maxima, zero and unit
divisors. No fake compiler intrinsic or runtime division helper is
supplied to change the tested implementation.

The test is registered in the ordinary compiler matrix and executes
on PDP-6 under KCC optimized/unoptimized and GCC O0/O1/O2/Os.
The actual results are **KCC 2/2 PASS, GCC 4/4 runtime failures**.
All four GCC executions reach **failure checkpoint 037 octal (case 31)**
in the generated 36-case sequence; the original source and compiler
implementations are unchanged, with repair deferred until the P1
testkit construction completes.

`PDP10-P1-DIVMOD-NATIVE-RESULTS-20261119-v1.tsv` and the archived
`refs/pdp10-p1-divmod-native-20261119-v1.tar.gz` contain all six
original compiler and guest logs with SHA256 evidence binding.
The registered host checker `tools/verify-p1-divmod-native-v1.py`
recomputes the reference cases independently, checks original
source provenance and historical deferred status, and fails if a
compiler profile or recorded assertion failure disappears.

## Remaining coverage

This deterministic companion is necessary but not sufficient to
claim the entire original `arith-rand.c` test resolved. It does not
execute the original 1000 randomized iterations, and its finite
36-case matrix cannot by itself establish every possible divide,
remainder, coercion or signed-extreme behavior. The original test
needs a separately justified PDP-10 random-bit generation and safe
divisor policy before promotion. Compiler investigation remains P2.
