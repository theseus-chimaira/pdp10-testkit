# Deferred integration: twelfth ten-source batch (2026-11-18, v19)

## Scope and outcome

Review exactly ten previously unreviewed source identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v12.tsv`, excluding all
eleven v8-v18 ten-source ledgers. Inspect original assertions, run
only bounded PDP-6 KCC/GCC configurations, and register only
meaningful tests. Do not run the full compiler/CPU matrix or any
of the 44 manually gated special tests.

**Five connected, five retained deferred, none removed.** All
original C source bytes and assertions remain unchanged. The
source-pinned `PDP10-DEFERRED-INTEGRATION-BATCH12-20261118-v19.tsv`
records the original/current SHA256, original disposition,
measured optimization-specific outcomes, matrix status and
decision reason for each of the ten sources.

Current authoritative sources:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v14.tsv`:
  **526 active, 189 deferred, 58 removed, 1 nonportable stress**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v13.tsv`:
  **189** SHA256-pinned current deferred source identities;
- `COMPILER_MATRIX.tsv`: **2,185** source registrations, five
  more than v18;
- `DEFERRED-SOURCE-DUPLICATES-20261118-v16.tsv` and its
  `DEFERRED-SOURCE-DUPLICATES-20261118-v17.tsv` review:
  exactly **50** original byte-identical source pairs, with
  `991014-1.c` reconciled to one active GCC owner and one
  deferred KCC-specific PDP-10 copy.

## Per-source decisions and real assertions

| Original | Decision | Verified scope and blocker |
| --- | --- | --- |
| `990513-1.c` | **Connect GCC and KCC** | `BM_tab[0400]` is initialized by real freestanding `memset`; `foo` walks backward four `int` elements per iteration, writing 6. `main` aborts unless `BM_tab[0]==6`. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, KCC native noopt/optimized **2/2 pass**. Only index 0 is explicitly asserted; do not claim independent validation of all 256 elements. |
| `990525-1.c` | **Connect GCC; record KCC optimized failure** | By-value `struct blah {int m1,m2}` is copied by the `for` update expression `buf[i++]=arg`; `die` aborts unless `buf[0].m1==1`. GCC PDP-6 O0/O1/O2/Os **4/4 pass**. KCC noopt **passes** but optimized **runtime fails**; single KCC PDP-6 matrix status is conservatively `fail`, and the v19 ledger preserves the true split. `m2` is not asserted. |
| `990628-1.c` | **Retain deferred** | `malloc` allocates `data_record`, `memset` fills storage, `fetch` copies `data_tmp` through `*p++`, and the original abort checks repeated target `0x55` bytes in `dummy`. KCC/GCC PDP-6 baseline **link fail** for actual `malloc`. The deployed header alone does not provide a real allocator. No dummy allocator or source rewrite was used. |
| `990826-0.c` | **Retain deferred** | The original `floor(0.1)==0.0` assertion is a legitimate math-library check, even though the historical comment reports an Alpha/g77 bug. Both compilers fail their PDP-6 baseline on hosted `stdio.h`/`math.h`; real `floor` and libm behavior was not executed. Retain the assertion until a genuine target math implementation is available. |
| `991014-1.c` | **Connect GCC; retain KCC failure** | `typeof(sizeof(char))` and huge array **types** drive `sizeof(union)`, `sizeof(struct)`, and member-offset arithmetic, each checked through original `abort` calls. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, with actual size/offset comparisons in assembly. KCC noopt/optimized **both runtime fail**. This does **not** allocate a huge object: it is compile-time layout calculation, not physical memory stress. The byte-identical PDP-10 copy stays deferred for KCC, without duplicate GCC scheduling. |
| `991030-1.c` | **Connect GCC; retain KCC failure** | The original hexadecimal floating constant `0x1.fp1` initializes `double x`, and `main` aborts unless `x==3.875`. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, KCC noopt/optimized **both runtime fail**. The literal, constant and oracle are unchanged. |
| `991112-1.c` | **Retain deferred** | Indirect function pointer call through `rl_character_len` must classify `'a'` as printable and control byte octal `002` as nonprinting, returning 1 and 2 respectively or aborting. KCC/GCC PDP-6 baselines both **link fail** on missing real `isprint`; a missing header is not the only blocker. No fabricated predicate or altered assertion. The identical PDP-10 copy stays deferred. |
| `991118-1.c` | **Retain deferred** | 52/53-bit signed long-long bitfields in four struct orderings are XORed, returned by value, and checked against fixed **64-bit-style** sign-extension masks. GCC PDP-6 O0/O1/O2/Os **all runtime fail**; KCC rejects long-long bitfields. Because native PDP-10 `long long` is a 71-bit signed representation, the intended target-specific expected masks must be derived independently before labeling these as compiler errors. The source has real assertions and must not be deleted or silently changed. |
| `991216-3.c` | **Connect as failing GCC varargs regression** | Original old-style `<varargs.h>`, `va_alist` / `va_dcl` and `va_arg` compare a variable number of integer arguments, followed by an exact wide `long long` value and trailing `0x55` in eight separate test invocations. GCC PDP-6 O0/O1/O2/Os **all runtime fail**; generated code contains the original comparisons/abort paths and eight call sites. Early failure can prevent reaching later calls: **do not claim all eight passed or fully executed**. KCC rejects the old-style varargs dialect, recorded `no_test`, not as a KCC run failure. The working failing GCC oracle is registered for the later compiler sweep. |
| `991228-1.c` | **Retain deferred; record GCC ICE** | Original GNU designated union initializer `d: -0.25`, double-to-two-word representation and `signbit` assertion. GCC PDP-6 O0 **internal compiler error** in `instantiate_virtual_regs_1` at `function.c:4444`. GCC O1/O2/Os do compile and exit 0, but actual assembly branches to the **early exit without calling `signbit`**; these are vacuous passes, not evidence that the regression is fixed. KCC rejects the designated-initializer syntax. Keep source unchanged and preserve the ICE for priority compiler triage, not as a passing test. |

No test warranted deletion. Five retained sources have meaningful
original assertions and either real hosted dependencies, unresolved
71-bit semantic expectations, or a compiler ICE that remains
diagnostically valuable.

## Bounded execution and matrix accounting

- Exactly ten original sources at KCC PDP-6 noopt and GCC O0:
  **20 native cells**.
- Four original GCC-O0-passing source identities plus three
  additional targeted GCC-failing/ICE sources at O1/O2/Os:
  **21 native cells**. The 12 optimized checks for the four
  connectable successes all pass. The six optimized
  `991118-1.c`/`991216-3.c` cells fail; the three
  `991228-1.c` runs exit without exercising `signbit`.
- Four KCC-supported sources with baseline passes or runtime
  failures at KCC optimized: **four native cells**.

**45 targeted compiler cells total**, not a broad sweep. The
five new matrix source owners select **20 GCC PDP-6 native
profiles: 16 `semantic` and four `fail`**. Four KCC-eligible
source owners select **eight KCC native PDP-6 slots: two
`semantic` and six conservatively `fail`**, with the
unoptimized success of `990525-1.c` preserved separately.
`991216-3.c` remains `no_test` for unsupported KCC old-style
varargs syntax. No untested CPU or toolchain family is recorded
as passing.

Versioned local evidence:

- `$TMPDIR/p10tk-deferred-integration-batch12-20261118-v19`
- `$TMPDIR/p10tk-deferred-integration-batch12-gccopts-20261118-v19`
- `$TMPDIR/p10tk-deferred-integration-batch12-kccopts-20261118-v19`

## Exact duplicate ownership and next review

`tests/todo/generic/991014-1.c` is byte-identical to
`tests/todo/generic/pdp10/991014-1.c`. The v16 duplicate census
and v17 review preserve all **50 SHA256-identical source pairs**
and reconcile this one pair to active generic GCC owner plus
deferred PDP-10/KCC-specific blocker. Neither source is edited,
deleted, or double-registered. Other duplicate records and
historical census versions are unchanged.

Batch 13 should select exactly ten previously unreviewed paths
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v13.tsv`, excluding
all v8-v19 ten-row ledgers, beginning at
`tests/semantic/upstream/extensions/align-1.c`. All **44 manual
special tests** and the full CPU/compiler sweep remain on hold.
Any future proposed deletion must first be explained to the user
with its exact target-specific reason.
