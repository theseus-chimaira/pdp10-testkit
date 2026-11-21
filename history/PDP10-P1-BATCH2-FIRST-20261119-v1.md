# PDP10 P1 Batch 2: compiler/policy admission, first six originals

Date: 2026-11-19. The immutable Batch 2 contains ten original source
identities. This stage constructs meaningful PDP-6 test oracles for six
and closes the test-construction obligation for **five**. The original
sources and their deferred historical classifications are unchanged.

## Source admission and exact observations

| Original source | Registered normal-matrix companion(s) | P1 state |
| --- | --- | --- |
| `921007-1.c` | `pdp10-builtin-strcmp-9bit-v1.c` | **covered** |
| `931002-1.c` | `pdp10-nested-closure-calls-v1.c` | **covered** |
| `961122-1.c` | `pdp10-wide-shifted-accumulator-v1.c` | **covered** |
| `index-1.c` | `pdp10-large-index-relocation-v1.c` | **covered** |
| `20020108-1.c` | `pdp10-width-shifts-v1.c` and `pdp10-signed-right-shifts-v1.c` | **covered** |
| `bf-sign-2.c` | `pdp10-bitfield-36bit-promotions-v1.c` | **partial** |

All 38 normal PDP-6 matrix cells are archived with actual compiler,
linker and guest evidence. There are **21 PASS**, **9 genuine guest
assertion failures**, **5 RH18 linker relocation overflows**, and
**3 SIMH wall timeouts**, with no invented guest exit.

### Large array indexing and linker relocation

The 40-element initialized integer array remains an actual data
object; `lookup(100030L)` must read element 30 after subtraction of
100000. Independently check positions 0, 30, 39. KCC PDP-6 noopt
passes, while KCC optimized and GCC O0/O1/O2/Os all report a genuine
`dlink: RH18 relocation overflow`. The test is fully constructed;
repair of the linker is later compiler/toolchain work, not P1.

### Native wide signed 71-bit high-word operations

The original `0xffff00000000LL + (1LL << 32)` produces exactly
`0x1000000000000LL` and subtraction restores the starting value;
this follows from independent unbounded host integer addition.
Volatile input and accumulator force real arithmetic. All six KCC/GCC
PDP-6 profiles return a readable abort at the first addition check.
No compiler implementation has been modified or patched.

### GNU nested callbacks and nine-bit string builtin

The original `931002-1.c` does not assert how often its callback is
invoked and can skip all tests with `NO_TRAMPOLINES`. Its companion
requires three real nested-function calls and a captured parent value.
GCC O0 passes; O1/O2/Os enter SIMH but time out with no readable
exit. KCC does not support this GNU feature and is not counted as
passing.

The `921007-1.c` companion uses `__builtin_strcmp("X", "X\\376")`
with the required negative result, and independently checks that the
nine-bit source character `\\376` is unsigned value **254**. GCC O0
passes. GCC O1/O2/Os reach a real assertion failure specifically in
the **9-bit literal readback**, checkpoint 3; this must not be
misreported as failure of the preceding `strcmp` assertion. KCC
cannot link `__builtin_strcmp` and is not marked as supporting it.

### PDP-10 9/18/36-bit shifts and 36-bit bitfields

The original `20020108-1.c` has only 8/16/32-bit target-width guards,
so it exercises no substantive shifts when `CHAR_BIT==9`. Its already
registered unsigned 9/18/36-bit source provides **63 counts and 126
real comparisons** with host-generated expectations. New
`pdp10-signed-right-shifts-v1.c` adds **63 counts and 126 signed
arithmetic right-shift comparisons**, each independently derived from
Python integer arithmetic. Negative signed right shift is an explicit
PDP-10 target policy (implementation-defined in C89), not a portable
C-language guarantee. All six KCC/GCC PDP-6 profiles PASS both shift
sources; the old width-guarded imported source remains unchanged.

The old `bf-sign-2.c` assumes 32-bit `int` and makes incorrect claims
for an unsigned 32-bit field on the PDP-10. The new companion verifies
standard promotions of 3-, 15-, 31-, 32-, and 36-bit unsigned `int`
fields and signed 31/32-bit fields, against actual 36-bit signed-int
range. KCC/GCC six PDP-6 profiles PASS. The original source additionally
uses nonstandard `unsigned long long` bitfields of widths 3 and 35;
there is not yet an independently justified cross-compiler extension
policy, so this original is **partial**, not falsely P1-closed.

## Evidence and next obligations

`PDP10-P1-BATCH2-FIRST-RESULTS-20261119-v1.tsv` contains the 38 exact
original-to-companion/profile status records and SHA256 per execution.
`refs/pdp10-p1-batch2-first-20261119-v1.tar.gz` contains the actual
compiler, linker and guest report text. The registered
`tools/verify-p1-batch2-first-v1.py` checks all original hashes,
source identities, normal matrix ownership, independently generated
unsigned/signed shift tables, arithmetic expectations, and every
archived real result class. No C source was altered in the historical
import tree.

The six remaining incomplete Batch 2 source-obligations consist of
**one partial** (`bf-sign-2.c`) and **four blocked** (`20010122-1.c`,
`eeprof-1.c`, `991228-1.c`, `nestfunc-3.c`). Continue these without
beginning compiler fixes; AAP architecture correctness is P3.

The 67-source live resolution becomes **23 covered, 7 partial,
37 blocked**, leaving **44 actionable P1 obligations**. The frozen
59-source six-batch assignment is unchanged.
