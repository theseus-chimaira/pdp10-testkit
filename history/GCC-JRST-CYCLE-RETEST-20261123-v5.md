# GCC PDP-10 JRST cycle and label-preservation repair (2026-11-23)

## Failure and root cause

The original GCC source
`tests/codegen/upstream-gcc/compile/goto-1.c` uses a legal label
within a loop and an unconditional branch that produces a cyclic
unconditional-jump chain under `-Os`. The compiler ICEs were observed
in 11 GCC size-optimization cells.

AddressSanitizer showed unbounded recursion between
`pdp10_output_jrst`, `final_scan_insn` and the generated jump template;
it ultimately terminated with stack overflow. The existing self-jump
check was insufficient for cycles containing two or more labels.

The first candidate added cycle detection but exposed a second bug:
`follow_label` could bypass and delete a label that was still targeted
by emitted assembly. DAS rejected the resulting `%L5` undefined
reference. The accepted repair fixes both paths:

1. The output optimizer checks the reachable label-only jump chain
   with Floyd cycle detection (constant additional memory) before
   recursively expanding an adjacent jump instruction.
2. The operand printer's `follow_label` does not rewrite or discard
   labels when the chain reaches a cycle. The original branches remain
   available for assembly and for infinite-loop semantics.

This corrects the optimizer's safety predicate, rather than adding
an arbitrary recursion limit or skipping the test.

## Verification

- GCC compiled `goto-1.c` at `-O0`, `-O2`, and `-Os` without ICE.
- GCC `-Os` output assembled successfully using DAS for `base`,
  PDP-6, KA10, KI10, KS10 and generic PDP-10. The earlier cycle-only
  candidate failed DAS with an undefined label; it was not accepted.
- A full staged retest of the original 414 GCC ICE cells changed
  exactly the 11 `goto-1.c` entries from `compiler_ice` to `pass`.
  No other cell changed result.

Current totals: 191 pass, 14 GCC ICE, 176 diagnosed compile failures,
33 runtime failures. The two ICE sources still open are
`20010329-1.c` (11) and `20020321-1.c` (3).

Full status report: `workdir/ice-retest-20261123-v8/results-v1.tsv`.
The compiler was staged and not installed; the complete 414-cell pass
is a regression check, not a full testkit suite run.
