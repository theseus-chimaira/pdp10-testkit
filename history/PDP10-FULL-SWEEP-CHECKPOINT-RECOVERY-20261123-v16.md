# PDP-10 full-sweep checkpoint recovery and installed GCC repair v16

Date: 2026-11-23

## Scope

This is a bounded repair of the already-recorded, interrupted
`workdir/full-sweep-current` run. The complete matrix still has 123,576
scheduled cells. Nothing here claims a complete sweep or repairs the
remaining runtime failures. The existing 1,059 runtime-failure
checkpoints were not reset.

## 1. Interrupted checkpoints

The initial checkpoint census contained 6,968 status files:

| Status | Before |
| --- | ---: |
| pass | 2,781 |
| compile_only | 3,090 |
| run_fail | 1,059 |
| compile_fail | 32 |
| compiler_ice | 2 |
| running | 4 |

All four `running` cells were in
`tests/semantic/runtime/runtime-reduce-struct-blt-byvalue-return-global.c`.
The source-scoped restart used `--skip-failures -j 4 --exit-policy strict`.
It skipped 40 existing passes, retried four interrupted checkpoints,
and ran ten previously missing cells. All 14 executions passed.
The source now has 54/54 PASS checkpoints.

The runner's own result-accounting regression also passed. It checks
restart classification and failure accounting, among other cases.

## 2. Two GCC O0 internal compiler errors

The installed compiler failed at `instantiate_virtual_regs_1` for
`tests/semantic/regression/pdp10-gnu-dec-signbit-function-v1.c` on
PDP-6 and KA10 at O0. The already-updated GCC source in
`gcc-pdp10` built and executed the reproducer successfully in a staged
compiler. The installed `cc1` was older than that source.

The installed `cc1` originally had SHA256:
`fd42b3acb75f07b9dc2aa8e3d34b05db60309d711bfaf7fa59e4e1467db24114`.

GCC was then rebuilt from the current `gcc-pdp10` checkout in a fresh,
out-of-tree build with both `PDP10_PREFIX` and `PREFIX` explicitly set
to `$HOME/cross`. The standard `build.sh --no-regen` completed and
installed the compiler. The newly installed `cc1` has SHA256:
`b4f6fe1e12f87030ba52c70689a8a5b0485204e45fd11d86aa47ab2c596bcf1f`.

The exact failed matrix source was rerun with `--compiler gcc`, strict
exit policy and two workers. Both formerly ICE configurations passed;
the other 14 PASS checkpoints were retained. Result: 16/16 PASS.

## 3. Thirty-two GCC compilation failures

The old installed `cc1` searched a stale private build prefix for its
`limits.h` rather than the intended `$HOME/cross` path. It therefore
published `CHAR_BIT == 8`, triggering explicit `#error` guards in:

- `tests/semantic/regression/pdp10-width-shifts-v1.c` (16 GCC cells)
- `tests/semantic/regression/pdp10-signed-right-shifts-v1.c` (16 GCC cells)

The correctly installed compiler now opens
`$HOME/cross/lib/gcc-lib/pdp10-dec-none/3.2/include/limits.h` and
defines `CHAR_BIT == 9`, `__PDP10__ == 1` and `__pdp10__ == 1`.
The `limits.h` SHA256 remained
`6627c97182848c8909483507607ecda6f3f8f509b86406c78c6ede0e786db233`:
the header content was not defective; the old compiler selected a
different, stale header.

Both exact sources were rerun with `--compiler gcc`, strict exit policy,
four workers and no exclusions. All 32 formerly `compile_fail` cells
compiled, linked and executed successfully (32/32 PASS).

## 4. Final persistent checkpoint census

Counts are from every `cells/*/status` file, not the per-selection
`summary.txt` overwritten by a focused rerun.

| Status | GCC | KCC | Total |
| --- | ---: | ---: | ---: |
| pass | 1,713 | 1,116 | 2,829 |
| compile_only | 2,052 | 1,038 | 3,090 |
| run_fail | 1,047 | 12 | 1,059 |
| compile_fail | 0 | 0 | 0 |
| compiler_ice | 0 | 0 | 0 |
| running | 0 | 0 | 0 |
| **Recorded** | **4,812** | **2,166** | **6,978** |

No C test sources, expectations, compiler source code, or testkit
dispatch logic were changed for this repair. The missing corrections
were already present in the compiler repository; the installed
toolchain needed a correctly prefixed rebuild.

Versioned backups of the previous installed compiler artifacts and
the full build log are retained under `$TMPDIR` on the build host as
`pdp10-gcc-repair-v16-backup/` and
`pdp10-gcc-repair-v16-build.log` respectively. They are not Git
artifacts.

Remaining: 1,059 previously recorded runtime failures, and the
unexecuted portion of the full 123,576-cell matrix.
