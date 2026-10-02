# DAIMOS direct 36-to-71-bit widening v1

KCC and PDP-10 GCC directly convert signed and unsigned 36-bit words to the
normalized 71-bit representation.

For signed input, the high word is the arithmetic sign extension and the low
word preserves the complete 36-bit source word, including the duplicated sign
position.

For unsigned input, source bit 35 becomes bit 0 of the high word and the low
word retains source bits 0 through 34 with its sign position clear.

Direct full-range 71-to-36-bit narrowing remains outside the common compiler
subset in GCC. Use `daimos_u71_to_u36()` or `daimos_i71_to_i36()` from
`daimos-wide-convert-v1.h`; these helpers are the canonical DAIMOS boundary
until GCC stops folding the conversion to an ordinary low-word subobject.
