> Suitability review and 23 subsequent deletions: `SEMANTIC-UPSTREAM-SUITABILITY-20261014-v1.md`. The v2 TSV manifest now marks removed sources.

# Upstream semantic classification v2 — 2026-10-14

This supersedes the deletion-only portability pass in
`SEMANTIC-TODO-PORTABILITY-AUDIT-20261014.md`.
All 773 original upstream torture-execute C sources and one `.s` support
source have been restored and assigned individual destinations in the adjacent
`SEMANTIC-UPSTREAM-CLASSIFICATION-20261014-v2.tsv` manifest.

The new `tests/semantic/upstream/` tree classifies tests by **actual intended
semantic coverage and obvious external requirements**, rather than by the
GCC import date. `generic` covers general C execution, `pdp10` preserves
PDP-10-specific variants, `wide-int` covers multiword arithmetic, `varargs`
covers calling-convention behavior, `extensions` tracks compiler-specific
language features, and `ieee` captures floating-point assumptions.

Special review-required categories are `inline-asm` (7), `host-os` (8),
`pdp10-monitor` (1), and `support` (1). The privileged `boot.c` is retained
for source review only; bare-metal code must not blindly execute its monitor
and hardware instructions. PDP-10-specific tests are **not** automatically
incompatible with the testkit, whereas OS monitor interactions may be.

**No tests from this batch have been enabled in `COMPILER_MATRIX.tsv`.**
Source classification is not proof that code compiles on both KCC and GCC,
that tests have a standalone harness, that they can run without an OS, or that
PDP-10 floating-point/char/long-long semantics match their assumptions.
Per-test suitability and runner integration remain separate work. In
particular, nonportable branches behind preprocessor conditions must be
reviewed before activation. No source content was changed in this pass.
