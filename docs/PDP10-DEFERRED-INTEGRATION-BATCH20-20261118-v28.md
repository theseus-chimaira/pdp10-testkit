# Deferred integration: twentieth ten-source batch (2026-11-18, v28)

## Scope, source selection, and disposition

Inspect exactly ten previously unreviewed canonical source identities,
beginning at `tests/semantic/upstream/extensions/string-opt-2.c`,
in manifest order from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v21.tsv`. Exclude
every source in the v8-v27 ten-source review ledgers and the 97
physically retired duplicate aliases. Read the complete original
C source and its actual checks, then run only bounded native PDP-6
KCC/GCC profiles. No broad compiler/CPU sweep, DAIMOS test,
or one of the 44 manually gated special tests was run.

**All ten sources activated, none retained deferred, no C source
adaptation and no source deletion.** All ten sources contain genuine
original runtime assertions. The original freestanding string
libraries are now available for relevant ordinary calls, removing
several historical linkage blockers. This does not make the actual
compiler failures pass: every failure observed in the selected GCC
profiles is preserved.

The matching
`PDP10-DEFERRED-INTEGRATION-BATCH20-20261118-v28.tsv`
records original/current SHA256 (identical), previous disposition,
all measured KCC/GCC native PDP-6 execution outcomes, matrix
registration statuses, and per-source evidence.

Authoritative new inventories:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v23.tsv`:
  **533 active, 85 deferred, 58 removed, 1 stress-nonportable**,
  total 677 canonical historical source identities.
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v22.tsv`:
  **85** SHA256-pinned still-deferred source identities.
- `COMPILER_MATRIX.tsv`: **2,192** registered source owners.
- Historical v21 consolidation remains **97 retired source
  aliases, zero current duplicate source hashes, and 16
  separately preserved compiler-specific repair gates**.

## Ten original-source decisions

| Original source | Decision and observed native PDP-6 evidence |
| --- | --- |
| `string-opt-2.c` | **Activate GCC failing regression.** `strpbrk`/`__builtin_strpbrk` must return exact pointers for empty accept sets, first matching characters, and letters in `hello world`; `strcmp` checks the substring `"llo world"`. The original `*bar--` tests pointer side effects. GCC O0/O1/O2/Os **all runtime abort** (`__test_exit=1`), not timeouts or linker errors. GCC O0 links actual `strcmp` and freestanding `strpbrk`; optimized O2 emits an immediate abort. KCC noopt/optimized **both link fail on undefined GNU `__builtin_strpbrk`**, even though ordinary assembler `strpbrk` is linked. Thus KCC GNU-builtin profiles remain `no_test`, not a fabricated KCC regression pass or an ordinary missing-libc claim. |
| `string-opt-3.c` | **Activate GCC failing regression.** The original uses `strlen`, `strcmp`, `strrchr`, `rindex` and explicit GNU builtins to assert lengths, equality and ordering, last-character and NUL pointer locations, and exact `x++`/`--x` evaluation counts. GCC O0/O1/O2/Os **all runtime abort**; O0 actually links target `strlen`, `strcmp` and other string functions, while optimized code emits an early abort. KCC noopt rejects the GNU declarations. The source's own nonoptimized `rindex` fallback remains unchanged. |
| `string-opt-4.c` | **Activate GCC mixed optimization regression.** The original checks missing `x`, first/next `o`, the trailing NUL pointer, `index` for absent `z`, and explicit `__builtin_strchr/index` pointer results. GCC **O0 passes** with a real freestanding `strchr`; O1/O2/Os **all runtime abort**. KCC noopt/optimized **both link fail on undefined GNU `__builtin_strchr`**, despite ordinary `strchr` being available. KCC GNU-builtin cells remain unsupported/`no_test`. |
| `string-opt-5.c` | **Activate GCC failing regression.** This longer source checks actual `strlen` lengths; `strcmp` sign and matching; `strchr`/`strrchr` pointer results; `strncpy` exact padding and bytes; `memset` return pointers, contents and side effects; and explicit `x`/`y` increment counts. GCC O0/O1/O2/Os **all runtime abort** with real freestanding string/memory routines selected at O0/O2. KCC noopt fails compiling the GNU builtin/type dialect. No expected value, buffer length or side-effect expression changed. |
| `string-opt-6.c` | **Activate GCC failing regression.** Original global `p[32]` undergoes `strcpy` and `memcpy` at several offsets, with exact destination return values and `memcmp` readback of 5/6/9-byte patterns, including explicit GNU builtin forms. GCC O0/O1/O2/Os **all runtime abort**; O0 links ordinary `strcpy`, `memcpy`, `memcmp`; O2 still emits `memcmp` and reachable abort checks. KCC noopt rejects the GNU builtin declarations. |
| `string-opt-7.c` | **Activate GCC mixed regression.** The source resets a 64-byte destination using real `memset`, then verifies `strncpy` result pointer and content for four-byte, zero-byte, twelve-byte and explicit `__builtin_strncpy` operations through `strncmp`/`strcmp`. It also requires `++dst2` and `++src2` to evaluate once, including zero-length calls. GCC **O0 passes**, O1/O2/Os **all runtime abort**; optimized O2 contains actual calls and checks. KCC noopt rejects the GNU builtin/type syntax. |
| `string-opt-8.c` | **Activate GCC failing regression.** Numerous `strncmp` assertions check equality, greater/less signs, length zero/one/large, pointer increments and `++n` counts, plus explicit `__builtin_strncmp`. The additional `cmpstrsi`-hardware-only subtests are guarded for i386/pj/i370 and correctly not reached on PDP-6; the extensive generic oracle still executes. GCC O0/O1/O2/Os **all runtime abort**, O0 using the actual freestanding `strncmp`. KCC noopt rejects GNU builtin/type syntax. No platform guard was changed. |
| `string-opt-9.c` | **Activate GCC mixed regression.** Original `strcpy` resets the destination; `strcat` with empty or NUL-pointing source must return the exact destination pointer and preserve the expected string. `++d2` evaluation and explicit `__builtin_strcat` are checked. GCC **O0 passes** with real `strcpy`/`strcat`/`strcmp`, O1/O2/Os **runtime abort**. Optimized O2 still contains calls and abort branches. KCC noopt rejects GNU builtin/type syntax. |
| `strlen-1.c` | **Activate KCC/GCC native alignment-length regression.** The original statically aligned union holds a 9-bit character array and long-long/long-double alignment members. For all offsets before `sizeof(long long)` and lengths before `8*sizeof(long long)`, it writes a zero prefix, `len` `'a'` characters, one NUL, and a `'b'` suffix. The actual `strlen(u.buf+off)` result must equal `len` or abort. KCC noopt/optimized **both pass**. GCC O0/O1/O2/Os **all runtime abort** with real freestanding `strlen`; never describe these as missing headers or timeouts. |
| `strncmp-1.c` | **Activate KCC/GCC native alignment-sign regression.** The original loops over both aligned-union offsets and varying string lengths. Its test function asserts `strncmp` signs and equality for matching prefixes, longer/shorter strings, `b`/`c` and native 9-bit high-byte octal `0251`/`0252`, comparing both full available length and exact prefix length. KCC noopt/optimized **both pass**. GCC O0/O1/O2/Os **all pass**, with real freestanding `strncmp` and abort comparisons emitted. No loop limits, sizes or expected values were changed. |

## Correct interpretation of KCC failures

The original `string-opt-2.c` and `string-opt-4.c` compile
under KCC but do not link under **either** KCC optimization mode:
their unresolved symbols are `__builtin_strpbrk` and
`__builtin_strchr`. These are GNU-specific builtin entry
names, **not** failures to provide the ordinary
`strpbrk`/`strchr` implementations, which are actually
selected by the archive resolver. Since the tests explicitly
exercise GNU builtin optimization and KCC does not implement
these GNU intrinsics, these KCC profiles remain `no_test`.
Both exact `link_fail` statuses are nevertheless retained
in the v28 ledger for later compiler feature-policy review.
The other six GNU source tests fail KCC compilation and are
also not registered as KCC semantic successes.

The two non-GNU alignment/length tests are genuine
KCC-compatible tests: both pass KCC noopt and optimized.
All source bytes and the original assertion values were
left untouched.

## Bounded compiler execution and registration accounting

- Original ten-source KCC noopt plus GCC O0 baseline:
  **20 cells**.
- All ten originals at GCC O1/O2/Os:
  **30 optimized GCC cells**.
- The two supported alignment/length tests at KCC optimized:
  **two cells**.
- GNU builtin `string-opt-2.c` and `string-opt-4.c`
  KCC optimized linkage checks: **two cells**.
- **54 targeted native PDP-6 executions total**, no full
  processor/compiler sweep and no manual suite.

Ten new source registrations add **40 GCC PDP-6 native
profiles**: **seven observed `semantic` passes and 33
`fail` statuses** for real guest `abort` executions,
not compile errors or simulator timeouts. The two
KCC-compatible tests add **four observed `semantic`
profiles**; the eight GNU-specific tests have no selected
KCC profiles. All remaining architecture, backend,
family and manual-suite cells remain pending or
unsupported as appropriate.

Versioned local execution evidence:

- `$TMPDIR/p10tk-deferred-integration-batch20-20261118-v28`
- `$TMPDIR/p10tk-deferred-integration-batch20-gccopts-20261118-v28`
- `$TMPDIR/p10tk-deferred-integration-batch20-kccopts-20261118-v28`
- `$TMPDIR/p10tk-deferred-integration-batch20-kccopts-string-20261118-v28`

## Next review cursor

Batch 21 (v29) begins at
`tests/todo/generic/generic/struct-ini-4.c`.
Select the next ten *still-unreviewed* canonical sources
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v22.tsv`,
excluding all prior v8-v28 ten-source decision ledgers.
There are **20 still-unreviewed** deferred identities
and **65 previously reviewed identities still deferred**.
The 16 independent consolidated compiler gates remain
open for a later compiler/assembler repair sweep.
Explain any proposed deletion before removing a source.
Do not run the 44 manual tests or broad CPU/compiler
matrix during that bounded review.
