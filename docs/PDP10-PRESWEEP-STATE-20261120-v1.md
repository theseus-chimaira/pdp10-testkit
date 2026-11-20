# PDP-10 testkit state immediately before the full sweep (v1)

Date: 2026-11-20. Scope: `pdp10-testkit` only. **No full compiler,
CPU, optimization or DAIMOS boot regression sweep was run.**

## Branches and source ownership

`pdp10-testkit` has only `main` and `origin/main` as ordinary branches;
there are no feature branches to consolidate. The internal
`refs/devspace/review/*` are review references, not branches to merge.
The sibling `daimos-testkit` is **out of scope** and must not be changed,
merged, reset or committed as part of this task.

`pdp10-testkit` owns generic compiler, assembler, linker, processor ISA,
optimization and freestanding ABI tests. Booted DAIMOS kernel, syscall,
filesystem, device and guest-native toolchain integration tests belong
to `daimos-testkit` under the already accepted v4 transfer. The strict
cross-repository ownership checker PASSes (127 compiler/assembler
transfers, 23 OS transfers, 71 guest-native returns). No new ownership
transfer is justified by the inspected generic compiler tests.

## Live source/registry status

The live inventory and ownership auditors, rather than the earlier
historical snapshots, report:

| Registry | 2026-11-20 status |
| --- | ---: |
| Compiler matrix sources | 2,294 |
| Special test registrations | 347 |
| Owned script paths | 511 |
| Unowned C/ASM tests | 0 |
| Missing script ownership edges | 0 |
| Duplicate historical pairs reconciled | 97 |
| Deferred upstream original identities | 67 |
| P1 obligations covered / partial / blocked | 45 / 0 / 22 |

Of the 67 canonical deferred source identities, all have undergone
individual review. Their frozen historical classification is not a
test-execution verdict. The live v16 P1 resolution ledger records
**45 constructed/covered and 22 blocked** intents, and the fixed
59-source batch plan records 37 constructed/covered and 22 blocked.
The newest completed integrations are the unchanged `930513-1.c`
floating-point sprintf function-pointer oracle (six PDP-6 KCC/GCC
PASS) and the original `struct-ret-1.c` (four GCC PASS), paired with
its independently asserting aggregate-return companion (one genuine
GCC failure, two KCC timeouts). Source-pinned evidence and negative
controls are described in `PDP10-P1-930513-ORIGINAL-CLOSURE-20261120-v1.md`
and `PDP10-P1-STRUCTRET-HOSTED-CLOSURE-20261120-v1.md`.

The pre-existing uncommitted `pdp10-noreturn-reachability-v1.c` and
its matrix row were preserved. Four bounded GCC PDP-6 O0/O1/O2/Os
executions compile but each fails at linking with the exact unresolved
symbol `__builtin_abort`. This is a real builtin/runtime deficiency,
not a compiler PASS or proof that the source's four noreturn paths
actually execute. Investigate the proper compiler lowering; no test
stub is allowed.

### Host-only dispatch and historical-admission reconciliation

The live manual-root registry contains **21** explicit manual tests.
Two older dispatcher regressions still required the previous 18-root
snapshot and failed, even though registry ownership was valid. The
reviewed exact-ID/group/path contract now lives at
`docs/PDP10-MANUAL-ROOTS-20261120-v1.tsv`, and both dispatcher
regressions pass with that source. No manual guest test was executed
or automatically promoted.

The earlier P1 admission audits v1-v6 similarly required the three
newly active `930513-1.c` GCC PDP-6 O1/O2/Os columns to remain
`no_test`. Their historical manifests and source/profile inventories
are preserved. A narrow, evidence-authenticated source exception
in `tools/p1_matrix_post_admission_v1.py` now checks the original
six-profile archive before accepting **only** these three new pending
columns. All six auditors and their existing 16 negative controls
PASS. Other unreviewed additions still fail closed.

## Blocked original intents: current v16 inventory

This list is a **test-construction backlog**, not 22 proved compiler
bugs. These failures remain in the matrix where already admitted.

| Type | Sources | Open reason |
| --- | --- | --- |
| Target libc/ctype | `991112-1.c` | Real `isprint` missing; post-1.0 UTF-9 decision |
| Integer/FP runtime | `conversion.c` | `__fixunssfsi` missing in GCC; separate KCC guest assertion failure |
| Variadic hosted | `920501-8.c` | KCC guest timeout; GCC formatted runtime needs independent acceptance |
| KL10 assembler | `920428-1.s` | Exact KL10 ISA/assembler oracle still incomplete |
| Hosted format/alloc | `20020406-1.c`, `920810-1.c`, `941014-2.c`, `990628-1.c` | Real allocator/stdio semantics and timeouts not resolved |
| Stack/representation | `960521-1.c`, `980605-1.c` | Nominal 64K memory limit or unasserted stack effect; mere PASS is insufficient |
| Hosted libc/math | `980707-1.c`, `980709-1.c`, `990826-0.c` | ctype/math/stdio functions and target headers; linker and compiler issues |
| Noreturn | `builtin-noret-1.c` | `_exit`/`_eexit`, source macro policy and optimized code elimination |
| Computed goto | `comp-goto-1.c` | GNU label addresses, real allocator, native pointer scaling and timeout |
| FP diagnostic | `gofast.c` | Real stderr/formatting and target floating runtime |
| Native byte pointers | historical `old.tort.c` | Replaced by live native-width torture; six actual compiler/ABI failures remain |
| Structure varargs | `strct-varg-1b.c` | Structure va_arg/runtime still unverified; `struct-ret-1.c` now has independently asserted companion coverage |
| Hosted stdio optimization | `stdio-opt-1.c`, `stdio-opt-2.c`, `stdio-opt-3.c` | Real FILE/stdout/fprintf/putchar/puts backend and builtin transforms |
| va_end | `va-arg-21.c` | Real malloc/vprintf with asserted pointer side effects |

### Missing callable functions and external symbols

The following are **observed unresolved linker symbols or explicitly
absent runtime facilities**, rather than inferred missing functions:

| Symbol/facility | Original failing test/evidence | Classification |
| --- | --- | --- |
| `__builtin_abort` | New noreturn PDP-6 GCC O0/O1/O2/Os, actual four `dlink` failures | Compiler builtin lowering/runtime symbol |
| `__fixunssfsi` | GCC `conversion.c`, source-pinned Batch 4 link failure | Unsigned float-to-int runtime helper |
| `isprint` | KCC and GCC `991112-1.c`, Batch 4 link failures | libc ctype, UTF-9 policy deferred |
| `isspace` | `980707-1.c`, KCC symbol-table inspection | libc ctype; linker separately reports duplicate `exit` |
| `_eexit` | GCC `builtin-noret-1.c`, Batch 5 link failure | Nonstandard external, exact source macro/oracle policy required |
| `stderr` | KCC `gofast.c`, Batch 6 link failure | Hosted stream object, not an ordinary function |
| `stdout` | KCC `stdio-opt-1.c`, Batch 6 link failure | Hosted stream object, not an ordinary function |
| `__builtin_printf` | KCC `stdio-opt-2.c`, Batch 6 link failure | Compiler builtin or lowering support |
| `putchar` | GCC `stdio-opt-2.c`, confirmed on current installed runtime | Real console output/backend function |

Additional hosted functions whose execution remains unverified or
incomplete, but which must **not** be declared universally missing,
include `malloc`, `calloc`, `printf`, `vprintf`, `fprintf`, `puts`,
`fputs`, `floor`, and other math/ctype functions. In several original
KCC test cells `sprintf`, allocation routines, and `memcpy` actually
link; some then time out. GCC's installed buffer-formatting `stdio.h`
supplies only sprintf/vsprintf/snprintf/vsnprintf, not FILE/console
I/O. Duplicating symbols with dummy test-only stubs is prohibited.
The original `980707-1.c` `dlink: duplicate global: exit` despite
one input definition remains a real **linker** priority, separate
from its unresolved `isspace` reference.

There are nine *historical* codegen compiler ICE/signal records in
`PDP10-INITIAL-SWEEP-FAILURES-20261117-v1.tsv` (six GCC, three
KCC). They are dated evidence and require later targeted revalidation
against the installed compiler; no historical ICE is reclassified
as fixed merely because an unrelated current compile succeeds.

## Required work before authorizing the full sweep

1. Resolve or independently justify the 22 P1 original-source oracle
   gates; do not hide compiler and linker failures behind skipped cells.
2. Finish source-reviewed compiler diagnostic and negative oracles,
   missing native assembler/linker contracts, and correct expected
   output/diagnostic policy without unused DejaGNU machinery.
3. Confirm restart/checkpoint identities, timeout/ICE/link/runtime
   classification, and selected-run determinism using host-only
   negative controls and individually selected cells.
4. Recheck script/fixture provenance, duplicate ownership, frozen
   imports, compiler matrix registration and published state.
5. Keep floating hardware reference accuracy and new AAP coverage as
   separately prioritized P3 work. Boot-linked kernel coverage is
   DAIMOS-specific and not a compiler-testkit preflight gate.

The subsequent full compiler/CPU/optimization matrix is **explicitly
not authorized by these checks**. No full sweep was run in this phase.
