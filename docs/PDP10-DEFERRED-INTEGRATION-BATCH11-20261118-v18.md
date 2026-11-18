# Deferred integration: eleventh ten-source batch (2026-11-18, v18)

## Scope and outcome

Select exactly ten *previously unreviewed* deferred source identities
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v11.tsv`, excluding all
v8-v17 ten-row review ledgers. Inspect original assertions and run only
selected native PDP-6 GCC/KCC configurations. No full CPU/compiler
matrix, DAIMOS guest suite, or one of the 44 manual special tests was
run. Do not change compiler, assembler, simulator, or runtime libraries.

**Five source owners connected; four retained deferred; one source
removed after its architecture-specific incompatibility was explicitly
explained before deletion.** The source-pinned ten-row decision ledger
is `PDP10-DEFERRED-INTEGRATION-BATCH11-20261118-v18.tsv`. Each entry
records original/current SHA256, status before/after any adaptation,
all measured PDP-6 compiler outcomes, matrix statuses, and the actual
reason for connecting, retaining, or removing that source.

Current authoritative state:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v13.tsv`:
  **521 active, 194 deferred, 58 removed, one stress-nonportable**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v12.tsv`:
  **194** SHA256-pinned deferred originals, including an explicitly
  reconciled, minimally corrected duplicate copy;
- `COMPILER_MATRIX.tsv`: **2,180** registered source identities,
  five more than v17;
- Duplicate census `DEFERRED-SOURCE-DUPLICATES-20261118-v14.tsv`
  and review `DEFERRED-SOURCE-DUPLICATES-20261118-v15.tsv`:
  all **50** identical-source pairs retained, with the one
  `990106-2.c` active/deferred ownership and matching-hash
  transition made explicit.

Earlier manifests and duplicate-census revisions remain historical
snapshots and are not silently rewritten.

## Per-source decisions

| Original source | Decision | Genuine PDP-6 assertion and current evidence |
| --- | --- | --- |
| `980526-1.c` | **Connect GCC** | GNU function-local `__label__` values populate a static two-entry jump table, and `doit(0)` / `doit(1)` must return 1 / 2 respectively or the callers abort. GCC O0/O1/O2/Os **4/4 pass**. Both O0 and O2 generated code contain an actual **indirect `JRST`** and abort comparisons; this is not a bypassed label test. KCC rejects GNU label addresses and computed goto. |
| `980526-2.c` | **Retain deferred** | Original Linux device-number encoding expects the *32-bit* bit pattern `0x15800078` from `major<<22 | minor`; it also includes integer/pointer arithmetic in `getname`. On native PDP-10 `unsigned int` is **36 bits**, so the original 32-bit truncation/encoding cannot be assumed. Both GCC and KCC baseline **run_fail**. The corresponding PDP-10 copy remains deferred. Do not replace the fixed assertion with an unreviewed native encoding; establish intended 36-bit semantics first. |
| `980605-1.c` | **Retain deferred** | Original 20 `getval` calls, floating-to-`unsigned short` conversion, and integer sum must equal 227 or abort; the same result is also written through real `sprintf`. GCC baseline cannot compile absent `stdio.h`; KCC baseline links fail on `sprintf`. Removing formatted output or faking the ABI would alter the test's combined oracle. Keep source intact for a genuine hosted runtime. |
| `980707-1.c` | **Retain deferred** | `buildargv` splits writable `" a b"` with actual `isspace`, and `main` checks `strcmp(args[0],"a")`, `strcmp(args[1],"b")`, and the final NULL slot. GCC baseline lacks `stdio.h` and `ctype.h`. KCC has working freestanding string routines but **cannot link `isspace`**; the unused stdio include is not its sole blocker. Keep the original three assertions; do not substitute a fake whitespace function. |
| `980709-1.c` | **Retain deferred** | The original volatile-double `a=32.0`, real `pow(a,1.0/3.0)`, and +/-0.1 floating tolerance around 3.174802 are genuine math-library coverage. Both compilers fail their PDP-6 baseline at the unavailable `math.h` prerequisite. No real target `pow` execution was established; retain until a proper header and implementation are installed. |
| `990106-2.c` | **Connect KCC and preserve GCC failures** | Native unsigned 36-bit `c=-1`, `a=c/1234`, `b=0-a*1234` must return **1008** modulo 2^36 or abort. The historical lowercase `__pdp10__` guard incorrectly selected a non-PDP-10 width branch. The actual compiler target macro `__PDP10__`, accepted alongside lowercase, selects the unchanged original 1008 expected value. KCC noopt/optimized **2/2 pass**, while GCC O0/O1/O2/Os **4/4 runtime fail**. Both identical source copies received the **same one-line guard correction**; the generic source is the sole active matrix owner, while the PDP-10 copy stays deferred for GCC arithmetic triage. |
| `990127-2.c` | **Connect GCC; preserve KCC optimized failure** | `fpTest(35.7,45.0)` compares the constant expression `(35.7*100.0)/45.0` with the actual parameter expression `(x*100.0)/y`; `fpEq` aborts if they differ. GCC O0/O1/O2/Os **4/4 pass**; KCC noopt **passes** but optimized **runtime fails**. The current KCC native matrix status spans both modes and is conservatively `fail`; the v18 ledger retains the true split. |
| `990130-1.c` | **Connect GCC (compiler constraint, not ISA)** | Empty GNU extended `asm("" : "+r"(*bar()))` must evaluate `bar()` exactly once; `bar` increments global `count`, and `main` aborts unless `count==1`. GCC O0/O1/O2/Os **4/4 pass**, and O0/O2 emitted code calls the helper and checks `count` with a reachable abort. KCC rejects the GNU extended-assembly syntax. **No PDP-10 assembler instruction is being tested.** |
| `990324-1.c` | **Connect KCC and optimized GCC; preserve GCC O0 failure** | The PDP-10-specific octal long argument `0777777777001` must cast to a native 9-bit signed `char` that is positive and nonzero, otherwise `f` aborts. The old lowercase-only `__pdp10__` selected the wrong non-PDP-10 input. With the same macro compatibility correction and unchanged octal argument, KCC noopt/optimized **2/2 pass**, GCC **O0 runtime fails**, while GCC O1/O2/Os **3/3 pass**. Register `fail/semantic/semantic/semantic` for GCC. |
| `990413-2.c` | **Remove as inapplicable x87 ISA fixture** | The test's actual arithmetic requires x87 **`fpatan`**, **`fsqrt`**, register-stack constraints **`=t`, `u`, `st(1)`**, and 32-bit halves of an x86 double. GCC cannot compile unknown `st(1)` register on PDP-6 and KCC rejects the GNU assembly syntax. There is **no PDP-10 machine instruction, suitable alternate implementation, or executable target assertion** in this source. This concrete reason was provided **before deletion**. Original source and SHA256 remain recoverable from the parent Git commit and v18 ledger. |

No other source was removed. The four retained sources have distinct
real blockers (width-specific system encoding, formatted runtime,
ctype runtime, math runtime) and are not judged disposable.

## Target-macro change and duplicate reconciliation

The two newly active regression sources `990106-2.c` and
`990324-1.c` replace exactly one historical guard:

```c
#if defined(__PDP10__) || defined(__pdp10__)
```

This preserves historical lowercase compatibility while accepting
the installed compilers' uppercase target macro. Every original
arithmetic expression, expected value, and abort is unchanged.

For `990106-2.c`, the byte-identical **deferred** counterpart at
`tests/semantic/upstream/pdp10/pdp10/990106-2.c` receives the
**same guard-only change**, without registration or extra execution.
Its SHA256 is updated in the v12 deferred manifest and in the v14
duplicate census/v15 review. The earlier exact duplicate SHA256
remains in the previous manifests and Git revision. The pair now
has an active generic owner with observed **KCC pass/GCC fail**
and a deferred historical PDP-10 copy retaining the GCC defect
without double scheduling. The other 49 pairs are untouched.

## Targeted execution accounting

- Ten original sources x KCC noopt and GCC O0: **20 cells**.
- Scratch-only target-guard check, two sources x four GCC
  optimizations and two KCC modes: **12 cells**.
- The two edited originals x KCC noopt and GCC O0: **4 cells**.
- The five selected connected source owners x GCC O1/O2/Os:
  **15 cells**, of which **12 pass and 3 fail** (all three
  optimized failures are from `990106-2.c`).
- Three KCC-supported owners x KCC optimized: **3 cells**,
  two pass and one runtime fails.

The actual **54 bounded checks** include scratch probes, not a
full compiler or CPU sweep. The five new active matrix sources
select **20 GCC native PDP-6 profiles: 15 pass, 5 fail**.
They select **six KCC native PDP-6 profiles: four pass and two
conservatively fail**, since the `990127-2.c` optimized-only
failure is represented by a shared CPU-wide status for both modes.
Other CPUs and compiler families remain pending/unsupported,
never inferred as passing.

Versioned local execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch11-20261118-v18`
- `$TMPDIR/p10tk-b11-macro-scratch-20261118-v18`
- `$TMPDIR/p10tk-batch11-macro-edited-20261118-v18`
- `$TMPDIR/p10tk-deferred-integration-batch11-gccopts-20261118-v18`
- `$TMPDIR/p10tk-deferred-integration-batch11-kccopts-20261118-v18`

## Next ten-source cursor

For batch 12, choose the first ten paths still deferred and
absent from **all v8-v18 review ledgers**, beginning with
`tests/todo/generic/990513-1.c` in the current
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v12.tsv`.
There are **160** not-yet-individually-reviewed deferred sources
and **34** deferred identities already reviewed by these batches.
Keep all 44 manual tests, full CPU/compiler sweeps, and routine
compiler repairs on hold. Explain any proposed source deletion
before taking action.
