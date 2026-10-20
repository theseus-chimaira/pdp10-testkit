# PDP-6 FP original-drawing verification: evidence update v2

## Result

**Unresolved.** The accessible DEC original floating add/subtract flowchart
confirms the FAT control-flow family; it does **not** provide enough evidence
to decide whether AAP's `0544000000003` or the exact oracle/SIMH's
`0544000000001` is the original 166 CPU result for
`-134217728.0F + 1.0F`.

The original flowchart was retrieved from the Computer History Museum:

`https://archive.computerhistory.org/resources/access/text/2023/04/102748654-05-1660fdas-acc.pdf`

It shows FAT0 through FAT10 and the NORMALIZE RETURN call.  The AAP
implementation in `pdp6/emu/apr.c` likewise routes FAT10 into NRT0.5 and
implements NRT0..NRT6 as a separate pulse sequence, citing drawing 6-27.
The scanned floating-add sheet does not show the gates controlling the
NRT left-shift loop or rounding increment.  Treat matching state names and
high-level arrows as **partial corroboration**, not gate-level proof.

## Exact still-unverified signals

* 6-27's condition equivalent to `AR_EQ_FP_HALF` and `AR9_EQ_AR0` at NRT1.
* 6-27's condition equivalent to `NR_ROUND` at NRT3/NRT5.
* Which low AR/MQ bits survive right alignment and the subsequent NRT2
  left shifts for the exact counterexample.
* Whether the hardware adds one at NRT5 before or after a potential
  additional normalization pass and exponent insertion.

The last two low-bit values of the result must be derived from *these*
conditions, not from a mathematically rounded PDP-10 model alone.

## Preservation and next action

Leave `pdp6/emu/apr.c`, SIMH and the existing 24-case expected values
unchanged. The full AAP diagnostic remains manual, while the independent
eight-case negative-halfway acceptance remains enabled. Obtain a readable
copy of original DEC CPU sheet 6-27 with revision metadata, then capture
the FAT/NRT registers and pulse path of the failing guest and compare every
decision with the drawing. Only a demonstrated discrepancy justifies an
emulator change.

This document records a *partial hardware comparison*, not a resolution.
