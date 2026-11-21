# PDP10 host verification reconciliation - 2026-11-19 v1

## Scope

All 21 currently registered `verify` entries in `SPECIAL_TESTS.tsv`
were executed using `./run-misc-tests.sh run-id ID`.  This is a
host-side static/inventory/runner check, not a full GCC/KCC matrix,
SIMH/AAP execution sweep, or DAIMOS guest-native compiler acceptance.
Logs are retained under
`$TMPDIR/pdp10-host-verification-20261119-v3/`.

## The two corrected audit failures

1. `gcc-c-unmirrored-ownership-v1` was comparing the immutable
   2026-11-16 `adapted-deferred` decisions with the later live matrix
   registrations of `20020402-3.c` and `920728-1.c`.  Those sources
   became active in the reviewed 2026-11-18 semantic batches, with
   actual GCC PDP-6 execution recorded there.  The auditor now keeps
   the historical review and v1 ownership ledger unchanged while
   requiring the exact later activation and source owner in
   `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv`, as well as
   live registered GCC cells.  It recognizes only those two explicit
   post-baseline promotions.  This does not hide their documented
   KCC failure or extension limitations.

2. `verify-optimization-common-source` was missing four annotations
   for shared tests that contain `__builtin_memcpy` or
   `__builtin_memset`: `20000703-1.c`, `20000815-1.c`,
   `20001026-1.c`, and `20011121-1.c` under
   `tests/semantic/upstream/extensions/`.  All are now present in
   `OPTIMIZATION_RESULT_ONLY.tsv`.  Their assertions remain valid,
   but GCC builtin lowering is not comparable directly to KCC's
   compatibility or unsupported builtin handling for code-size or
   performance measurements.  No original C test or compiler source
   was changed.  The checker now finds 90 differential shared
   sources and 90 corresponding annotations.

## Actual verification results

All **21/21** registered host `verify` test executions passed:

* source and script ownership, compiler/OS boundary and registry checks;
* compiler negative-test and output-decoding policies;
* synthetic runner result-accounting, special dispatch, and diagnostics;
* registered source/fixture integrity and deferred dispositions;
* common-source, target symbol and wide-integer/type-adapter guards;
* historical document/source integrity with retained source fingerprints.

The ownership auditor was also exercised against two temporary,
deliberately invalid semantic manifests, changing each newly
activated source from `active` to `deferred`.  Both negative controls
were rejected.  The test did not edit any checked-in classification.

The source inventory remains 2,210 compiler matrix sources, 260
special entries (235 direct, 19 manual, six nested) and 393 owned
scripts.  The separately recorded 19-root manual execution sweep
remains **13 PASS and six not passing**, including two intentionally
disputed floating-point diagnostics; see
`PDP10-MANUAL-RUNTIME-SWEEP-20261119-v1.md`.  No new runtime claim
is made for those cases.
