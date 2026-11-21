# PDP10 P1: prefetch and 36-bit-limb arithmetic oracles (2026-11-19 v1)

## Test-construction policy

P1 constructs meaningful target assertions and preserves compiler
failures for later investigation. No compiler, emulator, source import,
or freestanding runtime implementation was modified in this pass.
The original six upstream examples remain deferred and checksum-pinned
in `SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv`.

## GNU prefetch without a PDP-6 prefetch instruction

The five deferred `builtin-prefetch-{1,2,3,5,6}.c` sources originally
exercise valid locality/read-write syntax, global/local and volatile
addresses, potentially unaligned addresses, and invalid-address
nonfaulting behavior. On a PDP-6 with no hardware prefetch instruction,
a successful call may be a no-op; success alone cannot prove address
expression evaluation.

The new standalone
`tests/semantic/regression/pdp10-prefetch-address-effects-v1.c`
contains independently checked side effects on a volatile global
index and a function call used to construct the address. It checks a
postincremented local pointer, a volatile pointer to an array, two
byte-offset addresses within nine-bit chars, null prefetch addresses,
and unchanged source data. The explicit volatile/return checks make
compiler elimination of side-effecting addresses observable. The test
does not require a fictitious PDP-6 prefetch opcode, test-only libc,
or any actual memory read from the null address.

The original five files remain deferred for complete exact source and
code-generation policy review. The companion covers their meaningful
address-expression and no-fault properties but is not a claim of
hardware prefetch support. KCC currently links undefined
`__builtin_prefetch` and is recorded as unsupported for this companion;
it was not supplied an artificial helper to make it pass.

Normal compiler matrix result: **GCC PDP-6 O0/O1/O2/Os = 4 PASS**.

## 36-bit native limbs and unsigned 71-bit wide multiplication

Original `tests/todo/generic/960416-1.c` contains GNU integer-to-union
casts and assumes a 32/32-bit union overlay even though the PDP-10 has
36-bit `unsigned long` words and the toolchain's `unsigned long long`
is a 71-bit value. Its conditional early exits do not prove either
wide-integer multiplication path executed.

A preliminary standalone union readback experiment was *not* accepted:
both KCC and GCC disagreed with an assumed 36+36-to-71-bit overlay.
The source of that disagreement (including the union layout and
representation/packing rules) must be established independently; no
invented ABI layout is installed as an oracle.

Instead, `tests/semantic/regression/pdp10-wide-multiply-36bit-v1.c`
uses unsigned 36-bit input words below 2^35 and computes five 71-bit
products. All five full product expectations, high 36-bit limbs and
low 36-bit limbs were calculated with **Python arbitrary-precision
integers**, independently of either compiler, any target union
representation, or target arithmetic. Inputs are volatile to prevent
whole-constant elimination, and each comparison sets an individual
failure checkpoint. This is substantive 71-bit arithmetic coverage;
it is explicitly **not** a completed union-layout test.

Normal compiler matrix result: **KCC PDP-6 opt/noopt = 2 PASS**;
**GCC PDP-6 O0/O1/O2/Os = 4 run_fail**, with nonzero `fail_id`
checkpoints. These observations are compiler-regression evidence, not
permission to begin compiler repair during P1.

## Audited registrations and source ownership

The ten regular matrix executions are recorded in
`manifests/PDP10-P1-PREFETCH-WIDE-MATRIX-RESULTS-20261119-v1.tsv` and their
complete original compiler/guest logs in
`refs/pdp10-p1-prefetch-wide-pdp6-20261119-v1.tar.gz`.
The registered host verifier `tools/verify-p1-prefetch-wide-v1.py`
checks the original deferred status, matrix profile registrations,
source hashes, checksum-pinned evidence, and independently reconstructs
all five 71-bit multiplication expectations.

The complete source/companion mapping for the 14 historically
nonasserting deferred sources is
`manifests/PDP10-P1-NONASSERTING-COVERAGE-20261119-v1.tsv`:
**8 targeted** companion oracles, **6 partial**. It is checked by the
existing deferred-baseline verifier, including whether each companion
actually has a source-pinned entry in a recorded compiler-matrix
execution. Having some independent companion coverage is **not** the
same as closing the original deferred classification. In particular,
`960416-1.c` still requires an independent union/71-bit overlay ABI
oracle, and several GNU prefetch original syntax/address families
require complete policy review.
