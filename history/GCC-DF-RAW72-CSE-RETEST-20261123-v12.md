# GCC PDP-10 D-format constant reinterpretation and CSE repair

Date: 2026-11-23.

## Root cause

The 33 original GCC runtime failures in
`tests/semantic/validation-gcc/runtime-helper/libgcc_helper_ownership_fp.c`
all reached its last comparison (`fail_id=19`, displayed as octal 023).
The target-executed `__negdf2(1.5)` helper returned the correct two
36-bit words for -1.5, but optimized GCC compared its first word
against an incorrectly truncated immediate. The failure was not in
libgcc's software negation or ABI.

The first wrong immediate appeared in GCC's `09.cse` RTL dump. Earlier
RTL still compared two register words taken from a union. The
`gcc/emit-rtl.c:gen_lowpart_common` conversion from a floating
`CONST_DOUBLE` to an integer representation assumed two 32-bit
chunks, even for PDP-10's 72-bit D-format. The target's
`REAL_VALUE_TO_TARGET_DOUBLE` provides three 32-bit chunks. In the
big-endian case the generic conversion also indexed beyond its
four-element chunk buffer. CSE then treated the truncated result
as a valid known integer word and replaced the comparison.

## Compiler correction

`gcc/emit-rtl.c` now provides a guarded 64-bit-host PDP-10 path for
72-bit floating `CONST_DOUBLE` reinterpretation. It collects all
three target chunks, rebuilds the two 36-bit target words, and
packs the raw 72-bit result into the integer constant without any
numeric float-to-int conversion. The other target/mode paths remain
unchanged. The generated optimized comparison now uses the complete
high word, octal 0576200000000, instead of a truncated immediate.

No runtime library source, assembler, or linker was modified.
The compiler under `$PDP10_PREFIX` was not overwritten.

## Verification

Using the staged rebuilt GCC and the unmodified existing full
`libgcc_helper_ownership_fp.c` source, all **44 registered GCC
profiles passed** on the target emulator, including the original
33 `run_fail` profiles. Results:
`workdir/libgcc-fpneg-20261123-v15/results-v1.tsv`.

The full original 414-GCC-ICE-cell checkpoint was rerun with the same
staged compiler. All 414 cell keys match the previous v12 checkpoint.
Exactly 33 cells transitioned from `run_fail` to `pass`, all belonging
to `libgcc_helper_ownership_fp.c`; all other statuses were unchanged:

| Outcome | Prior v12 | Current v16 |
| --- | ---: | ---: |
| `pass` | 205 | 238 |
| `compile_fail` | 176 | 176 |
| `run_fail` | 33 | 0 |
| `compiler_ice` | 0 | 0 |
| Total | 414 | 414 |

Results: `workdir/ice-retest-fpneg-20261123-v16/results-v1.tsv`.

The additional isolated C89 regression
`tests/semantic/regression/pdp10-gcc-df-raw72-cse-v1.c` is registered
for 44 GCC profiles. It checks the high and low raw D-format words
of positive and negative constants, and the union reinterpretation
around `__negdf2`. The repaired staged compiler passed all 44
(`workdir/gcc-df-raw72-20261123-v17/results-v1.tsv`). The installed
previous compiler passed 11 and crashed in 33 optimized cells
(`workdir/gcc-df-raw72-installed-20261123-v18/results-v1.tsv`),
showing this test detects compiler bugs independently of the linker.

## Remaining scope

The only unresolved outcomes among the original 414 GCC ICE cells are
176 ordinary diagnosed compilation failures from four KCC-specific
packed-aggregate sources. Other priority-rerun link, timeout and
policy categories remain separate; this checkpoint is not a complete
testkit sweep.
