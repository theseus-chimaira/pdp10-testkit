# PDP-10 testkit current stop point before full sweep (v20)

Date: 2026-11-21. **`pdp10-testkit` and GCC were updated; KCC retains its verified original-source repair**.
This document supersedes the v19 pre-sweep state without altering the original v1/v2
evidence or changing any historical imported compiler source. The
full compiler/CPU/optimization sweep is still deferred and must not be
started as part of these test-construction and diagnostic tasks.

## Live state, scope and branches

| Item | Live measured count |
| --- | ---: |
| Matrix-owned compiler sources | 2317 |
| Registered special test entries | 398 |
| Owned standalone/delegated scripts | 571 |
| Unowned test files / unconnected scripts (committed conversion scope) | 0 / 0 |
| Historical duplicate source pairs reconciled | 97 |
| Original deferred identities | 67 |
| P1 test-construction covered / partial / blocked | **56 / 0 / 11** |
| Frozen 59-source batch positions covered / blocked | **48 / 11** |

The branch inspection found ordinary `main` and `origin/main` only,
with no pending feature merge. Internal review refs are not ordinary
branches. The owning KCC and GCC compiler repositories were updated. The existing strict
cross-testkit boundary audit passes: generic compiler, linker, ABI,
assembler and ISA tests belong here, whereas kernel/booted-DAIMOS OS
tests belong outside this repository. No new test ownership transfer
was needed. All 67 historical deferred source identities retain their
original import status, independent from live compiler correctness.

Authoritative live source construction:

* `PDP10-P1-SEMANTIC-RESOLUTION-20261121-v29.tsv`
* `PDP10-P1-SOURCE-BATCHES-20261121-v28.tsv`

## Latest P1 closure: unchanged GNU conversion.c, all six PDP-6 profiles

The previously blocked P1 Batch 4, slot 4 original source
`tests/semantic/upstream/pdp10/pdp10/conversion.c`, with historical
SHA256 `2736912e40e1dabd84f7f193ddaaf5ddf9bf00e76edb0cca0611b3f49e5c1beb`,
now **PASSes unchanged in all six native PDP-6 profiles**: KCC
noopt/opt and GCC O0/O1/O2/Os. The original-source abort-assertion
line diagnostic also PASSes in all six profiles. GCC commit
`bca60ef` implements six genuine, independently selectable PDP-6
71-bit SF/D-format libgcc1 conversion helpers, including direct
nearest/ties-even integer-to-single conversion with full 71-bit
guard/sticky, and direct signed/unsigned float-to-integer conversion
with correct two-word ABI sign/zero. It fixes the old missing helper
link failures, 71-bit rounding errors and floating-to-integer guest
timeouts without changing or substituting the historical source.

The final compiler-owned libgcc archive SHA256 is
`f9b1720d59df7b0e8868e27a0aa036a222472a820d7080a3e008f61b0b4bed6c`.
The previous complete libgcc archive SHA256
`afd520fbbff5db32466d887e49136f09ee2c4517b63eded83325cd721505f960`
is preserved. GCC `cc1` and the KCC compiler remain byte-identical
to their previous verified checkpoints. The normal testkit runner
selects real compiler-owned freestanding C, never generic DAIMOS libc.

The new evidence authenticates **24 real native PDP-6 PASS**:
six unchanged original guests, six unchanged-original line-diagnostic
guests, four direct C89 71-bit public helper ABI guests, four original
GNU 71-bit integer-to-floating guests and four original GNU 71-bit
floating-to-integer guests. The C89 ABI test covers full 36+35-bit
extrema plus a 2^69 exact SF half-ULP and one-bit-sticky rounding
pair, without a target `long long` extension. All 129 archived raw
compiler, linker, SIMH and binary/DOBJ artifacts are SHA256-pinned.
The independent evidence validator has 17 fail-closed controls.
The eight prior 36-bit conversion tests also PASS all six profiles
under the final library (48 additional guest PASS). Historical GCC
`link_fail`, `run_fail` and timeout outputs remain frozen, not
relabeled. See `PDP10-P1-CONVERSION-FULL-20261121-v1.md`.

Only the verified original `conversion.c` P1 source advances from
blocked to covered. **Authoritative P1 is 56 covered / 11 blocked**
across 67 original source identities; frozen 59-source batch
positions are **48 covered / 11 blocked**. All eleven other P1
construction blockers remain outstanding. The full CPU/compiler/
optimization sweep remains deferred and untested. The v19 KCC-only
checkpoint described below is an immutable prior-state record,
not the current disposition of the GCC original.

The source ownership numbers above refer to the versioned committed
conversion patch. Three unrelated, untracked compatibility shell
scripts also appeared in the active worktree during this change;
they belong to a separate workflow and were deliberately left
unmodified and unstaged. They currently cause the whole-worktree
script-ownership audit to fail until their owner registers them.
This does not change the source-pinned conversion evidence.

## Previous v19 KCC-only original-source checkpoint (now superseded)

The unchanged P1 Batch 4, slot 4 `conversion.c` now has **two actual
native KCC PDP-6 original-source PASS** (noopt and opt). The owning
KCC compiler commit `bea2680` fixes target-width unsigned constant
folding, inconsistent double-constant encoding, and signed 36-bit
integer/D-format conversion in both directions. It installs a real,
independent `libp10fp36-signed-df-pdp6-v1.a` from one source into both
KCC/GCC compiler freestanding directories. Archive SHA256 is
`fad2b3371567a2dde082bfbe2227220cd183ec9322eef6eaba763efd5f252b73`.
Existing FP36 and compiler C archives retain their frozen SHA256s.

Eight independently registered full-range conversion tests now have
**48 actual native PDP-6 PASS** across KCC noopt/opt and GCC
O0/O1/O2/Os, including the new constant-folding, signed D-format
boundary and exact signed SI-to-D-format roundtrip tests. The two
unchanged KCC original guests and two original-source line-map
companions also PASS. The resulting evidence pins **52 real guest
PASS and 8 actual GCC 71-bit link failures**, 60 exact source/profile
outcomes, 289 raw outputs and 14 fail-closed mutation controls.
See `PDP10-P1-CONVERSION-KCC-ORIGINAL-20261121-v1.md`.

All four GCC PDP-6 profiles for the unchanged `conversion.c` still
fail linking on the genuine missing GNU 71-bit `__fixunssfdi`
conversion entry. **Do not** classify the entire original as covered;
KCC original PASS is not a GCC original PASS. Earlier KCC aborts
at original lines 58, 87 and 266 are retained as historical
pre-repair failures, not rewritten.

The source-construction ledger stays at **55 covered / 12 blocked**
original P1 identities and the 59-source frozen batch ledger stays
**47 covered / 12 blocked**. No full compiler/CPU/optimization
sweep has been authorized or run. The GCC 71-bit runtime and other
P1 blockers must be completed first.

## Current-round additions

### Nine current compiler crashes verified, not fixed

`PDP10-COMPILER-ICE-CURRENT-20261120-v1.md` pins the exact nine
historically identified PDP-6 native source/profile failures. The
installed compilers still exhibit **six GCC and three KCC
`compiler_ice`** results: five GCC `instantiate_virtual_regs_1`
errors, one GCC `cc1` segmentation fault, two KCC compiler-internal
diagnostics, and a KCC `line4.c` silent SIGSEGV independently
confirmed by direct KCC returncode -11. All nine source bytes,
recorded compiler logs, exact native compiler profiles and status
checkpoints are SHA256-pinned, with ten host negative controls.
The focused commands also selected nine `base` profiles, but this
specific audit authenticates the nine historical native profiles only.
These **confirmed compiler defects have highest repair priority**;
no underlying compiler was modified and no source is marked PASS.

### Source 960521: native pointer semantics now covered

The unchanged `tests/todo/generic/960521-1.c` requests two default
32768-native-int allocations (65536 core words before program/runtime
overhead). Current installed KCC PDP-6 noopt and GCC PDP-6 O0 both
link genuine `malloc`, then time out without a guest HALT. The
original is neither deleted nor called a compiler failure.

The new normal-matrix companion
`pdp10-shifted-array-boundary-v1.c` uses two 4096-native-word static
arrays, the original `*b++` operation and both fill loops, plus
native `b[-1]` and exhaustive array/canary assertions. Its six
selected KCC/GCC PDP-6 compiler profiles all PASS. Eight source-
authenticated guest outcomes and 24 generated artifacts are archived
with ten negative controls. This closes only the compiler-semantic P1
oracle, **not** the hosted allocator, complete 65536-word runtime or
untested CPU profiles. The live P1 v19 record explicitly retains
`hosted-malloc-and-large-memory-contract` as a separate follow-up.
See `PDP10-P1-960521-SHIFTED-ARRAY-CLOSURE-20261120-v1.md`.

### Source 990628: real 9-bit memset and aggregate copy now covered

The unchanged `990628-1.c` original still links real `malloc`,
`memset`, and the original fetch/copy bodies; current KCC/PDP-6 noopt
and GCC/PDP-6 O0 executions both time out with no completed HALT.
The independent normal-matrix companion `pdp10-record-fetch-copy-v1.c`
uses real static storage rather than a substitute allocator. Its six
PDP-6 profiles (two KCC and four GCC) all PASS, exercising genuine
linked `memset`, all 101 copied native integers, repeated 9-bit byte
representation, struct pointer postincrement, a two-fetch/one-store
SQL loop, termination state and canaries. Eight original/companion
reports and 24 emitted artifacts are SHA256-pinned, with ten negative
controls. This closes test construction for compiler record-copy
semantics but **not hosted malloc or original runtime correctness**.
See `PDP10-P1-990628-RECORD-COPY-CLOSURE-20261120-v1.md`.

### Source 941014: compiler volatile short oracle, GCC optimization failures

The unchanged historical `941014-2.c` uses hosted `malloc` and a
conditional `printf` in its volatile two-unsigned-short test. With
compiler stdlib only, its original KCC PDP-6 noopt and GCC PDP-6 O0
cells now **link_fail** on genuine missing `printf` and `malloc`,
respectively. No OS library or fake allocator was added.

The C89 normal-matrix companion `pdp10-volatile-short-offset-v1.c`
uses static guarded storage, asserts two 18-bit volatile halfwords
per 36-bit word, exact `b=0x0100` readback, pointer return, canaries,
and all three original `(unsigned long)pointer` `-30/+2/-30`
expressions and their numeric delta. Its six selected native PDP-6
cells produce **3 PASS** (KCC noopt/opt and GCC O0) and **3 real
GCC `run_fail`** (O1 failure ID 11, O2/Os failure ID 16).
Optimized GCC emits inconsistent byte-pointer/integer arithmetic
representations; those fail IDs remain compiler repair obligations.

Thirty exact original/companion logs, assembly, maps, guest reports
and compiler runtime statuses are SHA256-pinned in
`PDP10-P1-941014-VOLATILE-SHORT-EVIDENCE-20261120-v1.tsv` and
`refs/p10tk-p1-941014-volatile-short-20261120-v1.tar.gz`, with
11 negative mutation controls. This completes *test construction*
for one historical source, not the original malloc/printf execution
or optimized GCC correctness. At the v21 checkpoint P1 was **50 covered, 17 blocked**;
59 frozen batch positions were **42 covered, 17 blocked**. The newer
920810 compiler oracle increases the live counts to **51/16** and
**43/16** respectively. See
`PDP10-P1-941014-VOLATILE-SHORT-CLOSURE-20261120-v1.md`.

### Source 920810: real memcpy/memset child inheritance oracle

The unchanged original `920810-1.c` uses `malloc`, copies three
structure fields through real `memcpy`, then overwrites the copied
child's `super`, `name` and `size`. Its two freshly checked native
PDP-6 compiler-library profiles (KCC noopt and GCC O0) **link_fail**
on unresolved real `malloc`. This original runtime remains unverified.

The normal-matrix C89 companion `pdp10-memcpy-child-inheritance-v1.c`
uses statically owned, guarded child storage, but preserves the
original three-field structure, real compiler `memcpy` and real
9-bit `memset` behavior. It asserts all copied fields *before* the
original fixups, full byte-fill pattern, final parent pointer,
zero name, size, original source preservation and both guards.
All six KCC/GCC native PDP-6 compiler profiles **PASS** with genuine
linked `memcpy` and `memset` and both guest exit assertions zero.

The two original link-failure logs and six real guest outcomes are
preserved in 30 SHA256-pinned raw artifacts, with 11 mutation controls.
This closes compiler-oracle **construction**, not hosted `malloc`
or untested CPUs. `PDP10-P1-920810-CHILD-COPY-CLOSURE-20261120-v1.md`
records the evidence. The live P1 v22 ledger now has **51 covered,
16 blocked**, and the fixed batch ledger has **43 covered,
16 blocked**; the source remains in its original batch-4 slot 10.

### Source 20020406: actual recursive cofactor-slot argument swap

The unmodified historical `20020406-1.c` allocates its degree-one
and degree-two DUPFF input objects through hosted `malloc`/`calloc`,
then calls `DUPFFexgcd` with a recursive four-argument swap of
both pointer-to-pointer cofactor slots and both object inputs.
Fresh KCC noopt and GCC O0 native PDP-6 original cells link-fail on
missing `malloc` with the compiler's own C library. Hosted `calloc`,
`printf` and complete original execution remain unverified.

The new normal-matrix C89 companion
`pdp10-duptree-recursive-pointer-swap-v1.c` retains the original
reachable degree/coefficients, recursive expression, reversed slots,
changed data arguments and early return. It uses real static input
objects and verifies two actual recursive invocations, correct
cofactor pointer addresses and argument swapping, returned object
identity, untouched cofactor sentinels and unchanged input arrays.
The original unreachable unfinished algebra is not modeled or
claimed to pass. **All six** selected native PDP-6 KCC/GCC profiles
PASS. Both original link failures and all six companion results are
backed by 30 SHA256-pinned raw artifacts and ten negative controls.

See `PDP10-P1-20020406-RECURSIVE-SWAP-CLOSURE-20261120-v1.md`.
This adds one *constructed compiler oracle*, not a successful hosted
original execution. The v23 live P1 ledger has **52 covered / 15
blocked**, and frozen source batches have **44 covered / 15 blocked**.
Batch 4, slot 9 retains its fixed identity.

### Source 980707: optimized GCC literal strcpy corruption isolated

The unchanged `980707-1.c` needs original hosted `isspace` and target
`ctype.h`; KCC PDP-6 noopt currently link-fails on missing `isspace`
under the compiler C archive, while GCC PDP-6 O0 compile-fails on the
missing target ctype header. Historical hosted-libc attempts instead
exhibited a separate competing CRT exit/abort provider conflict.

The normal-matrix `pdp10-space-token-pointer-v1.c` companion retains
real `strcpy` and `strcmp`, the original two nested scans, 9-bit char
and pointer operations, delimiter NUL writes, original exact two-token
input and additional guarded edge cases. Its predicate is restricted
to ASCII space, deliberately **not** a fake `isspace` implementation.
KCC PDP-6 noopt/opt and GCC PDP-6 O0 PASS. GCC O1/O2/Os genuinely
**run_fail** at `fail_id=8` (first token pointer).

An independent `pdp10-strcpy-space-literal-v1.c` C89 compiler oracle
uses real `strcpy(" a b")` and volatile byte reads to validate actual
memory. Again three native profiles PASS and GCC O1/O2/Os
**run_fail** at `fail_id=3` (second input byte should be `a`).
The optimized GCC assembly emits only a 9-bit `DPB` of the first
space character, silently omitting the rest of the literal; GCC O0
instead calls real `strcpy`. This isolates the optimized target GCC
code-generation defect without hiding it or implementing a string
routine locally. The 14 original/companion results and 65 raw outputs
are SHA256 pinned and guarded by 11 negative mutation controls.
See `PDP10-P1-980707-SPACE-TOKEN-CLOSURE-20261120-v1.md`.

P1 **test construction**, not original hosted execution or compiler
correctness, now totals **53 covered / 14 blocked**; frozen 59-source
batches are **45 covered / 14 blocked**. The original retains batch
5, slot 6 and its hosted ctype/compiler-regression follow-up.

### Source va-arg-21: KCC stdarg va_end drops pointer side effects

The unchanged upstream `va-arg-21.c` still requires genuine hosted
`malloc` and `vprintf`. Fresh native PDP-6 compiler-stdlib results
show real original KCC noopt **link_fail** on missing `vprintf` and
GCC O0 **link_fail** on missing `malloc`; neither original ran.

The independent C89 normal-matrix companion
`pdp10-vaend-pointer-sideeffect-v1.c` uses the installed compiler
`stdarg.h` directly, two automatic `va_list` objects, the original
three-pointer array with NULL middle slot, two real
`va_start`/`va_arg` sequences and the original expression
`va_end(**ap_ptr++)` followed by another explicit `ap_ptr++`. It
checks that the first side effect advances the pointer before the
second increment, the subsequent integer varargs, slot identities
and guards. No allocator, console or `va_end` substitute is linked.

All **four GCC PDP-6 profiles PASS**. Both native **KCC noopt and
KCC opt run_fail at `fail_id=4`** with actual guest exit 1. The
installed KCC `stdarg.h` defines `va_end(ap)` as `((void)0)`,
therefore the argument expression's `ap_ptr++` side effect is
discarded; GCC uses the `__builtin_va_end` path and passes. This
isolates a KCC compiler-header semantic bug, **not** an original
hosted program PASS. The two compiler header hashes, exact two
original links and six actual native results are pinned in 38 raw
artifacts with 11 fail-closed mutation controls. See
`PDP10-P1-VAARG21-VAEND-CLOSURE-20261120-v1.md`.

Only P1 **oracle construction** changes: v25 is **54 covered /
13 blocked**, frozen source batches **46 covered / 13 blocked**.
The original keeps batch 6, slot 9 and retains the unresolved
KCC-header repair and real hosted malloc/vprintf follow-up.

### Installed KCC va_end repair verified on PDP-6

The KCC source `self/include/stdarg.h` now evaluates the `va_end`
argument exactly once, using `((void)(ap))` rather than `((void)0)`.
The change was committed and pushed in the *owning compiler repo*,
`kcc` commit `5fa3510`. The actual corrected target header was
installed under `$PDP10_PREFIX/lib/kcc/include/stdarg.h` using the
KCC `install-headers` target. Its SHA256
`f966aa2588b7d59dbf2bf704ffd87fb67097673455ee77fe86d8a75232f23e7f`
exactly matches the compiler's source; no compiler executable or
C archive was replaced.

The original historical native KCC noopt/opt failures at
`fail_id=4` and the old header SHA remain immutable in the v1
`va-arg-21` evidence. In a new focused replay **without** the
`KCC_INCLUDE_DIR` override, both KCC noopt and KCC opt PDP-6
guest tests now **PASS**, as do the four GCC PDP-6 profiles. Two
additional native KCC noopt/opt variadic return-type ABI tests
also **PASS**. All eight tests reached actual SIMH HALT with both
`fail_id=0` and `__test_exit=0` using compiler-only libc.

The eight outcomes, 41 SHA256-pinned artifacts and ten fail-closed
negative controls are documented in
`PDP10-KCC-VAEND-HEADER-REPAIR-20261120-v1.md`. The v26 P1
ledger changes only the compiler repair follow-up; the upstream
original still requires genuine hosted `malloc` and `vprintf`.
P1 source-oracle counts remain **54 covered / 13 blocked** with
**46 covered / 13 blocked** fixed batch positions. No other CPU,
complete variadic ABI or full sweep was exercised.

### GCC packed 9-bit string builtin correction verified on PDP-6

GCC 3.2 `gcc/builtins.c` had called **host `strlen`** on PDP-10
9-bit `STRING_CST` storage, where each 9-bit character occupies
two host bytes. As each ordinary ASCII target character begins
with a zero host byte, the optimizer treated `" a b"` as an
empty string and emitted only the first character of `strcpy`.
Generic host-string folds also incorrectly interpreted the packed
9-bit storage as an ordinary host C string.

The owning GCC code now counts logical target characters, checks
both host bytes for a target NUL, declines unsafe raw-host folds
and retains the target-aware literal copy callback. The corrected
`cc1`, SHA256
`0c33d1e7e93dd372e8b503aabf167c3299acdd830b289199c679ca07a7529b8a`,
was built using the GCC 3.2 GNU89 host-compiler flags and installed;
the previous `cc1` is backed up under the versioned `$TMPDIR` path.

**Twelve** focused native GCC PDP-6 replays now PASS: four profiles
for each of the old `strcpy` and token-pointer regressions, plus
four of the new high-9-bit/string constant test. Under the
previous `cc1`, all four profiles of the new string9 test gave
actual guest `run_fail`, `fail_id=1`, and the old optimized
`strcpy`/token-pointer failures were preserved independently.
The new string9 test also exposes a separate **KCC PDP-6 noopt/opt
`run_fail`, `fail_id=6`**, due to KCC emitting octal escape `\400`
as byte zero. Both genuine KCC failures stay scheduled for repair.

All 18 new source/profile outcomes and 90 raw artifacts are SHA256
pinned; the registered host validator passes 11 negative controls.
See `PDP10-GCC-STRING9-FOLD-REPAIR-20261120-v1.md`. This fixes the
observed GCC compiler bug but **does not** provide original hosted
`isspace`/`ctype.h`. P1 stays **54 covered / 13 blocked** with
fixed 59-source batch positions **46 covered / 13 blocked**; the
v27 ledger updates only the completed compiler repair follow-up.
No other CPU or complete compiler sweep was run.

### Real C-locale ctype: original 991112 and 980707 now execute

KCC commit `5264ccc` adds one genuine, PDP-6-compatible C-locale
classifier implementing `isprint` and `isspace` over all 512 9-bit
unsigned character values and EOF. It requires no target stack, heap,
system call or writable global. The exact same independently linkable
`libp10ctype-c-locale-v1.a` is installed in KCC and GCC freestanding
runtime directories. It is **not** a test-only predicate or a hosted
DAIMOS libc, and does **not** claim Unicode/UTF-9 classification.
The old core `libp10c-v2.a` SHA256 remains unchanged.

The matching GCC target `<ctype.h>` is owned by GCC commit `4fb9555`.
The testkit selector now recognizes direct calls and `.long`/`.word`
function pointer data relocations, so indirect references load the
real installed classifier rather than unresolved placeholders.
The installed freestanding audit checks both core/ctype archive
identities, with five negative controls; 20 source-selection tests
also pass.

The **unchanged `991112-1.c`** (Batch 4 slot 3) now PASSes all six
native PDP-6 compiler/optimization profiles, as does the separate
full-9-bit-domain exhaustive classifier oracle. The *unchanged*
`980707-1.c` (already P1-covered) also PASSes all six profiles with
real `isspace`, target ctype headers and the repaired GCC string
optimization. The two genuine historical missing-`isprint` link
failures remain SHA256-pinned; no original source was weakened.
The new evidence captures **20 source/profile outcomes**,
**102 raw outputs** and 11 fail-closed negative controls. See
`PDP10-P1-991112-C-LOCALE-CLOSURE-20261120-v1.md`.

P1 is now **55 covered / 12 blocked**; immutable 59-source batches
are **47 covered / 12 blocked**. All remaining 12 P1 original-source
construction slots are required to close **before** the full
compiler/CPU/optimization sweep is authorized. Other CPU variants and
complete UTF-9 classification remain unverified.

### PDP-6 signed/unsigned 36-bit floating conversion repair

The owning GCC and KCC compilers had real errors in integer-to-float
normalization, guard-bit rounding and conversions spanning bit 35.
GCC also lost the low nine bits of unsigned SI-to-D-format input by
routing through 27-bit single precision, and its `__fixsfsi` returned
zero for the representable signed minimum `-2^35`. The repaired
GCC PDP-10 backend selects dedicated exact `__floatunsidf` and
`__fixunssfsi` libgcc1 members. The corrected `libgcc.a`, SHA256
`afd520fbbff5db32466d887e49136f09ee2c4517b63eded83325cd721505f960`,
retains its other old members, and the old full archive is backed up.
The installed GCC `cc1` SHA256 is
`67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7`.

KCC's proper compiler-level ABI calls use the independently selectable
PDP-6 source `kcc-libc-fp36-pdp6-v1.s` for signed/unsigned 36-bit
integer/SF and unsigned integer/D-format operations. The six genuine
entry points are installed in a versioned archive with identical KCC
and GCC copies, SHA256
`de4aa2f79db32c5c95747a658c2f4d6366e69efbb626b0f2ff3b21f847e2e7b2`.
The compiler core `libp10c-v2.a` remains unchanged. The installed
KCC compiler SHA256 is
`0574417c52be0fdd7e4595ba4a23a91967a703f8cd522b9d7c58688985b7a35b`.

**Five exact C89 conversion tests now PASS all six native PDP-6
compiler profiles:** original signed arithmetic companion, separate
signed/unsigned integer/FP locators, unsigned SF half-ULP rounding,
and signed 36-bit boundary/rounding. The evidence retains 30 actual
new guest PASS, six genuine pre-repair signed conversion failures,
and 12 still-failing current original/line-locator results. The 48
source/profile cells and 230 raw archives are SHA256-pinned; the
validator passes 13 mutation controls. See
`PDP10-P1-CONVERSION-36BIT-REPAIR-20261120-v1.md`.

**Do not reclassify `conversion.c` P1 Batch 4 slot 4:** the unchanged
source still has genuine KCC noopt `run_fail` at original line 266
(signed D-format negative integer boundary), KCC opt `run_fail`
at line 58 (`fnear` near the unsigned upper SF limit), and GCC
O0/O1/O2/Os `link_fail` for missing GNU 71-bit `__fixunssfdi`.
Source construction counts therefore remain **55 covered / 12
blocked**, with frozen source batches **47 covered / 12 blocked**.
No wider CPU/optimization sweep was run. The full compiler matrix
remains blocked until **all 12** outstanding P1 positions close.

## Runtime policy correction: compiler stdlib only

The normal compiler semantic runner no longer gets its target C library
from the generic `$PDP10_PREFIX/lib/libc.a`. The installed `p10run`
would otherwise append that archive automatically, including unrelated
hosted/OS runtime providers. The testkit now gives `p10run` a
per-compiler, versioned runtime prefix whose `lib/libc.a` is solely a
symlink to the installed compiler's own `libp10c-v2.a`. The compiler
binaries, installed headers and canonical libgcc remain unchanged.
Semantic restart checkpoints include `compiler-stdlib-v1` and the exact
compiler archive SHA256, preventing silent reuse of historical green
cells from the old library provider. No fake malloc/ctype/printf is
included. See `PDP10-COMPILER-STDLIB-RUNTIME-20261120-v1.md`.

Six freshly selected original PDP-6 cells now expose **real missing
compiler-library functions**, rather than unrelated hosted runtime:

| Historical source | Native target profile(s) | New compiler-stdlib result |
| --- | --- | --- |
| `920810-1.c` | KCC noopt; GCC O0 | Both `link_fail` unresolved `malloc` |
| `980707-1.c` | KCC noopt | `link_fail` unresolved `isspace` |
| `920501-8.c` | GCC O0 | `link_fail` unresolved hosted `printf` |
| `990628-1.c` | KCC noopt; GCC O0 | Both `link_fail` unresolved `malloc` |

The separate `pdp10-record-fetch-copy-v1.c` compiler-oracle companion
still gives **two real PDP-6 guest PASS** outcomes (KCC noopt/GCC O0)
using the installed compiler's own `memset`. Eight current original/
companion outcomes and 28 raw artifacts are SHA256-pinned. Previously
recorded original SIMH timeouts and duplicate-global links remain
historical observations under the former runtime policy; **do not
reinterpret them as current compiler-stdlib results**. At the time of the provider
correction, P1 construction stood at 49 covered and 18 blocked. The
separate 941014 oracle added later raises construction to 50/17;
neither change is itself a new optimized-compiler guest PASS.

The official `run-misc-tests.sh` dispatcher now also enforces this
compiler-owned runtime for its five registered compiler guest-test
groups (`verify`, `compat`, `validation`, `kcc-regression`,
`gcc-bare-libgcc`). A shared prefix is allowed only when KCC/GCC
archive bytes are identical. Selected `upstream-crt-v1`,
`kcc-pdp6-float-literal-v1` and `gcc-9bit-data-section-v1` PDP-6
registered guest tests PASS. A fail-closed host check verifies four
selected roots, all five guest
groups, three host/tool exceptions, and incompatible-archive
rejection. See `PDP10-COMPILER-STDLIB-SPECIAL-DISPATCH-20261120-v1.md`.
Individually invoked raw scripts and host/tool-build suites are not
covered by this runtime policy; do not claim universal isolation.

## Direct GCC stdio archive use: two raw-script hazards fixed

The two independently registered GCC formatter compat scripts
(`test-gcc-p10stdio-v1.sh` and `test-gcc-p10stdio-v2.sh`) formerly
passed the generic `$PDP10_PREFIX/lib/libc.a` explicitly in their
`dlink` extraction checks. A direct raw invocation could therefore
use the unrelated hosted OS archive even if the official registered
special dispatcher was already isolated. They now pass the installed
compiler-owned `libp10c-v2.a` by canonical GCC freestanding-archive
path. The production formatter v1/v2 archives still supply their
actual implementations, and canonical GCC libgcc remains unchanged.

Their later `p10run` guest invocations are also isolated: each script
uses `prepare_script_prefix()` to create a GCC-only temporary prefix
whose implicitly loaded `lib/libc.a` resolves to the **compiler**
archive, even when the script starts with the ordinary installed
prefix. The default full test selection stays unchanged; the optional
`P10_STDIO_CELLS=pdp6-O0` permits two real guest programs to be
checked per script without a full four-CPU run.

Both formatter archive-extraction links PASS. Both scripts were
executed **directly** (not through the special dispatcher) under the
ordinary installed prefix; all four selected native PDP-6 O0 guests
PASS with actual compiler library ownership. Sixteen raw report,
map, source and policy artifacts are SHA256-pinned, and a registered
host validator rejects 15 wrong source/provider/outcome mutations.
These focused checks are **not** the complete 16-cell per-version CPU
matrix. Other directly invoked raw scripts and tool/host-build
exceptions still require separate review; their library environment
is not automatically protected by this specific change. See
`PDP10-GCC-STDIO-DIRECT-COMPILER-ARCHIVE-20261120-v1.md`.

## Direct invocation script-ownership audit scope

A focused literal source scan found 73 candidate `p10run` caller or
helper scripts across the registered compat, validation,
KCC-regression, GCC bare-libgcc and verify groups plus delegated
helpers. No additional explicit generic `lib/libc.a` link argument
was found in normal `misc/` compiler guest scripts beyond the two
GCC formatter cases already corrected. This is **not** an assurance
that all arbitrary direct shell invocations use the compiler library:
most registered scripts rely on the official dispatcher to prepare
its library-isolated runtime prefix. `misc/tools/` installer and
`p10run` functional fixtures deliberately set up private prefixes;
those are tool tests, not compiler stdlib oracles. Separate direct
script invocation review and explicit environment contracts remain
open prior to a full sweep. This scan itself did not run any of the
73 candidate scripts.

## Twelve remaining original-source construction TODOs

| Classification | Sources | Required work |
| --- | --- | --- |
| Hosted math/formatting | `980709-1.c`, `990826-0.c` | Provide genuine target math/ctype execution; no substitute pow or floor implementation |
| GNU control flow/noreturn | `builtin-noret-1.c`, `comp-goto-1.c` | Check source macro policy, native labels/addresses, runtime and missing builtins |
| Hosted floating/varargs I/O | `gofast.c`, `strct-varg-1b.c`, `stdio-opt-1.c`, `stdio-opt-2.c`, `stdio-opt-3.c` | Separate compiler assertions from real FILE/stream/formatting dependencies |
| Native pointer torture | historical `old.tort.c` | Native replacement's six recorded compiler/ABI failures remain unresolved |
| Missing conversion helpers | `conversion.c` | Real unsigned floating conversion and exact original assertions; no fake `__fixunssfsi` |
| KL10 ISA/assembler | `920428-1.s` | Execute an independently justified KL10 assembler/ISA oracle |

**Classification totals:** 10 hosted-runtime, one libc-linkage and
one ISA-harness. The frozen 59-source batch assignments remain intact.
Completing test construction does not change recorded compiler FAIL,
ICE, LINK failure or TIMEOUT statuses.

## Observed missing functions versus independent compiler/linker bugs

| Confirmed symbol or facility | Current/historical evidence |
| --- | --- |
| `__builtin_abort` | GCC PDP-6 noreturn source fails linking in O0/O1/O2/Os |
| `__fixunssfsi` | GCC original `conversion.c` unresolved unsigned float conversion |
| `isprint`, `isspace` | Historical missing-provider/hosted-libc collision remains pinned, but both now have genuine compiler-owned C-locale implementations; unchanged `991112-1.c` and `980707-1.c` each PASS all six native PDP-6 profiles |
| `_eexit` | GCC original `builtin-noret-1.c`, requiring source/target policy review |
| `__builtin_printf` | KCC original `stdio-opt-2.c` |
| `putchar` | GCC original `stdio-opt-2.c`; no real freestanding console output |
| `stdout`, `stderr` | Real hosted stream objects absent; not ordinary functions |

**Historical generic/hosted-libc link conditions:** KCC `980707-1.c`
previously reported `dlink: duplicate global: exit`. The exact six original
objects contain one explicit `exit` and one explicit `abort`; a new
five-case source-pinned dlink replay confirms default `lib/libc.a`
provides a second of each when real hosted `isspace` is resolved.
Dropping only the explicit `exit` exposes duplicate `abort`; dropping
both permits a link, but **does not validate** the test CRT's required
observable `__test_exit` termination semantics. This is now a
confirmed two-provider runtime conflict, not an unexplained symbol
table defect. See `PDP10-P1-980707-CTYPE-PROVIDER-CLOSURE-20261120-v1.md`. The GCC `920501-8.c` original previously reported duplicate
`vsprintf`, but a new source-pinned replay has now established **two
runtime formatter providers**, not a proved `dlink` implementation
bug: the separately selected GCC `p10stdio-format-v2.s` and the default
`lib/libc.a` archive pulled by hosted `printf`. Six explicit linker
objects define one `vsprintf`; adding the default archive reports the
duplicate; removing the standalone formatter makes the full link
succeed; omitting default libc leaves `printf` unresolved. **Linking is
not execution**, and the compatibility of default libc's hosted
GCC varargs/stdio ABI remains unproved. The separate `sprintf`
default-precision `%f` failure remains six PDP-6 companion guest exit
41 results. See `PDP10-P1-920501-STDIO-PROVIDER-CLOSURE-20261120-v1.md`.

Some historical original tests linked hosted `malloc`, `sprintf`,
`printf`, `vprintf` and real string/memory functions under the previous
runtime archive policy. The **current compiler-only** archive has not
provided `malloc`, `isspace` or hosted `printf` in the focused PDP-6
rechecks. Do not confuse historical hosted outcomes with current
compiler-library availability.

## What remains before an operator-selected full sweep

1. Preserve and prioritize the nine confirmed ICE/signal regressions,
   both diagnosed libc-provider conflicts (`exit`/`abort`, `vsprintf`),
   their still-unproved real guest ABI/termination behavior, and
   missing builtin/helper contracts. Compiler/assembler/linker repairs
   belong in their respective codebases; do not substitute test hacks.
2. Resolve the 12 remaining source-oracle obligations, distinguish
   hosted dependencies from valid freestanding language/ABI tests,
   and retain all genuine failing matrix cells.
3. Maintain compiler-owned stdlib in both normal semantic cells and
   official registered compiler guest-test dispatch. Review remaining
   direct shell invocations and host/tool-build exceptions separately;
   complete diagnostic, restart/checkpoint, timeout, source provenance
   and script-dispatch negative controls.
4. Recheck versioned inventory, branch state, `git diff --check`,
   host-only and narrowly selected compiler cases before permission
   is given to run the large suite.

**STOP:** No full compiler/CPU/optimization sweep, full ISA/AAP scan,
manual-special sweep, or DAIMOS OS test was run for this continuation.
