# KCC signed 71-bit/software D-format conversion (2026-10-20, v1)

## Scope and architectural separation

This completed fix implements the established portable *C software D-format*
on the PDP-6 using **integer instructions only**. It does **not** implement
the PDP-6's native hardware floating-point format, or infer the floating
semantics of a KA10, KI10, KS10 or KL10 from a PDP-6 result. The target
selection in `kcc/ccgen2.c` is restricted to `-x=pdp6` signed DImode casts
to/from `double` and `long double`.

The source `tests/semantic/upstream/wide-int/930622-2.c` is *byte-identical*
to the original imported test. It previously terminated KCC with
`[FATAL] vrwiden: reg already wide`, because the generic cast path
attempted scalar widening on an already paired 71-bit DImode value.

## Implementation

The versioned runtime source is
`kcc/runtime/libc/kcc-libc-dimode-float-pdp6-v1.s`, installed as an
independently extractable `libp10c-v2.a` member and distributed identically
by KCC and GCC. The two entry points are:

- `__kcc_floatdidf`: signed high36:low35 DImode AC1/AC2 to software D-format
  AC1/AC2, with nearest/even rounding at the 62-fraction-bit boundary
- `__kcc_fixdfdi`: software D-format AC1/AC2 to signed high36:low35
  DImode AC1/AC2, truncating the represented value toward zero

The implementation handles positive and negative numbers, canonical low
word sign duplication, exponent normalization, ties and exponent carry.
Each assembler routine uses no writable data or internal stack allocation;
the compiler-generated caller temporarily pushes two argument words.
There is no generic libgcc dependency. The earlier libgcc bridge was
discarded because it failed negative-value and timing investigations.

## Verified acceptance

| Regression | KCC PDP-6 optimized | KCC PDP-6 `-n` |
| --- | --- | --- |
| Original GCC upstream `930622-2.c`, without source edits | PASS | PASS |
| Seventeen independently calculated integer-to-D-format bit patterns, including signed minimum, signed maximum, and nearest-even ties; each checked through the assembler ABI and ordinary C casts | PASS | PASS |
| Ten fractional D-format values, verifying truncation toward zero through the assembler ABI and ordinary C casts | PASS | PASS |
| Prior signed DImode automatic-load and D-format negation regressions | PASS | PASS |

The unchanged upstream test also passes on GCC PDP-6 at `-O0`, `-O1`,
`-O2`, and `-Os`. Both installed freestanding libraries were checked for
byte identity. Inventory and deferred-disposition validators both pass.

The matrix enables `pdp6` for both KCC optimization modes and
`pdp6_gcc_o0/o1/o2/os` for GCC. **All other CPU/family columns are
explicitly inactive (`no_test`)**, not assumed to pass or declared
unsupported. This is target-limited activation, not all-CPU validation.

## Independent AAP PDP-6 execution (2026-10-20)

The current AAP emulator (`pdp6/emu`, source revision `ac603e8`) was
rebuilt without patches to its source or reintroducing deleted diagnostic
commands. The normal toolchain assembled and linked complete guest images
and SIMH validated them before AAP loaded them. The AAP acceptance routine
then synchronously deposited the guest, initialized the `__test_exit`
word to octal `777`, and verified that value *before* starting execution.
The successful guest path's `exit(0)` changes the same word to zero.
Polling synchronous AAP memory examinations establishes this transition
without fixed-delay success assumptions, synthetic opcode execution, or
simulated HALT status.

| AAP guest | Linked words | Outcome |
| --- | ---: | --- |
| Unmodified `930622-2.c`, KCC optimized | 221 | PASS |
| Unmodified `930622-2.c`, KCC `-n` | 235 | PASS |
| 17 integer + 10 fractional cases, KCC optimized | 624 | PASS |
| 17 integer + 10 fractional cases, KCC `-n` | 818 | PASS |
| 21 signed DImode/native 36-bit float cases, KCC optimized | 899 | PASS |
| 21 signed DImode/native 36-bit float cases, KCC `-n` | 1001 | PASS |
| Nine 36-bit float literal patterns, KCC optimized | 170 | PASS |
| Nine 36-bit float literal patterns, KCC `-n` | 222 | PASS |
| Negative control: replace guest entry instruction with HALT | 221 | Correctly rejected |

The negative-control image never writes the success word, so the exit
sentinel remains nonzero. This establishes that loading a guest, observing
an initially cleared variable, or HALT alone cannot pass the test. The
registered executable regression is
`misc/validation/test-kcc-aap-dimode-float-pdp6-v1.py`.

These results verify both the integer-only software D-format guest and
the separate signed DImode/native-single conversion path on two PDP-6
emulators. The native float path uses the hardware-compatible 36-bit
single representation, while the D-format helper itself does not execute
native floating-point instructions. They do not prove later PDP-10 CPU
semantics or timing equivalence.

## Further work

The first AAP attempt waited for a diagnostic timing trace removed from
the emulator, so it produced no useful result. The sentinel-transition
oracle above supersedes that attempt and passes all eight real guests.
Later PDP-10 hardware-specific floating modes require separate profiles,
code generation, and regression evidence. The accepted PDP-6 software
D-format and native-single paths must not be silently reused for them.

Historical failure analysis is preserved in
`docs/KCC-71BIT-FLOAT-CONVERSION-INVESTIGATION-20261019-v1.md`.
