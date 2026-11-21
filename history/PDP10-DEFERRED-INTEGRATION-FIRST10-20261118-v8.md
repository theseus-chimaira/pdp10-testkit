# Deferred integration: first ten sources (2026-11-18, v8)

## Scope

This is exactly the **first ten rows** of the historical
`SEMANTIC-DEFERRED-DISPOSITION-20261019-v1.tsv` in declaration order.
The batch reviews, checks and connects meaningful compiler sources,
not the 44 manually registered special tests. It does **not** run
the full compiler/CPU matrix, change compiler sources or chase
ordinary compiler regressions. No source was removed in this batch.

The original 774-entry classification and 269-entry deferred ledger
remain unchanged as historical snapshots. Current authoritative
files are:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v3.tsv`
  (458 active, 260 deferred, 55 removed, one stress-nonportable);
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v2.tsv`
  (260 source SHA256-pinned outstanding decisions);
- `PDP10-DEFERRED-INTEGRATION-FIRST10-20261118-v8.tsv`
  (all ten decisions, original/current hashes and distinct observed
  compiler/optimization outcomes).

Nine C sources were connected to `COMPILER_MATRIX.tsv`. The sole
remaining deferred test was **retained**, not dropped. Existing
source assertions, failure/abort paths, and compiler/runtime helpers
were not weakened or replaced by success stubs.

## Decisions (exact group of ten)

| Source | Decision | Reason and currently checked execution |
| --- | --- | --- |
| `20000227-1.c` | Activate | Raw high-bit source literal versus octal escape equality; GCC PDP-6 all four optimizations pass. KCC `-n` runtime failure remains recorded. |
| `20000622-1.c` | Activate | Three argument values and integer/pointer cast are asserted; GCC PDP-6 all four optimizations pass. KCC `-n` runtime failure remains. |
| `20000703-1.c` | Activate | GNU memory builtins and adjacent struct field integrity; GCC PDP-6 all four optimizations pass with real installed freestanding linkage. KCC cannot link its builtin symbol. |
| `20000815-1.c` | Activate | CSE invalidation must not call an aborting remove operation; GCC PDP-6 all four optimizations pass. KCC lacks builtin `memset` lowering/linkage. |
| `20000822-1.c` | Activate partially | Genuine nested-function/trampoline path: `f0`, `f1`, and nested `f2` are present in the generated program, and the original assertion passes with GCC `-O0`. GCC `-O1/-O2/-Os` fail at runtime and are registered as **fail**, not pass. KCC nested functions remain unsupported. |
| `20000914-1.c` | **Retain deferred** | GCC cannot link a real hosted `malloc` implementation; KCC additionally rejects GNU `__SIZE_TYPE__` declaration syntax. The test's enum/bitfield/aggregate switch and allocation dependency remain meaningful. Neither stubbing `malloc` nor deleting the test is warranted. |
| `20001009-1.c` | Activate | Original `__pdp10__` condition failed to select the 9-bit branch because installed GCC and KCC predefine `__PDP10__`. Recognizing either spelling retains the original expected-value assertion. GCC PDP-6 four optimizations and KCC PDP-6 optimized/unoptimized all pass. |
| `20001009-2.c` | Activate | Same target-macro correction selects `0x1ff` for an asserted signed 9-bit conversion to -1 across an empty extended-assembly barrier. GCC PDP-6 four optimizations pass; KCC rejects GNU extended-asm syntax. This is a compiler semantic test, not independent ISA instruction coverage. |
| `20001026-1.c` | Activate | GNU builtin `memset`, by-value aggregate return and nonzero field assertion; GCC PDP-6 four optimizations pass; KCC builtin unresolved. |
| `20001203-2.c` | Activate | Real statement-expression and nested-aggregate evaluation asserts computed length `4*(2-0+1)==12`. GCC PDP-6 four optimizations pass; KCC rejects GNU type/syntax. The original `xmalloc` test helper is unchanged. |

No decision above is a claim about other CPUs, target families or
optimization profiles that were not executed. New matrix rows retain
`pending` for eligible unverified profiles and `unsupported` for
PDP-6 target-family combinations that cannot execute. KCC GNU-only
constructs are not silently counted as passing. Existing KCC
compile/link/runtime failures are preserved in the review ledger;
where their extension is potentially supported, the matrix marks
the observed PDP-6 failure and leaves other KCC profiles pending.

## Why the two 9-bit tests needed adaptation

Both originals had
`#ifdef __pdp10__` around a **target-specific expected value**, but
the installed PDP-10 compilers define `__PDP10__` instead. The old
non-target branch used `0xfe` or `0xff`, yielding real runtime
failures that were not evidence of a compiler signed-char bug.
Only the preprocessor condition changed to:

```c
#if defined(__PDP10__) || defined(__pdp10__)
```

The exact expression under test, the 9-bit constants, asserted return
values, and abort paths are unchanged. A scratch-only `-D__pdp10__`
experiment first demonstrated the correct branches; the two updated
source files then passed their actual PDP-6 probes without added
compiler flags, including independently rerun optimized modes.
The v8 review TSV retains both original and changed source hashes.
The untouched originals are recoverable from the Git parent of this
integration commit.

## Bounded execution evidence

1. Original ten sources, one PDP-6 native profile per compiler:
   20 cells (KCC `-n`, GCC `-O0`).
2. Seven initially GCC-passing sources, `-O1/-O2/-Os`:
   21 cells. All pass except the three optimizer-level executions
   of `20000822-1.c`.
3. The two signed-char sources under the correct PDP-10 branch in
   scratch: eight GCC optimization executions and two KCC modes
   for the first source.
4. Corrected originals rechecked without explicit macro flags:
   KCC/GCC PDP-6 `-n/-O0` original-source probes; six further GCC
   optimization executions and KCC optimized for `20001009-1.c`.

Detailed preserved per-cell reports:

- `$TMPDIR/p10tk-deferred-integration-first10-20261118-v1`
- `$TMPDIR/p10tk-deferred-integration-first10-gccopts-20261118-v1`
- `$TMPDIR/p10tk-first10-macro-20261118-v1`
- `$TMPDIR/p10tk-first10-macro-source-20261118-v2`
- `$TMPDIR/p10tk-first10-source-postedit-20261118-v2`

The tests use the real installed compiler, assembler, simulator,
freestanding library where referenced, and original bare-metal
`abort`/`exit` termination checks. No full matrix or manual-special
suite was started.

## Following batch

Select only the **next ten still-deferred sources** from the updated
260-row disposition in order. Classify each original assertion and
its dependencies before considering deletion. If a source cannot
be integrated, state why before making any deletion; keeping it
deferred is preferred whenever a real test remains possible.
Defer ordinary compiler failures (including the GCC VLA aggregate
copy issue) until the later full sweep.
