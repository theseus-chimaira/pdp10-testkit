> Historical preparation-stage report. Current state: `docs/PDP10-SPECIAL-RUNNER-20261119-v3.md`.

# Explicit special-test runner (2026-11-19 v1)

`./run-special-tests-v1.sh list` lists all manually gated registrations.
`./run-special-tests-v1.sh run ID` executes one eligible non-native
registration through the existing timeout-aware dispatcher.
`./run-special-tests-v1.sh run-all` deliberately opts into all eligible
manual tests, including diagnostics and benchmarks; it is not part of
`run-tests.sh` or the default special verification suites.

The 25 `native-toolchain-` and `native-kcc-` registrations are listed as
`native-deferred` and cannot be executed through this entry point. They
are awaiting transfer to `daimos-testkit`, including their fixtures,
registrations and documentation. The DAIMOS testkit checkout currently
contains unrelated working-tree changes; no migration was attempted in
this first bounded patch. Other tests requiring DAIMOS source builds
must be reviewed individually before final ownership changes.

The original `SPECIAL_TESTS.tsv` remains authoritative, and the existing
`run-misc-tests.sh run-id ID --manual` remains functional. No test oracle,
compiler profile, or matrix entry has changed. This runner intentionally
performs no test execution on `list`.

## Bounded dispatcher verification (v2)

`tools/test-run-special-tests-v2.py` checks registry partitioning,
exact-ID selection, complete opt-in selection, continued execution after
one failing test, refusal of native/unknown IDs, and side-effect-free
listing using a mocked subprocess. It is registered as an ordinary host
verification check; it never starts a compiler or simulator.

The 25 native cases are not a standalone move: some contain auxiliary
Python scripts, assembly fixtures, expected probe files, and dependencies
on earlier staged builds. Their new ownership must include the complete
fixture trees and update the old v3 migration audit, which explicitly
rejects native compiler tests under the DAIMOS testkit. Existing unrelated
DAIMOS working-tree changes must be preserved.
