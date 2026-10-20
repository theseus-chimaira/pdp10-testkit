# KCC target-precision single-float constant folding (2026-10-20, v1)

## Correctness problem

The hosted KCC evaluator had used IEEE binary32 (`float`, 24 significant
bits) to fold `TS_FLOAT` expressions. A PDP-10 36-bit single floating value
has 27 significant bits. Arithmetic, comparisons, integer/floating casts
and reassociation could therefore erase three representable fraction bits.

## Compiler implementation

The host compiler retains the 27-bit target values in host `double` and
rounds explicitly at target operations. A wider `long double` preserves
guard/sticky information for arithmetic; hosts without sufficient
intermediate precision leave the arithmetic expression to target code
rather than fold it incorrectly. The source evaluation order is retained:
floating addition/multiplication cannot be reassociated across a variable.

Target-precision arithmetic, literal-word encoding and host-word decoding
reside in `ccoututil.c`, linked by KPARSE, KGEN, KOPT and the integrated
compiler. No target runtime storage or additional stack space is needed.

PDP-6 rounded floating arithmetic differs from casts and literals. The
independent AAP PDP-6 model rounds positive halfway FADR/FSBR arithmetic
upward and negative halfway arithmetic toward zero. The compiler applies
this mode only on the PDP-6 target; the other PDP-10 processors have not
been validated by these tests. Cast/literal rounding remains nearest-even.

### Phase transport: KPCODE2

Hosted `PCODE.Pfloatword` now holds the final, exact 36-bit target float
word rather than an IEEE binary32 value. KGEN and KOPT use `KPCODE2`,
whose new magic/version deliberately rejects old `KPCODE1` intermediates.
The existing PCODE union field is reused, without target RAM growth.
The regression verifies that `0234400000002` survives a full stream
round-trip; this corresponds to a value whose low three target fraction
bits would otherwise be vulnerable to host IEEE float narrowing.

## Verified regressions

- `misc/validation/test-kcc-pdp6-float-fold-v1.sh`: 20 static
  arithmetic/cast cases, folded comparisons, source-order-sensitive
  addition and positive halfway runtime agreement; PASS with KCC
  optimized and `-n` on SIMH PDP-6
- `misc/validation/test-kcc-aap-dimode-float-pdp6-v1.py`: the same
  target-precision folding guest passes independently on AAP PDP-6
  in both modes, together with previous D-format, native-float, literal
  and unchanged upstream guests; the immediate-HALT negative control
  continues to be rejected
- `misc/kcc-regression/kcc-kpcode-format-20261006.sh`: KPCODE2
  serialization and version rejection PASS
- `misc/kcc-regression/kcc-kpcode2-float-phase-v1.sh`: the complete
  KCPP/KPARSE/KGEN/KOPT pipeline retains the exact 27-bit float
  constant word and the linked guest **executes successfully on PDP-6**
  in both optimized and unoptimized modes. This validates real phase
  transport rather than only a synthetic record roundtrip.

The complete 27-unit phase byte-identity sweep now **passes** in its
applicable profiles. DAIMOS KGEN had a 64-entry peephole ring while
DAIMOS integrated KCC/KCC1 used 256; once the code generator had
produced 64 pseudo-instructions, the allocator consulted different
recent-instruction histories and selected different ACs. Unifying the
DAIMOS rings at 64 entries in `ccparm.h` eliminated the `-n`
differences, including the original `cccse.c` reproducer, and saved
192 PCODE slots in backends formerly configured for 256. The enabled
`misc/kcc-regression/kcc-phase-byte-identity-20261006.sh` verifies
strict integrated/KCC1 identity in both modes and strict KIR1/KGEN
identity at `-n`. Optimized KPARSE deliberately runs an extra
`bindopt` pass, so optimized KIR1 output is *not* required to be
byte-identical; KPCODE2 end-to-end float execution passes separately.

## PDP-6 negative halfway rounding: SIMH repair and independent AAP

The original SIMH PDP-6 returned `0544000000001` for the operation
`-134217728.0F + -1.0F`. AAP returned `0543400000000`. Historical
Stanford SAIL `10TO6.TED` (1973, *Floating Point Instructions* point 5)
explicitly specifies that PDP-6 negative *exact halfway* rounded
arithmetic moves toward zero, unlike later PDP-10 processors:
https://www.saildart.org/10TO6.TED%5BH%2CDOC%5D

SIMH's PDP-6 path previously added an entire `FPRBIT1` at this exact
negative halfway boundary. The traced sign-extended two's-complement
fraction was `1677777777700000000000` (octal), whose discarded field
equaled `FPRBIT2`. Adding the full unit crossed a normalization boundary
and produced a result on the wrong side of the halfway tie. The PDP-6
path now adds the *half-unit* `FPRBIT2` only for negative exact ties;
all other cases retain the previous rounding logic, including the
distinct later-PDP-10 path. The original two-case regression now passes,
and the corrected SIMH passes 24 boundary cases in both KCC modes.
Eight negative halfway cases independently pass AAP in both modes.

## Separate AAP hardware-fidelity question: exact result at exponent edge

**AAP has not been modified and is not declared incorrect.** In the full
24-case expanded experiment, cases 1–8 passed on AAP. Case 9 was the
first discrepancy:

| Expression | Mathematically exact normalized word | AAP observed word |
| --- | --- | --- |
| `-134217728.0F + 1.0F` | `0544000000001` | `0544000000003` |

Direct AAP memory inspection confirmed operand words
`0543400000000` and `0201400000000`, case index `011` (octal),
and output word `0544000000003`; this was not inferred from a timeout.
The SIMH candidate produces the mathematically expected `0544000000001`.

The **same primary source**, `10TO6.TED` point 6, warns that the PDP-6
can lose bits in floating add/subtract/multiply when significant information
resides only in the low word before normalization. The PDP-6 arithmetic
is not guaranteed to agree with a correctly rounded mathematical result.
We have not established whether that specific hardware condition occurs
in case 9, nor verified the precise result from an original 166 CPU
logic drawing or physical PDP-6. AAP implements the actual PDP-6
normalization/rounding microsequences (`emu/apr.c`: `fat*`, `nrt*`,
including `NR_ROUND`, `AR_EQ_FP_HALF` and `SC_COM`). These are
evidence worth preserving, **not grounds for a speculative AAP patch**.

The testkit separately records the full 24-case AAP run as the **manual
known-disagreement** test `misc/validation/test-aap-pdp6-rounded-fp-v2.py`.
It deliberately fails against the mathematical oracle on AAP case 9;
the normal AAP acceptance suite includes only the eight independently
cross-verified negative-halfway cases. Do not label AAP faulty or write
an AAP correction without a pulse-level comparison to primary DEC
166 CPU drawings and verified physical behavior.

Later PDP-10 floating modes, AAP's exact-result edge, and broader
underflow/overflow cases remain outside the validated scope.
