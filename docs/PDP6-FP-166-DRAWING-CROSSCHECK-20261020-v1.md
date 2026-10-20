# PDP-6 FP: 166 CPU drawing cross-check (2026-10-20, v1)

## Scope and evidence status

This is a trace map, not a finding that AAP is incorrect.  The mathematical
oracle for `-134217728.0F + 1.0F` is `0544000000001`; the AAP guest was
previously observed to produce `0544000000003`.  The original DEC drawing
set must decide whether this difference is an intended PDP-6 behavior.

The DEC 166 CPU engineering drawings are indexed at
`https://bitsavers.trailing-edge.com/pdf/dec/pdp6/166_CPU_Drawings/`.
An independently indexed archival scan of the DEC floating-point flowchart
is `https://archive.computerhistory.org/resources/access/text/2023/04/102748654-05-1660fdas-acc.pdf`.
Its FLOATING ADD/SUBTRACT flow includes FAT0 through FAT10, SC COM, SC PAD,
the AR/MB swap and the NORMALIZE RETURN transfer.  This establishes the
relevant drawing family but **does not yet establish the disputed bit result**.

## Emulator-to-drawing trace points

In `pdp6/emu/apr.c`, the comments identify DEC drawing locations:

| AAP step | Functional action | Drawing sheet cited in AAP |
| --- | --- | --- |
| `fat0` through `fat10` | Exponent alignment, add, normalization entry | 6-22 |
| `fat10` | Transfer to `nrt0_5` | 6-22 / 6-27 |
| `nrt0_5`, `nrt0` | Start normalization, shift right | 6-27 |
| `nrt01_dly`, `nrt1` | Zero test, complement scale | 6-27 |
| `nrt2`, `nrt1_dly` | Shift left, test sign/half conditions | 6-27 |
| `nrt3`, `nrt31_dly` | Scale and rounding decision | 6-27 |
| `nrt4`, `nrt5`, `nrt6` | Store exponent / round / return | 6-27 |

Three software predicates need a *signal-by-signal* comparison with 6-27:

* `AR_EQ_FP_HALF`: low AR fraction zero and AR bit 9 asserted;
* `AR9_EQ_AR0`: equality of AR bit 9 and AR sign bit;
* `NR_ROUND`: rounded opcode, MQ bit 1, and normalization flag NRF3 clear.

Additionally verify the implementation of `SC_COM`, `SC_INC`, and the
AR/MQ shift inserts against sheets 6-15, 6-16, 6-17, and 6-7.  The AAP
source contains a comment marking an artificial delay in `nrt6`;
its effect on result settling must not be presumed harmless or faulty.

## Required next experiment

1. Obtain readable originals of DEC sheets 6-22 and 6-27 (plus their
   referenced datapath drawings), recording edition/revision.
2. Record a single failing guest's AR, MQ, MB, SC, NRF1/2/3 and FAT/NR
   pulse transitions, including before and after each pulse.  Keep
   the AAP emulator source unchanged for the baseline run.
3. Compare every transition and conditional path to the corresponding DEC
   gates.  Derive the final two low bits from those transitions.
4. Only after a specific mismatch is demonstrated, modify the responsible
   emulator and rerun the manual 24-case diagnostic under both KCC modes,
   alongside the SIMH suite and established guest regressions.

The full 24-case AAP test remains manual and failing; do not weaken the
oracle, reinterpret `0544000000003` as a pass, or generalize these PDP-6
results to KA10/KI10/KS10/KL10.
