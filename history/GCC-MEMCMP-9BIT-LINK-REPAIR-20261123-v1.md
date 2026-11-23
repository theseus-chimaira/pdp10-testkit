# GCC PDP-10: constant 9-bit memcmp folding and linker failures

Date: 2026-11-23.

## Failure

The original GCC test `tests/todo/generic/generic/string-opt-16.c`
compares literal strings using `memcmp` with constant lengths. When
compiled at `-O1`, `-O2`, or `-Os`, its deliberately undefined
`link_error` symbol must be eliminated by constant folding. All
33 optimized GCC cells in the priority rerun instead failed with
`dlink: undefined symbol: link_error`.

This was a compiler optimization defect, not a missing function that
should be supplied by a test stub. The symbol is an explicit test
oracle. Adding a definition would conceal the defect.

## Compiler root cause and repair

`gcc/builtins.c:expand_builtin_memcmp` uses `c_getstr` and host
`memcmp` to evaluate known literals. On the PDP-10, `c_getstr` must
reject 9-bit `STRING_CST` values because each logical target character
is stored in two host bytes. Comparing those host bytes is not
equivalent to comparing unsigned target characters.

The compiler already has `pdp10_builtin_string_data_init` and
`pdp10_builtin_string_char`, which read logical 9-bit target
characters with correct offsets. `expand_builtin_memcmp` now uses
those existing helpers to fold two constant literal arguments of a
known length, checking that the length is within both actual literal
bounds before comparing. The result is the correct negative, zero,
or positive integer sign. No runtime helper or linker workaround
is introduced.

## Target-executed verification

The unchanged original upstream test was rerun in all 44 registered
GCC configurations. **44 passed**, including all **33 former
link failures**, with exact matching keys against the priority
rerun (`workdir/priority-rerun-20261123-v1`).

The new source
`tests/semantic/regression/pdp10-gcc-memcmp-9bit-constant-v1.c`
is registered on 33 optimized GCC profiles. It tests 9-bit character
values `0400` through `0777`, embedded NULs, unequal and equal
strings, both `memcmp` and `__builtin_memcmp`. An intentionally
unresolved `link_error` ensures all constant cases truly fold.
**All 33 new tests passed.** Nonoptimized profiles are not included
in this fold-required regression because the optimizer is not active.

Both groups were executed by the official target-emulator testkit,
not merely compiled. Results:
`workdir/gcc-memcmp-9bit-20261123-v10/results-v1.tsv`.

## Scope

The original 414 GCC compiler-ICE baseline was separately rerun after
this change under `workdir/ice-retest-20261123-v11/results-v1.tsv`.
All 414 identities and results match the preceding v10 baseline:
205 passes, 176 diagnosed compilation failures, 33 runtime failures,
and **zero compiler ICEs**. KCC's use of GCC-specific
`__builtin_memcpy` and `__builtin_memset` remains a separate
compatibility issue, not fixed by this GCC patch.
