# Deferred integration: sixth ten-source batch (2026-11-18, v13)

## Scope and registration policy

Select exactly ten **previously unreviewed** deferred source identities
in the order of `SEMANTIC-DEFERRED-DISPOSITION-20261118-v6.tsv`,
excluding all paths in the v8/v9/v10/v11/v12 ten-source ledgers.
Only bounded PDP-6 native KCC and GCC profiles were executed; no
full compiler matrix, other CPU, DAIMOS guest test, or manually
registered special test was run. All 44 manual registrations remain
untouched. No compiler or libc implementation was modified.

**Seven source identities connected, three retained deferred, none
deleted.** `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v8.tsv`
records **488 active, 229 deferred, 56 removed, one stress source**.
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v7.tsv` pins the **229**
outstanding deferred sources to their actual SHA256s.
`COMPILER_MATRIX.tsv` now owns **2,147 unique compiler sources**.
Earlier manifests remain historical evidence.

The ten-row
`PDP10-DEFERRED-INTEGRATION-BATCH06-20261118-v13.tsv` preserves
each source's original SHA256, current SHA256, previous disposition,
original probe and final PDP-6 profile results, registration outcome,
and exact decision reason.

## Individual decisions

| Original | Decision | Exact assertion and observed limitations |
| --- | --- | --- |
| `920501-7.c` | Connect GCC | GNU nested function `y` recursively descends from depth 1,000, then performs a nonlocal goto to `xlab`; `main` aborts unless `x(DEPTH)==DEPTH`. GCC PDP-6 O0/O1/O2/Os **4/4 pass**. O0/O2 generated assembly includes a real indirect `JRST` and the abort comparison, not a vacuous fallback. KCC rejects GNU nested/local-label syntax. |
| `920501-8.c` | **Retain deferred** | Thirteen variadic integer values after fixed `int/double/int` parameters must be rendered, with the exact string compared after `sprintf`. GCC cannot compile the installed bare-metal `stdio.h` dependency; KCC cannot link actual `printf/sprintf`. Testing only `va_arg` with a fake formatter or removing formatted output would not validate the original oracle. |
| `920603-1.c` | **Connect KCC and GCC after minimal target macro correction** | Original signed 9-bit `char -1` converted to unsigned 18-bit `short` must yield octal `0777777` or abort. The source used lowercase `__pdp10__`; both compilers define uppercase `__PDP10__`, so their original runs wrongly selected the 16-bit non-target expectation and failed. Recognizing either spelling changes **only the preprocessor condition**, not the expression, 18-bit expected constant, or abort. GCC PDP-6 O0/O1/O2/Os **4/4 pass** and KCC native unoptimized/optimized **2/2 pass** with the corrected original source. |
| `920612-2.c` | Connect GCC, limited oracle | GNU nested `a(2)` decrements argument `x` to zero while incrementing captured `i`; `main` asserts return zero. GCC PDP-6 O0/O1/O2/Os **4/4 pass**. O0/O2 assembly retains the nested call and loop. The final value of captured `i` is **not** asserted, so this is only nested call/loop-return coverage, not full captured-variable value verification. KCC rejects nested syntax. |
| `920710-1.c` | Connect GCC | Tests conversion of unsigned 64-bit maximum to `double` within the two specified decimal bounds and a long-to-`float` equality around 16,777,217. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, both original abort expressions retained. KCC noopt fails compilation; a separate KCC compiler/dialect issue, not a GCC pass. |
| `920721-4.c` | Connect GCC; reconcile duplicate | GNU nested `do_switch` returns pointers to six distinct function-local labels, and `try` indirectly branches to return 1..6. Original `main` asserts all six results. GCC PDP-6 O0/O1/O2/Os **4/4 pass**; O0/O2 assembly shows `JRST (register)` and reachable aborts. KCC rejects GNU nested labels-as-values/computed goto. Its byte-identical PDP-10 copy stays deferred. |
| `920726-1.c` | **Retain deferred** | Two real varargs paths, one with structure return, must format exactly `5 20 ` via `sprintf` and `strlen` and compare both buffers. GCC cannot compile hosted `stdio.h`, KCC cannot link real `sprintf`. Replacing formatting with a dummy output routine or changing the comparison would weaken the test. |
| `920728-1.c` | Connect GCC, limited oracle | Converts shifted `0xff000000L` into PDP-10 9-bit `unsigned char`, clears bit 4 and asserts 251. GCC PDP-6 O0/O1/O2/Os **4/4 pass** with a real comparison and abort. The source's GNU zero-length-array typedef is accepted, but its low-three-bit conditional bypasses the subsequent pointer reinterpretation and array read for this input. Do **not** claim zero-length-array memory-access behavior was exercised. KCC rejects the GNU extension. |
| `920810-1.c` | **Retain deferred** | Real `malloc` must allocate a child structure, `memcpy` must copy its parent fields, and `main` asserts correct parent pointer, zeroed name, and structure size. GCC bare-metal hosted includes are incomplete; KCC links fail on real `malloc`. A dummy allocator is not a faithful replacement. |
| `920829-1.c` | Connect GCC | GCC must initialize 71-bit signed `long long c3` from `2863311530LL*3`, then compare it to a runtime `c*3`; `main` aborts on mismatch. GCC PDP-6 O0/O1/O2/Os **4/4 pass**. Generated O0/O2 assembly retains wide integer arithmetic and global comparison. KCC noopt rejects the original initializer/expression syntax, retained as compiler work. |

The three retained sources have meaningful original hosted formatting
or allocation assertions. **None should be deleted on the available
evidence.** The seven connected sources retain their original
assertions; only the `920603-1.c` condition was adapted:

```c
#if defined(__PDP10__) || defined(__pdp10__)
```

This keeps historical lowercase compatibility while correctly using
the two installed compilers' uppercase target macro. The v13 review
ledger preserves both original and modified SHA256s. The changed
source's original is retained in the preceding Git revision.

## Bounded proof and matrix status

- Ten unchanged originals: **20 PDP-6 native cells**, KCC noopt
  and GCC O0. Before the target macro correction, both `920603-1.c`
  cells failed their wrong target expectation.
- Six initially successful GCC sources plus the corrected
  `920603-1.c`: **21** GCC O1/O2/Os cells, **all pass**.
- A scratch-only `-D__pdp10__` check first demonstrated the
  intended source branch: four GCC modes and both KCC modes pass.
- The actual edited source (without added command-line macro)
  passed one further KCC noopt and one GCC O0 run. The original
  edited source also passed KCC optimized. No assertion was changed.

The seven connected source registrations contribute **28 passing
GCC PDP-6 native profiles**, plus KCC `920603-1.c` in its two
native optimization modes. Two more KCC CPU-wide source slots
(`920710-1.c` and `920829-1.c`) are conservatively marked
`error` for original noopt compilation failures, without claiming
independent optimized KCC measurements. Four GNU-only cases are
`no_test` under KCC. All untested CPU/family profiles remain
pending/unsupported as applicable, never claimed passing.

Versioned local evidence:

- `$TMPDIR/p10tk-deferred-integration-batch06-20261118-v13`
- `$TMPDIR/p10tk-deferred-integration-batch06-gccopts-20261118-v13`
- `$TMPDIR/p10tk-batch06-macro-check-20261118-v13`
- `$TMPDIR/p10tk-batch06-920603-source-20261118-v13`

## Identical-source ownership

`tests/semantic/upstream/extensions/920721-4.c` is identical to
`tests/todo/generic/pdp10/920721-4.c`. The new v10 duplicate
census and v11 duplicate review retain all **50 source-pair
SHA256s**. Only this pair changes: the extension source becomes
the active, actually verified GCC owner; its identical PDP-10 copy
remains deferred for its independently unsupported KCC dialect.
No second GCC matrix source was registered. All prior duplicate
census/review revisions remain historical records.

## Next

Batch 7 should select exactly ten **not-yet-reviewed** source
identities from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v7.tsv`,
excluding all paths in the six v8/v9/v10/v11/v12/v13 ten-row
review ledgers. The first eligible path is `920908-2.c`.
Explain any proposed source removal *before* deletion. Defer
ordinary compiler repairs, the full CPU/optimization sweep, and
all 44 manual special tests until the deferred integration review
is complete.
