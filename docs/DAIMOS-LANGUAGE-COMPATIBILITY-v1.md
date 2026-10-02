# DAIMOS KCC/GCC language compatibility v1

## Exact-width common subset

KCC and PDP-10 GCC share exact signed and unsigned 6-, 7-, 8-, 9-, and
18-bit integer semantics.  The v13 executable probes verify truncation,
sign interpretation, integer promotion, array storage independence, argument
use, and returned values under both compilers.

The canonical spellings are `daimos_intN_t` and `daimos_uintN_t` from
`support/common/daimos-language-v1.h`.

## Widths not shared natively

GCC supports exact 16- and 32-bit integer types.  KCC does not.  KCC must not
silently call a 36-bit `int` an exact 16- or 32-bit type.

The shared header therefore reports `DAIMOS_HAVE_EXACT_INT16` and
`DAIMOS_HAVE_EXACT_INT32` as zero under KCC.  Explicitly widened adapters are
available as `daimos_word16_t`, `daimos_uword16_t`, `daimos_word32_t`, and
`daimos_uword32_t`; their names intentionally do not promise exact storage or
arithmetic width.

## Attributes

New compatibility code must use named DAIMOS attribute macros.  Diagnostic
attributes such as `unused`, `noinline`, and `noreturn` may degrade to empty
macros under KCC because this does not alter object representation or the
calling ABI.

Semantic and ABI attributes do not degrade silently.  `DAIMOS_PACKED`,
`DAIMOS_ALIGNED`, `DAIMOS_WEAK`, and `DAIMOS_ALIAS` deliberately produce a
KCC compilation failure until KCC implements the requested behavior or a
specific adapter is selected.

The catch-all `__attribute__(x)` macro in the old assembly-comparison shim is
legacy test infrastructure.  It is not part of the DAIMOS language
compatibility interface and must not be used by new shared source.

## PDP-6 native-compiler constraint

This phase adds no KCC compiler machinery.  It reuses KCC's existing native
byte types and makes unsupported widths visible at preprocessing or compile
time.  That keeps the native compiler small, avoids additional register
pressure, and requires no instructions unavailable on a PDP-6.

Future KCC language additions must be justified against native PDP-6 compiler
size, memory use, register pressure, bootstrap complexity, and generated
runtime cost.  Exact 16- or 32-bit types should not be added merely to mirror
GCC if explicit word adapters provide the required semantics more cheaply.
