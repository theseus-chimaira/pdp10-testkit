# Deferred integration: twenty-first ten-source batch (2026-11-18, v29)

## Selection, scope, and result

Review exactly ten previously unreviewed, still-deferred canonical
source identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v22.tsv`, beginning
at `tests/todo/generic/generic/struct-ini-4.c`, after excluding
all v8-v28 ten-source decision ledgers. Read each complete original
source and the assertions it actually makes. Run bounded native
PDP-6 KCC and GCC profiles only. Exclude broad CPU/compiler sweeps,
DAIMOS guest OS tests and all 44 manually gated special tests.

**Nine activated, one retained deferred, one exact one-line source
portability correction, zero sources deleted.** The accompanying
`PDP10-DEFERRED-INTEGRATION-BATCH21-20261118-v29.tsv`
preserves original/current SHA256, original disposition, original
and final compiler outcomes, exact registration statuses,
and each source decision.

Authoritative inventory following this review:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v24.tsv`:
  **542 active, 76 deferred, 58 removed, one stress-nonportable**
  among 677 canonical upstream identities.
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v23.tsv`: **76**
  SHA256-pinned currently deferred sources.
- `COMPILER_MATRIX.tsv`: **2,201** registered sources,
  nine more than v28.
- The separate v21 duplicate consolidation still verifies
  **97 retired source aliases, zero new duplicates and 16
  independent open compiler repair gates**.

## Ten original-source decisions

| Original source | Disposition and verified evidence |
| --- | --- |
| `struct-ini-4.c` | **Activate GCC.** Original GNU old-style field designator `c: {1,2,3}` initializes `struct s` containing `a[3]` and `c[3]`. The original `main` aborts unless `s.c[0]==1`. GCC PDP-6 O0/O1/O2/Os **4/4 pass** and generated code retains the check. KCC noopt **compile fails** with `c` interpreted as an undefined identifier rather than a supported GNU field-label designator. No original initializer or assertion was changed. |
| `struct-ret-1.c` | **Retain deferred.** Original function `X f(B,char,double,B)` receives two `B` structures and two scalars, formats arguments through real `sprintf(out,...)`, and returns `X`. Main calls `f` directly and through a function pointer, copies the first formatted output and aborts if the two formatted outputs differ. KCC noopt **link fails on undefined hosted `sprintf`**, and GCC O0 **compile fails** in the hosted stdio path. Importantly, main never directly verifies the returned `X` fields: it is an argument/formatting consistency oracle, *not* confirmed struct-return correctness. Do not stub `sprintf` or claim coverage of the returned object. |
| `tmp.c` | **Activate GCC.** Original scratch test declares a signed `long long` one-bit pad and **37-bit** bitfield, initializes `field` to `0xc00000000`, then reads and compares the field against that exact value or aborts. The value fits within signed 37-bit range, regardless of host 64-bit assumptions. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, with an emitted abort condition. KCC noopt **compile fails** on the nonstandard `long long` bitfield. This is narrow 37-bit storage/readback coverage; the source's commented alternate width/value was not substituted. |
| `tstdi-1.c` | **Activate KCC and GCC after exact target guard correction.** Original `feq/fne/flt/fge/fgt/fle` compare signed `long long` against zero; main checks **36** exact `TRUE=13`/`FALSE=140` results for zero, -1, 1, sign bit, sign bit plus one, and sign bit minus one. Installed compilers define `__PDP10__` but not lowercase `__pdp10__`; the original guard wrongly selected the 64-bit hexadecimal constants and both original baseline executions aborted. Independently evaluating **all 36** checks against the *existing* PDP-10 71-bit octal values produced zero mismatches. A single line now accepts uppercase or lowercase PDP-10 target macros without changing any constant or expectation. On the actual corrected source, GCC O0/O1/O2/Os **4/4 pass**, KCC noopt **passes** but KCC optimized **runtime aborts**. The shared KCC CPU matrix is conservatively `fail`; the actual mode split is pinned in the v29 TSV. The KCC optimized sign-boundary failure is a compiler-repair priority. |
| `va-arg-10.c` | **Activate GCC with O0 failure.** Original `stdarg.h` test calls `f0` through `f15`, varying the position of the last fixed `format` argument and number of variadic integer arguments. `fap` copies the `va_list` via `va_copy` (or `__va_copy`), checks `strlen(format)==16-i`, and walks both lists separately to compare every integer against the matching hexadecimal digit. GCC PDP-6 **O0 runtime aborts; O1/O2/Os pass**. Emitted optimized assembly retains all sixteen caller paths and the `fap` checks. KCC noopt **compile fails** at the source's GNU `__SIZE_TYPE__` declaration, so it did not execute any `va_copy` oracle under KCC. |
| `va-arg-15.c` | **Activate GCC failing regression.** Original obsolete `<varargs.h>`/`va_alist`/`va_dcl` function consumes **18 alternating integer and double** variadic arguments representing 1 through 18; every value is compared and a mismatch aborts. GCC O0/O1/O2/Os **4/4 runtime abort**, not linker errors or timeouts. Generated O0 and O2 code contains an actual `vafunction` call, integer/double comparisons, and abort branches. KCC noopt cannot compile the unavailable legacy `varargs.h`/`va_dcl` interface. No source conversion to a different calling convention was attempted. |
| `va-arg-16.c` | **Activate GCC failing regression.** Original old-style function accepts two named double arguments `888.0` and `999.0`, then checks nine `va_arg(double)` values 1 through 9. GCC O0/O1/O2/Os **4/4 runtime abort**, with real double comparisons and callback invocation in emitted O0/O2 assembly. KCC noopt rejects missing obsolete `varargs.h` and `va_dcl`; do not record a KCC ABI failure or change the legacy source interface to manufacture a pass. |
| `va-arg-17.c` | **Activate GCC failing regression.** Original old-style `va_alist` function with dummy string argument reads and verifies nine `double` values 1 through 9. GCC O0/O1/O2/Os **4/4 runtime abort**, executing the original double comparisons. KCC noopt **compile fails** on unavailable legacy `varargs.h`/`va_dcl`. |
| `va-arg-19.c` | **Activate GCC failing regression.** The original old-style `va_alist` function reads nine `int` values 1 through 9 and aborts on a mismatch. GCC O0/O1/O2/Os **4/4 runtime abort**, with a real `vafunction` call and nine comparison/abort checks emitted. The pre-existing `NO_VARARGS` branch only executes `exit(0)` **without asserting anything**, so it was deliberately *not* enabled as a target workaround. KCC noopt rejects missing obsolete `varargs.h`/`va_dcl`. |
| `va-arg-2.c` | **Activate GCC with O0 failure.** Original `stdarg.h` test uses sixteen functions `f0` through `f15` with increasing numbers of fixed integer parameters and a shifting last named `format` pointer. Each checks the expected `strlen`, then sequentially consumes `va_arg(int)` values against hexadecimal digits. GCC PDP-6 **O0 runtime aborts; O1/O2/Os pass**, and optimized assembly retains the sixteen calls and checks. KCC noopt **compile fails** at the GNU `__SIZE_TYPE__` declaration, so no KCC variadic ABI result is inferred. |

## Independent sign-boundary verification

For a signed 71-bit value, the original
`__LONG_LONG_71BIT__` branch contains:

- `MSB = 0200000000000000000000000LL`: interpreted as
  `-2^70` in signed 71-bit two's-complement arithmetic.
- `MSB_PLUS_1 = 0200000000000000000000001LL`: interpreted
  as `-2^70 + 1`.
- `MSB_MINUS_1 = 0177777777777777777777777LL`: interpreted
  as `2^70 - 1`.

Each of `feq/fne/flt/fge/fgt/fle` was independently evaluated
on the six original argument cases and compared with all **36**
`TRUE`/`FALSE` expectations: **zero disagreements**. The
only production source change is:

```diff
-#ifdef __pdp10__
+#if defined(__PDP10__) || defined(__pdp10__)
```

The original source SHA256 and corrected SHA256 are both
preserved in the versioned v29 ledger. The corrected source
was compiled and executed without synthetic target defines:
KCC noopt passes, optimized aborts, GCC all four levels pass.
Do not weaken the 36-assertion oracle to avoid the
optimized KCC compiler defect.

## Execution accounting and registration

- Original ten sources at KCC noopt and GCC O0: **20 cells**.
- Nine assertion-bearing original sources at GCC O1/O2/Os:
  **27 cells**.
- Corrected `tstdi-1.c` at KCC noopt and GCC O0: **two cells**.
- Corrected `tstdi-1.c` at KCC optimized and GCC O1/O2/Os:
  **four cells**.
- Total: **53 bounded native PDP-6 executions**, plus an
  independent non-compiler check of all 36 sign comparisons.

Nine newly registered sources select **36 GCC native PDP-6
profiles: 18 verified `semantic` and 18 `fail` runtime
abort outcomes**. KCC selects two conservatively `fail`
slots for `tstdi-1.c`; the true noopt-pass/optimized-fail
distinction is recorded separately. Remaining tests use
unsupported GNU field labels, nonstandard bitfields,
unavailable legacy `varargs.h`, or a GNU `__SIZE_TYPE__`
declaration that KCC does not compile. Such KCC slots remain
`no_test`: neither a vacuous pass nor a misleading runtime
compiler failure is registered.

Versioned local execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch21-20261118-v29`
- `$TMPDIR/p10tk-deferred-integration-batch21-gccopts-20261118-v29`
- `$TMPDIR/p10tk-deferred-integration-batch21-tstdi-edited-20261118-v29`
- `$TMPDIR/p10tk-deferred-integration-batch21-tstdi-edited-optimized-20261118-v29`

## Next first-review cursor

Batch 22 (v30) starts with
`tests/semantic/upstream/extensions/va-arg-21.c`. Select
the final ten never-before-reviewed still-deferred
canonical identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v23.tsv`
after excluding v8-v29 ten-row ledgers. **Ten**
currently deferred identities still await first review;
**66** already-reviewed canonical identities remain
deferred. The 16 consolidated compiler gates remain
separate for later repair, and the 44 manual suites
must remain untouched. Explain any proposed deletion
before performing it. Do not run broad CPU/compiler
sweeps during this stage.
