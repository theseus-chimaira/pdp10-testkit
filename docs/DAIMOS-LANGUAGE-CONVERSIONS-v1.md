# DAIMOS integer conversions v1

## Shared conversions

KCC and PDP-10 GCC use the following common language rules:

- signed 36-bit values convert to signed 71-bit values with sign extension;
- nonnegative 36-bit values through `0377777777777` convert identically to
  signed or unsigned 71-bit values;
- exact 6-, 7-, 8-, 9-, and 18-bit values convert to 71-bit values after the
  ordinary 36-bit promotion described by the language subset;
- 71-bit values representable in a 36-bit word convert back without changing
  their value.

These rules require no new arithmetic mode on a PDP-6.  KCC uses a two-word
pair and ordinary `MOVE`, `ASH`, and `LSH` operations.

## KCC correction

KCC previously cleared bit 0 of the low word while widening every 36-bit
value.  This changed negative signed values.  Signed widening now preserves
the complete low word and sign-extends the high word.  Constant materialization
also restores the low-word sign copy from the high word.

## Not yet common

The following remain outside the shared language subset:

- conversion of unsigned 36-bit values with bit 35 set to `uint71_t`;
- direct conversion from a 71-bit value to any exact-width narrow type;
- out-of-range conversion from a 71-bit value to a 36-bit signed or unsigned
  word.

KCC and GCC currently disagree in these cases.  Public DAIMOS code must use
explicit checked or modulo helper functions until their semantics are selected
and implemented consistently.
