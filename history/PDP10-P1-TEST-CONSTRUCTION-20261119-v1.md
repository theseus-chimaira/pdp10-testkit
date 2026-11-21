# PDP10 P1 test construction and oracle inventory (2026-11-19 v1)

This document records testkit construction, not a compiler repair cycle.
Independent ISA/ABI expectations, assertion reachability, test ownership,
and correct matrix execution come first. Benchmarks are deferred to P2/P3.

## Reproducible PDP-10 width-shift fixture

The original GCC `tests/semantic/upstream/extensions/20020108-1.c`
contains meaningful shift assertions guarded by CHAR_BIT equal to 8,
16 or 32, none of which execute on the actual PDP-10's 9-bit char.
A previous no-error result for this original is **not acceptance**.
The original C source remains unchanged and deferred.

`tools/generate-pdp10-width-shifts-v1.py` derives the results using
independent unbounded host integer arithmetic and pins the generated
`tests/semantic/regression/pdp10-width-shifts-v1.c` byte-for-byte.
The generated fixture tests 9-, 18- and 36-bit unsigned types, both
shift directions, across 63 shift counts (126 assertions), with a
volatile input and shift amount to prevent vacuous constant folding.
It is a normal compiler matrix source. Actual PDP-6 guest executions
passed all six tested profiles: KCC opt/noopt and GCC O0/O1/O2/Os.

These runs exposed the installed PDP10 GCC `limits.h` selecting its
8-bit generic branch because the active target defines uppercase
`__PDP10__`, not lowercase `__pdp10__`. This was fixed at the original
GCC source, `gcc/glimits.h`, in the independent `pdp10-gcc` commit
`5a625f4`, then installed under `$PDP10_PREFIX`, preserving the prior
header. No ad-hoc test-only header was introduced.

## CPU floating-point oracle construction is not compiler repair

`manifests/PDP10-FP-HARDWARE-ORACLES-20261119-v1.tsv` is the explicit
independence inventory for all 24 original boundary computations on
PDP-6, KA10, KI10, KS10 and KL10: 120 CPU/case pairs. **Only the
PDP-6 case-9** expectation is currently independently reconstructed
from DEC Type 166 FDAS/EMNF and its original pulse checkpoints. Its
hardware octal result `0544000000003` differs from the original
mathematical `0544000000001`. The other **119 are marked as requiring
independent hardware evidence**, not as successful tests.

`tools/verify-p1-fp-oracles-v1.py` verifies the original 24 values and
re-executes the independent DEC case-9 normalization model. It rejects
unjustified replacement of any hardware expectation. The other CPUs
must be characterized independently before the testkit treats their
observed simulator values as hardware truth. The earlier 24-case
mathematical diagnostic remains unchanged.

## Deferred source coverage

`tools/run-p1-deferred-evidence-v1.py` provides **bounded, opt-in**
source-SHA-pinned probes of the 67 canonical deferred sources through
the existing `tools/probe-deferred-libc-v1.py` and ordinary semantic
runner; it does not activate sources, add dummy libc functions or
convert compiler failures into passes. Its no-argument mode checks all
67 original bytes and is registered as a host-only verifier. Actual
source/profile evidence must receive an assertion-review disposition
before activation. The full 67-source GCC/KCC operational sweep is
**not complete** and must not be reported as such.

## Canonical compiler repair gates

The 16 historical canonical compiler gates are now ordinary matrix
sources; there is no parallel compiler-gate execution runner.
The 38 native PDP-6 cells were executed by the normal matrix, with
original source identities and unchanged expectations. See
`history/PDP10-COMPILER-GATES-MATRIX-20261119-v1.md` and its archived
cell logs. One gate, `20011113-1.c`, passes KCC PDP-6 opt/noopt with
verified assertion reachability; fifteen still have failing compiler
profiles. The compiler fixes remain deliberately deferred.

## Registered checks

The three new host verification entries confirm deferred-source SHA
provenance, hardware oracle independence, and exact generated shift
tables. The negative-mutant assertion-strength test is registered as
a *validation test* because its deliberately corrupted inputs are
expected to fail; the unchanged positive gate stays in the compiler
matrix. All 24 host verify entries passed, as did the registered
negative-mutant validation (six executions: two originals and four
intentionally failed mutants). The current inventory reports 2,212
matrix source rows, 263 special entries and 396 owned scripts.
