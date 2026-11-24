# GCC/KCC timeout triage and repair v21

Date: 2026-11-24

## Baseline: seven timeout sources, not 135 unrelated problems

The previous `workdir/full-sweep-current` checkpoint recorded
**135 timeouts** across seven source paths. A read-only inventory
of each cell's p10run report separates instruction-budget expiration
from the host simulator wall-clock timeout:

| Source | Timed-out cells | Step-limit | Wall-clock |
| --- | ---: | ---: | ---: |
| `semantic/upstream/wide-int/950612-1.c` | 36 | 16 | 20 |
| `todo/generic/20000822-1.c` | 33 | 18 | 15 |
| `semantic/kcc-ported/gnu-packed-byvalue.c` | 27 | 22 | 5 |
| `semantic/runtime/runtime-byte-pointer-diff.c` | 16 | 16 | 0 |
| `todo/generic/20020402-3.c` | 11 | 11 | 0 |
| `todo/generic/20001203-2.c` | 11 | 6 | 5 |
| `semantic/upstream/generic/920428-1.c` | 1 | 1 | 0 |
| **Total** | **135** | **90** | **45** |

The distinction matters: the old `timeout` status cannot be treated
as an ordinary failed assertion, nor can it be treated as an automatic
false positive. A step limit can expire on a genuine infinite loop;
a wall-clock deadline can interrupt a slower simulator before it
reaches its own instruction limit.

## One invalid upstream test corrected

The original `920428-1.c` evaluated `a[*s++] |= 1` on `char a[1]`
without initializing the element. `|=` reads the existing value,
so the source had undefined behavior independent of the intended
pointer postincrement check. A temporary experiment using
`char a[1] = {0}` passed KS10 O0/O1/O2/Os while the original still
reproduced the KS10 O1 step-limit failure under the current GCC.

The registered upstream test now initializes `a[0]` but preserves
the postincrement expression and the original pointer comparison.
The official isolated full GCC/KCC matrix completed **66/66 PASS**
under strict exit policy; 65 cells had already passed and the one
old timeout is now eliminated without weakening the intended oracle.

## Thirty-three genuine GCC trampoline failures repaired

GCC's PDP-10 nested-function trampoline template uses two executable
words on the stack. With the default `TRAMPOLINE_ALIGNMENT`, generic
GCC rounded an already-word-addressed stack location to a four-word
boundary, possibly outside the allocated frame. At KI10 O2 the
trampoline was initialized at `1(17)` while the following `PUSHJ`
overwrote it. The original guest expired its instruction budget at
PC 0; moving the trampoline into its frame in scratch assembly
passed. This is a compiler bug, not a slow-but-correct runtime test.

The backend now specifies one address-unit trampoline runtime
alignment, and GCC's template-copy logic recognizes a separate
36-bit copy alignment. This preserves two-word BLT initialization
and avoids both the out-of-frame address and the larger byte-copy
sequence. Source: `gcc-pdp10/gcc/config/pdp10/pdp10.h` and
`gcc-pdp10/gcc/function.c`.

The registered `20000822-1.c` source then passed all **44/44 GCC**
matrix cells with a rebuilt installed compiler, versus 33 timeouts
and 11 passes in the old checkpoint. An initial safe, unoptimized
copy was superseded by the compact two-word BLT implementation.

With the final compact compiler installed in `$HOME/cross`, an
independent strict exit-policy rerun selected four sources: the two
corrected timeout tests and the earlier v19/v20 pointer regressions.
All **218/218** cells passed (160 GCC, 58 KCC), with no old green
checkpoints skipped. Output:
`workdir/pdp10-timeout-triage-v21-final`.

## Other clusters still open

The 16 `runtime-byte-pointer-diff.c` timeouts were previously removed
in v20; the source's remaining three optimized KS10 assertion
failures are not timeouts.

The wide-integer `950612-1.c` test was rerun on GCC KI10 O2 with the
guest step budget doubled to **200 million** and simulator wall-clock
allowance increased. It still expired its step budget at PC 0. This
sample is not a timeout-limit false positive.

The entire GCC `gnu-packed-byvalue.c` matrix was rerun with the v21
compiler: **27 timeouts and 17 runtime failures** remain across 44
cells. None should be counted as passing. The two KCC optimizer
clusters, 11 cells each, were inspected and still require separate
correction/verification. In total, **85 of the original 135** timeout
records are not yet shown repaired by these focused runs.

The original full-sweep checkpoint was not modified by these trials.
All new evidence resides in isolated, versioned output directories;
the full matrix is not claimed complete.
