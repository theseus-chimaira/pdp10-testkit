# Inactive upstream codegen import audit (2026-10-14)

Audited `tests/todo/codegen/upstream-gcc/` (900 files, including 873 C
sources and 27 support files). A conservative automatic source/harness
classification was followed by a focused KCC PDP-6 compile check.

## Retained in the compiler matrix

- 277 independent `torture-unsorted` compile/codegen sources.
- 6 standalone `gcc-dg` compile sources without expected diagnostics,
  nonportable assembler, custom options, target clauses, or external headers.
- Total: **283** source rows in `COMPILER_MATRIX.tsv`, group
  `codegen-upstream-imported`, stored in
  `tests/codegen/upstream-gcc-imported/`.
- Compiler profiles follow the existing KCC/GCC matrix. PDP-6 with the
  PDP-10-only target family remains unsupported. These cells are *scheduled*,
  not certified as passing for every compiler, CPU, or optimization level.

## Not imported

The remaining **617 C sources** and their supporting files were removed from
this inactive import batch as requested. Exclusion categories include:

- DejaGNU preprocessing, run, and link tests (not ordinary codegen cells).
- Diagnostic tests (`dg-error`, `dg-warning`, `dg-bogus`) that require a
  diagnostic harness or different expected-result semantics.
- Source tests using target restrictions, host/target-specific assemblers,
  configuration options, or unprovided include-file dependencies.
- Preprocessor (`gcc-dg/cpp/`) and debug-format (`gcc-dg/debug/`) cases,
  which cannot be meaningfully certified by assembly generation alone.
- Special DejaGNU multi-file or target-specific cases.

No new replacements or synthetic stubs were introduced. This was a selective
import, not an implementation of a DejaGNU frontend. The removed files may
remain available from the upstream GCC sources, but are no longer in this
repository.

## Checks

- All retained sources resolve from the matrix; no old todo codegen files
  remain.
- Twenty representative `torture-unsorted` sources compiled successfully
  with PDP-6 KCC, unoptimized.
- Earlier broad samples showed KCC compile failures among unsupported
  preprocessor/debug tests, which were then excluded.
- A complete compiler/CPU/optimization sweep and GCC run were **not** done.
