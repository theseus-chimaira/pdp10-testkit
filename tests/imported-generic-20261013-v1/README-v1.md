# Generic regressions imported from daimos-testkit

These checks were copied (not removed from their original repository) after
classifying them as generic KCC/GCC compiler, build-contract or bare-metal
PDP-6 CPU tests. No DAIMOS kernel, filesystem or boot image is required by
this imported batch. Original test names are retained for identification.

Host-side KCC source/build checks need KCC_REPO and may also require BMAKE,
MAKESYSPATH or a host compiler. Bare-metal tests require PDP10_PREFIX and
TMPDIR. The GCC multidimensional-char test requires PDP10_PREFIX and DAS.

These tests are not yet inserted into the full TEST_MATRIX.tsv: first verify
individual runner environment contracts and prevent redundant matrix entries.
Originals in daimos-testkit are intentionally left untouched at this stage.

## Initial focused checks (2026-10-13)

- `target/daimos-kcc-local-word-array-pdp6-v1/run.sh`: PASS using the
  installed KCC and `p10run` for PDP-6.
- `gcc/pdp10-gcc-multidim-char-20261012-v1.sh`: FAIL at `-O0` with
  `lost the 103-byte row stride`. Preserve as a regression pending a
  compiler-side investigation; this migration does not change GCC.

No comprehensive suite or regression matrix was executed.

## Matrix integration v1

Six semantic source wrappers are registered in `TEST_MATRIX.tsv`. Their
original test functions are compiled unmodified into `matrix-semantic-v1.c`,
with `main` recording the returned failure code in `fail_id`.
The multidimensional char wrapper exercises row stride, adjacent columns,
and pointer decay by execution, not by assuming a particular MULI sequence.

Matrix cells are scheduled as `semantic` for each supported CPU/compiler
profile. PDP-6 with the `pdp10` target family is `unsupported` because that
family cannot execute on PDP-6. `semantic` means scheduled for verification,
not a historical pass claim.

Initial focused evidence: PDP-6 native KCC optimized and GCC `-O0` both
executed all six wrappers successfully (12 passes). Other CPU, family and
optimization combinations have not yet been plausibility-reviewed. Each
imported test requires one documented cross-cell comparison before acceptance:
compare observable `fail_id`/`got` values, generated assembly and any legal
CPU-specific instruction choices. Do not infer correctness from compilation
alone or require identical instruction sequences across optimization levels.

The 17 imported host-side shell regressions are not CPU/optimization-specific;
they remain outside the CPU matrix until a dedicated host-check execution
category is implemented. The original target shell runners remain as focused
standalone reproductions, not additional matrix cells.

## Additional focused review

The runner now recognizes GCC `.comm` and `.lcomm` result variables, so
`__test_exit` and `fail_id` are actually asserted rather than silently
omitted. With that correction:

- All five KCC-origin tests passed on PDP-6 with native optimized KCC and
  native GCC `-O0`; on KA10 with unoptimized KCC; and on PDP-6 with GCC
  `-O2` and KS10 with GCC `-Os`.
- The multidimensional character test passed with native KCC on PDP-6 and
  KA10, but failed with GCC on PDP-6 (`-O0`, `-O2`) and KS10 (`-Os`). The
  first observed failure is `fail_id=1`, indicating that an indexed row store
  overwrote the byte at a different row. It is not merely an assembly-pattern
  mismatch. Do not modify GCC as part of testkit integration.

Full cross-cell assembly plausibility comparison and the 17 imported
host-side test integrations are still pending. No full matrix sweep was run.
