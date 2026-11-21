# PDP-6 search functions and GCC regression (2026-10-19, v1)

## Implemented library routines

The shared `libp10c-v2.a` contains three **separately extractable** PDP-6
assembler routines, implemented in the KCC runtime and packaged identically
in the GCC freestanding library:

| Routine | Assembly instruction words | Comparable KCC C words |
| --- | ---: | ---: |
| `strstr` | 28 | 38 |
| `strpbrk` | 13 | 27 |
| `strspn` | 14 | 29 |
| **Total** | **55** | **94** |

These figures count emitted instructions in the respective function bodies,
not archive metadata, link relocation tables, or caller code. The comparison
is 39 words (41.5%) less static routine code. **AAP logical ticks and
elapsed runtime have not been measured**. All three routines use PDP-6
`LDB` and `IBP`, without stack or
writable library data. Each has its own archive object, minimizing resident
memory when only one routine is used. They use no OS services or extended
instructions. The C89 equivalents live in
`tests/semantic/freestanding-search-reference-v1.c` for independent
functional and code-size comparisons; they are not production libc.

The empty-string cases, overlapping patterns, repeated-prefix patterns,
empty match sets, 9-bit data, and offsets crossing 36-bit word boundaries
were checked with `tests/semantic/freestanding-search-v1.c`.

The registered `freestanding-search-v1` test passes with installed KCC
optimized and unoptimized, and GCC `-O0/-O1/-O2/-Os`, all on SIMH PDP-6. Both installed
archives were checked for byte identity. The production linker resolved
`strstr`, `strpbrk`, and `strspn` independently from the archive.

## Compiler issue found and fixed

GCC's 9-bit data emitter buffered subword initializers. The last incomplete
36-bit word could be emitted in `.text` after switching away from `.data`,
corrupting a string or other initialized object. GCC now flushes the pending
word at the end of the object's declaration, before a section transition.
`gcc-9bit-data-section-v1` executes successfully at `-O0`, `-O1`, `-O2`,
and `-Os` on PDP-6. The fix was applied in `gcc/config/pdp10/gas.h`.

## Resolved compiler ICE: 9-bit stack subword ADDRESSOF

The extended `freestanding-search-v1` test originally triggered an internal
compiler error in `put_addressof_into_stack` at GCC `-O1` while handling a
9-bit local stack object already represented by `SUBREG(ZERO_EXTRACT(MEM))`.
The compiler fix shares PDP-10 byte-pointer construction between early
variable-fixup and late address-of cleanup, rather than trying to allocate
the existing stack slot again. The unchanged reproducer is:

```
tests/semantic/validation-gcc/gcc-addressof-pdp6-ice-v1.c
misc/validation/test-gcc-addressof-pdp6-ice-v1.sh
```

The formerly manual regression now runs in the standard test suite and
passes at `-O0/-O1/-O2/-Os`. Full C search regression execution also passes
on PDP-6 at all four profiles. The corrected compiler is installed.
Compilation of the reproducer at `-O1` passed for KA10, KI10, KS10 and
KL10 too; these other targets have not been runtime-tested here.

## Deterministic SIMH executed-step comparison

The benchmark source and driver are:

```
tests/semantic/freestanding-search-benchmark-v1.c
tools/benchmark-freestanding-search-v1.py
```

Each paired program performs 16 searches, verifies a volatile checksum, and
returns zero through the identical CRT. The host driver bisects the
`p10run --step-limit` bound to the smallest instruction count for a
completed run with `benchmark_done_v1=1`,
`benchmark_checksum_v1=20` (octal), and `__test_exit=0`. The same KCC
`-n` (unoptimized) caller and PDP-6 emulator are used on both sides.

| Routine | ASM executed steps | C reference executed steps | Reduction |
| --- | ---: | ---: | ---: |
| `strstr` | 71,243 | 198,011 | 64.0% |
| `strpbrk` | 54,315 | 132,123 | 58.9% |
| `strspn` | 21,771 | 42,939 | 49.3% |

These counts include the common test harness. They are specific to long
searches/repeated-prefix patterns and do not measure PDP-6 elapsed time or
AAP logical ticks. Additional target and short-case comparisons remain open.
Reproduce with:

```
python3 tools/benchmark-freestanding-search-v1.py --compiler kcc --opt noopt
```

The final `strpbrk` implementation advances AC1 directly and returns
without an extra jump or saved pointer; `strspn` reads the unchanged
accept pointer directly from AC2. The updated step counts were checked at
the exact passing threshold and at one fewer step (which did not complete).

For independently optimized GCC `-O2` C reference implementations:

| Routine | ASM steps | GCC `-O2` C steps | Reduction |
| --- | ---: | ---: | ---: |
| `strstr` | 59,626 | 65,770 | 9.3% |
| `strpbrk` | 42,538 | 42,618 | 0.2% |
| `strspn` | 12,954 | 20,714 | 37.5% |

Here `strpbrk` is essentially tied with optimized GCC C on this workload;
its greater confirmed benefit is compact, stack-free code. No routine is
claimed to win every possible workload.

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
