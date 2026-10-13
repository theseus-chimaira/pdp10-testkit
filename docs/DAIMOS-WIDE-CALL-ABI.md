# DAIMOS 71-bit fixed-argument calling ABI v1

## Scope

This document records the measured fixed-argument calling convention for the
normalized PDP-10 71-bit `long long` model.  It applies to direct KCC/GCC calls
using ordinary non-variadic C functions.  It does not claim variadic,
structure-return, floating-point, or raw 72-bit native ABI compatibility.

## Measured convention

A normalized 71-bit value occupies one adjacent accumulator pair.  The high
word is in the lower-numbered accumulator and the low word is in the next
accumulator.

For the simple fixed-argument functions measured by
`tests/compat/wide-call-abi.c`:

- the first 71-bit argument is passed in AC1:AC2;
- the second 71-bit argument is passed in AC3:AC4;
- a 71-bit return value is returned in AC1:AC2;
- ordinary calls use the PDP-10 `PUSHJ 17,symbol` convention;
- a compiler may replace a final call with a tail `JRST symbol` after restoring
  its caller frame.

Both KCC and GCC generate this convention.  Direct mixed-compiler calls for
these fixed signatures therefore require no adapter.

## Representation requirement

The accumulator pair uses the same normalized 71-bit representation as memory:
the high word contains the sign and upper value bits, while the low-word sign
position duplicates the sign.  Passing a flat raw 72-bit pair through this ABI
is invalid even though both representations occupy two words.

## Consumed-pair register lifetime

A mixed signature such as

```c
int71_t f(int a, int71_t b, int c)
{
    return b + a + c;
}
```

places `a` in AC1, `b` in AC2:AC3, and `c` in AC4.  A read-once 71-bit
parameter may be consumed directly from its incoming pair, but those ACs cease
to be protected ABI inputs at that point and must become available to the
normal temporary allocator.  The KCC regression suite checks this lifetime
rule explicitly so later DImode operations do not exhaust `rrdfind`.

## Compatibility status

Direct native ABI compatibility is established only for the measured
fixed-argument 71-bit cases.  The following remain unresolved and must not be
inferred from this result:

- 71-bit values after accumulator arguments are exhausted;
- mixtures with pointers, narrow byte values, structures, or floating point;
- variadic functions and `va_list` traversal;
- structure return and hidden result pointers;
- native raw 72-bit calls under GCC `-mlong-long-72bit`;
- caller- and callee-saved accumulator rules beyond the observed functions.
