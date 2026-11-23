# GCC PDP-10 static byte-pointer relocation: verified repair

Date: 2026-11-23.

## Failure and cause

In static initialization of an encoded local byte pointer, the generic
GCC 3.2 `MINUS_EXPR` expansion used `plus_constant(pointer, -offset)`.
That treats the P/S selector in the left half as ordinary arithmetic
bits: subtracting a byte offset can borrow into the selector instead
of correctly advancing the 18-bit word address and intra-word byte
position. Compilation and assembly could succeed with a wrong pointer.

Separately, `fold-const.c:split_tree` could remove representation-changing
casts between word pointers and 9-bit byte pointers and reassociate
pointer arithmetic across them. A/B builds demonstrated that removing
the pointer reassociation guard breaks static initialization even with
the `MINUS_EXPR` fix. Restricting the guard only to direct cast nodes
also failed, because reassociation occurs around the enclosing pointer
expression. The guard remains in the repaired compiler.

The final compiler changes jointly:

- Preserve the typed pointer expression in standalone and aggregate
  static initializers (`gcc/varasm.c`).
- Preserve the target's pointer representation across relevant tree
  arithmetic folding (`gcc/fold-const.c`).
- Fold constant symbolic pointer additions without allocating a
  register, using word-address addition for word pointers and the
  PDP-10 ADJBP simplifier for local byte pointers
  (`gcc/config/pdp10/pdp10.c`).
- Use the same target ADJBP constant-folding semantics for static
  byte-pointer subtraction instead of raw `plus_constant`
  (`gcc/expr.c`).

For the scratch source with an array of pointer-sized words, the
repaired local assembly records a pointer to the first byte of
`object+1` for `(char *)&object.p[2] - 4`, and a pointer to
`object` for `(char *)&object.p[2] - 8`, without changing the P/S
selector. A cast back to a word pointer yields the corresponding
word address. Both `.word` halves remain independent during relocation.

## Runtime regression

The new registered source is
`tests/semantic/regression/pdp10-static-pointer-cast-offset-v1.c`.
It contains volatile static pointer variables and a volatile aggregate
holding pointers, so the emulator must load the initialized data.
It checks negative four-, five- and eight-byte offsets, positive-plus-
negative syntax, conversion back to word pointers, and word values.
The code uses only ASCII and C89 declarations.

Its 44 registered local GCC profiles were executed using the official
testkit harness and the staged rebuilt compiler. All 44 passed.
The original run is saved under
`workdir/static-pointer-rh18-20261123-v24/results-v1.tsv`.
The final restored-guard run is saved under
`workdir/static-pointer-rh18-20261123-v31/results-v1.tsv`.

## Regression checks

The exact 414 original GCC ICE cells were rerun against the repaired
staged compiler with 414 matching keys, no changes versus the last
verified baseline: 205 passes, 176 diagnosed compile failures,
33 runtime failures, and **zero compiler ICEs**.
Checkpoint data: `workdir/ice-retest-20261123-v10/results-v1.tsv`.

The same 19 adjacent pointer regression cells were run with the staged
compiler (`workdir/static-pointer-adjacent-20261123-v29`) and the
previously installed GCC (`workdir/static-pointer-adjacent-20261123-v30`).
All 19 statuses matched exactly: nine passes, two compile-only and
eight pre-existing runtime failures in two separate sources.

## Existing upstream GCC link failure closed (verified v8)

All 44 originally `link_fail` configurations of the unchanged upstream
source `tests/semantic/upstream/generic/20021101-1.c` were rerun using
the repaired staged GCC and the official target-execution harness.
The original compiler emitted a bad RH18 relocation for a static
initializer of the form `(int *)((char *)&x.a[2] - 8)`, and `dlink`
rejected the object with `RH18 relocation overflow`. That initializer
uses precisely the mixed word/byte pointer cast and negative byte
offset corrected here. After the fix, **all 44 configurations pass**
compilation, assembly, linking, and guest execution, not just linking.

The 44 old failure keys and 44 new successful keys match exactly, with
no missing or duplicate configurations. Evidence:
`workdir/static-pointer-upstream-link-20261123-v32/results-v1.tsv`.
This closes 44 of the 560 previously observed linker failures; the
other 516 original failures have not been exhaustively rerun after
the compiler repair and are not claimed resolved.

These results cover local 18-bit right-half pointer relocation. They
do not establish extended-pointer correctness or resolution of the
unrelated runtime failures. The installed compiler was not replaced.
