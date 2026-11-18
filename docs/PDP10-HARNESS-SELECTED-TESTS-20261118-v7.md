# Specialized test harness connection and single-ID execution (2026-11-18 v7)

## Scope and priority

This checkpoint addresses **harness routing, registration, and unconnected
tests only**. The GCC dynamic variadic VLA aggregate-copy failure in
`tests/todo/generic/20020412-1.c` is classified as a separately recorded,
still failing compiler/ABI semantic issue. Its precise cause is not yet
isolated between outgoing argument lowering, block-copy address/length
construction, and the runtime calling convention. Do not continue compiler
debugging during harness integration; retain the unchanged source, recorded
failure, and deferred status for the future full compiler sweep.

## Actual connection inventory

The current static ownership and registry checks find:

| Category | Count | Meaning |
| --- | ---: | --- |
| Compiler matrix sources | 2,108 | Registered source identity, not a passing cell |
| Specialized registrations | 284 | Unique names with explicit group, runner, profile, activation, timeout |
| Direct enabled specialized tests | 234 | Explicit suite-dispatched roots |
| Manual specialized tests | 44 | Owned roots intentionally excluded from automatic suites |
| Nested DAS helpers | 6 | Registered under a parent; never independently dispatched |
| Owned Python/shell scripts | 425 | Includes registered and delegated/helper scripts |
| Unowned or disconnected discovered scripts | 0 | Static ownership result, not an execution claim |
| Deferred compiler sources | 269 | Known, classified compiler work; not silently scheduled |

The matrix also contains pending and `no_test` profile cells. Those
labels denote different review/CPU-applicability states and are **not**
evidence of unowned source files. Likewise, a listed script may have
unsatisfied toolchain, hosted runtime, simulator, make or media
prerequisites; static reachability does not prove executable coverage.

## Exact-ID execution, without widening the suite

`run-misc-tests.sh` retains all existing group routes unchanged.
Two opt-in commands now use the authoritative `SPECIAL_TESTS.tsv`:

```sh
./run-misc-tests.sh list-manual
./run-misc-tests.sh run-id test-script-ownership-v4
./run-misc-tests.sh run-id kcc-pdp6-rounded-fp-boundaries-v2 --manual
```

The final command is **illustrative only**; the historical mathematical
PDP-6 rounding oracle is intentionally known to disagree with DEC
hardware case 9, so execution must not be counted as passing merely
because it was explicitly selected.

Selection uses the registered runner, absolute in-repository path and
per-test timeout. An unknown/duplicate name, unsupported runner,
invalid/nonpositive timeout or escaped/missing path fails closed.
Manually registered tests require `--manual` in addition to their exact
ID. Nested DAS checkers are always rejected by this entrypoint:
they must retain their owning aggregate's preparation, execution and
oracle sequence. The independently built `pdp10-tools` suite and
DAS jobs that need prepared images/builds are likewise rejected for
single-ID invocation; use their existing named group suite instead.
KCC-host selection preserves the existing explicit `KCC_REPO`
source-tree prerequisite.

The registered host `test-special-suite-dispatch-v1` now covers
the new exact-ID behavior with intercepted subprocesses. It asserts
one enabled test executes once, a manual test does not execute without
the flag, the same test runs once with the flag, nested or unknown
IDs cannot execute, and a prepared `pdp10-tools` case cannot escape
its suite. It also compares the actual `list-manual` output to all
44 manual registry entries in declaration order. This is **static/
mocked dispatch validation**, not execution of manual regressions.

One real low-risk host-only selected run was performed using
`run-id test-script-ownership-v4`; the ownership check passed.
Its existing suite entry remains registered as before.

## Next harness work

1. Continue prerequisite-aware, bounded execution of *connected*
   specialized suites whose actual runtime status is still unknown.
   Do not claim full special-suite coverage from dispatch tests.
2. Review manual roots individually for valid execution environments,
   especially DAIMOS-boot-backed native compiler/assembler cases.
   Preserve manual status until prerequisites and oracles are verified.
3. Keep source registration/ownership and matrix status checks
   independent of compiler correctness. No matrix activation or
   full compiler sweep is authorized by this harness checkpoint.
