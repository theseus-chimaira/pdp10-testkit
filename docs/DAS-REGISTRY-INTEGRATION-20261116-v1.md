# DAS registry integration and execution audit (2026-11-16, v1)

## Scope and ownership

`SPECIAL_TESTS.tsv` now owns the ordered list, profile, and timeout for each
direct DAS special test. `tools/run-misc-suites.py` supplies the shared
`DAS_ROOT`, `DAIMOS_REPO`, `PDP10_PREFIX`, and prerequisite build, then
dispatches registry rows. No hardcoded DAS script list remains there.

* `das-fast`: eight ordered `fast` entries after `make all`.
* `das`: the same eight `fast` entries followed by two `full` entries.
* `das-native`: one `native` phase builder, which also owns its nested
  guest-invocation test. The older independent native chain builder remains
  `manual`, outside those automatic suites.
* The remaining DAS helper/checker rows use `nested`; their owning test
  scripts invoke them, so the registry does not execute them twice.

The static inventory auditor rejects unknown DAS profiles, inconsistent
direct/manual states, and a missing `fast`, `full`, or `native` profile. It
does not claim that a source has executed merely because it is registered.

## Changes needed to preserve real tests

Three host DAS C fixtures explicitly select `DAS_HOST` before including
`das.c`, matching the current host/native split. The alias
`pdp10-dec-none-as` is tested with its historical `-b/-a/-l/-o` interface;
standalone `das` retains `-B/-A/-L/-O`. The `-o` flag is intentionally valid
in the legacy interface, not a retired option. The malformed DXR2 metadata
oracle checks the current diagnostic, and the nested linker test passes the
installed `PDP10_PREFIX` through its prerequisite Make invocation.

The streaming test no longer asserts an exact number of parser passes.
Instead, it verifies at least one classification per input statement and a
linear upper bound of eight classifications per input statement plus two
directives. Token-probe bound is 64. The existing strict 65,536-word peak
budget, exact DXR output size, symbol spill, and literal spill oracles remain.

## Executed acceptance evidence

Against independent DAS Git revision `a956d0c4e2f5`, the 2026-11-16 run:

* `./run-misc-tests.sh das-fast`: 8/8 direct entries PASS.
* `./run-misc-tests.sh das`: 8/8 fast and 2/2 full entries PASS.
* The stream stress processed 120,000 words, 12,000 symbols, and 2,500
  literals; reported peak working storage was 10,335 words.

The full tests include native-source host self-checks, KCC assembly corpus,
DXR validation, and DOBJ/DARC/DLINK integration. These are actual executions,
not static census counts.

`./run-misc-tests.sh das-native` is **NOT PASSING**. The first attempt exposed
obsolete assembly filenames (`das1.s`/`das2.s`), repaired to the actual
versioned Makefile outputs (`das1-v1.s`/`das2-v1.s`). After that correction,
the native builder compiled and linked the phase images but stopped at its
existing code-size gate: `das_strip_c_comments` was 94 instructions versus
the 68-instruction hard limit. No native guest PASS is claimed. The gate was
not weakened; investigate source complexity or compiler output before
trying to accept the resident implementation.

## Outside this change

No DAS, KCC, GCC, or DAIMOS production source was changed. No complete
compiler-matrix or cross-CPU coverage is implied. The tools suite still
registers an aggregate rather than individual tool regressions. Existing
`pdp10-doc` state remains unchanged pending full native acceptance.
