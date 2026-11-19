# PDP10 standalone repair and ownership review - 2026-11-19 v1

## Unsafe P10FOLD/DLINK local relocations: fixed

The original `p10fold-local-section-v1141` detected a genuine
cross-object alias: equal numeric LOCAL TEXT offsets in separate DOBJ
files were treated as equivalent relocated addresses. DAIMOS host
`p10fold.c` and the independent DLINK fold-plan validator `dlink.c`
now reject such external LOCAL references unless the target is ABS or
relocation remains inside the matched span with the same relative
offset. **Both** comparisons need the fix; changing only P10FOLD left
DLINK accepting a deliberately malformed plan.

Production commit: DAIMOS `01e58f2`. The two host tools were rebuilt
with `-std=c99 -Wall -Wextra -Werror`, installed into `$PDP10_PREFIX/bin`,
and their previous binaries backed up as `*.pre-local-reloc-v1`.
`p10fold-local-section-v1141` and `p10fold-io-skip-v1` both passed
through registered manual dispatch, as did the complete generated
P10FOLD/DLINK link contract against these binaries. No original
fixture or negative linker assertion was weakened.

## KINIT: moved to the operating-system testkit

`kcc-kinit-adjsp-codegen-v1` inspected assembly generated from actual
DAIMOS KINIT source. It did not belong in a standalone compiler suite.
The source-based script and its original assertions now live under
`daimos-testkit/tests/validation/daimos-kinit-pdp6-stack-codegen-v1.sh`,
dispatched by `make test-daimos-kcc-pdp6-codegen`. It **passed**.
DAIMOS production commit `01e58f2` fixes the stack-mode stamp by
defining the watermark variable before the Makefile target expansion.
DAIMOS-testkit commit `d6e864f` owns the migrated test. The original
PDP10 special registration and its script have been retired. The
historical 19-test manual report is unchanged as an execution record;
current standalone manual inventory is 18.

## KCC induction pointer: added to compiler matrix, defect deferred

The new standalone C89 runtime test
`tests/semantic/regression/kcc-indptr-call-v1395.c` exercises a loop
that writes an array through an intervening function call and checks
its pointers, values and call count. The regular matrix now selects
native PDP-6 KCC optimized and unoptimized cells. An optional exact
`--source` path filter permits bounded individual matrix reruns without
starting the entire corpus. A nonexistent source fails closed.

Actual SIMH execution: KCC PDP-6 **noopt PASS**, **opt RUN_FAIL**
(`__test_exit=2` rather than zero). Reports and assembly are preserved
under `$TMPDIR/kcc-indptr-matrix-v1395-20261119-v1/`. The older
manual assembly-pattern checker remains as an additional shape oracle
for `-O`, `-O=gen` and call-free optimization. Its compiler failure is
not reclassified as success. Compiler repair is deferred by user choice.

## AAP illegal-relocation diagnostic: coherent APR-latch query

Current PDP-6 emulator revision `ac603e8` had deliberately removed
AAP pulse-class traces and its old `cpustatus` console command. A
read-only, simulation-thread `cpustatus` and `aprclass` interface
restores deterministic HALT acknowledgement and coherent APR exception
snapshots without restoring the obsolete pulse clock. The test now
checks `APR_CLASS_V1 ILLOP` after HALT instead of searching for an
unavailable `AAP_CLASS_EVENT_V1` timestamp.

The diagnostic completes with ordinary JRST controls reporting HALTED
and no ILLOP. Other relocation/mode candidates still do not HALT
within their bounds and are reported **unresolved**. This is an actual
control/diagnostic recovery, **not** proof of positive ILLOP events or
pulse-level AAP exception coverage. The emulator source commit is
`b60b1e4` (local). Its GitHub push was attempted but blocked by
missing HTTPS credentials; it has **not** been published remotely.

## Static ownership follow-up

Current inventory: 2,211 compiler matrix sources; 259 special
registrations (235 enabled direct, 18 manual, six nested); 392 owned
shell/Python scripts after moving the KINIT script. All **21/21** registered host verification checks pass after the
final ownership move, using the registered runner. Logs are under
`$TMPDIR/pdp10-postrepair-host-20261119-v2/`.
KCC self-hosted DAIMOS guest compiler bugs remain deferred.
