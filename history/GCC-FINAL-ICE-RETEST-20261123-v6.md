# GCC PDP-10 final ICE cleanup and complete original-baseline retest

Date: 2026-11-23.

## Final two compiler defects

The 14 remaining ICEs after `workdir/ice-retest-20261123-v8` had
two unrelated causes:

1. `tests/semantic/upstream/generic/20010329-1.c` (11 cells) emitted
   `(xor:SI (const_int ...) (const_int ...))` through
   `gcc/config/pdp10/pdp10.c:pdp10_emit_cmp_and_jump_insns`. The
   unextended byte-pointer comparison path passed immediate constants
   to `gen_xorsi3`, whose first operand must be a register or memory.
   The corrected lowering folds a constant XOR-and-rotate at compile
   time and materializes the result in a register. Nonconstant input
   is made a register or memory operand before the XOR. The original
   extended-pointer rotation path is preserved.
2. `tests/semantic/gcc-historical-b01-v1/20020321-1.c` (3 cells)
   triggered `reload.c:3548`, `unable to generate reloads for`, when
   comparing a single-precision floating value with a nonzero
   constant on PDP-6 at `-O1`, `-O2` or `-Os`.
   `gcc/config/pdp10/pdp10.md` had three specialized comparison
   patterns (`*snesf`, `*sltsf`, `*sgesf`) whose templates are only
   correct for zero. They used the broad `immediate_operand` predicate
   alongside the zero-only `R` constraint, allowing recognition of
   nonzero constants which reload could not satisfy. Those patterns
   now explicitly use `pdp10_const_double_0_operand`, leaving nonzero
   values to the general comparison patterns.

## Verification

The staged GCC compiler rebuilt, including generated machine-pattern
tables. Focused checks showed `20010329-1.c` compiling at `-O0`,
`-O1`, `-O2`, and `-Os`; `20020321-1.c` also compiled at all four
optimization levels.

The official testkit cell runner retested exactly the 414 GCC cells
originally marked `compiler_ice` in the priority rerun. The keys and
individual checkpoints were independently checked (414 unique rows,
no missing checkpoints). Only the two target sources changed status
from the v8 baseline.

| Outcome | v8 | v9 |
| --- | ---: | ---: |
| compiler_ice | 14 | 0 |
| pass | 191 | 205 |
| compile_fail | 176 | 176 |
| run_fail | 33 | 33 |
| Total | 414 | 414 |

Transitions: 11 `20010329-1.c` cells and 3 `20020321-1.c` cells
changed from compiler ICE to pass. No other cell changed result.

Results: `workdir/ice-retest-20261123-v9/results-v1.tsv`.

## Scope of success and unfinished work

**Zero GCC ICEs are left among the 414 original GCC ICE cells with
the staged compiler.** This does not establish a clean full testkit:
176 cells remain ordinary diagnosed compilation failures in four
KCC-specific packed-source cases, and 33 are runtime failures of
`libgcc_helper_ownership_fp.c`. The 1,613-cell priority rerun also
included KCC, link, timeout and policy failures outside this GCC
compiler-focused cycle. Those were not retested after this final
patch, and their previous statuses have not been overwritten.

The compiler has not been installed into `$PDP10_PREFIX`; this
report describes staged compiler behavior and directly observed
testkit results.
