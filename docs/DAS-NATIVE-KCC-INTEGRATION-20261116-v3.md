# DAS native size and KCC compound-assignment integration (2026-11-16 v3)

## Verified compiler correctness

KCC `22aedc8` corrects a source-tree bug in the constant compound-
assignment folder (`cceval.c`). Rewriting `*= -1`, signed `/= -1`,
`^= -1`, floating `*= -1.0` or `/= -1.0` to a unary rvalue operation
discarded the mandatory lvalue store. This could also mis-handle an
incremented pointer lvalue. The fixed folder preserves the original
compound assignment and its single lvalue evaluation.

A second bug in `cccode.c` could fold `MOVE S,[-1] / IDIV R,S` into
`IDIVI R,-1`, which uses an unsigned 18-bit effective-address divisor,
not signed full-word -1. The corrected optimizer retains the register
division for negative or wider-than-18-bit divisors.

`misc/kcc-regression/compound-negating-assign-v1.sh` passes eight target
executions: PDP-6, KA10, KI10, KS10, each at optimized and `-n`.
The independent optimized negative-one division test failed before the
fix, while unoptimized passed. The existing terminal-return-chain script
now accepts valid direct `ADD 1,2` output and checks the semantics in
an actual PDP-6 execution, rather than insisting on an extra copy.

## Verified native assembler size and host execution

With DAS source `6dfb707`, the native `das_strip_c_comments` produces
**68/68** instructions at KCC PDP-6 `-O` (originally 94). The separate
`das_read_line` remains **133/136**. No limit was raised. The native
relocation bitmap is now scratch-backed, replacing the permanent static
2,731-word array; maximum DXR image size remains `0300000` octal words.

| Phase | Image (octal words) | BSS | Process including stack |
| --- | --- | --- | --- |
| DAS1 | `033233` | `002032` | `037265` |
| DAS2 | `027751` | `001523` | `033474` |

The image-size, BSS, ownership and phase-chain checks all pass. The
independent DAS host suite passes **9/9 fast plus 2/2 full**. The new
`das-native-relmap-spill-v1.c` mock checks byte-for-byte relocation
bitmap positions, a late update to an earlier bitmap word, the complete
image ceiling, and injected scratch-read errors. It passes.

## Still open: real DAIMOS guest execution

The guest image boots, finds the imported S6REC input, and reports
`/TEMP` mode `01777`, but the guest cannot create even a short scratch
file in the directory. This is a preflight failure *before* DAS1 starts.
The native build and phase-chain checks do not substitute for an
assemble/execute PASS. Root mount read-only policy, blockset write
service and D6FS journal conditions are under investigation.

The earlier v1/v2 reports remain historical records of the 94-word
and 72-word failures, respectively. The current strict size gates pass;
the guest test does not yet pass.
