# GCC PDP-10 lowercase target macro and noreturn linker regression

Date: 2026-11-23.

## Root cause

The generic PDP-10 GCC driver defined `__PDP10__` and `__PDP10`,
but not the historical reserved spelling `__pdp10__`. The NetBSD
PDP-10 target already provided `__pdp10__`, while the TOPS-20 target
overrode the same predefines without it.

The unmodified upstream source `tests/todo/generic/builtin-noret-1.c`
uses `#ifndef __pdp10__` to exclude its `_eexit` helper, which is not
provided by the PDP-10 environment. Because the generic compiler
omitted the macro, it compiled the unsupported branch; the linker
reported `dlink: undefined symbol: _eexit`. All 16 native GCC
profiles for this source were `link_fail` in the priority baseline.
Adding a `_eexit` test stub would hide an incorrect target identity;
this patch repairs the compiler driver definition instead.

## Compiler change

`gcc/config/pdp10/pdp10.h` now includes `-D__pdp10__` alongside
the existing uppercase predefines in both conditional variants.
`gcc/config/pdp10/tops20.h`, which overrides the generic predefines,
also includes the same reserved lowercase macro. This keeps the
generic, NetBSD and TOPS-20 target identity declarations consistent.
The TOPS-20 configuration was changed in source only; the executable
verification below uses `pdp10-dec-none`.

The compiler driver (`xgcc`), generated specs and `cc1` were rebuilt
as staged binaries. `xgcc -dM -E` confirms both `__PDP10__=1` and
`__pdp10__=1`. The previously installed compiler was not replaced.

## Tests and results

The new C89 source
`tests/semantic/regression/pdp10-lowercase-target-macro-v1.c` is
registered for all 44 applicable GCC profiles. It rejects a missing
uppercase or lowercase target macro at preprocessing time and checks
that both macros have value 1.

The official testkit reran the 44 new regression cells and the
16 registered GCC cells of unchanged `builtin-noret-1.c` using the
staged GCC driver with the rebuilt `cc1`. All **60 cells passed**
compilation, assembly, linking and execution. Specifically, all 16
original `_eexit` linker failures now pass.

Results: `workdir/gcc-lowercase-macro-20261123-v11/results-v1.tsv`.

The original 414-cell GCC compiler-ICE set was retested with the same
staged driver. There were no status changes versus the preceding
baseline: **205 passes, 176 diagnosed compilation failures,
33 runtime failures and zero ICEs**. All 414 keys match exactly.

Results: `workdir/ice-retest-macrodriver-20261123-v12/results-v1.tsv`.

The existing `pdp10-noreturn-reachability-v1.c` regression comment
was updated to reflect that the original test can now execute without
the unsupported branch. No test oracle, runtime stub or link policy
was weakened.

## Remaining scope

With the previous 77 verified linker repairs, 93 of the 560 original
link-failure cells are now confirmed passing. The remaining 467 have
not been exhaustively rechecked and must not be described as current
confirmed failures. KCC handling of GCC-specific builtins and hosted
library dependencies remains separate work.
