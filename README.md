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

Set `PDP10_PREFIX` to the installed toolchain prefix. Use `make verify` for
compatibility checks, `make test` for the matrix, `make list` to enumerate
cells, and `make clean` to remove generated artifacts. The full matrix is
`TEST_MATRIX.tsv`; runner usage is described in `docs/parallel-cells.md`.
