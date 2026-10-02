# DAIMOS raw 72-bit extension ABI v1

`raw72_t` and `uraw72_t` denote a flat pair of 36-bit words.  All 72 bits are
value bits for unsigned operations; signed operations use flat 72-bit two's
complement.  The high word is stored first.

This representation is distinct from normalized `int71_t`/`uint71_t` and uses
separately named helpers (`raw72_*`).  Public mixed-compiler interfaces must
not pass a raw 72-bit value as `long long`.

GCC programs compiled wholly with `-mlong-long-72bit` may use `int72_t` and
`uint72_t` as native `long long` aliases.  In 71-bit GCC mode and in KCC,
those names resolve to the two-word aggregate adapter.  DAIMOS remains built
with `-mlong-long-71bit`.

## Complete adapter operation set

The portable aggregate ABI provides modulo-2^72 add, subtract, negate,
bitwise operations, logical shifts, multiplication, and unsigned comparison.
`raw72_udivmod` and `raw72_sdivmod` return zero on success and `-1` for a zero
divisor.  Signed quotient truncates toward zero and signed remainder has the
sign of the dividend.

`raw72_from_int71_words` sign-extends a normalized 71-bit word pair into flat
72-bit two's complement.  `raw72_to_int71_words` returns `-1` when the flat
value is outside the signed 71-bit range; otherwise it restores the duplicated
low-word sign bit.  These functions are the required boundary adapters for
mixed 71-bit and raw-72 interfaces.
