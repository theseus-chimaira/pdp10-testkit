# Explicit standalone special-test runner - 2026-11-19 v3

`run-special-tests-v1.sh` executes manual special tests separately from
the compiler matrix and default suites. The current registry contains
18 standalone manually selected roots, none requiring native booted
DAIMOS execution. The 25 native KCC/DAS/DLINK guest registrations and
all 71 source/helper files now belong exclusively to `daimos-testkit`.

```
./run-special-tests-v1.sh list
./run-special-tests-v1.sh run TEST_ID
./run-special-tests-v1.sh run-all
```

Individual tests retain the timeout, interpreter and explicit manual
gate supplied by the existing dispatcher. `run-all` is intentionally
opt-in and can include exploratory diagnostics, an unresolved PDP-6
floating-point oracle and benchmarks; it does not establish a clean
regression result just by being invoked. `list` never executes tests.
The `tools/test-run-special-tests-v2.py` dispatch test intercepts all
child processes to confirm selection and rejection behavior.

Guest-native test selection is now handled only by
`daimos-testkit/tools/run-native-toolchain-v1.py`. See the ownership
report `TESTKIT-SCOPE-MIGRATION-20261119-v4.md` for the 71-file return.

## Focused manual input and executed acceptance (2026-11-19)

The deferred-libc diagnostic requires an explicit source before it
can be selected by ID. For example:

```
PDP10_DEFERRED_LIBC_SOURCE=tests/semantic/upstream/generic/20000910-2.c \
    ./run-special-tests-v1.sh run deferred-libc-probe-v1
```

The native DAS manual build root is now selectable by its exact ID
without starting the entire DAS suite; it builds its own native phase
images. The other prepared/nested DAS and tools entries remain gated.
The complete observed 19-root manual sweep is recorded in
`history/PDP10-MANUAL-RUNTIME-SWEEP-20261119-v1.md`. Six manual roots did
not pass; consult that report before treating manual suites as clean.

The 2026-11-19 KINIT ownership correction reduced manual entries
from 19 to 18: its DAIMOS kernel-source check now runs through
`daimos-testkit`, not this standalone compiler/ISA test runner.
