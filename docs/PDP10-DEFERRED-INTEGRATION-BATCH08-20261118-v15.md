# Deferred integration: eighth ten-source batch (2026-11-18, v15)

## Scope and ownership

Exactly ten previously unreviewed deferred source identities, selected
in order from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v8.tsv`
after excluding all seven prior ten-source review ledgers (v8-v14).
Only bounded KCC/GCC native PDP-6 profiles were run. No broad
compiler/CPU matrix, other architecture, DAIMOS guest suite or any
of the 44 manually registered special tests was run.

**Six connected, four retained deferred, zero deleted.** No original
source, assertion, compiler, assembler or installed libc was modified.
All ten original source SHA256 pins, execution statuses, exact
registration outcomes and decisions are in
`PDP10-DEFERRED-INTEGRATION-BATCH08-20261118-v15.tsv`.

New authoritative inventory:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v10.tsv`:
  **502 active / 215 deferred / 56 removed / one stress-nonportable**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v9.tsv`:
  **215** existing deferred source SHA256s, all verified;
- `COMPILER_MATRIX.tsv`: **2,161** unique compiler source
  registrations, six more than v14;
- `DEFERRED-SOURCE-DUPLICATES-20261118-v12.tsv` and its v13
  review: unchanged, because no promoted source has a conflicting
  copy in the 50-pair duplicate census.

## Exact source decisions

| Source | Decision | Original assertion and verification limits |
| --- | --- | --- |
| `930126-1.c` | **Connect GCC** | GNU unsigned 8-bit and 32-bit `long long` bitfields in `struct s` are passed to `f`, altered and returned by value; `main` aborts unless `a==12` and `b==0xcdef1234`. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, generated code retains field stores, aggregate return and both checks. KCC noopt does not support long-long bitfield syntax; no KCC pass is claimed. |
| `930406-1.c` | **Connect GCC with scoped termination oracle** | GNU statement expression with local `__label__` increments `x` from one until exactly three, then `f` calls `exit(0)`. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, and generated O0/O2 assembly retains the loop and comparison. The original contains **no explicit abort**, and its unused `big[0x1000]` is not verified for memory integrity. This tests reaching termination through the local-label control flow, not a general stack-allocation stress oracle. KCC noopt rejects the GNU extension. |
| `930513-1.c` | **Retain deferred** | The original invokes `sprintf` **via a function pointer**, formatting double 5.0 as `%.0f` and checking both output bytes (`'5'` and NUL). GCC PDP-6 O0 cannot compile the unavailable installed `stdio.h`/`sprintf` declaration; KCC noopt fails linkage on real `sprintf`. Faking the formatter or deleting its varargs/function-pointer boundary would invalidate the original test. A byte-identical PDP-10 copy remains deferred. |
| `930725-1.c` | **Connect KCC and GCC, with GCC optimizer failures** | `v=1` selects `"abc"` in `f()`, whose return is checked through real freestanding `strcmp`; `main` aborts for incorrect selection. KCC PDP-6 noopt/optimized **2/2 pass**; GCC O0 **passes**, but GCC O1/O2/Os **runtime fail**. Generated O0 code calls `strcmp`; optimized code differs and fails the original check. The uncalled `f1()` and `g()` branches are **not** claimed as tested. GCC matrix status is `semantic/fail/fail/fail`; no compiler fix during this phase. |
| `930921-1.c` | **Connect KCC and GCC, with explicit range limitation** | The original reciprocal constant `0xAAAAAAAB`, 71-bit `unsigned long long` multiply and shifts compute a candidate `i/3`; `main` independently compares it with ordinary division for **all 10,000 inputs 0..9999**. KCC PDP-6 noopt/optimized **2/2 pass**; GCC O0/O1/O2/Os **4/4 pass**. The source was not rewritten to use a 36-bit-wide reciprocal. Its **tested small input range is correct**, but this does *not* validate that a constant derived for 32-bit unsigned division works over all native PDP-10 36-bit input values. |
| `931002-1.c` | **Retain deferred** | Three GNU nested functions `t0/t1/t2` pass nested callbacks through `f`. GCC PDP-6 O0 compiles and links, but the simulator **times out (rc 124)** without readable `__test_exit`; this is not an asserted program mismatch or pass. KCC noopt rejects GNU nested syntax. The callbacks also have **no explicit success counter or abort**. Preserve for later focused trampoline/compiler debugging and meaningful assertion strengthening. |
| `931110-1.c` | **Retain deferred, nonasserting** | Signed `short` bitfields are stored in an array of ten records. The original writes **zero** to already-zero-initialized global storage, never reads back a field and exits successfully without checking any result. GCC PDP-6 O0/O1/O2/Os **4/4 pass**, but these passes **do not verify bitfield write correctness**; even the O0 assembly's `DPB` cannot establish the correct stored values without an assertion. KCC noopt rejects the signed-short bitfield extension. Retain for a later meaningful readback oracle rather than claiming false coverage or deleting the historical source. |
| `941014-2.c` | **Retain deferred** | Original hosted `malloc` obtains a `volatile foo_t`, `f` performs pointer arithmetic/calls, conditionally uses `printf`, stores `b=0x0100`, and main aborts if the value is lost. GCC PDP-6 O0 cannot compile missing `stdio.h`; KCC noopt cannot link `printf` (and hosted allocator prerequisites remain unresolved). A fake allocator, altered branch or removed print cannot faithfully test the original. |
| `941202-1.c` | **Connect GCC** | GNU `static inline f(3)` uses real `alloca` for an `int`, stores the argument, reads it and passes it into `g`, which aborts unless it equals three. GCC PDP-6 O0/O1/O2/Os **4/4 pass**; O0 assembly retains allocation, store/load and the guard. KCC noopt rejects its GNU null declaration/inline dialect. Its source is unchanged. |
| `950221-1.c` | **Connect KCC and GCC, narrow ABI oracle** | `main` sets `el=0`, places `0xdeadbeefL` in `parsefile->fd`, and invokes `f`, which calls `g2(long a)`. `g2` aborts if the passed 36-bit long is wrong and exits on success. KCC PDP-6 noopt/optimized **2/2 pass**; GCC O0/O1/O2/Os **4/4 pass**. The `g1` and `strcpy` path is **unreachable** under the original input, so no string-copy correctness is claimed despite linking its symbol. |

None of the four retained originals is a justified deletion: two
need real hosted facilities, one hangs on GNU nested trampolines, and
one needs a nonvacuous readback assertion. All remain available to
the later compiler/harness review. The prior v8 classification and
v8 deferred-disposition ledgers remain historical snapshots.

## Bounded execution and matrix accounting

- Original baseline: **20** native PDP-6 cells, KCC noopt and GCC
  O0 across the exact ten sources. Seven GCC O0 passes were observed,
  including the subsequently rejected `931110-1.c` vacuous pass.
- GCC optimization follow-up: **21** cells, seven GCC-O0 passing
  originals at O1/O2/Os. Results: **18 pass**, **three runtime
  failures**, all three in `930725-1.c`.
- KCC optimization follow-up: **three** cells on the three
  initially passing KCC sources. All three pass.
- **44 targeted compiler executions** in this batch, with no
  broad CPU/toolchain sweep.

Exactly six new compiler matrix source rows are active. Their 24
selected GCC PDP-6 native slots are **21 passing semantic** and
**three failing optimized** slots. Three KCC-native sources have
two optimization profiles each, **six passing KCC slots**. The
remaining three GCC-only sources are marked KCC `no_test` for
their unsupported GNU constructs; other CPUs remain
`pending`/`unsupported`, not inferred passes.

All source hashes and per-cell statuses are retained in the v15
ten-row TSV. Raw original-source execution reports remain in:

- `$TMPDIR/p10tk-deferred-integration-batch08-20261118-v15`
- `$TMPDIR/p10tk-deferred-integration-batch08-gccopts-20261118-v15`
- `$TMPDIR/p10tk-deferred-integration-batch08-kccopts-20261118-v15`

## Next group

Select exactly ten **previously unreviewed** deferred source
identities from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v9.tsv`,
excluding all v8-v15 ten-row review-ledger identities. The next
begins at `tests/todo/generic/950426-1.c`.
Do not re-review the now documented but still deferred blockers
as if they were new cases. Explain *before* any proposed source
deletion; keep compiler bug fixes, full matrix execution and all
44 manual special tests on hold until this classification work ends.
