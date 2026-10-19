# PDP-6 search functions and GCC regression (2026-10-19, v1)

## Implemented library routines

The shared `libp10c-v2.a` contains three **separately extractable** PDP-6
assembler routines, implemented in the KCC runtime and packaged identically
in the GCC freestanding library:

| Routine | Assembly instruction words | Comparable KCC C words |
| --- | ---: | ---: |
| `strstr` | 28 | 38 |
| `strpbrk` | 17 | 27 |
| `strspn` | 15 | 29 |
| **Total** | **60** | **94** |

These figures count emitted instructions in the respective function bodies,
not archive metadata, link relocation tables, or caller code. The comparison
is 34 words (36.2%) less static routine code. **Runtime timing has not been
measured**. All three routines use PDP-6 `LDB` and `IBP`, without stack or
writable library data. Each has its own archive object, minimizing resident
memory when only one routine is used. They use no OS services or extended
instructions. The C89 equivalents live in
`tests/semantic/freestanding-search-reference-v1.c` for independent
functional and code-size comparisons; they are not production libc.

The empty-string cases, overlapping patterns, repeated-prefix patterns,
empty match sets, 9-bit data, and offsets crossing 36-bit word boundaries
were checked with `tests/semantic/freestanding-search-v1.c`.

The registered `freestanding-search-v1` test passes with installed KCC
optimized and unoptimized, and GCC `-O0`, all on SIMH PDP-6. Both installed
archives were checked for byte identity. The production linker resolved
`strstr`, `strpbrk`, and `strspn` independently from the archive.

## Compiler issue found and fixed

GCC's 9-bit data emitter buffered subword initializers. The last incomplete
36-bit word could be emitted in `.text` after switching away from `.data`,
corrupting a string or other initialized object. GCC now flushes the pending
word at the end of the object's declaration, before a section transition.
`gcc-9bit-data-section-v1` executes successfully at `-O0`, `-O1`, `-O2`,
and `-Os` on PDP-6. The fix was applied in `gcc/config/pdp10/gas.h`.

## Unresolved, high-priority compiler issue

The extended `freestanding-search-v1` test at GCC `-O1` triggers an internal
compiler error in `put_addressof_into_stack` while handling a byte-sized
PDP-10 local stack object represented by `SUBREG(ZERO_EXTRACT(MEM))`. The
standalone reproducer and manual test are:

```
tests/semantic/validation-gcc/gcc-addressof-pdp6-ice-v1.c
misc/validation/test-gcc-addressof-pdp6-ice-v1.sh
```

This is not a freestanding library defect. Full GCC optimization coverage
remains explicitly blocked. To reproduce the extended sweep, set
`P10_SEARCH_SWEEP_GCC=1`; the ordinary registered libc test retains known
passing profiles and does not claim that the others are accepted. The manual
ICE regression must eventually pass without altering the source or masking
the defect.

## Status of GNU upstream tests

The original upstream `string-opt-1`, `string-opt-2`, and `string-opt-11`
remain deferred. Their missing `strstr`, `strpbrk`, and `strspn` link
dependencies have been supplied, but they test GNU `__builtin_*` semantics
and optimization transformations in addition to libc behavior. KCC does not
implement corresponding GNU builtins; GCC still has runtime failures in
these upstream tests. Do not rewrite libc or silently activate them to
remove these failures.

## Commands

```
sh misc/compat/test-freestanding-search-v1.sh
sh misc/validation/test-gcc-9bit-data-section-v1.sh
python3 tools/audit-test-inventory-v1.py
python3 tools/verify-deferred-disposition-v1.py
```

These tests use the installed toolchain under `$PDP10_PREFIX`. The test
source files, comparisons, and failure reproduction belong in the testkit.
