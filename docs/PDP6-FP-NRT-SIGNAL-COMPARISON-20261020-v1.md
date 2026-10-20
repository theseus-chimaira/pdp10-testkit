# PDP-6 Type 166 NORMALIZE RETURN: drawing-to-AAP audit (v1)

## Evidence

Primary DEC drawing `FD-D-166-0-EMNF`, page 12 of the 80-page schematic
set, retained as `refs/hardware/dec166-emnf-normalize-return-v1.pdf`.
The relevant emulator implementation is `pdp6/emu/apr.c`.

## Control path

| DEC operation | AAP implementation | Assessment |
| --- | --- | --- |
| FAT10 enters NRT0.5 | `fat10` -> `nrt0_5` | Control edge agrees |
| NRT0.5 sets NRF2 | `nrt0_5` | Action agrees |
| NRT0: SC+1; AR and MQ shift right | `nrt0` | Action agrees; shift bits unverified |
| Zero AR and MQ1 test | `AR_0_AND_MQ1_0` | Boolean interpretation agrees |
| NRT1: SC complement | `nrt1` | Action agrees |
| AR=FP HALF or AR9 differs from AR0 | `AR_EQ_FP_HALF || !AR9_EQ_AR0` | Branch appears to agree |
| NRT2: SC+1; AR and MQ shift left | `nrt2` | Action agrees; cross-register bits unverified |
| NRT3: overflow and conditional SC complement | `nrt3` | Action agrees; polarities still to prove |
| Rounding enabled, MQ1 set, NRF3 clear | `NR_ROUND` | Condition appears to agree |
| NRT4: insert SC exponent | `nrt4` | Action agrees |
| NRT5: set NRF1, increment AR | `nrt5` | Action agrees; datapath needs trace |
| NRT5A: clear NRF1, set NRF3, repeat | `nrt5a` | Control edge agrees |
| NRT6: return | `nrt6` | Functional match; AAP delay unverified |

This is a visual control-flow comparison, **not** bit-level verification.
The DEC drawing's identifier is `FD-D-166-0-EMNF`; `6-27` is the
cross-reference in AAP's annotated source.

## Decisive experiment

Trace the unchanged AAP's failing operation
`-134217728.0F + 1.0F`, recording pulse name and AR, MQ, MB, SC,
instruction bits, NRF1/2/3 and FAF1-4 before and after FAT/NRT pulses.
Inspect FAT alignment first, then NRT2 cross-register shift and NRT5
increment/reentry. The existing emulator already supports `-t` pulse and
AR/MQ/MB/SC tracing; this should be tried before adding instrumentation.
Its default tracing is off. The normal testkit acceptance paths must not
enable large traces by default.

The AAP result `0544000000003` and mathematical/SIMH result
`0544000000001` remain unresolved. Neither emulator nor the 24-case
manual diagnostic is changed by this audit.
