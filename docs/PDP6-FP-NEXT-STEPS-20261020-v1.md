# PDP-6 native floating-point: next steps (2026-10-20, v1)

**Historical plan, superseded for case 9 on 2026-10-21.** The DEC FDAS
and EMNF drawings were recovered; an independent calculation matched the
AAP FAT entry and all eleven NRT checkpoints. SIMH's PDP-6-only AR/MQ
hardware correction is committed as `828459c`. AAP and corrected SIMH
both pass the separate hardware case-9 guest in both KCC modes.
The original 24-case **mathematical** diagnostic remains unchanged and
manual; the other 23 cases and later CPU families need separate hardware
validation. The original plan and pre-correction results below are
retained as history, not current unresolved work. See
`docs/PDP6-FP-SIMH-FIDELITY-20261021-v1.md` for current status.

## Verified baseline before the Type 166 correction (historical)

- SIMH PDP-6 negative exact-halfway FADR/FSBR rounding is repaired in
  `sims` commit `2e6612e`; the old two-case regression is enabled.
- Corrected SIMH passes all 24 arithmetic boundary cases in
  `tests/semantic/kcc-pdp6-rounded-fp-boundaries-v2.c` under both KCC modes.
- Independent AAP PDP-6 passes the **eight** negative-halfway cases in
  `tests/semantic/kcc-pdp6-negative-halfway-aap-v3.c` under both modes,
  alongside the established toolchain guest suites.
- PDP-6 native FP behavior must not be assumed equivalent to later PDP-10 CPUs.

## Original investigation plan (completed for case 9; historical)

1. **Resolve the AAP normalization discrepancy.** For the exact operation
   `-134217728.0F + 1.0F`, AAP produces `0544000000003`, whereas
   the then-corrected SIMH (`2e6612e`) and a mathematical calculation produced
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

This file records the original investigation plan, not the present
hardware acceptance status. No AAP arithmetic correction was needed for
case 9; the SIMH PDP-6 path was corrected in `828459c`.
