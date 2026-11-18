# Deferred integration: nineteenth ten-source batch (2026-11-18, v27)

## Selection, scope, and outcome

Review exactly ten never-before-reviewed surviving canonical sources,
beginning at `tests/semantic/upstream/extensions/strct-pack-2.c`,
selected in manifest order from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v20.tsv` after excluding
all prior v8-v26 ten-source review ledgers and the 97 physically
retired SHA256-identical source aliases. Inspect the complete original
C sources and preserve all original assertion constants. Run
native PDP-6 KCC and GCC only, not a broad CPU/compiler sweep or
any of the 44 manually gated special tests.

**Nine activated, one retained deferred, one five-line source
portability adaptation, no source deletions.** The 10-row
`PDP10-DEFERRED-INTEGRATION-BATCH19-20261118-v27.tsv`
pins original/current SHA256, initial and final compiler execution
statuses, KCC noopt/optimized and GCC O0/O1/O2/Os matrix profiles,
and the evidence for each decision.

Current authoritative inventory:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v22.tsv`:
  **523 active, 95 deferred, 58 removed, one stress-nonportable**,
  totaling 677 canonical historical classifications.
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v21.tsv`:
  **95** current deferred sources, all SHA256-pinned.
- `COMPILER_MATRIX.tsv`: **2,182** unique source registrations.
- Original v21 duplicate consolidation remains **97 historical
  source pairs, zero current duplicate pairs, 16 separately
  tracked compiler repair gates**.

## Ten original-source decisions

| Source | Decision | Original assertion and verified PDP-6 outcomes |
| --- | --- | --- |
| `strct-pack-2.c` | **Retain deferred** | A packed/aligned short member and packed/aligned `short *ap[2]` array are declared in `A`. `main` only assigns `ap->ap[j]=&i` at `j=1` and exits. KCC noopt and GCC O0 both pass, but **there is no pointer readback, alignment, offset, or layout assertion**. A passing exit does not establish correct packing. |
| `strct-varg-1.c` | **Activate KCC and GCC after source portability correction** | Original legacy `varargs.h` was unavailable to native KCC. The existing `NO_VARARGS` branch uses deployed `stdarg.h` with `va_start(va,x_attr)`, reads two `struct s {int x,y}` values across an intervening integer, and aborts unless `x_attr==2`, first struct `0xaaaa/0x5555`, integer `3`, second struct `0xffff/0x1111`. The source now selects that **pre-existing branch only for `__PDP10__`/`__pdp10__`**, without modifying the argument sequence, expected numbers, or `va_arg` calls. Initially KCC noopt compile failed and GCC O0 aborted. Recompiling the **actual edited source without forced compiler flags** yields KCC noopt/optimized **2/2 pass** and GCC O0/O1/O2/Os **4/4 pass**. |
| `string-opt-1.c` | **Activate GCC failing regression** | Seven `strstr`/`__builtin_strstr` calls must return exact `foo`/offset pointers for empty strings, single characters and `world` within `hello world`. GCC O0/O1/O2/Os **4/4 runtime abort**, not linker errors or timeouts. O0 links real freestanding `strstr`; optimized O2 emits immediate `abort`, even though the source expects successful constant transforms. KCC noopt link fails on the required `strstr` symbol. This is an observed failing test, not a passing library claim. |
| `string-opt-10.c` | **Activate GCC** | `strncat` must return the original destination pointer and preserve/append exact content after `strcpy` resets. Cases exercise empty source, zero and nonzero maximum lengths, copies of `foo` and `hello world`, `++d2` evaluation exactly once, and `++x` changing 123 to 124. Checks compare final strings via real `strcmp`. GCC O0/O1/O2/Os **4/4 pass**; optimized code retains nontrivial checks and the intentionally aborting local `strncat` stub is not called. KCC noopt rejects the GNU builtin/type dialect. |
| `string-opt-11.c` | **Activate GCC failing regression** | The original checks `strspn` results for `hello world` and empty accept sets, plus copies through `strcpy`, `++d2` pointer side effects, and a `__builtin_strspn` constant case. GCC O0/O1/O2/Os **4/4 runtime abort**. The O0 executable links the real freestanding `strspn`; O2 emits immediate `abort` and retains the optimized local failing stub. KCC noopt compile fails on the GNU builtin/type declarations. Distinguish possible library behavior from compiler folding during future diagnosis. |
| `string-opt-12.c` | **Activate GCC with optimizer failures** | Exact `strcspn` prefix lengths, copied destination buffers, `++d2` side effects, empty search strings, and `__builtin_strcspn(s1,"z")==11` are checked. GCC **O0 passes** with the real library; O1/O2/Os **runtime abort**. At O2, `main` immediately aborts, not a freestanding link failure. KCC noopt rejects GNU builtin/type syntax. |
| `string-opt-13.c` | **Activate GCC** | The original resets a buffer to `"nts"` before each of six `strlen` comparisons around zero, including the terminator at `ptr+3`. The optimized branch defines an aborting local `strlen` as an oracle for inappropriate calls. GCC O0/O1/O2/Os **4/4 pass**, and optimized assembly retains checks while not calling its local failing `strlen`. KCC noopt cannot compile the GNU builtin type syntax. |
| `string-opt-14.c` | **Activate with narrow optimized-only oracle** | `memset(src,0,0)` and `memcpy(dst,src,0)` do not modify any memory. Original unoptimized `main` contains **no readback assertion** and calls actual freestanding functions, so O0 pass alone is vacuous as memory-contents coverage. Under `__OPTIMIZE__`, however, both functions are explicitly defined to `abort` if called. GCC O1/O2/Os **3/3 pass**, and O2 assembly has **no call** to either aborting local function: this is meaningful evidence of correct zero-length operation elimination, **not** a general memcpy/memset correctness test. KCC noopt rejects the GNU builtin type declarations. |
| `string-opt-15.c` | **Activate GCC with optimizer failures** | Original `strcpy(str,"3141")` prepares a short buffer. Five `memcmp` checks assert zero-length equality and single-byte equality/negative/positive sign; optimized builds supply an aborting local `memcmp` if residual calls remain. GCC **O0 passes** with real `memcmp`, O1/O2/Os **3/3 runtime abort** with real abort status. KCC noopt rejects GNU builtin/type syntax. |
| `string-opt-16.c` | **Activate GCC constant-fold/link oracle with three link errors** | Three constant `memcmp` cases check negative, equal and positive comparisons for four-character literals. Incorrect branches call `link_error()`. Under `__OPTIMIZE__`, `link_error` is intentionally **undefined** and local `memcmp` aborts if called. Correct optimization must fold comparisons and eliminate every `link_error` branch. GCC O0 **passes**, with actual freestanding `memcmp`; GCC O1/O2/Os **3/3 LINK_FAIL** on exact `dlink: undefined symbol: link_error`. Optimized assembly retains a reference to that intentionally unresolved symbol. Register **`error`**, not `fail`, in those three matrix cells; never stub `link_error` or claim the executable was run. KCC noopt compile fails on GNU builtin/type syntax. |

## Why the structure-varargs source changed

The existing original source already carried two alternative
varargs interfaces, controlled by `NO_VARARGS`. Native PDP-10
has `stdarg.h` but not the obsolete `varargs.h` API.
The only added source text is the five-line preprocessor/comment
prefix:

```c
/* PDP-10 has stdarg.h, not the obsolete varargs.h interface. */
#if defined(__PDP10__) || defined(__pdp10__)
#define NO_VARARGS 1
#endif

```

Every original assertion, expected value, function call, and
the existing `NO_VARARGS` conditional implementation is intact.
The original and modified SHA256 values are distinct and both
recorded in the v27 TSV. The retired byte-identical alias
`tests/todo/generic/pdp10/strct-varg-1.c` remains physically
absent. The v21 consolidation table keeps its **original**
source hash for historical provenance.

`tools/audit_consolidated_upstream_v21.py` now permits *only*
this exact, v27-pinned five-line addition at the surviving
`tests/todo/generic/varargs/strct-varg-1.c` owner: stripping
the prefix must recreate the exact old v21 SHA256; the
current SHA256 must match the new v27 ledger. Any other change
fails the audit. Source-equality provenance is not overwritten,
and the 16 independent unresolved compiler gates remain intact.

Two exploratory runs used a synthetic `profile.extra`
`-DNO_VARARGS` option. That option was accepted for KCC,
but **the semantic runner did not forward it to GCC**:
the GCC scratch failure therefore still executed the legacy
interface, not a valid test of the `stdarg` branch. The
decisive measurements are six native executions of the
**actual edited source without extra flags**, all passing.
No source-based workaround for a compiler bug was made.

## Execution accounting and registration

- Original ten-source KCC noopt/GCC O0 baseline: **20 cells**.
- Eight original GCC string-optimization sources at O1/O2/Os:
  **24 cells**.
- Edited structure-varargs source at KCC noopt and GCC O0:
  **two cells**.
- Edited source at KCC optimized and GCC O1/O2/Os:
  **four cells**.
- **50 targeted native PDP-6 executions** underpin the
  registration, plus six scratch experiments (two noopt,
  four optimized) used to explore the already present
  `NO_VARARGS` branch. Scratch failures not reflecting
  its actual use are **not** registered.

The nine new source rows select exactly **36 native GCC
PDP-6 profiles**: **19 `semantic` passes, 14 genuine
`fail` runtime aborts, and three `error` statuses**
for optimized `string-opt-16.c` link failures. KCC selects
**two `semantic`** profiles for the corrected
`strct-varg-1.c` and no native KCC slots for the eight
GNU-only string tests. Other CPUs, backends and the
44 manually gated special suites are untouched.

Versioned local evidence:

- `$TMPDIR/p10tk-deferred-integration-batch19-20261118-v27`
- `$TMPDIR/p10tk-deferred-integration-batch19-gccopts-20261118-v27`
- `$TMPDIR/p10tk-deferred-integration-batch19-varargs-stdarg-scratch-20261118-v27`
- `$TMPDIR/p10tk-deferred-integration-batch19-varargs-stdarg-optimized-scratch-20261118-v27`
- `$TMPDIR/p10tk-deferred-integration-batch19-varargs-edited-20261118-v27`
- `$TMPDIR/p10tk-deferred-integration-batch19-varargs-edited-optimized-20261118-v27`

## Next review cursor

Batch 20 (v28) starts with
`tests/semantic/upstream/extensions/string-opt-2.c`.
Choose the next ten previously unreviewed canonical
deferred identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v21.tsv`,
excluding all v8-v27 review ledgers. **30 unique deferred
sources remain unreviewed, and 65 previously reviewed
sources remain deferred**. The 16 independent
consolidated compiler repair gates stay open. Explain
any proposed deletion before performing it, do not
restore a retired alias, and do not execute the broad
CPU/compiler matrix or 44 manual suites.
