# KCC signed 71-bit to D-format conversion investigation (2026-10-19)

**Historical investigation snapshot.** The blocker documented below was
resolved and verified on PDP-6 on 2026-10-20. See the completed
`KCC-PDP6-SOFTWARE-DFORMAT-20261020-v1.md`; the earlier failed approaches
and observations are retained as the investigation record.

## Current acceptance state

The unmodified upstream `tests/todo/generic/930622-2.c` is still deferred.
Installed and original source-built KCC both fail in `vrwiden` with:

```
[FATAL] vrwiden: reg already wide
```

The crash occurs at the return of a `long long` as `long double`, both
with and without KCC optimization. The target's integral DImode is a
71-bit value held in a high36:low35 register pair. The pre-existing
`CAST_IT_FP` path treats it as a 36-bit scalar and calls `vrlowiden`
on an already paired register. The reverse `CAST_FP_IT` path does
not construct a full signed 71-bit result either.

For future acceptance, a manual exact upstream-source test is registered
as `kcc-71bit-floatcast-v1`. It must compile, link to the real runtime,
and execute with `__test_exit=0` under both KCC profiles. A compiler
fatal or a timeout is a failed acceptance gate, never an expected pass.

## Confirmed independent bugs repaired

Two focused regressions passed using a newly rebuilt KCC at both
optimized and unoptimized settings, on SIMH PDP-6:

1. `kcc-dimode-local-load-v1.c`: a signed `long long` automatic
   reloaded directly with `DMOVE` retained the low continuation word's
   duplicated sign bit, contrary to the internal high36:low35 register
   representation. A `TLZ` normalization after this load fixes negative
   DImode comparisons without additional stack data.
2. `kcc-dformat-negative-v1.c`: on PDP-6, the emulation of D-format
   `DMOVN` negated each 36-bit word independently. It now propagates
   the 35-bit low fraction borrow into the high word and restores the
   replicated continuation sign bit. The test checks both directions
   of double negation and the two sign bits.

These are legitimate compiler code-generation fixes regardless of whether
the wider integer/floating conversion feature is implemented.

## Rejected helper implementation experiment

A provisional KCC calling sequence passed the original small positive
`10LL` case after calling existing libgcc `__floatdidf` and
`__fixdfdi` using the shared AC1:AC2 ABI. A signed `-1LL`
regression exposed two additional problems: the PDP-6 D-format negation
bug above, and libgcc's generic 36-bit unsigned-to-double conversion
losing significant bits for negative DImode low words.

A second experiment converted unsigned 18-bit limbs of the absolute
integer magnitude before applying the sign. It passed an isolated
negative-value case after fixing the KCC negation, but the wider
17-case round-trip boundary suite did not complete inside the 32-second
SIMH timeout. The smaller early attempt also failed negative values.
Full-range correctness, speed, and worst-case stack usage are therefore
not established. Keeping the 71-bit cast automatically dependent on
these expensive libgcc operations would be inappropriate for the PDP-6.

Both unaccepted compiler-source experiments were reverted. Their
diagnostic diffs were preserved under versioned `$TMPDIR` filenames.
The installed libgcc archive was restored byte-for-byte to the original.
The original upstream source remains unchanged and deferred; no generated
stub, unverified built-in, or altered expected result was used.

## Next compiler work

Implement a real signed 71-bit/D-format conversion designed for the
PDP-6 and the 62-bit D-format mantissa. Investigate directly composing
and decoding exponent and fraction using native integer instructions and
a precisely specified rounding policy. Any assembler helper must have
bounded stack/RAM requirements and be linked as its own archive member.
Validate zero, positive/negative small numbers, both 36-bit boundaries,
exact powers of two, representable 62-bit values, precision-loss/rounding
boundaries, and signed minimum/maximum behavior. Round trip only values
that are exactly representable, and independently check others against
correctly rounded target expectations.

Once those checks pass with both compiler optimization profiles, activate
the original upstream test and change its deferred disposition.
