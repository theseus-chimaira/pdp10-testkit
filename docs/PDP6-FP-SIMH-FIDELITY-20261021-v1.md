# PDP-6 Type 166 FADR/FSBR hardware fidelity (2026-10-21, v1)

## Primary evidence

The recovered DEC 166 FDAS and EMNF drawings establish 36-bit AR/MQ
alignment, normalization and NRT5/NRT5A renormalization. See
`docs/PDP6-FP-NRT-HARDWARE-RESULT-20261020-v1.md` for the independently
derived case-9 register sequence and original source references.

## Separated acceptance and diagnostic oracles

The hardware-specific guest
`tests/semantic/kcc-pdp6-fp-hardware-case9-v1.c` checks only
`-134217728.0F + 1.0F` and expects octal `0544000000003`.
Its script runs under KCC optimized and unoptimized modes, with either
the installed PDP-6 simulator or `SIMH_PDP6=/path/to/candidate`.
The same guest runs independently on AAP through the existing suite.

The original 24-case test
`tests/semantic/kcc-pdp6-rounded-fp-boundaries-v2.c` is **unchanged**:
it retains its independently calculated mathematical values, including
`0544000000001` at case 9. It is now registered **manual**, not
marked as a passing PDP-6 hardware acceptance. The existing AAP full
24-case diagnostic remains manual as well. No expected values are
silently replaced and no failing case is classified as a pass.

## Corrected SIMH model

`sims/PDP10/kx10_cpu.c`, PDP6-only rounded add/subtract, implements
the physical 36-bit AR/MQ shifts, including a critical MQ0 right-shift
mask: the prior MQ0 must **not** flow into MQ1. NRT2 shifts MQ1 into
AR35, NRT5 increments AR once, and NRT5A repeats normalization with
rounding disabled. After DEC NRT4 inserts the exponent, generic
SIMH exponent packing must be bypassed to avoid encoding it twice.

The corrected implementation is committed in `sims` as `828459c`.
Completed checks:

| Check | Result |
| --- | --- |
| SIMH hardware case 9, both modes | PASS |
| AAP hardware case 9, both modes | PASS |
| SIMH negative FP runtime, both modes | PASS |
| Original mathematical 24-case SIMH test | Disagrees at case 9, as expected |
| SIMH native-float and software D-format, both modes | PASS |
| SIMH floating literals and constant folding, both modes | PASS |
| KPCODE2 four-phase float guest, both modes | PASS |
| AAP independent accepted guest suite, both modes | PASS |
| Testkit inventory and deferred-disposition audits | PASS |

The original 24-case mathematical suite is not a hardware acceptance
criterion. It was checked on the candidate and failed at the expected
case 9 (octal test index `011`), while the independent DEC case-9
hardware guest and earlier negative-halfway regression passed.
Full 24-case hardware characterization and later PDP-10 processor
verification remain separate work.

## Installed simulator verification

After rebuilding with Git identity `828459c`, the corrected SIMH PDP-6
binary was installed under `$PDP10_PREFIX/bin/pdp6`. The previous binary
was preserved as `$PDP10_PREFIX/bin/pdp6-pre-emnf-20261021-v1`.
The installed binary and committed build have identical SHA-256 hashes.
The hardware case-9 and negative FP runtime suites were rerun using the
installed simulator with `SIMH_PDP6` unset: both optimization modes
passed, as did the testkit inventory audit.
