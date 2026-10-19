# Deferred header/libc prerequisite retest (2026-10-19, v1)

This is a **limited PDP-6 dependency and execution retest**, not a complete
compiler/CPU/optimization sweep. Existing upstream regression sources remain
unaltered. The shared freestanding routines are from the installed
`$PDP10_PREFIX` toolchain; no libc algorithm was replaced or stubbed.

## Confirmed header problems and corrections

1. `support/include/string.h` previously redeclared `size_t` with a typedef.
   Installed KCC `stddef.h` defines `size_t` as a macro, which made that
   typedef invalid C and rejected `20000910-2.c`. Include `<stddef.h>` rather
   than guessing or duplicating the compiler's target type. The test now
   compiles, links, and executes with KCC PDP-6.
2. GCC's bare-metal installation includes a compiler-provided `stddef.h`,
   `stdarg.h`, `stdbool.h` and `varargs.h`, but does not install a target
   `stdlib.h`. A minimal `support/include/stdlib.h` supplies *declarations*,
   not implementations, for ordinary C library interfaces. The real existing
   `support/exit-v1.s` and `support/abort-v1.s` still implement the termination
   semantics. `20000910-2.c` now passes under both compilers.
3. KCC's installed include tree lacks `stdbool.h` but its compiler already
   accepts native C99 `_Bool`. A proper testkit `stdbool.h` mapping `bool`
   to `_Bool` and defining `true`/`false` restored the *original* semantic
   test `20010604-1.c`: **both KCC and GCC PDP-6 execution PASS**. No fake
   integer substitute or compiler change was required.

The installed KCC include directory already contains `stddef.h`, `stdlib.h`,
`stdio.h`, `string.h`, `stdarg.h`, `limits.h`, `ctype.h`, `errno.h` and `time.h`.
Missing from the installed KCC header tree are `stdbool.h` (now supplied
by the testkit), `math.h` and historical `varargs.h`.
Declarations are not proof of linked implementations. GCC's target installation
has no hosted `stdio.h` or full `math.h` under the currently tested paths.

## Actual isolated PDP-6 results

All `KCC` measurements here used installed KCC `-n` and PDP-6. All `GCC`
measurements used installed GCC `-O0 -march=pdp6`. The testkit's actual
bare-metal CRT and termination harness required `__test_exit=0`.

| Source basename (retained upstream test) | KCC | GCC | Decision |
| --- | --- | --- | --- |
| `20000910-2.c` | PASS | PASS | Active: `strchr`, exit/abort test |
| `20001011-1.c` | PASS | PASS | Active: `strcmp` and function name |
| `20020828-1.c` | PASS | PASS | Active: char-array indexing after `memset` |
| `20020830-1.c` | PASS | PASS | Active: function pointers, indexed byte stores and `memset` |
| `921006-1.c` | PASS | PASS | Active: meaningful `strcmp` comparison |
| `20010604-1.c` | PASS | PASS | Active: native `_Bool`, `stdbool.h` and argument passing |
| `20010925-1.c` | PASS | PASS | Keep deferred: `memcpy` contents not asserted |
| `950221-1.c` | PASS | PASS | Keep deferred: `strcpy` occurs only on unreachable branch; test primarily concerns another ABI path |
| `20010915-1.c` | PASS | run_fail | Compiler/semantic candidate; existing `strcmp` links |
| `20020828-2.c` | run_fail | PASS | Compiler/semantic candidate; existing `memset` links |
| `20020828-3.c` | run_fail | PASS | Compiler/semantic candidate; existing `memcpy` links |
| `strlen-1.c` | PASS | run_fail | Compiler/target-layout candidate; existing `strlen` links |
| `string-opt-13.c` | compile_fail | PASS | KCC rejects `__SIZE_TYPE__`; GCC libc link and run pass |
| `string-opt-1.c` | undefined `strstr` | undefined `strstr` | Truly missing freestanding function |
| `string-opt-2.c` | undefined `strpbrk` | undefined `strpbrk` | Truly missing freestanding function |
| `20020406-1.c` | compile_fail | undefined `malloc` | Heap allocator is not part of freestanding libc |
| `va-arg-15.c` | compile_fail | run_fail | KCC lacks old `varargs.h`; GCC compiled but failed the actual variadic ABI assertions |

**Do not infer optimization correctness from any `-O0`/`-n` passing test.**
The existing testkit runner's status and diagnostic reports remain in versioned
`$TMPDIR/p10tk-*` probe folders. For repeatable future probes, use:

```
python3 tools/probe-deferred-libc-v1.py --source tests/semantic/upstream/generic/20000910-2.c
```

`tools/probe-deferred-libc-v1.py` calls the actual semantic runner without
modifying the matrix, records status/report paths in `results-v1.tsv`, and
does not treat expected investigation failures as harness success. It is
registered as a *manual* specialized test because it requires source inputs.

## Runtime implementation inventory: make decisions before adding code

The installed freestanding PDP-6 assembler already implements `memcpy`,
`memmove`, `memset`, `memcmp`, `strlen`, `strcmp`, `strncmp`, `strcpy`,
`strncpy`, `strcat`, `strncat`, `strchr`, `strrchr`, `strtok`, `strcspn`,
and the raw byte-pointer primitives. **Do not reimplement these** until an
independent correctness or performance investigation justifies it.

| Gap | Preliminary policy recommendation | Reason |
| --- | --- | --- |
| `strstr`, `strpbrk`, `strspn`, `memchr` | Consider compact assembler routines, only after explicit decision | Pure bounded-memory string operations; currently missing from installed freestanding implementation (the first three are used by deferred tests) |
| `isprint` and other `ctype` operations | Consider small 9-bit-character routines if real consumer coverage warrants them | Header declarations do not mean implementations exist; keep byte/locale semantics explicit |
| `atoi`, `abs`, `qsort` | Evaluate separately; no current mandate to implement in assembler | Distinct performance/algorithm and RAM tradeoffs; measure before selecting assembly |
| `malloc`, `calloc`, `realloc`, `free`, `alloca` | Do not introduce a test-only heap/stack allocator | Requires defined ownership, heap/stack boundaries and ABI, not dummy functions |
| `printf`, `fprintf`, `sprintf`, streams and other hosted stdio | Keep out of the mandatory bare-metal suite unless a real OS-independent runtime is justified | Formatting/streams are substantial and `stdio` tests often exercise their observable effects |
| `pow`, `floor` and other libm | Defer/consider GCC-only or hosted execution | Requires correct floating-point and mathematical-library behavior, not merely a header |
| Legacy `varargs.h` | Do not synthesize KCC compatibility macros | Obsolete GNU/K&R varargs semantics and an actual GCC runtime failure require independent ABI validation |
| `_Bool` / `stdbool.h` | **Resolved:** add only the standard testkit header | KCC native `_Bool` behavior actually passed; no compiler change or fabricated type needed |
| GNU `__builtin_*` function lowering | Evaluate GCC and KCC separately | Mapping ordinary libc calls is not equivalent to implementing compiler builtins or optimizations |

`strcspn` is **already present** in the assembler library. Some tests have
additional optimization-only assertions; those must be exercised at the
appropriate optimization profile before activation, even if a library link
succeeds at `-O0`.

## Follow-up

1. Decide whether to add the small, OS-independent missing string routines
   (`strstr`, `strpbrk`, `strspn`, optionally `memchr`) as production code.
   If adopted, implement and benchmark in the shared library source project;
   keep independent executable regressions here.
2. Re-run other genuinely meaningful deferred cases with existing headers and
   the installed library before attributing failures to compilers.
3. Separate unimplemented hosted facilities from language tests that can be
   executed freestanding; preserve upstream test cases where possible.
4. Only afterward investigate the now clearly separated KCC/GCC runtime
   failures. Genuine compiler ICEs remain the highest-priority exception.
