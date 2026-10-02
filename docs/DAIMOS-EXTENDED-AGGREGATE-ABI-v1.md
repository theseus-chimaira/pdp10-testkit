# DAIMOS extended aggregate and function-pointer ABI v1

This document records measured KCC/GCC behavior.  It does not generalize
beyond the probes in `tests/compat/extended-aggregate-abi.c`.

## Structures larger than four words

A structure occupying five 36-bit words is returned through caller-provided
storage.  AC1 contains the destination address.  Explicit scalar arguments
begin in AC2 and continue in AC3 and AC4, with remaining arguments passed in
the ordinary stack argument area.  Both compilers copy the complete result to
the destination supplied in AC1.

This extends the directly compatible aggregate-return subset beyond the
one-to-four-word AC return convention documented earlier.

## Function pointers

The measured function pointer is one 36-bit code address.  Both compilers pass
it in an ordinary accumulator and perform an indirect `PUSHJ 17` through that
address.  Fixed-signature function-pointer calls are directly compatible.

## Union layout

A union containing a normalized 71-bit integer and a two-word structure places
the high word first and the low word second in both compilers.  This confirms
layout compatibility for this measured union only.

## Bit fields

The measured unsigned sequence of 6-, 9-, and 18-bit fields occupies one
36-bit word with identical PDP-10 byte positions in both compilers.  This does
not yet freeze signed fields, zero-width fields, fields crossing a word
boundary, mixed base types, packing attributes, or implementation-specific
alignment controls.

## Remaining work

The following remain unproven:

- aggregates requiring more complicated hidden-return and argument mixtures;
- unions with differently aligned members;
- signed and cross-word bit fields;
- function-pointer representation under overlays or non-default code models;
- floating-point and packed aggregate interfaces.
