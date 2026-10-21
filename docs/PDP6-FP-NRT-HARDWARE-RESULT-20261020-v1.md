# DEC Type 166 FP case 9: independently reconstructed NRT result (v1)

**Verification status updated 2026-10-21:** The hardware-specific case-9
oracle now passes on both AAP and corrected SIMH (`sims` commit `828459c`)
under both KCC optimization modes. The mathematical 24-case diagnostic
remains unchanged and manual, and the other 23 cases are not yet
hardware-characterized. The measurements and derivation below are
preserved as originally recorded. Current acceptance details:
`docs/PDP6-FP-SIMH-FIDELITY-20261021-v1.md`.

## Evidence and scope

The original DEC schematic `FD-D-166-0-EMNF`, available as
`refs/hardware/dec166-emnf-normalize-return-v1.pdf`, contains the
NORMALIZE RETURN flowchart.  The original floating-add/subtract sheet
is archived by the Computer History Museum at
`https://archive.computerhistory.org/resources/access/text/2023/04/102748654-05-1660fdas-acc.pdf`.

AAP's unmodified `-t` diagnostic for `-134217728.0F + 1.0F` reaches
FAT10/NRT0.5 with (octal) AR `777400000000`, MQ `200000000000`,
and SC `234`. Its original operand words were AR `543400000000`
and MB `201400000000`. This report checks **both the original FDAS
FAT alignment and the EMNF normalization** for these operands. The
other 23 cases and other instruction paths remain separate work.

## Independent normalization reconstruction

The testkit's `misc/validation/analyze-aap-pdp6-emnf-case9-v1.py`
implements the DEC FDAS alignment for the two raw 36-bit operand words,
followed by the EMNF NRT arithmetic/shift rules and branch predicates,
without importing AAP or SIMH code. It checks the reconstructed output
and optionally matches the FAT entry and eleven NRT checkpoints against
an actual AAP `-t` log.

The FDAS path selects the smaller positive operand, strips its exponent,
and right-shifts the fraction **27 times** through AR into MQ. It then
adds the large negative operand's sign-extended mantissa, producing
AR `777400000000`, MQ `200000000000`, SC `234`. These are the observed
FAT10 entry values and serve as an independent NRT starting state.

```
python3 misc/validation/analyze-aap-pdp6-emnf-case9-v1.py
python3 misc/validation/analyze-aap-pdp6-emnf-case9-v1.py \
    "$TMPDIR/p10tk-aap-rounded-trace-opt-v1.log"
```

Both commands passed on 2026-10-20. The second checked the FAT entry and
all eleven state transitions, not only the final word.
As a negative control, changing the recorded final NRT2 AR low bits from
`003` to `001` caused the analyzer to fail at checkpoint 8, confirming
that the trace comparison detects the disputed low-bit difference.

| DEC stage | AR | MQ | SC |
| --- | --- | --- | --- |
| FAT10 entry | `777400000000` | `200000000000` | `234` |
| NRT0, right shift | `777600000000` | `500000000000` | `235` |
| NRT2, left shift | `777400000000` | `600000000000` | `543` |
| NRT3, complement SC | `777400000000` | `600000000000` | `234` |
| NRT5, AR+1 | `777400000001` | `600000000000` | `234` |
| NRT5A, set NRF3 | `777400000001` | `600000000000` | `234` |
| Next NRT0, right shift | `777600000000` | `700000000000` | `235` |
| Next NRT2, first left shift | `777400000001` | `600000000000` | `543` |
| Next NRT2, second left shift | `777000000003` | `400000000000` | `544` |
| NRT4 exponent insertion | `544000000003` | `400000000000` | `544` |

The two critical effects are that NRT5A repeats normalization **after**
NRT5 adds one to AR, and that NRT2 shifts MQ bit 1 into AR bit 35.
The repeat pass performs two left shifts and consequently leaves low
bits `003`, not `001`. The original EMNF flowchart shows both actions.

## Interpretation and follow-up

For the recorded operand words, the DEC FDAS/EMNF flow predicts
`0544000000003`, exactly matching AAP. The **earlier SIMH implementation**
produced the mathematically rounded `0544000000001`; corrected SIMH
now matches the hardware result. This is primary-source evidence for
the correction of the PDP-6-specific floating model in this case;
it is **not** evidence that all AAP
arithmetic is correct or that every physical 166 CPU revision behaves
identically.

Preserve the manual failing 24-case mathematical diagnostic unchanged.
Do not replace all its expected words with AAP output. The separate
case-9 hardware oracle and isolated SIMH PDP-6 correction are now
implemented and validated, without modifying the KA/KI/KL/KS paths.
The focused compatibility suites passed in both KCC modes. The remaining
work is to derive independent hardware expectations for the other 23
cases and test later CPU implementations separately.
