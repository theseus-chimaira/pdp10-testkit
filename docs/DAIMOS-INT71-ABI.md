# DAIMOS signed 71-bit integer ABI v1

## Scope

This document freezes the source-level and object representation used by the
PDP-10 GCC `long long` mode and selected for DAIMOS compatibility.  It is the
reference for KCC/GCC comparative tests.  Raw 72-bit arithmetic is a separate
extension and is not described here.

## C types

The canonical signed type is `int71_t`; the canonical unsigned type is
`uint71_t`.  In both GCC and KCC test headers these are aliases for `long long`
and `unsigned long long`.  Ordinary `int` and `long` remain one 36-bit word.

The historical testkit names `Dint` and `uDint` denote the same 71-bit model.
The old `int72` and `uint72` names are retained temporarily as compatibility
aliases, but they do not denote raw 72-bit arithmetic and must not be used in
new tests.

## Representation

An object occupies two consecutive 36-bit words in high-word, low-word order.
The high word contains the sign and the upper 35 value bits.  The low word
contains 35 further value bits.  Its sign-position bit is a normalization bit,
not an independent 72nd value bit.

For a normalized pair `(hi, lo)`, bit 0 of the low PDP-10 word is a copy of the
sign bit of `hi`.  The mathematical value therefore has 71 significant bits,
with signed range `-2^70` through `2^70 - 1`.

The in-memory pair and an accumulator pair use the same word order.  A value
returned in accumulators starts with the high word in the lower-numbered
accumulator.

## Arithmetic contract

Signed addition, subtraction, negation, multiplication, division, remainder,
and shifts operate on the normalized 71-bit value.  Results are normalized
before becoming observable through memory, calls, or comparisons.

Unsigned operations use the corresponding normalized two-word representation.
The exact unsigned range and overflow wording remain provisional until the
GCC and KCC boundary probes are complete; tests must not assume a flat modulo
`2^72` integer.

Shift counts requiring explicit compatibility coverage are 0, 1, 35, 36, 70,
and 71.  Raw 72-bit shifts and arithmetic must use separately named types or
intrinsics.

## ABI requirements

1. Objects occupy two words, high word first.
2. Register pairs use the lower-numbered accumulator for the high word.
3. Arguments, returns, helper calls, and memory operations preserve the same
   normalized representation.
4. Public interfaces must use `int71_t` or `uint71_t`, not misleading `int72`
   names.
5. A compiler configuration using 36-bit `long` for `Dint` is semantically
   incompatible and must be rejected by comparative-test metadata.

## Open items

The following are deliberately not frozen by version 1:

- the final unsigned overflow specification;
- complete varargs placement;
- all helper symbol names and clobber sets;
- structure-return interactions;
- raw 72-bit extension spelling and ABI.
