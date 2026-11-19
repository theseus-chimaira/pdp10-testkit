# PDP10 post-migration validation, 2026-11-19 v1

## Scope

Continue standalone PDP10 compiler/assembler testkit acceptance only.
Native KCC Hello-world timeouts and the KCC `gaddress()` defect remain
deferred to the DAIMOS native toolchain track; no compiler fix is made
in this sweep.

## Completed host-only checks

- `test-testkit-boundary-v1.py --require-cross`: PASS after explicitly
  recognizing the two newly created DAIMOS-owned Hello-world smoke
  files. These are post-v4 files, not historical migration returns.
- `audit-test-inventory-v1.py`: PASS, 2,210 matrix sources, 260 special
  registrations, no unowned test sources.
- `audit-script-ownership-v4.py`: PASS, 393 owned scripts.
- `test-registered-fixture-integrity-v1.py`: PASS, no problems.
- `test-special-suite-dispatch-v1.py`: PASS.
- `test-run-special-tests-v2.py`: PASS, 19 selectable manual roots.
- `test-runner-result-accounting-v1.py`: PASS.
- `test-codegen-declared-oracles-v1.py`: PASS.
- `test-diagnostic-oracles-v1.py`: PASS.

## Actual manual test execution

Using `./run-special-tests-v1.sh run ID` with the current sibling
DAIMOS/DAS/KCC repositories and installed PDP10 tool prefix:

- `das-dxr2-st2-v1070`: PASS, seven ST2/TX2 checker cases.
- `p10fold-io-skip-v1`: PASS, skip-sensitive fold guards and
  non-skipping positive control.
- `kcc-host-make-split-v1`: PASS, native staged KCC graph checks.

These are three **actual test executions**, not mocked dispatch.
The other 16 manual roots were not executed in this sweep.

## Outstanding historical documentation drift

`test-historical-document-paths-v1.py` currently FAILS with 162
reported problems: 109 broken local documentation path references,
52 missing mapped current sources, and one changed mapped source.
The dated source relink registry is
`docs/HISTORICAL-SEMANTIC-SOURCE-RELINK-20261117-v1.tsv`.
Do not weaken the checker or silently change source SHA256 values.
Reconcile each missing/changed source against Git history and preserve
historical report semantics before declaring this audit passing.
This documentation regression is independent of the three manual
runtime passes above.

## Follow-up: historical paths reconciled (2026-11-19)

The 162-problem observation above is preserved as the original audit
result. The historical path checker now passes with zero problems after
relinking the moved sources and separately fingerprinting the reviewed
stdarg adaptation. See
`docs/PDP10-HISTORICAL-DOC-PATH-AUDIT-20261119-v2.md`.

## Follow-up: all manual roots exercised (2026-11-19)

All 19 standalone manual roots have now been attempted using current
installed tools, with 13 passing and six not passing. The explicit
source-bound deferred-libc diagnostic and the native DAS phase build
completed successfully after routing/build-interface corrections.
See `docs/PDP10-MANUAL-RUNTIME-SWEEP-20261119-v1.md` for individual
results, actual benchmarks and outstanding defects.
