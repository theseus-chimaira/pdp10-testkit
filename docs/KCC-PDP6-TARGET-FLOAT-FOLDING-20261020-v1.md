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

## Independently reproducible SIMH/AAP discrepancy

For native PDP-6 negative halfway FADR/FSBR, the AAP model returns
`0543400000000`, while installed SIMH PDP-6 returns `0544000000001`.
The old compiler rounding heuristic yielded `0543377777777`; it was
corrected against the independent AAP result. This does *not* repair the
SIMH runtime disagreement, which remains a manual, genuinely failing
regression at
`misc/validation/test-kcc-pdp6-negative-fp-runtime-v1.sh`.

Reconcile PDP-6 hardware rounding against primary hardware documentation
before promoting this runtime test or claiming negative-FP execution
equivalence. Later PDP-10 floating modes and edge underflow/overflow
cases remain explicitly outside the verified scope.
