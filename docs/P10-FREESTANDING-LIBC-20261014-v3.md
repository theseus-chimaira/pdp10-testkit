# Deferred test libc-link investigation (2026-10-14, v3)

## Policy

Deferred imported semantic tests must not be removed merely because the
minimal assembly-only `p10run` link leaves an ordinary string/memory symbol
unresolved. First link the installed shared assembler libc implementation,
rerun and then distinguish remaining test, compiler and libc defects.

Do not add dummy implementations or duplicate existing libc functionality.
Real libc functions may be written in readable, portable C or PDP-10 assembly.
Prefer assembly only when measurements demonstrate smaller code/RAM use or
better execution speed; correctness and PDP-6 compatibility take precedence.
Avoid replacing a working C implementation without a measured benefit.
Hosted services (`malloc`, `printf`, etc.) require their own implementation
and ABI verification; do not treat them as automatically available from the
freestanding archive.

## First reproduced integration result

`tests/todo/generic/generic/string-opt-13.c` previously failed its GCC
PDP-6 minimal link with unresolved `strcpy` despite successful compilation.
Using GCC `-S -O0` and supplying these installed assembler sources to
`p10run` resolved the link and produced **PASS on PDP-6**:

- `kcc-libc-string-v1.s` (string family, including `strcpy`)
- `kcc-libc-strlen-v1.s`
- `kcc-libc-strcmp-v1.s`

This establishes a genuine missing archive-extraction/link-integration
problem in the original minimal test command, rather than a failure of
these library operations. KCC still needs independent compilation checks;
this GCC result alone does not activate the manifest entry.

Next: make the regular test runner resolve required freestanding archive
members via the production linker, rather than permanently injecting all
library sources or introducing test-only replacements. Rerun deferred libc
tests and only then decide activation, fixes or removal.
