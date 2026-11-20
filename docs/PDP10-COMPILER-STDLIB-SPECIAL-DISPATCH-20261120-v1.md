# Compiler-owned libc in the registered special-test dispatcher (v1)

Date: 2026-11-20. Scope: **`pdp10-testkit` only**. No compiler,
assembler, emulator, library, OS, or sibling repository was modified.
No complete special/manual/compiler/CPU sweep was run.

## Registered guest runtime selection

The normal compiler matrix already selects the installed compiler
freestanding archive rather than the generic `lib/libc.a`. Many
registered special and regression scripts run `p10run` directly;
without a matching policy those tests would still select the
unrelated hosted OS archive and produce non-comparable results.

`tools/run-misc-suites.py`, the implementation of official
`run-misc-tests.sh`, now applies the same policy for registered
**compiler guest-test groups**:

* `verify`, `compat`, `validation`, `kcc-regression`, `gcc-bare-libgcc`.

The dispatcher uses a versioned process-specific temporary runtime
prefix. Unlike an individual matrix test, one special script may
invoke both KCC and GCC. The shared prefix is permitted only when
the two installed compiler-owned `libp10c-v2.a` archive SHA256s
are **identical**. The current installed archives are identical at
SHA256 `ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.
If they differ, the dispatch fails closed rather than picking the
wrong compiler ABI. The temporary `lib/libc.a` links solely to the
compiler-owned archive. Installed compiler binaries, canonical
`libgcc`, KCC/GCC headers, and freestanding fragments remain
available through read-only-in-intent symlinks to their real paths.
The generic/DAIMOS libc is **not** the default link input for these
registered guest test groups.

Tool builders and host-only groups (`tools`, `kcc-host`, and `das`)
retain their existing installation environment. Their build/install
operations should not be silently redirected through a transient
prefix. They do not establish compiler C standard-library acceptance.
Directly invoking an individual raw shell/Python script outside
`run-misc-tests.sh` likewise does not yet guarantee this policy.

## Focused real execution and static ownership tests

Two exact registered guest roots were executed by the official
dispatcher, not by running their entire group:

| Registered ID | Actual result |
| --- | --- |
| `upstream-crt-v1` | PASS: five PDP-6 success/failure termination checks |
| `kcc-pdp6-float-literal-v1` | PASS: KCC PDP-6 single-float literal in opt and noopt modes |
| `gcc-9bit-data-section-v1` | PASS: GCC PDP-6 9-bit initialized data section in O0/O1/O2/Os |

The dispatcher-created `PDP10_PREFIX/lib/libc.a` was inspected
after execution and resolved to the actual installed compiler
`libp10c-v2.a`, not the generic archive. Compiler installations
were not altered. The separate matrix probe still provides
KCC/GCC native record-copy/memset PASS and missing-hosted-symbol
`link_fail` evidence (see
`PDP10-COMPILER-STDLIB-RUNTIME-20261120-v1.md`).

The registered host-only
`tools/test-special-compiler-stdlib-dispatch-v1.py` verifies the
actual special dispatcher with subprocesses mocked: four exact
single-test roots, all five compiler guest groups, the three
host/build group exceptions, runtime archive ownership, target
header/tool accessibility, and a negative control with deliberately
incompatible compiler archives. The existing exact-ID and manual
dispatch regressions continue to PASS.

## Remaining stop condition

Do not interpret the two targeted special-test successes as a full
compatibility/optimization/CPU sweep. The normal semantic matrix and
registered compiler guest groups use compiler-owned libc, while
standalone raw invocations and host/tool-build suites require separate
review. Preserve all historical generic-libc evidence without
promoting its PASS/timeout/link_fail to compiler-only results.

To rerun only the focused checks:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/test-special-compiler-stdlib-dispatch-v1.py
./run-misc-tests.sh run-id upstream-crt-v1
./run-misc-tests.sh run-id kcc-pdp6-float-literal-v1
```
