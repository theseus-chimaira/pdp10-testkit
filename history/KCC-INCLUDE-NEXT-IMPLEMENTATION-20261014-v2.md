# KCC `#include_next` and installed target headers — 2026-10-14 (v2)

## Compiler implementation

KCC now recognizes GNU `#include_next <name>` and `#include_next "name"`.
Unlike `#include`, both forms start searching **after** the header search
directory that supplied the current file. The preprocessor records that
directory (explicit and implicit header paths are distinguished) on the
nested include stack and restores it on pop.

KCC's lexer can pop a short header while scanning the operand of a
directive at EOF. The include origin is therefore captured when the
directive begins, before parsing its filename. This avoids accidentally
starting again at the first search directory and recursing forever.
Inactive `#include_next` directives are skipped without diagnostics.

## Installation

The KCC `install` target now installs the compiler-specific `self/include`
headers under `$(KCCLIBDIR)/include`, including its `sys/` subdirectory.
For `PREFIX=$PDP10_PREFIX`, the testkit discovers these headers at
`$PDP10_PREFIX/lib/kcc/include`. `KCC_INCLUDE_DIR` overrides that directory
for development without depending on an assumed sibling checkout.

## Validation

- Host KCC rebuilt successfully with `make cross`.
- Installed the compiler and target headers into a versioned staging prefix.
- Compiled the existing `stdarg.h` probe against the staged headers without
  the previous unsupported-directive warning or preprocessor ICE.
- `pp-include-next-v1.c` is registered in `COMPILER_MATRIX.tsv` as a KCC
  preprocessing regression. It tests both delimiter forms, progression
  across three `-I` directories, returning from nested includes, and a
  directive excluded by `#if 0`.
- Testkit's preprocessing path now honors file-specific KCC options, so
  these directory-specific tests exercise the real matrix compilation path.

This addresses header discovery and preprocessing, **not** the varargs ABI,
libc implementations, or broader cross-CPU execution of deferred tests.
