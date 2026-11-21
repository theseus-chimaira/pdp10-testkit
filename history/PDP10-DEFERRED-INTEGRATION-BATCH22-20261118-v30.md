# Deferred integration: final first-review batch 22 (2026-11-18, v30)

## Scope, selection, and result

Inspect the final ten previously unreviewed canonical sources,
beginning at `tests/semantic/upstream/extensions/va-arg-21.c`,
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v23.tsv`.
Exclude all v8-v29 ten-source review-ledger identities and all
97 previously retired byte-identical aliases. Read each complete
original C source and its assertion. Run only native PDP-6
KCC noopt and GCC O0/O1/O2/Os where supported, preserving
actual failures. Do not execute a broad CPU/compiler sweep,
DAIMOS OS tests, or any of the 44 manually gated special tests.

**Nine activated, one retained deferred, zero source adaptations,
zero deletions.** All ten original and current source SHA256
values agree byte-for-byte. The accompanying ten-row
`PDP10-DEFERRED-INTEGRATION-BATCH22-20261118-v30.tsv` pins
the original disposition, observed compiler cells, registered
profiles, exact hash, and per-source rationale.

Current authoritative inventories:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv`:
  **551 active, 67 deferred, 58 removed and one
  stress-nonportable** out of 677 surviving canonical
  historical identities.
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv`:
  **67** SHA256-pinned still-deferred original identities.
- `COMPILER_MATRIX.tsv`: **2,210** unique source registrations.
- Original v21 source consolidation: **97 retired aliases,
  zero reintroduced duplicates**, with **16 independent
  compiler-specific repair gates** preserved for later work.

## Original source-by-source decisions

| Source | Decision | Exact assertion and native PDP-6 evidence |
| --- | --- | --- |
| `va-arg-21.c` | **Retain deferred** | GNU hosted varargs side-effect test: it allocates two `va_list` objects using genuine `malloc`, passes both through genuine `vprintf`, uses `va_end(**ap_ptr++)` to advance one slot, then skips an intervening NULL pointer and aborts if the final pointer is NULL. KCC noopt **LINK_FAIL** on unresolved `malloc`; GCC O0 **COMPILE_FAIL** because hosted `stdio.h` is absent. Neither executed the side-effect assertion. Preserve the original allocation and `vprintf` semantics; never insert a fake formatter or allocator. |
| `va-arg-22.c` | **Activate GCC failing regression** | GNU variadic *aggregate-by-value* ABI test: 21 different `struct` types with character arrays of sizes **0..16, 31, 32, 35 and 72** are initialized with `i ^ (N << 3)`, passed to `foo(21,...)`, retrieved via `va_arg(ap,typeof(...))`, and every element checked through the stateful `bar` comparator. GCC O0/O1/O2/Os **4/4 actual runtime abort**, with emitted `foo`/`bar` and original checks, not a timeout or link failure. KCC noopt **COMPILE_FAIL** on the GNU zero-length array/aggregate `va_arg` language features. |
| `va-arg-3.c` | **Activate GCC failing regression** | Legacy `<varargs.h>`/`va_alist`/`va_dcl` ABI test corresponding to `va-arg-2.c`: 16 original `f0..f15` calling arrangements shift the position of the format pointer and verify `strlen(format)==16-i` and each `va_arg(int)` hex digit. GCC O0/O1/O2/Os **4/4 runtime abort**, executing the original calls and comparison paths with the real `strlen`. KCC noopt **COMPILE_FAIL** on absent obsolete `varargs.h`/unsupported `va_dcl`. The pre-existing `NO_VARARGS` branch merely exits and **was not enabled**, because it would render the original assertions vacuous. |
| `va-arg-7.c` | **Activate GCC failing regression** | Legacy `debug` has **seven named ints and nine named doubles**, then checks three trailing `va_arg(int)` values **8, 9, 10**. GCC O0/O1/O2/Os **4/4 actual runtime abort**, with an emitted call and three checks. KCC noopt **COMPILE_FAIL** on missing legacy `varargs.h` and `va_dcl`. Do not silently change the original calling convention to modern `stdarg`. |
| `va-arg-8.c` | **Activate GCC failing regression, target-header caveat** | Original old-style variadic function takes nine fixed ints and checks trailing `va_arg(int)==10` followed by `va_arg(long long)==0x123400005678LL`. A `#if __LONG_LONG_MAX__ == 9223372036854775807LL` selects that code. The actual installed PDP-10 **`limits.h` advertises the 64-bit maximum**, while the compiler also defines **`__LONG_LONG_71BIT__`**; consequently this branch actually compiles and executes even on the wider target. GCC O0/O1/O2/Os **4/4 actual runtime abort**, with real `debug` and checks. KCC noopt **COMPILE_FAIL** on absent obsolete `varargs.h`/`va_dcl`. The argument constants themselves fit a wider long long, but do **not** claim proof of an exclusively 64-bit ABI. Leave the inconsistent header/macro policy for independent toolchain investigation rather than rewriting the original oracle. |
| `va-arg-9.c` | **Activate GCC mixed optimization regression** | Standard `stdarg.h` ABI test: `f0..f15` shift the final named `format` parameter across fixed/variadic arguments, pass an initialized `va_list` into `fap(int,char*,va_list)`, then check `strlen(format)==16-i` and every variadic integer against the corresponding hexadecimal digit. GCC **O0 runtime aborts; O1/O2/Os pass**. Optimized generated code retains the `fap` function, all 16 caller paths and checked `va_arg` operations. KCC noopt **COMPILE_FAIL** on the GNU `__SIZE_TYPE__` declaration, not a KCC runtime ABI failure. |
| `wchar_t-1.c` | **Activate GCC failing wide-literal regression** | Original source contains a **single raw Latin-1 byte `0xC4`** for the non-ASCII character in `L"..."` and `L'...'` (**not UTF-8**). The code declares `wchar_t` using `__WCHAR_TYPE__`, then checks that a one-character wide string has exactly two elements, first element equals the original wide character, second is NUL, and a separate wide character has the same value. GCC O0/O1/O2/Os **4/4 runtime abort**. O0 assembly initializes the first wide string element to octal `0304` and separate wide character to decimal `196`, but its folded `sizeof(x)/sizeof(wchar_t)` condition emits an unconditional abort; a versioned scratch recompilation retaining **all original Latin-1 bytes** establishes `sizeof(x)==32` and `sizeof(wchar_t)==4`, i.e. **8 elements where 2 are required**. This is a concrete wide-literal array-size/encoding regression; do not transcode the original Latin-1 bytes. KCC noopt **COMPILE_FAIL** on unsupported GNU `__WCHAR_TYPE__`. |
| `widechar-2.c` | **Activate GCC** | Original deployed `stddef.h` `wchar_t` and `const wchar_t ws[]=L"foo"`: `main` checks **four elements**, wide `f`, `o`, `o`, NUL. GCC O0/O1/O2/Os **4/4 pass**, with emitted wide characters and comparison/abort paths. KCC noopt **COMPILE_FAIL** on unresolved `wchar_t` support in current headers. No source edits. |
| `zerolen-1.c` | **Activate GCC GNU extension** | Original union overlays `char carr[4]` with a struct containing `unsigned char name_len[1]` and GNU `char name[0]`. `set` writes `carr[0]=1` and `carr[1]=0`; the assertion reads those values through `name_len[0]` and `name[0]`. GCC O0/O1/O2/Os **4/4 pass** with original set/readback/abort checks. KCC noopt **COMPILE_FAIL** without the zero-length-array extension. Reading `name[0]` from a zero-element member is **not portable ISO C indexing**; it intentionally tests GNU overlay/storage semantics, and the source was not made artificially portable. |
| `zerolen-2.c` | **Activate GCC compile-time layout oracle** | Original `typedef int word __attribute__((mode(word)))` and `struct foo {word x; word y[0];}` assert `sizeof(word)==sizeof(struct foo)` and equal `__alignof__`. GCC O0/O1/O2/Os **4/4 pass**. The optimizer/front end folds those layout conditions (even O0 may emit a direct return); this is a **compile-time size/alignment check**, **not runtime zero-element readback**. KCC noopt **COMPILE_FAIL** on GNU mode/zero-length syntax. Original unchanged. |

## Target details that must not be obscured

The `va-arg-8.c` `__LONG_LONG_MAX__` guard is **actually
true** with the current deployed `limits.h` on native PDP-6.
The same compiler advertises `__LONG_LONG_71BIT__`.
The original mixed integer/long-long variadic assertions
execute and fail; this is actionable wide-argument evidence,
but the header's claim about a 64-bit maximum requires a
later independent toolchain/configuration review. A
pass from the alternate guarded `exit(0)` branch would
have been vacuous and is not claimed.

The original `wchar_t-1.c` uses single-byte `0xC4`.
Reencoding it to UTF-8 would modify the test input and
could change the very frontend behavior under test.
All original bytes are therefore SHA256-pinned and unchanged.

## Bounded runs and matrix registrations

- Ten original sources, PDP-6 KCC noopt and GCC O0:
  **20 baseline cells**.
- Nine GCC-executable original sources at O1/O2/Os:
  **27 optimized GCC cells**.
- **47 targeted native PDP-6 executions** total.
  KCC optimized was not run on sources that fail to
  compile with KCC noopt; no unsupported results
  were invented.

The nine new matrix source owners select **36 GCC native
PDP-6 profiles: 15 verified `semantic` passes and 21
`fail` guest aborts**. No new KCC profile is selected,
because the original KCC noopt compilation fails
for every newly activated source. All source-specific
KCC compile failures and target-header limitations remain
in the v30 evidence ledger.

Versioned local execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch22-20261118-v30`
- `$TMPDIR/p10tk-deferred-integration-batch22-gccopts-20261118-v30`

No source or production compiler/linker library was edited,
no test expectation relaxed, and none of the 44 manual
special suites was executed.

## Completion of the first-review queue

Every currently surviving canonical source identity has
now had a bounded first review through the v8-v30
source-pinned ten-entry ledgers. The current **67 still
deferred sources have all been individually reviewed**.
This is **not** a claim that their blockers are fixed:
hosted libc and byte-pointer prerequisites, unsupported
language extensions, meaningful oracle gaps and genuine
compiler failures remain.

Next: examine the **67 reviewed-but-deferred** source
identities by root cause, prioritizing independently
reproducible compiler/assembler errors, and preserve
the **16 separate consolidated compiler repair gates**.
Do not remove original sources without first explaining
exactly why; do not reintroduce retired duplicates.
Schedule broad CPU/compiler validation only as a
separate authorized stage. The 44 manually gated
tests remain explicitly excluded.
