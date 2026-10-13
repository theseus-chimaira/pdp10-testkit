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
