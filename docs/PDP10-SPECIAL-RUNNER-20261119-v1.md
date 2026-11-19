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
