# Deferred integration: seventeenth ten-source batch (2026-11-18, v25)

## Scope and outcome

Review exactly ten previously unreviewed canonical source identities,
beginning at `tests/todo/generic/memcpy-2.c`, selected in order from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v18.tsv` after excluding
all v8-v24 review-ledger identities. Preserve the v21 consolidation
policy: no retired source aliases, no repeated physical sources.
Inspect complete original assertions and run only bounded native
PDP-6 GCC/KCC profiles; do not run the full compiler/CPU sweep,
change production compiler or linker code, or execute any of the
44 manually gated special suites.

**Seven sources activated, three retained deferred, none edited
or deleted.** All seven active source owners are meaningful
compiler regression tests with original abort checks; three
retained sources are blocked by simulator execution/hosted
dependencies or lack a real result assertion.

The ten-row `PDP10-DEFERRED-INTEGRATION-BATCH17-20261118-v25.tsv`
pins original and current SHA256 (identical), previous disposition,
actual PDP-6 KCC/GCC optimization results, selected matrix
profiles and the evidence supporting every decision.

Current authoritative source records:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v20.tsv`:
  **509 active, 109 deferred, 58 removed, one
  stress-nonportable** among 677 canonical upstream identities.
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v19.tsv`:
  **109 SHA256-pinned current deferred identities**.
- `COMPILER_MATRIX.tsv`: **2,168 registered source identities**,
  with seven new canonical source owners.
- v21 provenance continues to track **97 retired byte-identical
  source copies**, **zero reintroduced duplicates**, and
  **16 still-open compiler-specific gates**.

## Ten original-source decisions

| Source | Decision | Grounded assertion, verified results and limits |
| --- | --- | --- |
| `memcpy-2.c` | **Activate KCC/GCC regression** | Original static unions hold buffers aligned for `long long` and `long double`. Nested loops vary both source/destination offsets over `sizeof(long long)` and copy lengths 1 through `8*sizeof(long long)-1`. Each `memcpy` must return the destination pointer, leave prefix/suffix bytes unchanged and make each copied byte equal `'A'`, or abort. KCC native PDP-6 noopt/optimized **2/2 pass**; GCC O0/O1/O2/Os **4/4 runtime fail**, with real `__test_exit=1` aborts, not timeouts. Target headers and actual freestanding `memcpy` are available; original source unchanged. |
| `memcpy-bi.c` | **Activate mixed GCC regression and KCC passing test** | Original 80-byte alphabet-pattern `src[]`, initialized `dst[]`, and 20 four-case `T(n)` families cover `n=0..79`: `memset(dst,0,n)`, `memcpy(dst,src,n)`, and `memcmp(dst,src,n)==0` for each length, else abort. KCC noopt/optimized **2/2 pass** with actual freestanding `memcmp` v2/`memset`/`memcpy`; GCC O0 **passes**, O1/O2/Os **3/3 abort**. Optimized output retains the `memcmp` check and abort path. The historical unavailable-memcmp linkage is solved by the existing archive; no fake function or source rewrite was used. |
| `memset-1.c` | **Activate KCC/GCC regression** | Statically aligned union buffer; original loops over destination offsets and fill lengths through `8*sizeof(long long)-1`. For every case, it invokes `memset` with zero, global `A`, and literal `'B'`; each returned pointer, exact filled region, untouched prefix and untouched suffix is checked or aborts. KCC noopt/optimized **2/2 pass**; GCC O0/O1/O2/Os **4/4 runtime fail**, with actual aborts. Target `string.h` and freestanding `memset` are available. |
| `nest-stdar-1.c` | **Activate GCC** | GNU nested `static double f(int x,...)` uses real `va_start`, `va_arg(args,double)` and `va_end`; the outer `main` aborts if `f(1,(double)1)!=1.0`. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, with emitted nested-function and floating comparison/abort checks even at O2. KCC noopt **compile fails** unsupported nested static variadic syntax. |
| `nestfunc-1.c` | **Activate GCC** | `g(a,b,gi)` calls a function-pointer callback. A nested `f2(a,b)` returns `a>b`; `f` aborts unless `g(1,2,f2)==2`, and `main` calls `f`. GCC O0/O1/O2/Os **4/4 pass**; emitted O0/O2 assembly retains actual `g`/`f2` and an abort branch. The `NO_TRAMPOLINES` bypass is **not** defined in measured profiles. KCC noopt **compile fails** unsupported GNU nested functions. |
| `nestfunc-2.c` | **Activate GCC with O2/Os failures** | Nested seven-argument callback `nested(a,b,c,d,e,f,g)` is passed to `foo`, which calls it with `(a,b,a,b,a,b,a)`. Triply nested 10-iteration loops accumulate `sum`; global `z` tracks callback arguments. Original `main` aborts unless `sum==2300` and `z==0x1b`. GCC O0/O1 **pass**, O2/Os **runtime abort**, not timeout; emitted code retains nested function call and checks. KCC noopt **compile fails** unsupported GNU nested functions. Never define `NO_TRAMPOLINES` to fabricate a passing result. |
| `nestfunc-3.c` | **Retain deferred** | Original nested `nest_0`, `nest_1` and `nest_2` callbacks pass through `foo/use`, capture an accumulating outer `sum`, and process 1,000 triply nested iterations. The final oracle masks the sum with `0xffffffff` and requires `0xbecfcbf5` or abort. GCC O0/O1/O2 **SIMH timeout rc124 without readable `__test_exit` examine output**; GCC Os reaches `abort` (`__test_exit=1`). These are **three unresolved executions and one real assertion failure**, not four independently confirmed failed assertions. KCC noopt **compile fails** unsupported nested functions. Preserve the original mask and diagnose PDP-6 nested closure/static-link execution separately before registration. |
| `old.tort.c` | **Retain deferred** | XKL/TOPS-20 byte-pointer experiment: 8-/9-bit, halfword and fullword accesses through nested structs/unions and `void *` casts, with extensive original `printf` diagnostics and `fail` paths. GCC PDP-6 O0 **link fails** without real hosted `printf`; KCC noopt **compile fails** on nonstandard byte-pointer syntax. Under non-TOPS20, original `main` exits **256 even on apparent success**; supplying `printf` alone would not give a PDP-6 pass. Requires a genuine hosted XKL/TOPS-20 compatibility environment, not stubbed diagnostics or changed assertions. |
| `packed-2.c` | **Retain deferred** | GNU `packed` attribute on `unsigned long b` following `unsigned short a`. Original `main` merely stores `t.b=0` and returns 0, **without reading it back or checking size/alignment/offset**. KCC noopt and GCC O0 both **pass vacuously**; this does not establish packed-field correctness. Keep for a meaningful compile-only policy or substantive packed-layout assertion. |
| `20020507-3.c` | **Activate GCC with KCC failures** | Original `static int x=-1; static char y[4]`; helper `foo` calls `memcpy(y,&x,4)` and aborts if leading byte `y[0]==0`. Under native PDP-6 9-bit chars, this is a real first-character readback assertion; **it does not assert every copied byte or an 8-bit host representation**. GCC PDP-6 O0/O1/O2/Os **4/4 pass**; KCC native noopt/optimized **2/2 runtime abort**. The existing actual freestanding `memcpy` is used where emitted. |

No deletion was justified. `nestfunc-3.c` remains unproven at
three optimization levels; `old.tort.c` requires an actual
hosted system, and `packed-2.c` has no checked oracle.

## Bounded execution and registry accounting

- Ten original sources at KCC native noopt and GCC native O0:
  **20 PDP-6 cells**.
- Eight meaningful original GCC sources, including the
  execution-blocked `nestfunc-3.c`, at O1/O2/Os:
  **24 PDP-6 cells**.
- Four KCC-supported original sources (`memcpy-2.c`,
  `memcpy-bi.c`, `memset-1.c`, `20020507-3.c`) at
  KCC optimized: **four PDP-6 cells**.
- **48 targeted native PDP-6 executions total**, no full
  CPU/compiler matrix and no manual special suite.

Seven new matrix source owners select exactly:

- **28 GCC PDP-6 native cells**: **15 `semantic` passes**
  and **13 `fail` runtime aborts**.
- **Eight KCC PDP-6 native cells**: **six `semantic`
  passes** for the three memory library tests and **two
  `fail` aborts** for `20020507-3.c`.
- GCC `nestfunc-3.c` timeouts and Os abort are retained in
  the ten-row v25 ledger but **not registered as successes**.
- Other CPUs, compiler families, and unsupported KCC GNU
  extensions stay pending/unsupported rather than inferred pass.

Versioned raw execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch17-20261118-v25`
- `$TMPDIR/p10tk-deferred-integration-batch17-gccopts-20261118-v25`
- `$TMPDIR/p10tk-deferred-integration-batch17-kccopts-20261118-v25`

The existing `run-tests.py` tail-`JRST` libc dependency
fix from v24 remains intact; no new library workaround or
original-source adaptation was necessary in this batch.

## Next ten and preserved deferrals

Batch 18 (v26) should select exactly ten still-unreviewed
canonical identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v19.tsv`, excluding
all prior v8-v25 ten-source ledgers, beginning with
`tests/semantic/upstream/pdp10/pdp10/conversion.c`.
There are **50 unique unreviewed deferred** source identities
and **59 previously reviewed identities still deferred**. The
separate **16 compiler-specific consolidation gates** remain
open for the later compiler/assembler sweep. Do not enable
the 44 manual suites or a broad CPU/compiler run here, and
explain the exact target-specific justification before any
future deletion.
