# DAIMOS wide variadic ABI status v2

## Decision

KCC and PDP-10 GCC use the same external variadic calling convention.
Arguments after `...` are stack-passed.  Mixed-compiler interfaces may use
variadic calls when all argument types themselves have a shared ABI.

The representation and traversal machinery used internally for `va_list` is
compiler-private.  KCC may use its PDP-10 byte-pointer machinery while GCC uses
its own frame-relative implementation; that difference does not by itself
constitute an ABI difference.

## Executable evidence

`tests/compat/test-wide-varargs-abi.sh` builds a current-KCC variadic callee and
executes it with:

- a KCC caller, as the control case;
- a GCC caller, as the mixed-compiler case.

The probe passes both ordinary 36-bit unnamed arguments and a normalized
71-bit `int71_t` unnamed argument.  Both executions must return zero under the
KS10 test harness.

This directly verifies that a GCC caller's variadic stack layout can be
consumed by KCC's `va_start`/`va_arg` implementation.  The test also compiles
the common variadic probe with both compilers so changes in either compiler's
varargs support remain visible.

## Boundary

- Named arguments use the canonical PDP-10 C ABI.
- Unnamed arguments after `...` are stack-only.
- Normalized 71-bit values use the shared two-word representation.
- Compiler-private `va_list` representation is not part of the external ABI.
- Raw 72-bit adapter values still require the explicit raw72 ABI and are not
  implied to be variadic-compatible by this test.

The previous wrapper-only restriction was based on comparing compiler-private
`va_list` traversal code rather than testing the external call boundary and is
therefore removed.
