# Deferred variadic ABI category and GCC dynamic va_arg ICE (2026-11-18, v4)

## Scope and source integrity

Continue the prerequisite work in `pdp10-testkit` from v3 (`2917be7`).
This is not a full compiler matrix or DAIMOS OS sweep. The original 269
imported deferred C sources, assertions and disposition decisions remain
unchanged. The corresponding
`PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v4.tsv` preserves every earlier
v1/v2 evidence column, rechecks all original SHA256 pins, and adds two
current operational PDP-6 outcomes for each of 26 `varargs-abi` sources.
Unexecuted cells are `not-probed`, not passing.

## GCC internal compiler error: reproduced and repaired

Original `tests/todo/generic/20020412-1.c` (GCC PR c/3711) uses
`va_arg` to retrieve a variably sized aggregate, with an original
executed assertion for ten ordered ASCII digits. Operational PDP-10
GCC 3.2 `-O0 -march=pdp6` aborted:

    Internal compiler error in pdp10_expand_builtin_va_arg,
    at config/pdp10/pdp10.c:5650

The target backend called `int_size_in_bytes(type)` and unconditionally
`abort()`ed for a negative result, although such a result legitimately
indicates a runtime-sized aggregate. It was a compiler defect, not an
ordinary missing-header failure.

The compiler-only repair is committed/pushed to `pdp10-gcc` as
`66f5a15`. For a dynamic type, it obtains `TYPE_SIZE_UNIT`,
computes the runtime 9-bit-unit size rounded to 36-bit stack words,
and advances the backwards va-list cursor without an ICE. The old
constant-size path remains. Missing/overflowed type metadata produces
a diagnostic, not a compiler abort.

The rebuilt compiler successfully compiles this unchanged source at
`-O0/-O1/-O2/-Os` on PDP-6. The newly registered
`misc/validation/test-gcc-varargs-vla-no-ice-v1.sh` explicitly checks
the original `foo` and `main` assembly labels, with **16/16 passing
compile-only cases**: PDP-6, KA10, KI10, KS10 x all four optimizations.
It is an ICE regression, **not a semantic execution pass**.

The installed GCC 3.2 `cc1` was replaced by the independently built
backend, with SHA256
`09504f4ebd7155f0e9a37bb98c07752d20c7020253250836ce56a2d01bcb8cf7`.
The previous `cc1` is retained under
`$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/cc1.pre-dynamic-varargs-20261118-v1`.
The GCC driver, assembler and linker were not replaced. Two existing
scalar varargs regression sources (`va-arg-1.c` and `931004-10.c`)
also compile and execute successfully using the rebuilt compiler.

The first build had inherited an unrelated, versioned staging-prefix
setting in its historical build directory, causing installed
`<string.h>` lookup to fail even though the compiler accepted the
VLA test. This was corrected at the compiler build configuration:
rebuild `cppdefault.o` with the real `prefix` and `exec_prefix`
set to `$PDP10_PREFIX`, then relink `cc1`. The production installed
header lookup, normal shared freestanding-library archive linkage
and PDP-6 execution test all pass again without `-I` workarounds.
The SHA256 above identifies this final, prefix-corrected compiler.

**Remaining original execution failure:** the variable-size aggregate
test reaches real PDP-6 execution after linking the installed
`kcc-libc-memcpy-v1.s`, but aborts at the first digit assertion.
In a private diagnostic copy of the assembly, its static digit
counter increased from octal `060` to `061` before aborting.
The compiler-generated VLA aggregate copy appears to pass raw
word addresses to a C `memcpy` interface expecting 9-bit byte
pointers. This needs an independent compiler block-copy/ABI analysis;
the source remains deferred, not silently converted into compile-only
semantic coverage.

## All 26 deferred `varargs-abi` sources: operational PDP-6 retest

Two unchanged 52-cell category-scoped batches ran. The first captured
the GCC ICE; the second used the repaired operational GCC/KCC compilers.
The only changed status was GCC `20020412-1.c`: `compiler_ice`
became `run_fail`. Both original and current statuses are preserved
in the versioned v4 manifest.
After rebuilding `cc1` with the correct production header prefix, a
third **GCC-only** run rechecked all 26 sources. All 26 GCC statuses
matched the preceding repaired-compiler run exactly, with no ICE.

| Actual stage/status after repair | KCC `-n` | GCC `-O0` |
| --- | ---: | ---: |
| Pass | 0 | 0 |
| Compile failure | 23 | 2 |
| Link failure | 3 | 1 |
| Runtime failure | 0 | 23 |
| Compiler ICE | 0 | 0 |
| **Total** | **26** | **26** |

Evidence and full per-cell logs:

- `$TMPDIR/p10tk-deferred-varargs-20261118-v3` (pre-ICE-fix)
- `$TMPDIR/p10tk-deferred-varargs-operational-20261118-v4` (post-fix)
- `$TMPDIR/p10tk-deferred-varargs-gcc-prefix-20261118-v4b`
  (post-install-prefix correction, 26 GCC cells, identical outcomes)
- `$TMPDIR/p10tk-gcc-operational-vla-no-ice-20261118-v1.log`
- `$TMPDIR/p10tk-gcc-vla-20020412-20261118-v1` (diagnostics)

The blockers are not interchangeable. Many KCC tests require the
historical `varargs.h` dialect, which is not part of its installed
headers; others use GNU `__SIZE_TYPE__` or compiler-specific syntax.
`920501-8.c`, `920726-1.c`, and `strct-varg-1b.c` expose actual
hosted `printf`/`sprintf` dependencies in one or both compilers.
The installed freestanding `libp10c-v2.a` deliberately does not
provide those hosted services. GCC's 23 actual runtime failures need
individual calling-convention and assertion review. No deferred test
was promoted, deleted, rewritten or treated as passing.

## GCC packed record-array investigation (distinct unresolved defect)

The earlier original `packed-char.c` failure persists at all four
GCC PDP-6 optimizations. A source-level trial in
`gcc/config/pdp10/pdp10.c` excluded packed records from subword
constant-index tail padding. Its generated static stores became
byte-contiguous, confirming this part of the underlying layout idea.
However, indirect loads from the incremented packed-struct pointer
still treated the pointer as a word address; the original assertion
continued to fail. The partial compiler change was **reverted**.
No codegen workaround was installed or committed, and the test remains
enabled and failing.

## Gates still open before the full matrix

1. Correct GCC packed-record-array storage **and** indirect pointer
   loads together, preserving the original `packed-char.c` assertion.
2. Correct variably sized aggregate copy/call ABI, then execute
   unchanged `20020412-1.c` end-to-end, not only compilation.
3. Decide whether KCC supports historical `varargs.h` and implement
   only a real, verified target ABI; keep it separate from `stdarg.h`.
4. Resolve hosted `printf`/`sprintf`/allocation prerequisites
   independently of freestanding libc.
5. Complete GNU/BSD make and other specialized-suite prerequisites
   before requesting a full compiler matrix sweep.
