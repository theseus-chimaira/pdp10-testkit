# KCC header integration investigation — 2026-10-14 (v1)

## Observations

- The testkit's configured PDP10_PREFIX for the semantic sweep has no
  `lib/kcc/include` directory. Its KCC binary is a symbolic link to
  `/usr/local/bin/kcc`, whose default include lookup attempts
  `/usr/local/lib/kcc/include` (also absent).
- The KCC source repository provides target-facing headers in `self/include`:
  `limits.h`, `stddef.h`, `stdlib.h`, `stdio.h`, `string.h`, `stdarg.h`, etc.
- An explicit `-I` pointing to the source-tree headers allows a simple
  `stdlib.h`/`limits.h` PDP-6 compile probe to succeed.
- The same approach **does not yet work for `stdarg.h`**: KCC diagnoses an
  internal preprocessor error on the GCC-only `#include_next` directive,
  even though `__COMPILER_KCC__` is predefined. That is an independent
  compiler/preprocessor issue to fix rather than masking it in tests.
- Making headers visible does not supply libc implementations or resolve
  calling-convention compatibility. Those are separate follow-up tasks.

## Testkit improvement

The compiler-matrix runner now searches for KCC target headers in
`$PDP10_PREFIX/lib/kcc/include`, with the explicit `KCC_INCLUDE_DIR`
environment variable available for development trees. The existing
`support/kcc`, `support/common`, and `support/include` include precedence is
unchanged; GCC is unaffected. No synthetic standard headers were introduced.

## Next work

1. Correct the KCC preprocessor behavior for inactive `#include_next` and
   revalidate `stdarg.h` without changing the varargs ABI by assumption.
2. Package the KCC target header tree within the supported toolchain prefix
   and verify real installed-header operation, not only an override.
3. Run the blocked header-dependent C tests, separating compile, link, and
   semantic execution outcomes. The initial classification must not be
   changed on compile success alone.
