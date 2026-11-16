# DAIMOS testkit disconnected-script discovery (2026-11-16 v1)

**Static discovery only, not a test run or an execution-coverage result.**
The separate `../daimos-testkit` checkout has a substantially larger
historical collection of tests than the generic `pdp10-testkit`.
Before attempting a complete suite, it needs its own ownership and
supersession inventory, not wholesale registration of every script.

One read-only tracked-file census covered `.sh` and `.py` sources under
`daimos-testkit/tests/` and `daimos-testkit/tools/`:

| Discovery class | Scripts |
| --- | ---: |
| Tracked scripts observed | 1,680 |
| Paths named literally in top-level Makefile | 363 |
| No literal Makefile path, but named by another script | 348 |
| No literal Makefile path or discovered script-name reference | 969 |

The last class is **not equivalent to 969 missed runnable tests**:
it includes archived superseded tests, experimental and manual
diagnostics, helper modules loaded dynamically, and scripts that may
be invoked through constructed paths or variable names. Static string
references also do not prove that a Makefile target is reachable from
the 31-row `regression` matrix or that referenced assertions execute.

The largest unreferenced subdirectories are `tests/validation` (721)
and `tests/host` (72), with smaller historical/versioned fixture
directories. The host subset includes 17 scripts with corresponding
generic KCC host regression names in `pdp10-testkit/misc/kcc-host`;
seven are byte-identical and ten differ. Differences need an
assertion-level comparison before treating their coverage as the same
or scheduling duplicates. Other host scripts relate to DAIMOS-specific
D6FS, DSH, native MAKE, `rm`, swap and XIP behavior and must retain
their original project ownership if still relevant.

The independent historical GCC testsuite is a separate obstacle:
the **currently selected** `gcc-pdp10` checkout contains no tracked
`gcc/testsuite` tree, unlike the earlier revision used for the v1
cross-repository census. Its 19 historical target-specific test files
cannot be equivalence-reviewed against absent current sources.

## Required classification before execution

For each candidate, determine whether it is (a) actively owned by a
Makefile/regression target, (b) an internally invoked fixture/checker,
(c) already migrated to a generic testkit with equivalent assertions,
(d) an explicitly manual diagnostic requiring real evidence, (e) a
superseded historical artifact, or (f) genuinely disconnected active
coverage needing registration. This needs versioned source-reference
and prerequisites evidence. The very large set of validation versions
must not all be run indiscriminately or marked PASS by registration.

This document does **not** modify `daimos-testkit`, its existing dirty
working files, its Makefile or its acceptance matrix. Broad compiler,
assembler and guest sweeps remain deferred until this second ownership
inventory and the missing-source crosswalk are resolved.
