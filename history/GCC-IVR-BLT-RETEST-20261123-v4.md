# GCC virtual-register and BLT address ICE repairs (2026-11-23)

## Diagnosis

The original 414-cell GCC ICE baseline was recorded at
`workdir/priority-rerun-20261123-v1`. After the first three compiler
fixes, 63 cells still ICEd. Two more independent RTL defects were
reproduced and corrected in a staged compiler:

1. In `gcc/function.c`, the IVR pass canonicalized a nested
   `subreg:SI(subreg:DF(reg:DI))` source but not an identical
   destination. In `20011217-2.c`, `991228-1.c`, and the DEC sign-bit
   test, the destination was not recognized and an otherwise legal
   virtual stack pointer substitution aborted. The same canonicalization
   now applies symmetrically to both SET operands. Complex DImode
   subregisters retain their separate target patterns.
2. In `gcc/config/pdp10/pdp10.c`, a pointer kept in a stack slot
   reached `pdp10_blt_setup` as a `mem:SI` expression, while the second
   address became `plus:SI(mem:SI, const_int 1)`. These are not valid
   BLT control-word effective-address operands. `expand_blt` and
   `expand_blt_clear` now materialize such memory-held pointers in
   registers before forming the setup and end-address operands.

The fixes correct RTL generation; they do not disable any tests or
relax the compiler ICE exit policy. Temporary diagnostics from the
reproduction were removed from the final GCC source.

## Full staged GCC rerun

The exact same 414 original GCC ICE cells were rerun through the normal
testkit cell runner, using a staged rebuild and not the installed GCC.

| Outcome | Before v6 | After v7 |
| --- | ---: | ---: |
| compiler_ice | 63 | 25 |
| pass | 142 | 180 |
| compile_fail | 176 | 176 |
| run_fail | 33 | 33 |
| Total | 414 | 414 |

Only these five source groups transitioned from ICE to pass:

| Test | ICE -> pass |
| --- | ---: |
| `tests/codegen/upstream-gcc/compile/20020617-3.c` | 11 |
| `tests/isa/pdp10-insn/BLT.c` | 7 |
| `tests/codegen/upstream-gcc/compile/20011217-2.c` | 9 |
| `tests/semantic/upstream/extensions/991228-1.c` | 9 |
| `tests/semantic/regression/pdp10-gnu-dec-signbit-function-v1.c` | 2 |

Results: `workdir/ice-retest-20261123-v7/results-v1.tsv`.

## Remaining ICE groups

- `tests/codegen/upstream-gcc/compile/goto-1.c`: 11
- `tests/semantic/upstream/generic/20010329-1.c`: 11
- `tests/semantic/gcc-historical-b01-v1/20020321-1.c`: 3

The 176 diagnosed KCC-specific packed-source compile failures and 33
libgcc FP runtime failures are still separate gates, not ICE passes.
