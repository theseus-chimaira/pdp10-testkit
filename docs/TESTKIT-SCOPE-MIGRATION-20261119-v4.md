# PDP10 / DAIMOS testkit ownership - 2026-11-19 v4

The standalone compiler/assembler test matrix is in `pdp10-testkit`.
Tests whose essential execution requires a booted DAIMOS guest are in
`daimos-testkit`, including the opt-in native KCC, DAS and DLINK
integration tests. This is a deliberate change from the 2026-11-17
primary-assertion-only classification; the v3 split report and manifest
are historical records, not today's final file ownership.

The v3 ledger records 150 original transfers: 127 from DAIMOS to PDP10
(99 moved and 28 deduplicated) and 23 from PDP10 to DAIMOS. The native
return recorded in `NATIVE-TOOLCHAIN-RETURN-20261119-v4.tsv` reverses
71 of those 99 movements, restoring the complete 25-suite guest-native
integration tree. The effective remaining compiler ownership transfers
are thus 56 files (28 moved and 28 deduplicated), with 23 earlier OS
transfers and 71 returned native fixture/test files resident in DAIMOS.

Each return manifest entry records the old PDP10 path, returned DAIMOS
path, source hash and original v3 source hash. The 10 original C files
remain byte-for-byte unchanged. Shell wrappers and Python root-builders
were adjusted only for DAIMOS-local file paths; every script is included.
The v4 ledger is mirrored in `daimos-testkit/tests/validation/`.

The normal compiler matrix is unchanged. `SPECIAL_TESTS.tsv` now has
260 entries: 235 enabled direct, 19 manual and six nested. The 25
native guest tests are no longer registered or dispatched here. The
separate `run-special-tests-v1.sh` selects only standalone manual roots.
DAIMOS registers the 25 guest-native roots in its own independent
`NATIVE-TOOLCHAIN-TESTS-v1.tsv`. All guest execution remains opt-in.

Run the following host-only checks after a transfer:

```
python3 tools/test-testkit-boundary-v1.py --require-cross
python3 tools/audit-test-inventory-v1.py
python3 tools/audit-script-ownership-v4.py
python3 tools/test-special-suite-dispatch-v1.py
python3 tools/test-run-special-tests-v2.py
cd ../daimos-testkit
python3 tools/test-native-toolchain-dispatch-v2.py
```

These checks validate identity, source ownership, shell/Python syntax,
fixture checksums, and selection without compiling or booting a guest.
They are not evidence of native test success. Existing staged-build
prerequisites and per-test oracles remain necessary for runtime results.

Post-migration follow-up (2026-11-19): the DAIMOS-owned opt-in
Hello-world native KCC smoke test was added after the historical v4
return. The boundary checker recognizes its exact two files without
changing the 71-file migration ledger. See
`docs/PDP10-POST-MIGRATION-VALIDATION-20261119-v1.md` for current
standalone manual test execution and unresolved historical doc drift.
