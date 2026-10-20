# PDP-6 native floating-point: next steps (2026-10-20, v1)

**Investigation update:** The DEC EMNF drawing was obtained, and the
NRT computation for case 9 was independently reconstructed and matched
to AAP at all eleven checkpoints. See
`docs/PDP6-FP-NRT-HARDWARE-RESULT-20261020-v1.md`. The original plan
below is retained as a historical baseline; its missing-drawing premise
no longer applies. The case-9 FAT entry and NRT transition verification
now pass. The isolated SIMH PDP-6 fidelity investigation remains open.

## Verified baseline

- SIMH PDP-6 negative exact-halfway FADR/FSBR rounding is repaired in
  `sims` commit `2e6612e`; the old two-case regression is enabled.
- Corrected SIMH passes all 24 arithmetic boundary cases in
  `tests/semantic/kcc-pdp6-rounded-fp-boundaries-v2.c` under both KCC modes.
- Independent AAP PDP-6 passes the **eight** negative-halfway cases in
  `tests/semantic/kcc-pdp6-negative-halfway-aap-v3.c` under both modes,
  alongside the established toolchain guest suites.
- PDP-6 native FP behavior must not be assumed equivalent to later PDP-10 CPUs.

## Remaining work, in priority order

1. **Resolve the AAP normalization discrepancy.** For the exact operation
   `-134217728.0F + 1.0F`, AAP produces `0544000000003`, whereas
   corrected SIMH and an independent exact-result calculation produce
   `0544000000001`. Check the original DEC 166 CPU drawings, specifically
   FAT/NRT microoperations, against `pdp6/emu/apr.c`. Stanford SAIL
   `10TO6.TED`, floating-point notes 5–6, warns of PDP-6
   normalization differences. Do not label AAP incorrect before
   establishing the original hardware behavior.
2. **Preserve the failure oracle.** Keep the full 24-case AAP diagnostic
   `misc/validation/test-aap-pdp6-rounded-fp-v2.py` manual and failing
   until item 1 is resolved. Do not suppress failures or substitute
   expected values for actual guest results.
3. **After hardware-level resolution**, correct the responsible
   implementation (if necessary), rerun all 24 cases on both emulators
   and both KCC modes, plus the D-format/native-float, KPCODE2 and
   inventory regressions. Only then promote full AAP acceptance.
4. **Maintain CPU separation.** Examine KA10/KI10/KS10/KL10 floating
   rounding, overflow and underflow separately; do not transfer
   PDP-6 fixes or expected values without model-specific evidence.

This file records next steps, not an implemented AAP correction.
