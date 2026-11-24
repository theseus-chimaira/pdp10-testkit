# Short16 reverse-pointer optimizer timeout repair v20

Date: 2026-11-24

## Original failures

The `runtime-byte-pointer-diff.c` source passed 9/36 GCC profiles
after v19 but produced 11 runtime failures and 16 simulator timeouts.
The PDP-6 O1 timeout was localized to octal PC 005127..005132, a
hidden reverse-IBP loop inside `*ADJBP_noKL10up_const`. The current
pointer was native S=16, but the optimizer had moved the logical
S=1 branch's apparently pure `UNSPEC_ADJBP` calculation before the
S selector check. The untyped reverse search could not reach its
saved pointer and ran past 100 million simulated instructions.

## Compiler repair

`gcc-pdp10/gcc/config/pdp10/pdp10.c` now emits real typed S=1
pointer arithmetic on pre-KL10 hardware. Constant bit counts within
the host-int helper's range are decomposed using the established
`maybe_expand_ibp (1, ...)` arithmetic, adjusting the right half
for full words. Other counts use the explicit RTL pointer-adjustment
routine, so CFG and possible loops remain visible to optimization.
Zero offsets copy the original pointer; KS10 native ADJBP remains
unchanged. This fixes the type/representation confusion rather than
weakening step limits or masking timeouts.

## Regression and original source

The new C89 runtime oracle
`tests/semantic/regression/pdp10-short16-reverse-adjust-v20.c`
tests signed and unsigned short16 arrays, native constant -9 reverse
adjustment, dereference values and dynamic forward/reverse steps.
It is registered in `COMPILER_MATRIX.tsv` for all 36 GCC semantic
profiles. The official runner in
`workdir/pdp10-short16-reverse-v20-isolated` passed 36/36.

The original comprehensive `runtime-byte-pointer-diff.c` was rerun
across all 36 GCC profiles without skipping successes:

| Outcome | Pre-v20 | Post-v20 |
| --- | ---: | ---: |
| PASS | 9 | 33 |
| run_fail | 11 | 3 |
| timeout | 16 | 0 |

The remaining failures are KS10-specific O1 case 0245 (signed 9-bit
load) and O2/Os case 0344 (18-bit halfword selection). These are
separate open defects. None was recorded as passing.

Six already-registered source regressions from v17-v19 were run
from scratch in the same isolated directory against the rebuilt
compiler: 216/216 PASS, strict exit policy, no old green skipped.
These are selected checkpoint results, not a completed full sweep.

The previous installed GCC executable was backed up under
`$HOME/tmp/pdp10-byteptr-o1-v20/`, along with stage and installation
logs. The work uses the established `$HOME/cross` compiler prefix.
