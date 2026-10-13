# DAIMOS pointer and aggregate ABI v1

## Scope

This document records measured KCC/GCC interoperability for ordinary pointers,
PDP-10 byte pointers, and small aggregate return values.  It does not define
function pointers, segmented pointers, packed persistent formats, or aggregates
larger than four words.

## Ordinary word pointers

Pointers to 36-bit objects are one-word word addresses in both compilers.

- The first pointer argument and pointer return value use AC1.
- Pointer addition by `n` words is ordinary address addition.
- Loads and stores use ordinary word memory instructions.

Direct mixed-compiler calls using pointers to 36-bit objects are compatible.

## Byte pointers

Pointers to `char` and `short` objects are native PDP-10 byte pointers in both
compilers.

- Loads use `LDB`.
- Stores use `DPB`.
- Pointer advancement preserves the byte size and position fields.
- GCC currently emits `ADJBP` directly.
- KCC currently implements equivalent advancement through `%ADJBPH`.

The different instruction selection does not imply a representation mismatch.
Byte-pointer values can cross fixed-argument KCC/GCC interfaces directly.
Persistent and externally serialized pointer values remain forbidden.

## Small aggregate returns

Measured aggregates occupying one through four words are returned in successive
accumulators beginning at AC1:

| Aggregate size | Return accumulators |
|---:|---|
| 1 word | AC1 |
| 2 words | AC1:AC2 |
| 3 words | AC1:AC3 |
| 4 words | AC1:AC4 |

This includes a structure containing one normalized 71-bit integer: its high
word is returned in AC1 and its low word in AC2.

KCC may construct an aggregate in temporary stack storage internally, but the
externally visible return registers agree with GCC.  Direct mixed-compiler
calls are therefore supported for measured aggregates of at most four words.

## Unresolved cases

The following still require probes before direct interoperability is claimed:

- aggregates larger than four words;
- unions and bit fields;
- function pointers and pointer conversions among address classes;
- floating-point-containing aggregates;
- hidden return-buffer conventions;
- packed or explicitly aligned structures.
