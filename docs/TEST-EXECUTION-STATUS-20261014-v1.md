# Test execution infrastructure review, 2026-10-14 (v1)

This review changes the testkit, not KCC or GCC.  Rejection tests which
expose compiler ICEs remain registered as negative tests and must keep failing
until corrected in their compiler repositories.

## Bare-metal upstream termination

`support/crt0-upstream-v1.s` supplies `__test_exit` when an imported semantic
source does not already define it.  The semantic runner selects this startup
only for such sources.  `support/exit-v1.s` and `support/abort-v1.s` provide
separate termination routines for either startup, unless the compiled test
already defines the corresponding function.  The runner requires
`__test_exit=0` for every executed semantic test, including those using the
existing `support/crt0.s`.  A return from `main` and `exit(status)` propagate
their actual status; `abort()` records a failing status and halts.  Neither
function is replaced by an unconditional success stub.

`misc/validation/test-upstream-crt-v1.sh` checks `return 0`, `return 1`,
`exit(0)`, `exit(1)`, and `abort()` on PDP-6 KCC.  The negative cases also
check that the simulator reported a failed `__test_exit` assertion, not an
unrelated link or execution failure.  This contract passed with the complete
test tool prefix used for the review.  The unmodified upstream bitfield test
`semantic/upstream/generic/20000113-1.c` also ran successfully as a focused
PDP-6 KCC pilot; it is **not yet** registered as active across the matrix.

This provides correct termination, not a full libc.  Tests with unresolved
standard-library or other external references still require real runtime
implementations or individual suitability decisions.  Unreviewed sources
must not be mass-enabled merely because the startup now exists.

## Registry and validators

The five existing top-level Python verification checks now have explicit
`SPECIAL_TESTS.tsv` rows, retaining their original execution order.  Special
rows respect their declared timeout; a failed row no longer prevents later
tests in the same group from executing.  The group prints a summary and exits
unsuccessfully if any test failed.  `kcc-all` includes `kcc-host`, with the
KCC repository path validated by the dispatcher.

The optimization source inventory now contains the seven upstream GCC
codegen cases previously missing builtin/varargs classification.  The
`verify-optimization-common-source` check passes with 86 differential-helper
entries.  The added inventory records *comparability*, not compatibility or
successful execution of a source.

## Actual execution findings

The KCC host suite ran all 17 registered cases against the current KCC
checkout: 13 passed and four failed.  The obsolete `findptr` regression was
updated to exercise the production `findtype`, `findnode`, and `findsymbol`
functions and now passes.  Two failed tests compare native build recipes to
historical git revisions (`daimos-kcc-native-make-recipe-equivalence-20261010`
and `kcc-cross-native-autovars-20261010`); investigate their changing
prerequisites before accepting or rejecting the historical expectations.
Two others (`kcc-cross-native-targets-20261010` and
`kcc-unix-make-portability-20261010`) require `BMAKE` and `MAKESYSPATH`,
which were unavailable in this run.  No compiler changes were attempted.

The full `verify` suite passed all five Python checks and the first three
compatibility cases in the installed-tool prefix used for validation, then
encountered `ks10rt.s` missing from the installed KCC runtime directory.
That prefix installs machine-specific runtime fragments instead of the
monolithic file assumed by many older compatibility scripts.  This is a
testkit runtime dependency issue; the correct future fix is to select the
appropriate runtime fragments for each test and CPU rather than fabricate
an `ks10rt.s` or silently omit needed symbols.

## Work remaining before all sources are executable

- Classify and activate suitable upstream semantic tests individually, with
  real libc/runtime dependencies and verified non-vacuous assertions.
- Replace legacy monolithic KCC runtime assumptions in special tests with
  CPU-correct, symbol-checked fragment selection.
- Complete DAS registry ownership and prerequisites; currently only a
  subset of listed DAS scripts are invoked directly by aggregate suites.
- Resolve host make prerequisites and historical expectation drift.
- Execute each compiler/CPU/optimization cell; a correct runner does not
  imply a test passed or that its required compiler is installed.
