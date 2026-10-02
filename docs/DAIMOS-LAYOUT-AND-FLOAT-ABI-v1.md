# DAIMOS Signed Bit-Field and Floating ABI v1

## Scope

This document records behavior measured by
`tests/compat/test-layout-float-abi.sh` under KCC and GCC in normalized
71-bit mode.

## Signed bit fields contained in one word

The tested sequence of signed 6-, 9-, and 18-bit fields occupies one
36-bit word in both compilers. Fields are allocated from the high end of
the word toward the low end in declaration order. Loads sign-extend the
declared field width before arithmetic.

This agreement is limited to fields whose total width does not exceed one
word and whose declared base type is signed `int`.

## Cross-word bit fields are incompatible

For three consecutive unsigned 20-bit fields, GCC packs 60 bits into two
36-bit words. KCC allocates three words, one word for each field. The same
C declaration therefore has different size, field offsets, argument
layout, and persistent representation.

Cross-word bit fields must not appear in DAIMOS public structures or
mixed-compiler interfaces. Use explicit words plus masks and shifts.
Compiler-specific structures may remain private to one translation unit.

## Floating-point fixed-call ABI

A `float` argument and result use AC1. A `double` argument and result use
AC1:AC2 with the high word in AC1. Function pointers with fixed `float` or
`double` signatures use the ordinary one-word code address and `PUSHJ 17`
indirect-call convention.

KCC may implement double arithmetic through runtime helpers while GCC may
emit native double-float instructions. That is a code-generation choice,
not an external ABI difference.

## Explicit packing and alignment

GNU `packed` and `aligned` attributes are not part of the verified common
source subset. KCC compatibility headers must not erase them silently.
Public DAIMOS interfaces requiring nondefault layout must use explicit word
or byte representations until both compilers implement the same named
facility.

## Still unresolved

- zero-width and unnamed bit fields;
- signed fields crossing a word boundary;
- non-`int` bit-field base types;
- floating-point variadic calls;
- floating-point structure and union layout;
- nondefault packing or alignment.
