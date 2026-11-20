# PDP-10 testkit current stop point before full sweep (v8)

Date: 2026-11-20. **Only `pdp10-testkit` was changed**. This document
supersedes the v7 pre-sweep state without altering the original v1/v2
evidence or changing any historical imported compiler source. The
full compiler/CPU/optimization sweep is still deferred and must not be
started as part of these test-construction and diagnostic tasks.

## Live state, scope and branches

| Item | Live measured count |
| --- | ---: |
| Matrix-owned compiler sources | 2298 |
| Registered special test entries | 365 |
| Owned standalone/delegated scripts | 538 |
| Unowned test files / unconnected scripts | 0 / 0 |
| Historical duplicate source pairs reconciled | 97 |
| Original deferred identities | 67 |
| P1 test-construction covered / partial / blocked | **49 / 0 / 18** |
| Frozen 59-source batch positions covered / blocked | **41 / 18** |

The branch inspection found ordinary `main` and `origin/main` only,
with no pending feature merge. Internal review refs are not ordinary
branches. No sibling repository was modified. The existing strict
cross-testkit boundary audit passes: generic compiler, linker, ABI,
assembler and ISA tests belong here, whereas kernel/booted-DAIMOS OS
tests belong outside this repository. No new test ownership transfer
was needed. All 67 historical deferred source identities retain their
original import status, independent from live compiler correctness.

Authoritative live source construction:

* `PDP10-P1-SEMANTIC-RESOLUTION-20261120-v20.tsv`
* `PDP10-P1-SOURCE-BATCHES-20261120-v19.tsv`

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
reinterpret them as current compiler-stdlib results**. P1 construction
still stands at 49 covered, zero partial, 18 blocked; this provider
correction is not a new compiler PASS.

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

## Eighteen remaining original-source construction TODOs

| Classification | Sources | Required work |
| --- | --- | --- |
| Hosted allocation and execution | `20020406-1.c`, `920810-1.c`, `941014-2.c` | Prove real allocator/hosted ABI or construct distinct sound compiler oracles; retain prior timeouts and current missing-`malloc` observations |
| ctype/math/formatting | `980707-1.c`, `980709-1.c`, `990826-0.c` | Complete genuine target headers and math/ctype execution; current `isspace` is missing from compiler stdlib, historical exit/abort provider collision is archived |
| GNU control flow/noreturn | `builtin-noret-1.c`, `comp-goto-1.c` | Check source macro policy, native labels/addresses, runtime and missing builtins |
| Hosted floating/varargs I/O | `gofast.c`, `strct-varg-1b.c`, `stdio-opt-1.c`, `stdio-opt-2.c`, `stdio-opt-3.c`, `va-arg-21.c` | Separate compiler assertions from real FILE/stream/formatting dependencies |
| Native pointer torture | historical `old.tort.c` | Native replacement's six recorded compiler/ABI failures remain unresolved |
| Missing libc/conversion | `991112-1.c`, `conversion.c` | Real UTF-9-aware `isprint`, unsigned floating conversion and exact original assertions |
| KL10 ISA/assembler | `920428-1.s` | Execute an independently justified KL10 assembler/ISA oracle |

**Classification totals:** 15 hosted-runtime, two libc-linkage and
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
2. Resolve the 18 remaining source-oracle obligations, distinguish
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
