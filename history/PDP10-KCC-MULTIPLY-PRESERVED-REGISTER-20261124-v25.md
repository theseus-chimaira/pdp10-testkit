# KCC 71-bit multiply clobbered preserved pointer repair v25

Date: 2026-11-24

## Original failure and reduction

`tests/todo/generic/20001203-2.c` had 11 optimized KCC timeouts
and 11 unoptimized PASS cells. The source constructs an array type
using `element_type->length * (high_bound - low_bound + 1)` with
`long long` range bounds, followed by writes through its live result
pointer. At the old optimized code, a diagnostic guest reached its
post-multiplication point (`length=12`) but never returned to main.
Replacing the wide multiplication with constant 12 allowed the old
compiler to pass, while preserving the multiplication reproduced
the error even with reduced field logic.

## Root cause

PDP-10 `MUL r,operand` writes a two-word product into AC `r` and
AC `r+1`. KCC's scratch allocator asked `rfree()` whether a register
had a currently assigned expression VREG; it could choose AC10
although AC10 was a callee-preserved `register` variable holding
`result_type`. The old generated 71-bit multiplication selected
`MUL 7,6`, overwriting AC7/AC10, then later stored the result
through the clobbered AC10 pointer and entered invalid control flow.
AC10 was not actually free; it was merely invisible to the VREG list.

## Compiler correction

`ccgen2.c:gdimode_try_ac` and `gdimode_try_pair` now allocate only
the configured volatile expression AC range (normally AC1..AC7)
and honor `fnargkeepmask`. `gdimodemul` reserves its adjacent
two-register product pair **before** selecting the one-register
cross-product scratch, avoiding fragmentation. If no legal product
pair exists with the current VREG layout, it uses the established
spill-and-reload path and repeats scratch allocation. It never
uses a callee-preserved register as an untracked scratch or adds
a new global/stack allocation on the common fast path.

The broad KCC regression sweep caught an important independent
constraint: the restoring 71-bit divider needs more than seven
scratch ACs. A first variant that restricted **all** wide arithmetic
to volatile AC1..AC7 produced 22 compiler ICE results in
`runtime-reduce-dimode-divmod-arbitrary.c`. That regression was
not accepted. The divider now uses a separate, bounded allocation
function which may use AC10..AC14, because the existing divider
explicitly saves and restores each preserved scratch register.
Raw comparisons and multiplication remain restricted to AC1..AC7.
Neither path can accidentally use KCC's reserved AC15/16.

With the separate divider register selection installed, the
**440/440** cells in the full 20-source KCC DImode/long-long
regression selection passed under strict exit policy, with no
skipped successes. These include all 22 KCC
`runtime-reduce-dimode-divmod-arbitrary.c` cells that had triggered
the earlier compile-time ICE. The verified checkpoint directory is
`workdir/pdp10-kcc-v25-arithmetic-verified`; the rejected allocator
variant is preserved separately for diagnosis.

After the final source rebuild, the four original/new KCC timeout
sources were rerun from scratch in
`workdir/pdp10-kcc-timeouts-v25-final`: **88/88 PASS** under strict
exit policy, no old greens skipped. Together, this is **528 fresh
KCC cells passing** across two independent isolated selections.
The installed compiler at `$HOME/cross/bin/kcc` has SHA256
`1045034ddd9cc98b61232366bbbe291d3d1f2d5d2b4e48d3f5cfce578927a64f`.
Pre-repair compiler executables remain backed up under
`$TMPDIR/pdp10-kcc-timeouts-v24/` and
`$TMPDIR/pdp10-kcc-timeouts-v25/`.

## Regression and verification

`tests/semantic/regression/pdp10-kcc-wide-multiply-preserved-ac-v25.c`
preserves the original register pressure and pointer lifetime while
reducing the unrelated obstack field handling. The previous
optimized KCC timed out on KI10; the repaired KCC passes on PDP-6,
KA10, KI10 and KS10. A simpler test which did not reproduce the
old failure was deliberately replaced by this red-old/green-new
regression, rather than accepted as sufficient evidence.

The original wide-multiply upstream source and both the new v24/v25
regressions were run with the actual installed KCC. All **88/88**
cells of the four-source isolated v25 acceptance test passed under
strict exit policy, with no old PASS records skipped. The historical
135-timeout snapshot now has no unresolved timeout cells among its
seven source families. This is not a full compiler-matrix PASS:
GCC's packed-argument field/ABI assertions remain independently
open after their timeouts were removed in v23.
