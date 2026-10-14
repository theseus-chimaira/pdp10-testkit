# Nonportable C stress tests (2026-10-14, v1)

Tests that intentionally depend on undefined, unspecified or implementation-
specific C behavior may be retained as **nonportable stress** coverage.
They are not normative semantic regression tests: a change in result or a
failure against an assumed outcome must not, on its own, be reported as a
compiler correctness regression.

Preserve the original test and assertions. Record the exact nonportable
assumption and observed compiler/CPU results. Such tests may be executed
for diagnostic comparison, but must be distinguishable from mandatory
pass/fail semantic checks. An undefined-behavior failure is not automatically
an ICE; genuine compiler crashes still require investigation.

The classification manifest uses `stress-nonportable` for these cases,
separately from `active` and `deferred`. Before wiring an automated stress
runner, it must report observations without counting expected semantic
outcomes as mandatory correctness checks.

## First classified case

`tests/todo/generic/20000603-1.c` passes KCC and GCC PDP-6 `-O0`, but
`f(&a, (struct s2 *)&a)` reads an object declared as `struct s1` through
an incompatible `struct s2 *`. Those types are not compatible merely
because their layouts match. The required return value is therefore not a
portable correctness assertion; keep the upstream source unmodified.
