# DAIMOS wide variadic ABI status v3

## Decision

KCC and PDP-10 GCC may interoperate directly across variadic calls only for
argument types whose external representation has been demonstrated to agree.
The compiler-private `va_list` representation is not part of this contract.

Direct mixed variadic calls are currently supported for:

- default-promoted narrow integer arguments;
- ordinary 36-bit integer arguments;
- normalized 71-bit `int71_t` arguments;
- ordinary word pointers;
- packed byte pointers whose byte size/position representation is shared;
- aggregates whose layout is already classified as ABI-compatible;
- floating arguments after the normal variadic promotion to `double`.

The v30 mixed matrix executes these classes in both directions:

- GCC caller -> KCC variadic callee;
- KCC caller -> GCC variadic callee.

## Unsupported direct cases

A native type is not automatically variadic-compatible merely because a
scalar value of that type can be converted to the same mathematical value.
Direct mixed variadic use remains unsupported for representations already
known to differ, including pointers to native exact 16-bit or 18-bit objects
whose C storage layout differs between KCC and GCC.

For such interfaces, use an explicit wrapper and a canonical ABI value.  The
existing exact-width adapters convert 16-bit and 18-bit scalar values to/from
ordinary word-register representations; raw 72-bit interfaces use `raw72_t`.
The wrapper must perform the conversion before entering the variadic boundary
or after leaving it.  Do not expose compiler-private `va_list` objects across
the boundary.

## Evidence

`tests/compat/test-kcc-gcc-varargs-matrix-v30.sh` compiles the same caller and
callee interfaces with both compilers and executes both mixed directions.  It
covers promoted narrow integers, a normalized 71-bit value, an ordinary word
pointer, a packed byte pointer, a two-word aggregate, a promoted floating
argument, and a trailing word argument.

`tests/compat/test-wide-varargs-abi.sh` independently covers normalized 71-bit
stack traversal with a KCC variadic callee and both KCC and GCC callers.

These runtime tests establish external call compatibility only for the
enumerated representations.  They do not make KCC's compatibility
`__builtin_va_*` macros and GCC's native varargs lowering equivalent for code
size or performance comparisons; those remain result-only under the
optimization-comparison policy.
