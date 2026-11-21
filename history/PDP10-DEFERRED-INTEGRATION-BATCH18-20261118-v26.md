# Deferred integration: eighteenth ten-source batch (2026-11-18, v26)

## Selection, scope, and disposition

Select exactly ten unreviewed *canonical* deferred source identities,
starting at `tests/semantic/upstream/pdp10/pdp10/conversion.c`,
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v19.tsv`.
Exclude the v8-v25 ten-source review ledgers and the 97 retired
byte-identical aliases. Inspect the exact original source and its
original assertion before recording any compiler result. Execute
only bounded native PDP-6 KCC/GCC cells, not the broad
compiler/CPU matrix, the DAIMOS guest tests, or the 44 manually
gated special tests.

**Five sources activated, five retained deferred, zero C source
edits and zero deletions.** The accompanying
`PDP10-DEFERRED-INTEGRATION-BATCH18-20261118-v26.tsv`
preserves ten source SHA256 pins, previous dispositions,
KCC noopt/optimized and GCC O0/O1/O2/Os observed results,
matrix registration statuses, and precise per-source reasoning.

Authoritative post-batch inventory:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v21.tsv`:
  **514 active / 104 deferred / 58 previously removed / one
  stress-nonportable**, totaling 677 canonical upstream identities.
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v20.tsv`: **104**
  source-hash-pinned currently deferred identities.
- `COMPILER_MATRIX.tsv`: **2,173** unique registered sources,
  up by five source owners.
- v21 consolidation continues to account for **97** previously
  retired identical-source aliases, **zero** current
  classified-source duplicates, and **16** independent
  still-open compiler-specific repair gates.

## Decisions and real original oracles

| Source | Decision | Evidence and limitations |
| --- | --- | --- |
| `conversion.c` | **Retain deferred** | Original arithmetic conversion suite checks signed/unsigned `int` and GNU `long long` conversion to/from `float`/`double`, with word-size-derived limits, multiple runtime `abort` checks and its own explicit warning that it is *not* a floating-conversion accuracy test. GCC native PDP-6 O0 **link fails** with a real undefined `__fixunssfsi`; no executed GCC semantic result. KCC noopt/optimized **both execute and abort** (`__test_exit=1`). The `sizeof(double)>=8` gates reflect original 8-bit-byte assumptions and may skip double checks on a 9-bit-character target. Correct target conversion support and independently derive 36/71-bit expectations before considering activation. Do not synthesize conversion helpers. |
| `ll-1.c` | **Activate GCC** | Original `typedef unsigned ll __attribute__((mode(DI)))` passes a 71-bit-capable unsigned operand `04000000000005ULL` as the **fourth argument** of `f(int,int,int,ll)`; `f` aborts if the received value differs. GCC PDP-6 O0/O1/O2/Os **4/4 pass**; emitted O0/O2 assembly contains an actual `f` call and abort comparison. KCC noopt **compile fails** on unsupported GNU `mode(DI)`. The oracle tests that specific argument value, not every mixed-size call. |
| `strct-1.c` | **Activate KCC/GCC with failures** | `f(int a,int b,int c,struct x d)` must receive scalar arguments 1,2,3 and struct members `d.e=4`, `d.f=5`; otherwise it aborts. Main passes `(struct x){4,5}` by value. KCC PDP-6 noopt **passes**, optimized **runtime aborts**. GCC O0 **runtime aborts**, O1/O2/Os **3/3 pass**. Emitted O0/O2 assembly retains the actual function call and member comparisons. KCC's shared native CPU field is conservatively `fail`, with exact mode split retained in the TSV; GCC is `fail/semantic/semantic/semantic`. |
| `strct-varg-1b.c` | **Retain deferred** | The original variadic function reads `struct s {int x,y}`, an intervening `int`, then another `struct s` using `va_start/va_arg/va_end`, and checks the fixed argument 2, first struct 0xaaaa/0x5555, integer 3, and second struct 0xffff/0x1111. It also calls **real variadic `printf` twice before the member comparisons**. Both KCC noopt and GCC O0 now compile against deployed headers but **link fail** for the unavailable hosted `printf` implementation. Do not replace real printf with a fake or delete its ABI effects to manufacture a pass. |
| `scope-1.c` | **Activate KCC/GCC regression** | File-scope **external** `int v=3` is shadowed by function-local `int v=4`; inner block `extern int v` must resolve to the global, or `f` aborts. GCC PDP-6 O0/O1/O2/Os **4/4 pass** with real `f` and abort code. KCC noopt/optimized **2/2 runtime abort**. This source specifically checks external file-scope linkage through a block-scope extern, not arbitrary variable shadowing. |
| `scope-2.c` | **Activate KCC/GCC regression** | Same inner `extern int v` shadowing test, but the original file-scope `v=3` is **static/internal linkage**. Its inner block must still refer to that visible file-scope entity, not local `v=4`. GCC O0/O1/O2/Os **4/4 pass**, KCC noopt/optimized **2/2 runtime abort**, with actual abort checks in emitted GCC O0/O2 code. Preserve as distinct internal-linkage coverage rather than merging with `scope-1.c`. |
| `stdio-opt-1.c` | **Retain deferred** | Hosted `fputs` transformations check observable stream-argument postincrements, `stdout`/`FILE *`, and explicit `__builtin_fputs/fputc/fwrite`; the `__OPTIMIZE__` branch intentionally defines an aborting local `fputs` to detect untransformed calls. KCC noopt **link fails** on hosted stdio dependencies. GCC O0 **compile fails** in its stdio builtin/prototype path. No usable real hosted `FILE` runtime is available; a stub or erased `stdout` would undermine the test. |
| `stdio-opt-2.c` | **Retain deferred** | Hosted `printf` optimization test asserts postincrement side effects on pointer arguments, runs `printf`, `__builtin_printf`, `putchar`, and `puts`, and defines an optimized aborting `printf` for inappropriate residual calls. KCC noopt and GCC O0 both **link fail** with real undefined `printf`. A no-hosted-output PDP-6 execution cannot establish this original assertion; no fake formatter or skipped I/O. |
| `stdio-opt-3.c` | **Retain deferred** | Hosted `fprintf` argument/stream side-effect test checks pointer postincrements and `__builtin_fprintf`, with aborting local `fprintf` under optimization. Both KCC noopt and GCC O0 **compile fail** with the deployed incomplete/incompatible hosted stdio builtin/prototype combination. Preserve original hosted `FILE` requirements. |
| `strcmp-1.c` | **Activate KCC/GCC** | Original two statically aligned character unions vary both string offsets and prefix lengths, constructing equal strings, greater/less lengths, `b` versus `c`, and high-byte octal **0251/0252** comparisons. Each `strcmp` result must have the **correct sign**, not a hardcoded difference magnitude. The high-byte values fit native 9-bit unsigned chars. KCC PDP-6 noopt/optimized **2/2 pass**, GCC O0/O1/O2/Os **4/4 pass**. O0/O2 assembly calls the **real freestanding `strcmp`**, checks the returned sign and retains abort branches. No width adaptation or synthetic comparison. |

No original expected value, source include, call, or C line was
modified. All five retained originals have substantive historical
value, but their missing hosted/conversion dependencies prevent
legitimate native bare-metal registration at this stage.

## Targeted native PDP-6 execution

- Ten originals at KCC noopt and GCC O0: **20 baseline cells**.
- Five meaningful GCC candidates (`ll-1.c`, `strct-1.c`,
  `scope-1.c`, `scope-2.c`, `strcmp-1.c`) at O1/O2/Os:
  **15 optimized GCC cells**.
- Five KCC candidates (`conversion.c`, `strct-1.c`,
  `scope-1.c`, `scope-2.c`, `strcmp-1.c`) at optimized:
  **five optimized KCC cells**.
- **40 bounded native PDP-6 executions**, no broad CPU/compiler
  matrix. The 44 manually gated special tests were not executed.

The new five source owners select **20 GCC native PDP-6 profiles**:
**19 `semantic` passes and one `fail`** (the GCC O0
struct-by-value regression). KCC selects **eight native PDP-6
profiles**: **two `semantic`** (`strcmp-1.c` noopt/opt)
and **six conservatively `fail`** (`strct-1.c`,
`scope-1.c`, `scope-2.c` at the two KCC optimization modes).
`strct-1.c` actually passes KCC noopt but fails optimized;
the shared matrix cell convention retains the conservative
`fail`, with the observed mode distinction in the v26 TSV.

Original execution logs and reports:

- `$TMPDIR/p10tk-deferred-integration-batch18-20261118-v26`
- `$TMPDIR/p10tk-deferred-integration-batch18-gccopts-20261118-v26`
- `$TMPDIR/p10tk-deferred-integration-batch18-kccopts-20261118-v26`

The previously corrected `JRST` freestanding-library dependency
logic remains intact. No standalone compiler, assembler or
linker source was changed.

## Next cursor

Batch 19 (v27) must select ten still-unreviewed canonical
deferred source paths from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v20.tsv`, excluding
all v8-v26 decision-ledger identities. The first is
`tests/semantic/upstream/extensions/strct-pack-2.c`.
At this checkpoint **40 canonical deferred identities await
first individual review**, and **64 previously reviewed sources
remain deferred**. The 16 independent consolidated compiler
repair gates remain open separately. Explain any source deletion
before performing it. Continue to defer broad CPU/compiler
tests and all 44 manual suites.
