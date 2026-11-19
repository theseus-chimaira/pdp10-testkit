# Deferred integration: fourth ten-source batch (2026-11-18, v11)

## Scope and provenance

Exactly ten **previously unreviewed** deferred source identities, in
the order of `SEMANTIC-DEFERRED-DISPOSITION-20261118-v4.tsv` after
excluding all paths in the v8, v9 and v10 review ledgers. This is
not a full compiler sweep. No DAIMOS tests, other CPUs, or any of the
44 manually registered specialized tests were run. No compiler
source, libc, or original C assertion was changed.

The ten-row `PDP10-DEFERRED-INTEGRATION-BATCH04-20261118-v11.tsv`
records every original/current source SHA256, per-compiler PDP-6
execution result, tested optimization levels, matrix applicability
and the exact integration/defer reason.

Outcome: **five connected, five retained deferred, zero removed**.
The original classed source count remains 774; current manifest
`SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v6.tsv` records 476
active, 241 deferred, 56 removed and one nonportable stress source.
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v5.tsv` independently
pins all 241 remaining deferred files by SHA256.

## Original-source decisions

| Source | Decision | Original oracle, evidence and limitations |
| --- | --- | --- |
| `20020107-1.c` | Connect GCC | Empty GNU inline asm with matching register constraint, plus pointer arithmetic, must preserve `foo(buf)-1-buf==1` or `bar` aborts. GCC PDP-6 O0/O1/O2/Os pass (4/4). KCC rejects extended GNU asm. This tests compiler expression lowering, **not** a PDP-10 machine instruction. |
| `20020108-1.c` | **Retain deferred** | Original QI/HI/SI shift tests depend on the compiler's `CHAR_BIT` and the `mode` attributes. KCC's `limits.h` reports 9, so **all original switch branches disappear** and its passing execution is vacuous. Installed GCC `lib/gcc-lib/pdp10-dec-none/3.2/include/limits.h` chooses its 8-bit definitions when `__pdp10__` is undefined, but target GCC actually defines `__PDP10__` and its backend has `BITS_PER_UNIT=9`. GCC's O0 pass executes the **wrong-width** tests, not verified 9/18/36-bit PDP-10 shifts. Defer proper target-header correctness and supported-width adaptation to the compiler/full-sweep phase. Neither a fake `-D__pdp10__` nor a hand-edited expected result was used to turn it into a pass. |
| `20020219-1.c` | Connect with KCC optimizer failure | Original `long long` test asserts `(1ULL << 63) >> 0` equals `1ULL << 63`, not an incorrectly narrowed value. GCC PDP-6 O0/O1/O2/Os pass (4/4). KCC noopt passes; KCC optimized **runtime fails**. The KCC matrix's native PDP-6 status applies to *both* optimization modes, so it is conservatively `fail`; their different actual results remain explicit in the v11 ledger. |
| `20020227-1.c` | **Retain deferred** | Packed struct containing a GNU complex float must yield complex 1 and adjacent char 42 on readback. GCC PDP-6 O0 executes and **runtime fails**. KCC rejects GNU complex/packed syntax. Compiler/ABI defect, not an absent assertion. |
| `20020314-1.c` | Connect GCC; reconcile duplicate | Original `g` combines floating operations, an `alloca(16)` and empty `f` call; main checks zero result and four unchanged inputs. GCC PDP-6 O0/O1/O2/Os pass (4/4). The `f` body is empty; do not claim this validates contents or lifetime of the allocated region. KCC noopt link fails on unresolved `alloca`. Its identical PDP-10 source stays deferred independently for KCC. |
| `20020402-3.c` | Connect with KCC optimizer failure | The adapted original `main` asserts the GDB blockvector binary-search result is exactly `&bv` at PC 0x500. GCC PDP-6 O0/O1/O2/Os pass (4/4). KCC noopt passes but KCC optimized **runtime fails**; native KCC matrix status `fail` conservatively covers both modes. |
| `20020406-1.c` | **Retain deferred** | Polynomial recursion needs real `malloc`, `calloc`, and `printf` to create coefficients and reorder degree arguments. GCC PDP-6 O0 cannot link hosted services; KCC rejects GNU `__SIZE_TYPE__`. No allocator stub, removed print call, or rewritten assertion is acceptable evidence for the original hosted program. |
| `20020411-1.c` | **Retain deferred** | GNU complex-float array, `__builtin_conjf`, and conversion to complex double must yield real 1 and imaginary -1; main aborts if either differs. GCC PDP-6 O0 **runtime fails**. KCC rejects GNU complex syntax. Preserve for later compiler/builtin review. |
| `20020412-1.c` | **Retain deferred** | GNU VLA aggregate passed through variadic `va_arg` asserts ten ordered character values. KCC rejects the extension; after the earlier GCC ICE repair, GCC PDP-6 O0 now **executes but fails** its original digit assertion. This remains the separately recorded aggregate-copy ABI/compiler issue deferred to the full compiler sweep. |
| `20020828-2.c` | Connect with explicit compiler failures | All 12 `memset` lengths 1..12 must clear the first `n` characters without changing the suffix, and the source aborts on every mismatch. GCC PDP-6 O0 passes; GCC O1 **runtime fails**, O2 and Os **link fail**; KCC noopt **runtime fails**. Register GCC `semantic/fail/error/error` and KCC `fail`, without weakening any check. |

## Bounded execution and matrix accounting

- Initial original-source PDP-6 KCC noopt and GCC O0: **20 cells**.
- Five meaningful GCC O0 passing sources at O1/O2/Os: **15 cells**
  (12 pass, one runtime failure and two link failures).
- Two original KCC noopt passing, meaningful sources at KCC optimized:
  **2 cells**, both runtime fail.
- Total **37 targeted executions**, not a full sweep.

Five new `COMPILER_MATRIX.tsv` rows contribute 20 selected native
PDP-6 GCC source/profile slots (17 passing, one runtime failure,
two link failures) and eight selected native PDP-6 KCC slots. The
KCC slots are marked `fail` or `error` to preserve known defects;
the v11 ledger distinguishes two actually passing KCC unoptimized
executions from their two optimized failures. Other CPUs and target
families remain unverified, not automatically promoted.

Reports are retained locally under:

- `$TMPDIR/p10tk-deferred-integration-batch04-20261118-v11`
- `$TMPDIR/p10tk-deferred-integration-batch04-gccopts-20261118-v11`
- `$TMPDIR/p10tk-deferred-integration-batch04-kccopts-20261118-v11`
- `$TMPDIR/p10tk-b04-width-check-v11` (temporary header/ABI check)

The width check directly reproduced the installed GCC
`CHAR_BIT==8` preprocessor branch alongside `BITS_PER_UNIT==9`
in the compiler backend; KCC's target header separately specifies
`CHAR_BIT==9`. A temporary standalone scratch program stopped on
its `CHAR_BIT!=9` check before the subsequent mode-width assertions;
those later checks are **not** claimed verified.

## Duplicate-source ownership

`tests/todo/generic/20020314-1.c` has a byte-identical PDP-10 copy
under `tests/todo/generic/20020314-1.c`. The v6 duplicate
census and v7 duplicate review record only the verified generic
source as the active GCC owner. The exact PDP-10 copy retains its
KCC `alloca` link gate and is not scheduled as a second compiler
regression. All **50 source pairs**, their SHA256 pins and earlier
historical review snapshots are retained. Current counts: five
active/deferred pairs and five distinct disposition conflicts, with
zero untracked or doubly scheduled owners.

## Next batch

Select the next **ten distinct, previously unreviewed source paths**
from the new `SEMANTIC-DEFERRED-DISPOSITION-20261118-v5.tsv`, excluding
the v8/v9/v10/v11 review-ledger identities. Do not repeatedly treat
known unresolved sources as new reviews. Retain meaningful compiler
failures until the full compiler sweep; explicitly explain any
inapplicable or vacuous test **before** considering deletion.
Keep all 44 manual special registrations untouched.
