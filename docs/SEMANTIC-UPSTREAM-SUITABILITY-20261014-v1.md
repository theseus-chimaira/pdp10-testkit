# Semantic upstream suitability review — 2026-10-14

This review follows the per-file v2 classification manifest. No file from this
upstream batch is enabled in `COMPILER_MATRIX.tsv`.

## Removed (23 C sources)

* 14 `ieee/` tests: the imported IEEE-754 tests are not appropriate as
  unconditional execution tests for PDP-10 floating-point semantics.
* Four IEEE-related OS/signal tests under `host-os/ieee/`.
* Four other Unix host tests: System V IPC (`20010724-1.c`) and the
  `/dev/zero`/`mmap` loop tests (`loop-2e/f/g.c`).
* `pdp10-monitor/boot.c`: PDP-10-specific, but not an appropriate bare-metal
  semantic test. Its device/monitor assembly is inside `#if 0` and the source
  is not a standalone test of processor behavior.

The v2 classification manifest preserves removed-file records and their
reasons. This is deliberately different from deleting all PDP-10-specific
sources: the 113 PDP-10 semantic regressions remain for further review.

## Integer width review (36-bit PDP-10)

`SEMANTIC-WIDTH-AUDIT-20261014-v1.tsv` enumerates 35 source files flagged
by explicit 32-bit boundary constants (`0xffffffff`, `0x80000000`, decimal
32-bit maxima), shifts by 31/32, or `sizeof(...) == 4/8` expectations.
These indicators do **not** prove all tests are invalid: a 32-bit mask can
be an intentional bitfield, a shift by 32 is legal on 36-bit words, and
PDP-10-specific branches may already have corrected expectations. The test
`pdp10/pdp10/990106-2.c`, for instance, explicitly uses `__pdp10__` and
expects the 36-bit result. Conversely `wide-int/920501-9.c` formats two
32-bit halves of a supposed 64-bit `long long` and needs a different test
contract for a 36-bit machine. Flagged sources remain physically present
but are marked `review-width`; do not register them blindly.

## Compiler extensions (73 source files)

`extensions/` is a *review category*, not a blanket assertion that KCC or GCC
implements the feature. It contains `__builtin_memcpy/memset`, string and
stdio builtins, `__builtin_constant_p`, `__attribute__` alignment/packing,
GNU local labels (`__label__`), builtin setjmp, computed behavior, prefetch,
and GNU/C99 complex-number constructs (`_Complex`, `__complex__`,
`__real__`, `__imag__`).

Memory and string builtins, alignment/packing, integer-related builtin and
local-label cases may be valuable after individual compiler/harness checks.
Complex-number cases are not candidates for KCC C99 test execution in the
current project policy; compiler-specific builtin and OS stdio runtime tests
need separate feature checks and should not be enabled without verification.
All 73 entries are marked `review-extension` in the manifest.

## Auxiliary assembler support

`support/920428-1.s` is KL10-targeted assembly using `.DIRECTIVE KL10`,
`XMOVEI`, `ADJBP`, byte pointers and unresolved external symbols. This may be
useful as a **DAS/ISA assembler** regression if dependencies and target mode
are provided. It is not a standalone C semantic test. Retained but deferred.

## Host OS cases

The eight identified host-OS sources depend on Unix APIs, signals or kernel
headers. They were removed rather than adapted with stubs: adding shims would
not exercise the originally intended environment. One was PDP-10-unrelated
IRIX compatibility, three were `mmap`/`/dev/zero` loops, and four were IEEE
and signal/OS-dependent cases.
