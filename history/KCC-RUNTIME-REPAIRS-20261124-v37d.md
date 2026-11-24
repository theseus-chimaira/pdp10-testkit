# KCC runtime repairs v37d (2026-11-24)

KCC commits b929249, f7d138c, c8618fb. Installed hosted SHA256:
6cc10d24ce39ad7fe2b9362f63edafe06bc04ea9f9b4906e94266cd39fb5c2c4.

- Correct UL suffix type; supply existing GNU builtin memory prototypes
  for undeclared memcpy/memset. Explicit declarations and strict mode
  retain their normal treatment.
- Check floating constant node type before removing addition of zero;
  account for conversion helper calls when preserving incoming arguments.
  Double comparisons ignore the redundant continuation-word sign bit.
- Wide shifts use the low count word; multiply includes bit 70;
  unsigned division handles the sign bit of the reconstructed remainder.
- Wide scalar truth and constant folding use both words. Fold a constant
  logical RHS directly, avoiding a synthetic comparison crash discovered
  by the new regression. No new permanent data structures or library ABI.

Strict installed replay: 97 PASS, 6 run_fail, zero compile or link failures
out of 103 historical KCC cells. Three new sources: 66/66 PASS. GCC not
run or modified. No full sweep. Native compiler execution, RAM and timing
measurements not performed. Unrelated native KGEN edits preserved.

Remaining sources (PDP-6 opt and noopt, two cells each):

- pdp10-enum-code-bitfield-switch-v1.c: fail_id 1, enum lowered to signed
  int; eight-bit bit-field sign-extends 222 to -34. Enum representation
  policy needs review; no policy change or exclusion made.
- pdp10-original-wide-karatsuba-v1.c: fail_id 4, little-endian union
  arithmetic case. Root cause not established; original oracle retained.
- pdp10-original-prime-interval-v1.c: 100000000-step budget exhausted.
  Diagnostic replay of the v37c optimized assembly with 1000000000
  steps and 90-second timeout passed both exit and fail_id checks.
  Standard budget and both historical failing cells remain unchanged.

Exact source/assembly/report hashes and remaining cells are in manifests
ending 20261124-v37d.tsv. Resume from the six-cell remaining manifest.
