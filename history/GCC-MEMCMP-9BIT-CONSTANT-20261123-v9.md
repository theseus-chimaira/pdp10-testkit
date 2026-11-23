# PDP-10 GCC constant memcmp on 9-bit characters (2026-11-23)

## Defect and correction

PDP-10 GCC stores a 9-bit `STRING_CST` character as two host bytes.
The generic constant `memcmp` optimization uses host-byte strings,
which cannot compare logical 9-bit characters correctly. As a result,
the compiler emitted a runtime `memcmp` call even when both strings
and the comparison length were compile-time constants.

`gcc/builtins.c:expand_builtin_memcmp` now uses the existing target
string reader for constant strings, compares unsigned 9-bit character
values in order, and returns a constant sign (-1, 0, +1). It folds
only when the requested comparison length fits both known literals;
all other cases use the existing generic/runtime path.

## Regression and result

`tests/semantic/regression/pdp10-gcc-memcmp-9bit-constant-v1.c`
checks 0400 versus 0377, 0777 versus 0400, equal values, embedded
NUL characters, and differences in the second byte. A deliberately
undefined `link_error` ensures constant comparisons must fold.

The test is registered in `COMPILER_MATRIX.tsv` for 33 supported
GCC semantic profiles. The official testkit runner used the staged
compiler and returned **33 pass, zero failures**.

Checkpoint table:
`workdir/memcmp-9bit-20261123-v1/results-v1.tsv`.

This verifies constant-literal comparison only, not the general
runtime `memcmp` implementation. The installed GCC was not changed.
