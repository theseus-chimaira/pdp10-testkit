# Deferred integration: ninth ten-source batch (2026-11-18, v16)

## Scope, evidence, and ownership

Review exactly ten previously unreviewed source identities from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v9.tsv`, excluding paths
in all eight preceding v8-v15 ten-source review ledgers. The
original sources, their assertions, tested PDP-6 profiles, final
matrix registrations and any source adaptation are SHA256-pinned
in `PDP10-DEFERRED-INTEGRATION-BATCH09-20261118-v16.tsv`.

**Eight sources connected, two retained deferred, none deleted.**
Only two historical preprocessor conditions were changed. The
asserted numeric constants and execution code were not rewritten;
no compiler, assembler, libc or unsupported-runtime stub was patched.
No full CPU/compiler sweep, DAIMOS guest suite or any of the
44 manually registered special tests was run.

Current authoritative inventory:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v11.tsv`:
  **510 active / 207 deferred / 56 removed / 1 nonportable stress**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v10.tsv`:
  **207** outstanding deferred sources with exact SHA256;
- `COMPILER_MATRIX.tsv`: **2,169** unique compiler sources,
  including eight newly connected original sources;
- Duplicate census/review **v12/v13 remain unchanged**: none
  of the eight new active sources has a byte-identical source
  represented by the 50-pair ownership census.

## Individual decisions and assertion boundaries

| Original | Decision | PDP-6 execution evidence and original oracle |
| --- | --- | --- |
| `950426-1.c` | Connect KCC/GCC | `func1(&p1->m1)` must return -1, then actual freestanding `strlen((p1->m2[i])++)` must return 3 for `m2[3]="123"`. Both tests abort on mismatch. KCC noopt/optimized **2/2 pass**, GCC O0/O1/O2/Os **4/4 pass** with a real `strlen` call. `foo("ok")` has an empty body, so no behavior of `foo` is asserted. |
| `950426-2.c` | Connect KCC/GCC | Right shifting signed 36-bit `long=-2147483648` by `char ca=1` and by `i/-2000000000L` (also 1) must produce -1073741824, with two abort branches. KCC noopt/optimized **2/2 pass**, GCC O0/O1/O2/Os **4/4 pass**. This tests the chosen negative long, not every signed-right-shift case. |
| `950511-1.c` | Connect GCC; preserve KCC failures | An `unsigned long long` is set through a pointer to -3, squared, and asserted to equal 9. GCC O0/O1/O2/Os **4/4 pass**. KCC noopt and optimized **runtime fail**; register their genuine compiler defects, not an unsupported dialect. |
| `950605-1.c` | Connect GCC; preserve KCC failures | Original test passes -1 into `f(unsigned char)` and aborts unless the PDP-10 9-bit value is octal `0777`. Previously the source only checked lowercase `__pdp10__`, which neither installed compiler defines, so both selected an incorrect 8-bit expected value and failed. Recognizing either `__PDP10__` or historical `__pdp10__`, **without changing 0777**, yields GCC O0/O1/O2/Os **4/4 pass**; KCC noopt and optimized still **runtime fail**, a genuine compiler defect. |
| `950607-2.c` | Connect GCC; preserve KCC optimized failure | By-value `Point` operands are subtracted and multiplied as signed `long long`; the cross-product orientation must return exactly 1. GCC O0/O1/O2/Os **4/4 pass**. KCC noopt **passes**, optimized **runtime fails**. The KCC matrix has one native PDP-6 status shared across both modes, so it is conservatively `fail`; the per-mode split is retained in the v16 ledger. |
| `950704-1.c` | Connect KCC; preserve GCC failures | Eight original abort checks test `errflag` on signed wide addition, including the PDP-10-specific octal `MSB` and `MSB_MINUS_1` for the compiler-defined `__LONG_LONG_71BIT__` model. The original lowercase-only `__pdp10__` incorrectly selected standard 64-bit hexadecimal expectations on both installed compilers. Changing only the preprocessor condition to recognize `__PDP10__` selects the intended constants: KCC noopt/optimized **2/2 pass**; GCC O0/O1/O2/Os **4/4 runtime fail**. The GCC compiler failures are registered explicitly, not considered a reason to drop a working KCC test. |
| `960117-1.c` | **Retain deferred, nonasserting** | Packed/aligned GNU union/struct operations set an identifier pointer and character, but `get_id` is declared to return `WORD` without returning a value; `main` never checks the produced fields or return, and calls `exit(0)` unconditionally. KCC noopt and GCC O0 **pass**, but those exits provide no verified semantic result. Preserve the original for later independent readback/return-oracle design. No fake pass or deletion. |
| `960312-1.c` | Connect GCC, scope to original assertion | An **empty** extended GNU `asm` with input-only register constraints affects compiler register allocation around struct/array loads and stores. `main` explicitly asserts `s.sp[2]==2`, which reaches `f`'s `t[2]=t1` and `x->sp=t` path. GCC O0/O1/O2/Os **4/4 pass** with reachable abort; KCC rejects GNU extended asm. This is **compiler constraint/liveness**, *not a PDP-10 ISA opcode test*, and other field assignments are not asserted. |
| `960321-1.c` | Connect GCC; preserve KCC optimized failure | `acc_a(2000000000L)` must subtract a 36-bit long index offset and use a byte pointer to obtain the first character `'d'` or abort. GCC O0/O1/O2/Os **4/4 pass**, with generated `LDB` and abort. KCC noopt **passes**, optimized **runtime fails**. KCC matrix status is conservatively `fail` for both modes; the v16 ledger distinguishes the observed executions. |
| `960327-1.c` | **Retain deferred, hosted formatting** | Original local string scanning, newline switch, and `sprintf(sp+1,"X")` must place `'X'` in `s[12]` or abort. GCC O0 fails compilation due to missing hosted `stdio.h`; KCC noopt cannot link actual `sprintf`. A fake print routine or bypass would change the original asserted behavior; retain for hosted runtime support. |

Both retained originals have concrete future uses; **neither is
eligible for deletion on current evidence**. All other source
assertions, constants and branch semantics remain unchanged.

## Target macro-only adaptations

Only these two conditions changed:

```c
#if defined(__PDP10__) || defined(__pdp10__)
```

They replace the original lowercase-only
`#ifdef __pdp10__` in `950605-1.c` and `950704-1.c`.
Both installed KCC and GCC define uppercase `__PDP10__`; both
also define `__LONG_LONG_71BIT__` for this target. The original
and modified byte hashes are recorded separately in v16 TSV.
The pre-edit originals remain recoverable in Git history.

A scratch-only `-D__pdp10__` preprocessor-branch probe was run
**before** applying the source edits. It established that 9-bit
unsigned-char expectation `0777` worked in GCC's four modes
but failed in KCC's two modes, while the intended 71-bit overflow
expectations worked in KCC's two modes but failed in GCC's
four modes. The actual edited original sources reproduced this
split without command-line macro overrides.

## Narrow execution and profile accounting

- Initial unchanged-source baseline: **20 PDP-6 cells**,
  ten KCC noopt and ten GCC O0.
- Pre-edit scratch macro tests: **12 PDP-6 cells**,
  two sources in four GCC modes and two KCC modes each.
- Actual edited source baselines: **four PDP-6 cells**,
  two sources by KCC noopt and GCC O0.
- Targeted GCC optimization checks: **24 PDP-6 cells**,
  eight active sources at O1/O2/Os, **21 passes and three
  failures** (all three `950704-1.c`).
- Targeted KCC optimized checks: **seven PDP-6 cells**,
  all seven active KCC-supported source identities except
  `960312-1.c`, which requires unsupported GNU asm.

Total **67 bounded execution probes** including scratch tests,
not a broad compiler/CPU sweep. The eight matrix entries select
**32 GCC PDP-6 profiles: 28 passing, four failing**. They select
**14 KCC PDP-6 profiles: six passing and eight conservatively
failing**; two of those failures represent CPU-wide registration
of an observed optimized-only KCC failure with a passing
unoptimized case (`950607-2.c`, `960321-1.c`).
The seven native KCC-supported tests were actually measured
in both modes. Other architectures/profiles remain untested
and pending/unsupported, never reported as passes.

Versioned execution reports remain in:

- `$TMPDIR/p10tk-deferred-integration-batch09-20261118-v16`
- `$TMPDIR/p10tk-b09-macro-probe-20261118-v16`
- `$TMPDIR/p10tk-batch09-edited-two-20261118-v16`
- `$TMPDIR/p10tk-deferred-integration-batch09-gccopts-20261118-v16`
- `$TMPDIR/p10tk-deferred-integration-batch09-kccopts-20261118-v16`

## Duplicate ownership and next review cursor

All **50 exact duplicate-source pairs** retain their historical
SHA256 hashes and v12 census/v13 review. None of the newly active
eight sources has a matching entry in that census; no duplicate
owner change or additional matrix registration was needed.

For batch 10, select the next ten **previously unreviewed**
deferred paths from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v10.tsv`, excluding
all paths in the v8-v16 ten-source review ledgers. The first
eligible source is `tests/todo/generic/960416-1.c`. The 44
manual special tests, ordinary compiler fixes and the full
compiler/CPU sweep remain on hold. Explain any proposed
deletion *before* removing a source.
