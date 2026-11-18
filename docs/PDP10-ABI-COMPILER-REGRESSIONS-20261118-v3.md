# KCC DImode caller preservation and packed-array ABI diagnosis (2026-11-18, v3)

## Scope and provenance

Continuation of the v2 operational prerequisite investigation in
`pdp10-testkit`. The full compiler/CPU/optimization matrix was **not**
started. Existing C source assertions were left unchanged. The only
existing test fixture edit corrects a demonstrably wrong octal literal
in a hand-written ABI checker. Original GCC packed-character failure
remains enabled and failing.

The KCC compiler repair is independently committed and pushed in its
own repository as `948dd9f` (`ccgen2.c`). No DAIMOS or
`daimos-testkit` code was modified.

## KCC signed 71-bit division/remainder: root cause and repair

`misc/compat/test-kcc-gcc-runtime-helper.sh` originally reached an
assertion failure at `__test_exit=2`: a GCC caller called KCC's signed
71-bit divider, then KCC's signed remainder with the same operands
(-12345 and 37), and the remainder was not -24.

An independent main calling the KCC remainder **before** division,
storing separate volatile results, passed for both operations. That
excluded a generally incorrect signed remainder formula. Inspection
of the original compiler's `runtime-helper-kcc.c` assembly showed
that the inlined divider wrote AC10 through AC14 without saving them.
Those registers are preserved by the GCC/KCC calling convention, and
the GCC caller held its later DImode operands in AC10..AC13.
This was a compiler register-liveness/ABI defect, not a libc symbol
or C assertion error.

The KCC `gdimodedivmod` backend now saves and restores exactly the
call-preserved ACs it selects as raw divider scratch registers.
The operands and result registers are excluded; only the selected
registers are pushed, in order, and popped in reverse order, with
balanced stack accounting. The observed signed-division fixture saves
five ACs; signed remainder saves three. Unused scratch ACs are not
saved. A separately built KCC passed the unchanged mixed test.

To guard against regression, the newly registered
`misc/compat/test-kcc-dimode-scratch-preserve-v1.sh` uses the
original `runtime-helper-main.c`, `runtime-helper-gcc.c` and
`runtime-helper-kcc.c` sources and actual GCC/KCC compilers. It
executes the same original quotient/remainder assertions across
five KCC targets (base, PDP-6, KA10, KI10, KS10) with both KCC
optimized and `-n` output. All **10/10 pass** with the repaired
compiler. The old installed compiler independently fails this new
test's first base/optimized case with `__test_exit=2`.

The repaired KCC binary was installed into `$PDP10_PREFIX/bin/kcc`;
the previous installed compiler was retained as
`$PDP10_PREFIX/bin/kcc.pre-dimode-preserve-20261118-v1`.
The new operational KCC has SHA256
`c95b5bd5d3dcffb3f7ab3572641bfef3de510855bb22c1517ef6891fd6763ad1`.
The existing `kcc-gcc-runtime-helper` script and the registered
10-case regression pass against the actual operational prefix.

## Mixed deep-call register ABI: wrong test constant

`misc/compat/mixed-register-support.s` sets the preserved ACs,
calls `abi_pressure_v24(1,2,3,4)`, checks the return and then checks
every preserved AC before restoring the caller's original registers.
The C function computes six locals (2, 4, 6, 8, 8, 13) and receives
11 from `abi_clobber_v24`, for a sum of **52 decimal**.

The old assembler check `CAIE 1,52` used PDP-10 *octal* syntax:
octal 52 is decimal 42, so the test incorrectly rejected a correct
return value with `__test_exit=4` (as it was entered by the main C
test). The correct assembly immediate is `CAIE 1,64` (decimal 52).
Changing only that single numeric check in a temporary copy made
both mixed compiler directions pass with all preserved-register
checks untouched. The verified correction is now applied in the
original shared ASM fixture. The registered `mixed-call-depth`
test passes with the operational toolchain.

## GCC packed 9-bit records: independently reproduced compiler defect

`misc/compat/test-packed-char.sh` still fails only in its GCC run,
with `__test_exit=010` (octal 8). The existing C assertion
`check_pointer(values)` expects the pointer to increment by one
`struct packed3`, containing exactly three 9-bit characters, then
read values 4, 5 and 6 from the second element.

GCC's compiled `main` writes successive packed records at
`values`, `values+1`, `values+2` **word addresses**. Its
`check_pointer` advances the incoming 9-bit byte pointer by three
`IBP` operations, which lands at the fourth byte of the first
word rather than the first byte of the second record. The calculated
C sizes are `sizeof(struct packed3)==3` and
`sizeof(values)==9`. Those sizes and the word-spaced field stores
cannot all describe the same contiguous array representation.

The original unmodified test fails with the same `__test_exit=010`
at GCC `-O0`, `-O1`, `-O2` and `-Os` on PDP-6. KCC's emitted
stores are byte-contiguous across word boundaries and its test
passes. The GCC backend appears to disagree internally about packed
record array offsets and pointer arithmetic. The relevant source
paths are `gcc/config/pdp10/pdp10.c` (array-offset and packed
component expansion) and `pdp10.h` (record alignment/byte storage).
The exact lowering defect needs further source/RTL investigation.
No workaround or false passing status was introduced.

## Focused post-install validation

| Check | Result |
| --- | --- |
| New KCC preserved-scratch ABI test, 5 targets x 2 modes | 10/10 PASS |
| Existing mixed KCC/GCC signed-71-bit runtime helper | PASS |
| Existing mixed deep-call and preserved-register ABI | PASS |
| KCC ADJBP marshalling, four CPUs | PASS |
| KCC GNU packed aggregate streaming | PASS |
| Mixed KCC/GCC varargs, mixed negative DImode, wide varargs | PASS |
| Installed KCC/GCC freestanding archive extraction and PDP-6 execution | PASS |
| GCC packed-character test at four optimization settings | 0/4 PASS; original asserted failure retained |
| Static compiler matrix/full special suite | **Not run** |

The operational scratch evidence is under
`$TMPDIR/p10tk-abi-diagnosis-20261118-v1`,
`$TMPDIR/p10tk-kcc-operational-20261118-v1.log` and
`$TMPDIR/p10tk-kcc-postinstall-smoke-20261118-v1`.
These are local diagnostic artifacts, not entries in the test inventory.

## Remaining priorities

1. Fix GCC's packed record-array field addressing in its actual compiler
   backend; preserve the existing `packed-char` regression. Verify
   constant/dynamic indexes, word crossings, four GCC optimization
   settings and applicable CPUs, not only the first failing source.
2. Finish the original pending specialized suite prerequisites:
   genuine GNU/BSD make installations and remaining KCC-host checks.
3. Continue the SHA256-pinned deferred semantic sources by blocker
   category, including hosted allocator, old-style varargs and
   compiler-specific GNU features. Do not launch the full matrix sweep
   until these gates are explicitly cleared.
