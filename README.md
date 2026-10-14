# PDP-10 bare-metal processor testkit

This repository tests the PDP-10 processor architecture and its bare-metal
software toolchain: compiler semantics and code generation, assembler, ISA,
ABI, object format, linker, and CPU execution. CPU variants include PDP-6,
KA10, KI10, KS10, and later supported implementations.

Tests must not require DAIMOS, an operating-system runtime, filesystems,
boot images, or emulated peripheral devices. Tests of device controllers and
other hardware beyond the processor do not belong here. DAIMOS-dependent
regressions belong in `daimos-testkit`; generic host-tool regression tests
may remain here if they exercise processor-oriented tooling only.

Set `PDP10_PREFIX` to the installed toolchain prefix. Use
`./run-misc-tests.sh verify` for specialized compatibility checks, `./run-tests.sh -j 6`
for the matrix, `./run-tests.sh list` to enumerate cells, and
`./run-misc-tests.sh clean` to remove generated artifacts. The compiler matrix is
`COMPILER_MATRIX.tsv`; specialized suites are listed in `SPECIAL_TESTS.tsv` and
run by `./run-misc-tests.sh`. Runner usage is described in `docs/parallel-cells.md`.

DAIMOS C language and ABI measurements are maintained in the `TOOLCHAIN/DAIMOS-*.MD` documentation under the separate `pdp10-doc` repository. The KCC KL10 EXTEND decision is recorded in `TOOLCHAIN/KCC-EXTEND-DECISION.MD` there. This testkit keeps executable tests and test-specific operating policies.

Active matrix-registered compiler sources are organized under `tests/semantic/`,
`tests/codegen/`, and `tests/isa/`. Unscheduled upstream imports and
unregistered negative/host tests are retained under `tests/todo/`; moving
sources there does not imply they have passed. Supporting source files included
by registered tests remain next to their owning tests. The dated import batch
was consolidated into `tests/semantic/imported/` and `tests/todo/imported-host/`.
