# GCC dynamic variadic aggregate copy: focused diagnosis (2026-11-18, v6)

## Scope and unchanged runtime oracle

After the verified GCC packed-record repair (`pdp10-gcc c099c40`,
`pdp10-testkit 3a3bbaa`), investigate the independently deferred
`tests/todo/generic/20020412-1.c` without starting the full compiler
or DAIMOS execution matrix.

The earlier compiler ICE is genuinely fixed by `pdp10-gcc 66f5a15`.
The original upstream test now compiles but **still aborts on its
first digit assertion** when executed on PDP-6 with the installed
real freestanding `kcc-libc-memcpy-v1.s`. Its original C source,
assertions and deferred classification remain unchanged.

## Current compiler lowering

At `-O0 -march=pdp6`, GCC generates four calls to the ordinary
`memcpy` symbol: two for outgoing variadic aggregates in `main`,
and two for copies from `va_arg` into the local VLA in `foo`.
The installed `memcpy` ABI takes native 9-bit byte pointers in
AC1 and AC2 and a byte count in AC3. The emitted call sites show
apparently inconsistent word-address and byte-pointer representations.

The GCC code to examine is `gcc/expr.c:emit_block_move`. Its PDP-10
branch chooses the input pointer byte size from virtual stack base
registers, `MEM_EXPR` object types or `MEM_ALIGN`, then calls
`pdp10_convert_ptr`. These inputs need not identify whether the RTL
address expression is already a native byte pointer. Separately,
`gcc/calls.c` computes the outgoing VLA argument area and its
placement relative to the stack pointer. The correct source/dest
address, overlap and runtime length need to be verified together.

## Temporary assembly diagnostics: insufficient simple conversion

The original GCC-generated O0 assembly was copied into a **versioned
scratch directory**. Only that temporary assembly, not the original
source or installed compiler, was modified to test a concrete
hypothesis: insert a local `TLO ...,0331100` before a `memcpy`
call for an apparent raw word pointer. The same original C assertions
and real installed `memcpy` were used in every simulator execution.

| Scratch variant | Target-executed result |
| --- | --- |
| No conversion (original) | Aborts, `__test_exit=1` |
| Convert outgoing destination at the two `main` copies | The byte-copy loop exceeds the 250,000-step bound; PC reaches `SOJN 7,1574` in `memcpy` |
| Convert incoming source at the two `foo` copies | HALTs on a failed assertion (`__test_exit=1`) |
| Convert all four copy call sites | Times out after 30 seconds in simulation |

In a bounded trace of the outgoing-copy variant, the simulator found
AC7 containing octal `070777774766` during the `memcpy`
decrement loop. That is not a plausible short byte count for a
five-character VLA aggregate. The observation shows that indiscriminate
pointer conversion is **not a repair**; it does not prove whether the
original source of the bad count is the outgoing argument placement,
runtime size calculation or memory corruption by an earlier copy.

The PDP-10 GCC canonical calling convention marks AC0 through AC7
call-clobbered. A later use of an accumulator after a `memcpy` call
must therefore not automatically be interpreted as a compiler
register-liveness violation: the generated code also recomputes
intermediate lengths. Actual live values and copy addresses must be
measured before assigning a register-preservation defect.

All scratch evidence is under
`$TMPDIR/p10tk-gcc-vla-copy-analysis-20261118-v1` (generated
assembly, variant assembly, compilation and simulator reports).
The diagnostic copies were **not** registered as production tests.
No fake helper or altered C assertion was introduced.

## Next validation gate

1. Trace the first and second outgoing `memcpy` entry values
   (AC1/AC2/AC3), object addresses and allocated stack extent,
   including whether the source and destination overlap.
2. Independently trace the corresponding `foo` copies from
   `va_arg`; verify their pointer representation and byte count.
3. Correct the relevant `emit_block_move` / outgoing aggregate
   argument lowering only after the actual address and length rules
   are known. Preserve the canonical freestanding `memcpy` ABI.
4. Require the **unchanged** `20020412-1.c` runtime oracle to pass,
   followed by GCC optimization/CPU and nearby scalar/block-copy
   regressions. Compiler-only success remains insufficient.

This investigation is not a completion claim for the dynamic VLA
aggregate runtime, GNU historical `varargs.h`, hosted services or
the full deferred-source matrix.
