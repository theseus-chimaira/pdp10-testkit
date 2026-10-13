# DAIMOS external symbol and wide-runtime ABI v1

## Measured common external-symbol subset

KCC and GCC emit the same assembler-visible spelling for external C identifiers
that are no longer than 31 characters. The measured subset includes lowercase
names, mixed-case names, and names beginning with an underscore.

DAIMOS public C and assembler interfaces shall therefore use externally visible
identifiers of at most 31 characters. This applies to functions, objects, and
runtime entry points intended to cross compiler boundaries.

## Longer identifiers

GCC preserves identifiers longer than 31 characters. KCC diagnoses truncation
and emits only the first 31 characters. Two distinct source identifiers sharing
those first 31 characters can therefore collide in a KCC object.

Long external names are not part of the common ABI. Source-private identifiers
may be longer only when they cannot become assembler or linker symbols.

## Case and leading underscores

The compiler outputs preserve the measured source spelling, including case and
a leading underscore. This document does not yet define whether every supported
assembler, librarian, and linker preserves case distinctions. Public interfaces
should not rely on two symbols differing only by case until the complete object
tool chain has been measured.

## 71-bit runtime helpers

GCC emits calls to `__divdi3` and `__moddi3` for the measured signed 71-bit
division and remainder operations. KCC emits compiler-private division code and
does not reference those GCC helper names.

Consequences:

- Runtime-helper names are not presently a shared KCC/GCC compiler ABI.
- A mixed image containing GCC objects must provide the required GCC helpers.
- DAIMOS public assembly interfaces must not call compiler-private helpers.
- Shared helpers, if introduced, need explicit names no longer than 31
  characters, documented arguments, results, clobbers, and edge behavior.
- Legacy compiler helper aliases may be added after their complete ABIs are
  measured; name similarity alone is insufficient.

## Unresolved

The following remain to be measured:

- case significance in DAS and the final object/linker tools;
- maximum symbol significance in every object format and linker;
- weak symbols, aliases, common symbols, and tentative definitions;
- GCC helper argument registers, clobbers, divide-by-zero behavior, and signed
  overflow behavior;
- helper requirements for unsigned division, multiplication, and conversions.
