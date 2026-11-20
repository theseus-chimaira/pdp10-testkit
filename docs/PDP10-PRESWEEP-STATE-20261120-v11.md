# PDP-10 testkit current stop point before full sweep (v11)

Date: 2026-11-20. **Only `pdp10-testkit` was changed**. This document
supersedes the v10 pre-sweep state without altering the original v1/v2
evidence or changing any historical imported compiler source. The
full compiler/CPU/optimization sweep is still deferred and must not be
started as part of these test-construction and diagnostic tasks.

## Live state, scope and branches

| Item | Live measured count |
| --- | ---: |
| Matrix-owned compiler sources | 2300 |
| Registered special test entries | 372 |
| Owned standalone/delegated scripts | 545 |
| Unowned test files / unconnected scripts | 0 / 0 |
| Historical duplicate source pairs reconciled | 97 |
| Original deferred identities | 67 |
| P1 test-construction covered / partial / blocked | **51 / 0 / 16** |
| Frozen 59-source batch positions covered / blocked | **43 / 16** |

The branch inspection found ordinary `main` and `origin/main` only,
with no pending feature merge. Internal review refs are not ordinary
branches. No sibling repository was modified. The existing strict
cross-testkit boundary audit passes: generic compiler, linker, ABI,
assembler and ISA tests belong here, whereas kernel/booted-DAIMOS OS
tests belong outside this repository. No new test ownership transfer
was needed. All 67 historical deferred source identities retain their
original import status, independent from live compiler correctness.

Authoritative live source construction:

* `PDP10-P1-SEMANTIC-RESOLUTION-20261120-v22.tsv`
* `PDP10-P1-SOURCE-BATCHES-20261120-v21.tsv`

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

## Sixteen remaining original-source construction TODOs

| Classification | Sources | Required work |
| --- | --- | --- |
| Hosted allocation and execution | `20020406-1.c` | Prove real allocator/hosted ABI or construct distinct sound compiler oracles; retain prior timeouts and current missing-`malloc` observations |
| ctype/math/formatting | `980707-1.c`, `980709-1.c`, `990826-0.c` | Complete genuine target headers and math/ctype execution; current `isspace` is missing from compiler stdlib, historical exit/abort provider collision is archived |
| GNU control flow/noreturn | `builtin-noret-1.c`, `comp-goto-1.c` | Check source macro policy, native labels/addresses, runtime and missing builtins |
| Hosted floating/varargs I/O | `gofast.c`, `strct-varg-1b.c`, `stdio-opt-1.c`, `stdio-opt-2.c`, `stdio-opt-3.c`, `va-arg-21.c` | Separate compiler assertions from real FILE/stream/formatting dependencies |
| Native pointer torture | historical `old.tort.c` | Native replacement's six recorded compiler/ABI failures remain unresolved |
| Missing libc/conversion | `991112-1.c`, `conversion.c` | Real UTF-9-aware `isprint`, unsigned floating conversion and exact original assertions |
| KL10 ISA/assembler | `920428-1.s` | Execute an independently justified KL10 assembler/ISA oracle |

**Classification totals:** 13 hosted-runtime, two libc-linkage and
one ISA-harness. The frozen 59-source batch assignments remain intact.
Completing test construction does not change recorded compiler FAIL,
ICE, LINK failure or TIMEOUT statuses.

## Observed missing functions versus independent compiler/linker bugs

| Confirmed symbol or facility | Current/historical evidence |
| --- | --- |
| `__builtin_abort` | GCC PDP-6 noreturn source fails linking in O0/O1/O2/Os |
| `__fixunssfsi` | GCC original `conversion.c` unresolved unsigned float conversion |
| `isprint`, `isspace` | Original `991112-1.c` needs a real target `isprint` contract; `980707-1.c` has hosted `isspace` but its archive conflicts with the test CRT termination providers |
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
2. Resolve the 16 remaining source-oracle obligations, distinguish
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
