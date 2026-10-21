# PDP-6 Type 166 AAP normalization trace, v1

**Captured evidence (2026-10-20); case-9 diagnosis completed 2026-10-21.**
The independent DEC FDAS/EMNF calculation subsequently matched the FAT
entry and all eleven NRT checkpoints recorded below. Corrected SIMH
and AAP now pass the separate hardware case-9 regression. The original
manual 24-case mathematical diagnostic remains deliberately unchanged.
See `docs/PDP6-FP-SIMH-FIDELITY-20261021-v1.md`.

## Reproduction

Run the manual 24-case diagnostic with the original AAP emulator, now
enabling its *existing* `-t -d` pulse trace through a testkit-only opt-in:

```
PDP6_AAP_TRACE_ROUNDED_V1=1 python3 misc/validation/test-aap-pdp6-rounded-fp-v2.py
```

The optimized guest fails the existing full mathematical oracle, as
expected. The opt-in preserves the emulator's trace at
`$TMPDIR/p10tk-aap-rounded-trace-opt-v1.log` (856 KB in this run).
Normal acceptance testing remains untraced; neither emulator source nor
the expected arithmetic words have been changed.

## Observed final floating operation (octal)

The final FAT/NRT sequence in the trace, immediately before the guest
stores the known discrepant value, includes:

| Pulse | AR | MQ | SC |
| --- | --- | --- | --- |
| FAT10 / NRT0.5 | `777400000000` | `200000000000` | `234` |
| NRT0 | `777600000000` | `500000000000` | `235` |
| NRT1 | `777600000000` | `500000000000` | `542` |
| NRT2 | `777400000000` | `600000000000` | `543` |
| NRT3 | `777400000000` | `600000000000` | `234` |
| NRT5 (AR + 1) | `777400000001` | `600000000000` | `234` |
| NRT5A -> NRT0.5 | `777400000001` | `600000000000` | `234` |
| NRT0 (second pass) | `777600000000` | `700000000000` | `235` |
| NRT1 | `777600000000` | `700000000000` | `542` |
| NRT2 | `777400000001` | `600000000000` | `543` |
| NRT2 (again) | `777000000003` | `400000000000` | `544` |
| NRT3 | `777000000003` | `400000000000` | `544` |
| NRT4 / NRT6 | `544000000003` | `400000000000` | `544` |

The trace shows `...003` derived by the second-pass left shift of an AR
value already incremented by NRT5. The original DEC EMNF drawing also
shows an NRT5A normalization-feedback path. This trace **alone** did not
prove the branch conditions and source bit transfers; the subsequent
independent DEC FDAS/EMNF reconstruction supplied that case-9 check.

## Original next questions (subsequently resolved for case 9)

1. Verify the NRT5A return condition and the second-pass NRT1/NRT2
   decisions against the right-hand side of `FD-D-166-0-EMNF`.
2. Trace the FAT alignment bit transfers, not just the NRT result.
3. Compare NRT2 AR/MQ low-bit interconnects with the full DEC datapath
   drawings, particularly the shift-routing pages cited by AAP.
4. Do not change AAP, SIMH or the manual failing 24-case oracle until a
   concrete divergence from original hardware has been identified.
