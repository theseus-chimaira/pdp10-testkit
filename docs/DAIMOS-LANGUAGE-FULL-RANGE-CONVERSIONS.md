# DAIMOS full-range integer conversions v1

## Selected semantics

Signed 36-to-71-bit widening sign-extends the high word and preserves the
complete low source word, including its duplicated sign position. Unsigned
36-to-71-bit widening transfers the source high bit into the upper word and
keeps the remaining 35 bits in the low word. Narrow 6-, 7-, 8-, 9-, and
18-bit values first undergo the ordinary 36-bit integer promotion.

KCC previously cleared the low-word sign position during signed widening;
the correction preserves the low word and normalizes constant materialization.

DAIMOS conversions retain the low destination-width bits.  Unsigned results
use modulo arithmetic.  Signed results interpret the retained bits as a
PDP-10 two's-complement word.

For a normalized 71-bit value, a 36-bit result is not merely the stored low
word.  The low word contains 35 independent value bits; result bit 35 comes
from bit 0 of the high word.

## Portable interface

`support/common/daimos-wide-convert.h` provides:

- `daimos_u36_to_u71`;
- `daimos_u71_to_u36`;
- `daimos_i71_to_i36`.

These helpers use ordinary shifts, masks, and additions.  They require no new
PDP-6 instruction, arithmetic mode, or runtime library entry point.

## Compiler status

KCC now reconstructs the full 36-bit result for direct casts from its
normalized 71-bit type.

PDP-10 GCC still folds some direct full-range casts as raw low-word moves and
also folds some unsigned 36-to-71 constants incorrectly.  Until its generic
conversion lowering is corrected, DAIMOS public code must use the helper
interface for values that may have bit 35 set.

Direct casts remain valid for the already verified representable subset.
