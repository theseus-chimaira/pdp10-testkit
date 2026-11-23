# GCC compiler ICE repair and staged retest (2026-11-23)

## Scope

The baseline is the completed priority rerun at
`workdir/priority-rerun-20261123-v1/category-results-20261123-v1.tsv`.
It contained 414 GCC `compiler_ice` cells. This report concerns those
cells only, not the independent KCC, linker, timeout or policy failures.

## Reproduced faults

- C frontend incremented an incomplete pointer after diagnosing the
  incomplete target type.
- Error recovery read an invalid formal parameter type in
  `convert_arguments`.
- Initializers of a malformed aggregate accessed missing field offsets
  while comparing field positions.
- PDP-10 `pdp10_bytesize` inspected a missing `TYPE_SIZE` during RTL
  expansion of an invalid declaration.

The corresponding GCC fixes are in `gcc/c-typeck.c` and
`gcc/config/pdp10/pdp10.c`. The GCC host-build portability repair in
`gcc/system.h` declares a detected but unprototyped `fputc_unlocked`.
These are source fixes, not testcase exclusions.

## Focused testkit results

The registered negative test
`tests/negative/gcc-pdp10/incomplete-member-recovery-v1.c` now passes
on 44 GCC profiles. The full result table is
`workdir/ice-retest-20261123-v3/results-v1.tsv`.

Four existing KCC-specific packed-aggregate sources formerly produced
176 GCC ICEs; all 176 now exit with diagnosed `compile_fail`. They remain
invalid GCC inputs because of KCC-specific type syntax. They were not
silenced, rewritten or classified as semantic passes.

## Complete original-GCC-ICE retest

The exact 414 GCC cells are recorded in
`workdir/ice-retest-20261123-v4/results-v1.tsv`:

| Final state | Cells |
| --- | ---: |
| compiler_ice | 106 |
| pass | 99 |
| compile_fail | 176 |
| run_fail | 33 |
| Total | 414 |

The 33 `run_fail` cells are all from
`tests/semantic/validation-gcc/runtime-helper/libgcc_helper_ownership_fp.c`.
These findings apply to the staged, rebuilt compiler and must not be
mistaken for results of the still-installed compiler.

The remaining 106 ICEs need separate root-cause repair. Do not discard
the recorded failure checkpoints or classify a diagnostic rejection as a
runtime semantic pass.
