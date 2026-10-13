# DAIMOS plain character and enumeration language rules v1

## Scope

This document records the common KCC/GCC behavior verified for PDP-6-compatible DAIMOS C source.

## Plain character types

- `char` occupies one addressable character unit.
- Plain `char` is an unsigned 9-bit type in the shared PDP-10 language subset.
- `signed char` is a signed 9-bit type.
- `unsigned char` is an unsigned 9-bit type.
- Arithmetic promotion follows the existing DAIMOS narrow-integer rule: all three promote to signed 36-bit `int` because every unsigned 9-bit value fits.

Portable source must use `signed char` when negative character values are required. It must not depend on host-C conventions where plain `char` may be signed.

## Enumerations

For enumerators representable as a signed 36-bit word:

- the enumeration object occupies one 36-bit word;
- values and comparisons behave as signed 36-bit `int` values;
- fixed arguments and returns use the ordinary one-word integer ABI.

Enumerations requiring values outside the signed 36-bit range are not yet part of the shared subset. Public DAIMOS interfaces should use an explicit `int71_t`, `uint71_t`, or raw representation instead of relying on compiler-selected extended enum types.

## PDP-6 implementation cost

These rules match KCC's existing native byte and word models. They require no new KCC machine mode, runtime helper, or additional native compiler pass.
