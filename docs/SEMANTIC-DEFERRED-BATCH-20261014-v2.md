# Deferred semantic batch 1: activation and resolution plan (2026-10-14, v2)

The initial review in v1 retained all eight tests. This follow-up reverses
that overly strict decision: a valid semantic test need not pass KCC to be
listed as active, provided its compiler and CPU expectations are recorded.

## Activated unchanged

- `wide-int/20000223-1.c`: GCC PDP-6 `-O0` passes; the `__alignof__`
  power-of-two property is checked. KCC currently rejects the extension.
- `generic/20000314-3.c`: GCC PDP-6 `-O0` passes the C99 return-of-void
  expression test; KCC currently rejects it, tracked as a compile failure.
- `generic/20000801-3.c`: GCC PDP-6 `-O0` passes the empty-structure GNU
  extension; KCC currently rejects it.

The matrix marks only measured GCC PDP-6 `-O0` semantic execution and
measured KCC PDP-6 compile failures. Other profiles remain pending;
PDP-6 with the PDP-10-only compiler profile remains unsupported.

## Still to resolve, not accepted as permanent deferrals

- `generic/20000227-1.c`: decide the source-file encoding policy for raw
  octet 0xff versus `\\377` before rewriting or removing the test.
- `generic/20000603-1.c`: resolved by user policy as `stress-nonportable`;
  preserve unchanged, separate from mandatory semantic regression outcomes.
  See `NONPORTABLE-STRESS-POLICY-20261014-v1.md`.
- `generic/20000622-1.c`: diagnose the KCC PDP-6 argument/pointer-integer
  failure against documented ABI behavior; fix compiler when required.
- `extensions/20000703-1.c` and `extensions/20000815-1.c`: investigate
  linking the existing assembler freestanding libc and recognizing GNU
  `__builtin_memcpy`/`__builtin_memset` names; never duplicate library
  implementation merely to silence unresolved symbols.

No compiler/assembler change or source rewriting has been attempted for
these five questions in this commit. Activation does not imply KCC success.
