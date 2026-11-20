# GCC PDP-10 packed 18-bit field readback (2026-11-20, v1)

Status: staged GCC 3.2 fix verified by PDP-6 execution at O0/O1.
This is not proof of O2/Os correctness and does not install a compiler.
No full sweep or original-source modification was performed.

## Root cause and correction

The original GCC torture source tests/semantic/upstream/extensions/20010518-2.c
contains two shorts following a packed long. GCC's layout records c at bit 54
(right half of word 1) and d at bit 72 (left half of word 2).

Installed GCC incorrectly loads static c from the left half of word 1, giving
c=2 instead of c=3. This reproduces without a memcpy call. The previously
committed BLKmode copy fix separately corrects a and b in local records.

GCC's gcc/expr.c now normalizes 18-bit packed field references that have
crossed a 36-bit word boundary, retaining the residual halfword selector.
For halfwords already on a word boundary, normalization is restricted
to dynamically addressed records. A broader normalization corrected c
but regressed static d; the narrower fix preserves both.

## Verified execution

| Source/operation | Installed GCC | Staged GCC |
| --- | --- | --- |
| Static c (PDP-6 O0) | Incorrect: 2 | Correct: 3 |
| Static d (PDP-6 O0) | Correct: 4 | Correct: 4 |
| Original 20010518-2.c, PDP-6 O0 | FAIL | PASS |
| Original 20010518-2.c, PDP-6 O1 | Not checked here | PASS |
| Original 20010518-2.c, PDP-6 O2 | Not checked here | FAIL |
| Original 20010518-2.c, PDP-6 Os | Not checked here | FAIL |

The original-source O2/Os field-specific diagnostic reaches the nested
nine-bit character e.b4 (exit 15), after the integer assertions pass.

The independent test source is
tests/semantic/validation-gcc/gcc-packed-halfword-readback-v1.c, owned
by the manual special-test script
misc/validation/test-gcc-packed-halfword-readback-v1.sh. C89-compatible
apart from the GNU packed attribute, it checks a/b/c/d in both a static
record and a copied local record accessed through a volatile pointer.

Installed GCC fails this regression on static c (exit 13, octal 015).
Staged GCC passes O0 and O1. O2 and Os still fail at dynamic c
(exit 23, octal 027). Thus higher optimization also has an independent
packed-halfword problem, even before the nested character check in the
original source. No assertion or expected result was weakened.

The script defaults to the verified O0/O1 profiles. Set
P10TK_PACKED_PROFILES='O2 Os' explicitly to reproduce the known
optimized failure. To run verified profiles with staged cc1:

    P10TK_GCC_CC1_DIR="$TMPDIR/p10-gcc-packed-aggregate-build-v1/gcc" \
      sh misc/validation/test-gcc-packed-halfword-readback-v1.sh

## Remaining P1 problems

- Correct optimized dynamic c extraction at O2/Os.
- Correct optimized nested e.b4 byte field at O2/Os.
- Diagnose KCC's independent packed initialization failure.
- Install and validate the compiler before enabling the manual test.
