# Deferred integration: fifteenth ten-source batch (2026-11-18, v23)

## Scope and outcome

Review precisely ten previously unreviewed canonical source identities
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v16.tsv`, excluding
the preceding fourteen ten-source decision ledgers (v8-v20 and v22).
Inspect original assertions and run only native PDP-6 KCC/GCC
configurations. Do not execute the full CPU/compiler matrix, the
DAIMOS operating-system tests, or any of the 44 manually gated tests.

**Six connected, four retained deferred, none deleted.** One original
source received an independently verified, one-line target-macro
correction; its entire 640-entry arithmetic oracle is unchanged.
The accompanying
`PDP10-DEFERRED-INTEGRATION-BATCH15-20261118-v23.tsv`
pins every original/current SHA256, status before and after that
adaptation, measured PDP-6 profiles, registered matrix cells and
the precise per-source decision.

Authoritative post-batch inventories:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v18.tsv`:
  **496 active / 122 deferred / 58 removed / 1 stress-nonportable**
  source identities, total 677 canonical upstream paths.
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v17.tsv`:
  **122** SHA256-pinned currently deferred source identities.
- `COMPILER_MATRIX.tsv`: **2,155** source rows, six more than v22.
- The 97-entry source-consolidation provenance, its **16 separate
  compiler-gate investigations**, and all retired source aliases
  remain unchanged. The v21 fail-closed audit still requires zero
  duplicate active/deferred source hashes.

## Per-source decisions

| Original source | Decision | Original assertion and native PDP-6 evidence |
| --- | --- | --- |
| `builtin-prefetch-5.c` | **Retain deferred** | Uses potentially unaligned struct/array/char-pointer addresses in `__builtin_prefetch` and exits 0; its only oracle is no abnormal exit. On PDP-6 the compiler may entirely eliminate target prefetch operations; no alignment/fault/side-effect check remains. GCC O0 passes, KCC noopt link fails for missing builtin. Do not treat a no-prefetch target's no-op as validated cache prefetch. |
| `builtin-prefetch-6.c` | **Retain deferred** | Attempts prefetches at potentially invalid pointers, but success is merely `exit(0)` on a target with no prefetch instruction. The source assumes `bits_per_ptr=8*sizeof(void*)`, whereas PDP-10 native characters are 9 bits, and uses single-word `1UL` shifts. GCC O0 passes, KCC noopt link fails. Neither valid address generation nor a hardware non-faulting prefetch was established; retain original. |
| `builtin-types-compatible-p.c` | **Connect GCC with a compile-time-only oracle** | The `rootbeer` array bound requires `__builtin_types_compatible_p(int,typeof(i))` to be constant, then six compatible and six incompatible type assertions cover qualifiers, enums, arrays, typedef aliases, pointers and double/long double. GCC O0/O1/O2/Os **4/4 pass**. The emitted `main` contains only exit because the builtin results fold at compile time; this **does test constant type compatibility**, but not a runtime ABI or memory operation. KCC noopt rejects GNU builtin/`typeof` syntax. |
| `cbrt.c` | **Retain deferred** | A Sun-derived IEEE-754 cube-root algorithm uses 32-bit word splitting and GNU `mode(SI)`. The original exclusion checks only lowercase `__pdp10__`, which both installed PDP-6 compilers omit. GCC O0 therefore runs inappropriate IEEE layout logic and aborts; KCC noopt rejects GNU mode. Simply recognizing uppercase `__PDP10__` in this file would select **`main(){exit(0);}`**, bypassing the sole `cbrtl(27.0)` assertion. Do not make this vacuous change; a proper PDP-10 floating-format implementation is required for meaningful activation. |
| `cmpdi-1.c` | **Connect KCC/GCC; preserve KCC optimized failure** | Original 8-by-8 comparisons through ten signed/unsigned `long long` helpers check **640 exact T/F entries**. An independent 71-bit two's-complement evaluator reproduced all **640 original expected values** with zero mismatches. A historical lowercase-only `__pdp10__` guard selected 64-bit arguments under both compilers. One source line now recognizes uppercase `__PDP10__` **or** historical lowercase, selecting the existing 71-bit octal test inputs; **not a single numeric expectation changed**. Original KCC noopt and GCC O0 both aborted. Corrected KCC noopt **passes**, KCC optimized **runtime fails**, and GCC O0/O1/O2/Os **4/4 pass**. The KCC CPU-wide field is conservatively `fail` for both optimization slots, with the actual split preserved in the v23 TSV. |
| `comp-goto-1.c` | **Retain deferred** | Tests a computed-goto bytecode interpreter with an aligned page allocated by real `malloc(8192)`, pointer-to-integer arithmetic, bitfield program encoding, TLB lookup and final asserted return 88. GCC O0 **link fails** for missing real target `malloc`; KCC noopt rejects GNU computed labels. The original assumes shifts of two units for 32-bit register-byte indexing and a 32-bit guest address encoding, not independently validated with PDP-10 36-bit integers and 9-bit bytes. No fake allocator or changed address computation. |
| `comp-goto-2.c` | **Connect GCC with real nested control flow** | A GNU nested `y` calls itself and performs a nonlocal goto to the enclosing function's `xlab`; `main` asserts `x(DEPTH)==DEPTH` with default `DEPTH=1000`. GCC O0/O1/O2/Os **4/4 pass**. Both O0 and O2 generated assembly contain the recursive `y%0` helper, real indirect `JRST`/jump and the caller's abort comparison. KCC noopt rejects GNU nested functions/`__label__`. |
| `complex-1.c` | **Connect GCC** | A complex function computes the real and imaginary parts of `cexp(1.0i)` through `__real__`/`__imag__`, with explicit `-1.0` and `0.0` comparisons and aborts. GCC O0/O1/O2/Os **4/4 pass**. O0 and O2 emit a real `cexp` call and result comparisons, not an unconditional no-op. KCC noopt rejects GNU complex syntax. |
| `complex-2.c` | **Connect GCC with O0 regression** | The by-value complex function `f(x,y)` computes `x+=y`. `main` checks that original `a=1+i` and `b=-2+2i` were preserved and result `c=-1+3i`. GCC O0 **runtime fails**; GCC O1/O2/Os **3/3 pass**. Emitted O0/O2 code calls `f` and compares complex components with reachable aborts. Register GCC **`fail/semantic/semantic/semantic`**, not an all-mode pass. KCC noopt rejects the GNU complex dialect. |
| `complex-4.c` | **Connect GCC with a compile-time-only signed-zero oracle** | Original conditions assert `(__complex__ double)0.0 == (__complex__ double)(-0.0)` and `0.0 == -0.0`. GCC O0/O1/O2/Os **4/4 pass**. Its `main` is an unconditional exit after correct compiler constant evaluation; this validates only folded complex/scalar zero equality, **not a runtime PDP-6 floating point datapath**. KCC noopt does not accept GNU complex syntax. |

The four deferred sources retain their original assertions and bytes.
Only `cmpdi-1.c` is changed, strictly to select the existing
target-correct input table. No source was removed.

## Verification and scoped execution

The 71-bit comparison-table verification is separate from compiler
execution: parse the original `correct_results[]` and its PDP-10
`__LONG_LONG_71BIT__` octal arguments, map eight signed/unsigned
values into **71 bits**, and independently calculate equality,
inequality, signed/unsigned less-than, greater-than and the reverse
comparisons for all 64 operand pairs. **All 640 values match**.
The historical 64-bit arguments do not reproduce that table.

- Original ten sources x KCC noopt and GCC O0: **20 cells**.
- Six selected original GCC sources, including the originally
  failing `cmpdi-1.c`, x O1/O2/Os: **18 cells**.
- Corrected `cmpdi-1.c` at KCC noopt and GCC O0: **2 cells**.
- Corrected `cmpdi-1.c` at KCC optimized and GCC O1/O2/Os:
  **4 cells**.
- Two additional diagnostic invocations using forced lowercase
  command-line defines were exploratory only, not taken as proof of
  the real source's final semantics. The actual corrected source
  was recompiled and re-executed without forced defines.

Thus **44 ordinary targeted baseline/optimized compiler executions
plus two scratch diagnostics**, not a full CPU/compiler sweep.
The six new source owners select **24 GCC PDP-6 profiles: 23
`semantic`, one `fail`** (`complex-2.c` O0). KCC selects
**two conservatively `fail` slots** for `cmpdi-1.c`, which
is verified passing noopt but failing optimized; no KCC slot for
unsupported GNU extensions is silently counted as success.

Versioned private execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch15-20261118-v23`
- `$TMPDIR/p10tk-deferred-integration-batch15-gccopts-20261118-v23`
- `$TMPDIR/p10tk-deferred-integration-batch15-cmpdi-target-macro-scratch-20261118-v23`
- `$TMPDIR/p10tk-deferred-integration-batch15-cmpdi-edited-20261118-v23`
- `$TMPDIR/p10tk-deferred-integration-batch15-cmpdi-edited-optimized-20261118-v23`

## Next review cursor

Batch 16 should choose the next ten *still-unreviewed surviving*
deferred sources from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v17.tsv`, excluding
all preceding v8-v23 ten-source ledgers. The first is
`tests/semantic/upstream/extensions/complex-5.c`.
There are **70 unique unreviewed deferred** identities and
**52 previously reviewed still deferred**. The **16 separately
preserved consolidated compiler gates** remain open for the
later compiler-repair sweep. Continue to exclude the 44 manual
special tests and full CPU/compiler sweeps, and explain any
proposed source deletion **before** removing it.
