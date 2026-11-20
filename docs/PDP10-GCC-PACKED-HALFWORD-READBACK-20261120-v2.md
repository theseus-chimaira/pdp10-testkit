# GCC PDP-10 packed halfword source regression (2026-11-20, v2)

This supersedes the v1 staged status. The exact original imported
GCC torture source 20010518-2.c now passes **all four PDP-6 GCC
optimization levels** with the patched, staged GCC 3.2 compiler.
The upstream file and its abort/exit assertions have not been edited.
The installed compiler has not been replaced.

## Correctness changes

The previously committed GCC packed BLKmode block-copy fix produces
proper 9-bit PDP-10 byte pointers from ordinary word addresses while
retaining an incoming byte pointer's selector.

The follow-up gcc/expr.c fix corrects packed 18-bit field access:

- The logical field layout places short c at bit offset 54 (right half
  of 36-bit word 1), and short d at bit offset 72 (left half of word 2).
- Direct HImode lowering had discarded c's right-half selection.
  The expander now normalizes relevant COMPONENT_REF accesses to a
  containing 36-bit word and keeps the residual halfword bit position.
- At O2/Os, GCC had conservatively labeled the normalized full-word
  MEM as only 9-bit aligned. Its generic bit-field expander then emitted
  two incorrect 9-bit fragment accesses. After the normalization, the
  MEM represents an actual full PDP-10 word, so restoring the physical
  36-bit alignment enables correct word/halfword extraction.
- The normalization preserves static left-half fields that were already
  correct, avoiding an earlier overbroad experiment which broke d.

This addresses the underlying memory/address and alignment semantics,
not a per-test special case or a libc workaround.

## Targeted PDP-6 evidence

| Test and compiler | O0 | O1 | O2 | Os |
| --- | --- | --- | --- | --- |
| Exact original 20010518-2.c, staged GCC | PASS | PASS | PASS | PASS |
| Independent static/dynamic halfword regression, staged GCC | PASS | PASS | PASS | PASS |
| Previous packed block-bytepointer regression, staged GCC | PASS | PASS | PASS | PASS |
| Current installed GCC, independent halfword regression | FAIL at O0 | Not checked | Not checked | Not checked |

The static readback diagnostic initially gave c=2 instead of 3
on installed GCC, without invoking memcpy. The staged compiler gives
a=1, b=2, c=3 and d=4. The independent regression checks all four
fields both statically and through a copied local packed record.

The exact original source executes after real assembly and linking on
the PDP-6 simulator with the installed freestanding memcpy source and
CRT/exit/abort code. This is not a claim of production DARC archive
linking or validation on every PDP-10 machine family.

## Reproduction and ownership

- Test: tests/semantic/validation-gcc/gcc-packed-halfword-readback-v1.c
- Runner: misc/validation/test-gcc-packed-halfword-readback-v1.sh
- Additional test: misc/validation/test-gcc-packed-block-bytepointer-v1.sh
- Staged compiler: $TMPDIR/p10-gcc-packed-aggregate-build-v1/gcc/cc1
- Original source: tests/semantic/upstream/extensions/20010518-2.c

Use P10TK_GCC_CC1_DIR to select staged cc1 in either validation script.
The scripts are registered manual until the installed compiler is
updated and its target matrix can accept the correction.

## Still open

- The installed GCC remains at its previous revision; installation and
  installed-tool verification have not yet been performed.
- KCC still fails the original packed aggregate source independently.
- Broader CPU/ABI test coverage is deferred until the P1 test
  infrastructure and runtime prerequisites are complete.
