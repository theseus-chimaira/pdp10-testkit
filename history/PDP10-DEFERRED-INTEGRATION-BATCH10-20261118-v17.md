# Deferred integration: tenth ten-source batch (2026-11-18, v17)

## Scope and decision ledger

Select exactly the first ten **previously unreviewed** deferred source
identities from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v10.tsv`,
excluding all earlier v8-v16 ten-row source-review ledgers.
Review original assertions and run only targeted PDP-6 KCC/GCC
cells. No broad compiler/CPU matrix, DAIMOS guest test, or any
of the 44 manually registered special tests was run.

**Six sources connected, three retained deferred, one i386-only
source removed after explicit explanation.** No compiler, linker,
simulator, or installed libc was modified. The only retained source
edit is a historical/actual PDP-10 target-macro compatibility
condition; numeric expected values and assertions are unchanged.

The ten-row `PDP10-DEFERRED-INTEGRATION-BATCH10-20261118-v17.tsv`
records original SHA256, current SHA256 or `removed`, original
disposition, actual KCC/GCC PDP-6 optimization results, matrix
statuses and the precise decision reason.

Current authoritative inventory:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v12.tsv`:
  **516 active, 200 deferred, 57 removed, one nonportable stress**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v11.tsv`:
  **200** current deferred SHA256-pinned sources;
- `COMPILER_MATRIX.tsv`: **2,175** unique registered source owners;
- Existing duplicate census v12/review v13 remain unchanged:
  no new active source is in the 50-pair exact-duplicate inventory.

## Decisions on each original

| Source | Decision | Exact semantic evidence |
| --- | --- | --- |
| `960416-1.c` | **Retain deferred** | Original GNU integer-to-union casts, 36-bit `unsigned long` struct members, and 71-bit `unsigned long long` calculations are checked only inside conditionals comparing `x.d` against two **64-bit-style 32/32 packing constants**. GCC PDP-6 O0 exits successfully, but the layout predicates can skip both `f_be/f_le` failure assertions. O0 assembly keeps conditional branches *before* each expensive function call. No affirmative evidence either predicate was true; do not promote an unverified conditional oracle. KCC rejects integer-to-union GNU syntax. Preserve for later independent PDP-10-appropriate layout/assertion design. |
| `960512-1.c` | **Connect GCC** | GNU complex double `f` sets a complex variable from a zero integer array element, then returns it by value. `main` aborts if the assigned complex result is nonzero, including either component. GCC PDP-6 O0/O1/O2/Os **4/4 pass**; O0 emits conversion, multiword complex return and reachable abort. KCC does not support the GNU complex syntax. |
| `960521-1.c` | **Retain deferred** | Original uses real `malloc` to create two arrays, sets `*b++=0`, then writes -1 through subsequent elements and asserts `b[-1]` is unchanged. Both KCC and GCC PDP-6 baseline **link fail** due to the missing hosted allocator; neither a dummy malloc nor reduced buffer size was substituted. The original memory-boundary oracle remains valuable. |
| `960608-1.c` | **Connect GCC** | GNU `unsigned char` bitfields have widths 2, 3, 1, 1, 1. `main` writes `a=2,b=3,c=0,d=1,e=1`; `foo` compares **all five** and returns a nonzero mismatch indicator. `main` aborts on any mismatch. GCC PDP-6 O0/O1/O2/Os **4/4 pass**; O0 assembly includes byte pointer `DPB` stores and actual field comparisons. KCC rejects this GNU bitfield dialect, not a valid KCC runtime failure. |
| `960830-1.c` | **Remove as inapplicable** | The only real test is i386 `mull` extended assembler with `=a` and `=d` registers, followed by an assertion about 7*7. All of that code is behind `#ifdef __i386__`. On PDP-6/PDP-10, the `#else` contains only `main(){exit(0);}`, which both compilers trivially pass. **No PDP-10 assertion, assembler operand, or machine instruction is executed.** This explicit reason was communicated *before deleting* the source, following the earlier Alpha-only deletion precedent. Its original bytes and source SHA256 survive in the preceding Git revision and v17 ledger; no active semantic test was removed. |
| `961017-2.c` | **Connect KCC and GCC after macro-only adaptation** | A native **36-bit** unsigned `long` repeatedly subtracts hexadecimal `0x4000` from zero until it wraps back to zero, requiring exactly **0x400000** iterations. The unchanged original source uses lowercase `__pdp10__` to select the correct limit; both installed compilers instead define `__PDP10__`, so the prior 32-bit limit **0x40000** caused both to abort. A scratch compile with `-D__pdp10__` passed GCC/KCC PDP-6 noopt; recognizing either spelling in the original source subsequently passes **GCC O0/O1/O2/Os 4/4 and KCC noopt/optimized 2/2**. The loop, condition, numeric limits, and abort remain unchanged. |
| `961122-1.c` | **Retain deferred** | Signed wide-int `acc` starts at `0xffff00000000LL`; `addhi(1)` adds `((long long)1)<<32` and must produce `0x1000000000000LL`. `subhi(1)` must restore the original. Two original abort checks establish meaningful compiler arithmetic coverage. KCC noopt and GCC O0 PDP-6 both **run_fail**, with their actual semantic defects retained for the later compiler sweep. No assertion was changed. |
| `961206-1.c` | **Connect with KCC optimization failure** | Four independent `unsigned long long` comparisons to fixed 32-bit constants must each return zero at `0x80000000ULL`, or `main` aborts. GCC PDP-6 O0/O1/O2/Os **4/4 pass**. KCC noopt **passes**, optimized **runtime fails**. The current KCC native matrix field covers both modes and is conservatively `fail`; this per-mode split remains explicit in the v17 ledger. |
| `970217-1.c` | **Connect GCC, preserve KCC failure** | The parameter `int array[i++]` must increment `i` from 10 to 11; `main` exits nonzero if `sub(10,array)` is not 11. GCC PDP-6 O0/O1/O2/Os **4/4 pass** with an actual increment in O0 assembly; KCC noopt/optimized both **runtime fail**. Preserve the original GNU parameter-VLA side effect and exit-status oracle. |
| `980506-3.c` | **Connect KCC/GCC with explicitly narrow oracle** | Real freestanding `strlen("bind")` and `memset(lookup_table,++m,257)` are called, then `build_lookup` must return exactly 4 or `main` aborts. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, KCC noopt/optimized **2/2 pass**. **The original never reads `lookup_table`**, so this covers call/return/length arithmetic but *not* correct `memset` bytes or the full 257-character memory write. |

Three sources remain deferred, rather than being discarded, because
they have useful or potentially useful original behavior blocked by
layout/oracle selection, real hosted allocation, or genuine wide
arithmetic failures. Only `960830-1.c` is removed, for its
unconditional non-i386 empty exit path.

## Source change and bounded execution

The only retained C-source edit is:

```c
#if defined(__PDP10__) || defined(__pdp10__)
```

in `tests/semantic/upstream/generic/961017-2.c`. This replaces
`#ifdef __pdp10__` and preserves the original 36-bit width
expectation and loop. Both original/current hashes are recorded in
the v17 TSV. The removed x86-only source is also hash-pinned,
marked `removed`, and recoverable in Git history.

Targeted PDP-6 executions:

- Ten original sources x KCC noopt/GCC O0: **20** cells.
- Scratch `-D__pdp10__` check on `961017-2.c`: **two** cells,
  KCC noopt/GCC O0, both passing.
- Actual macro-adapted `961017-2.c` KCC noopt/GCC O0:
  **two** further passes.
- Six meaningful GCC-passing sources at O1/O2/Os:
  **18** cells, **18 passing**.
- Four KCC-eligible active sources at optimized mode:
  **four** cells, two passes and two runtime failures.

Total **46 bounded original and scratch executions**, not a
compiler/CPU sweep. The six new active matrix sources provide
**24 GCC PDP-6 native profiles, all passing**, and **eight KCC
native profiles: four passing, four conservatively marked failing**.
For `961206-1.c`, the latter records an optimized failure
despite the separate noopt success. Other unverified CPUs and
toolchain families remain pending/unsupported.

Local versioned execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch10-20261118-v17`
- `$TMPDIR/p10tk-b10-wrap-limit-scratch-20261118-v17`
- `$TMPDIR/p10tk-b10-961017-edited-20261118-v17`
- `$TMPDIR/p10tk-deferred-integration-batch10-gccopts-20261118-v17`
- `$TMPDIR/p10tk-deferred-integration-batch10-kccopts-20261118-v17`

## Next batch

For batch 11, select the next ten previously unreviewed deferred
source identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v11.tsv`, excluding
all v8-v17 ten-source review ledgers. The first eligible path is
`tests/semantic/upstream/extensions/980526-1.c`. Do not
re-review the three currently unresolved but already classified
sources as new identities.

The 44 manual special tests, ordinary compiler repairs, and full
matrix/CPU sweeps remain outside this work. Explain the exact
PDP-10-specific reason before any future source deletion.
