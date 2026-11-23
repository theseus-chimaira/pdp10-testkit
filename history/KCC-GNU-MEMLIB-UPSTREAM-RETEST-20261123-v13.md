# KCC GNU builtin memory functions: 110 linker failures repaired

Date: 2026-11-23.

## Original failure

The priority testkit rerun marked 110 KCC cells from five GCC
upstream semantic test sources as `link_fail`. KCC treated
`__builtin_memcpy`, `__builtin_memset`, and `__builtin_strcmp` as
undeclared external C functions. The compiler emitted those exact
names into assembly and `dlink` failed with undefined symbols.

The five unchanged upstream sources are:

| Source | Profiles | Operation |
| --- | ---: | --- |
| `tests/semantic/upstream/extensions/20000703-1.c` | 22 | memcpy, memset |
| `tests/semantic/upstream/extensions/20000815-1.c` | 22 | memset |
| `tests/semantic/upstream/extensions/20001026-1.c` | 22 | memset |
| `tests/semantic/upstream/extensions/20011121-1.c` | 22 | memcpy |
| `tests/semantic/upstream/extensions/921007-1.c` | 22 | strcmp |

These were not missing runtime implementations. The installed KCC
freestanding library already provides real, 9-bit PDP-10-safe
`memcpy`, `memset` and `strcmp` implementations, which the official
testkit harness links based on actual referenced symbols.

## Compiler repair

`ccstmt.c:gnu_builtin_memlib_v13` recognizes exactly three GNU
builtin spellings when an otherwise undeclared function is called.
It supplies function argument and return types using KCC's existing
type/prototype constructors: byte pointers, void pointers, a
character for memset, and a size argument. It retains each
`__builtin_*` identifier independently from ordinary C library names.

`ccout.c:outmiref` translates the external builtin references into
the existing `memcpy`, `memset` and `strcmp` linker names. It does not
rewrite an explicitly defined `__builtin_*` function. For long
identifier output, internally linked symbols (`SC_INTREF`,
`SC_INTDEF`, `SC_INLINK`) are prefixed with `$`, preventing local
static functions from colliding with public libc symbols. Legacy
nonlong identifiers retain KCC's original SIXBIT mapping.

The upstream `921007-1.c` contains a `static strcmp` alongside a
macro that invokes `__builtin_strcmp`. The first attempt incorrectly
aliased the builtin to the static function and failed the compiler.
The corrected symbol model emits separate `$strcmp:` and
`pushj 17,strcmp` entries, and that source now passes on all profiles.

This is genuine compiler lowering to the existing library, not a
source rewrite, fake stub or runtime-library change.

## Verification

The final staged compiler is built with KCC's own cross.mk into
`$TMPDIR/pdp10-kcc-memlib-build-20261123-v16/kcc`, separately from
the installed compiler and previous checkout binaries.

The original five upstream sources passed all 110 registered KCC
target-execution cells with the staged compiler. The result identities
were matched exactly to all 110 old `link_fail` checkpoints in
`workdir/priority-rerun-20261123-v1/category-results-20261123-v1.tsv`.
The original successful experiment is in
`workdir/kcc-gnu-memlib-20261123-v16/results-v1.tsv`.
The final rebuilt-compiler recheck is in
`workdir/kcc-gnu-memlib-20261123-v19/results-v1.tsv`.

The new C89 semantic regression
`tests/semantic/regression/pdp10-kcc-gnu-memlib-shadow-v1.c`
requires the builtin memory functions to return correct pointers,
read/write correct target bytes, and remain separate from a source's
static `memcpy`, `memset` and `strcmp`. It is registered for 22
KCC profiles; all pass. The original and final result files are
`workdir/kcc-gnu-memlib-shadow-20261123-v17/results-v1.tsv` and
`workdir/kcc-gnu-memlib-shadow-20261123-v20/results-v1.tsv`.

Sixteen adjacent KCC compiler-only cells from `char-pointer.c`,
`function-pointer.c`, `string-literals.c` and `struct-copy.c`
had identical `compile_only` results with staged and installed KCC:
`workdir/kcc-static-linkage-adjacent-20261123-v18-staged` and
`workdir/kcc-static-linkage-adjacent-20261123-v18-installed`.

The installed KCC under `$PDP10_PREFIX` was not replaced. The native
DAIMOS multi-phase build was not separately checked. This patch
fixes the 110 observed cases, not other hosted-library dependencies.
