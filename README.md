# PDP-10 compiler, assembler and CPU testkit

This repository tests GCC and KCC compiler behavior, PDP-6/PDP-10
assembler and linker formats, ABI contracts, optimization and processor
ISA execution. Targets include PDP-6, KA10, KI10 and KS10. It is **not**
the DAIMOS operating-system test suite.

Four bounded, ten-entry deferred reviews are recorded in
`docs/PDP10-DEFERRED-INTEGRATION-FIRST10-20261118-v8.md`,
`docs/PDP10-DEFERRED-INTEGRATION-NEXT10-20261118-v9.md`, and
`docs/PDP10-DEFERRED-INTEGRATION-BATCH03-20261118-v10.md`, plus
`docs/PDP10-DEFERRED-INTEGRATION-BATCH04-20261118-v11.md`.
The fourth connected five meaningful sources with precise PDP-6
KCC/GCC results and retained five blocked tests, including the
misconfigured GCC 8-bit `limits.h` shift regression. The current
inventories are **2,135 matrix sources**,
**476 active / 241 deferred / 56 removed** upstream tests, and
**284 specialized registrations**, including **44 intentionally
manual tests**. No broad sweep was started.
The current upstream and deferred classification manifests are
`SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v6.tsv` and
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v5.tsv`; older versions
remain historical snapshots.

## Test ownership

- **`pdp10-testkit`** owns GCC/KCC, DAS/DLINK, p10fold, ABI,
  compiler diagnostics/code generation and processor ISA tests.
- **`../daimos-testkit`** owns DAIMOS boot, kernel, filesystem,
  device, process, syscall, shell and guest-service tests.
- Ownership follows **what is asserted**. A native KCC/DAS/DLINK
  compiler regression can use DAIMOS as its execution environment,
  but remains here as an **explicit manual** test. Such tests use
  `DAIMOS_TESTKIT_REPO` for the OS-owned boot and SIMH harness,
  never an implicit copy of those tools. They are excluded from
  routine compiler/CPU matrix sweeps.
- Generic AAP/PDP-6 instruction/timing fixtures remain here;
  DAIMOS-specific kernel-coverage inventories and runtime profiles
  belong in `daimos-testkit`.

The current 150-file, SHA256-pinned cross-repository ownership record
is `docs/TESTKIT-SCOPE-MIGRATION-20261117-v3.tsv`. Its explanation is
`docs/TESTKIT-SCOPE-MIGRATION-20261117-v3.md`. Intermediate versions
are preserved in Git history rather than as competing active manifests.

## Usage

Set `PDP10_PREFIX` to the installed toolchain root (containing `bin/`).
Set `TMPDIR` to a writable scratch area; if unset, prefer `$HOME/tmp`.
Optional source overrides include `KCC_REPO`, `DAS_ROOT`,
`DAIMOS_TESTKIT_REPO`, and `PDP10_TOOLS_REPO`.

```sh
export PDP10_PREFIX="$HOME/cross"
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
./run-tests.sh list
python3 tools/audit-test-inventory-v1.py
python3 tools/test-testkit-boundary-v1.py --require-cross
```

`./run-tests.sh` runs selected compiler, CPU and optimization cells;
its `list`, `list-kcc` and `list-gcc` commands only enumerate tests.
`COMPILER_MATRIX.tsv` defines compiler applicability and expectations.
Use `./run-tests.sh --help` and `docs/parallel-cells.md` for selector,
resume, output and timeout controls. A pending entry is not a passing
execution result. Full sweeps are operator-selected.

`SPECIAL_TESTS.tsv` records specialized tests, including deliberately
manual guest-native KCC/DAS/DLINK cases. `./run-misc-tests.sh` is the
special-suite entry point; `verify` runs the broader verify/compatibility
and validation groups, **not** merely a fast static ownership audit.
Use `./run-misc-tests.sh list-manual` to enumerate manual roots without
executing them, or `./run-misc-tests.sh run-id TEST_ID` to execute
exactly one enabled registered test. A manual root additionally requires
`--manual`; nested DAS helpers and suite-prepared tools cannot be
launched by ID. This is explicitly selected execution, not a new
automatic suite. See `docs/PDP10-HARNESS-SELECTED-TESTS-20261118-v7.md`.
Use the individual Python auditors above for host-only preflight.
For named DAS groups use `das-fast`, `das`, or `das-native`.
The independent PDP10-TOOLS suite is sourced from `../pdp10-tools`;
it is not silently replaced by `DAIMOS/tools/host`.

## Directory ownership

| Location | Purpose |
| --- | --- |
| `tests/semantic/` | Compiler semantic/runtime tests; `upstream/` is individually classified |
| `tests/codegen/` | Compiler assembly/code-generation assertions and reviewed GCC imports |
| `tests/negative/` | Rejection and diagnostic source tests |
| `tests/isa/` | CPU instruction and machine-specific semantics |
| `misc/` | Registered special suites (`kcc-host`, `das`, `compat`, `validation`, `tools`) |
| `refs/` | Reviewed historical source snapshots, not automatically runnable tests |
| `docs/` | Test-specific policy, source decisions, historical evidence and versioned manifests |
| `tools/` | Matrix runners and static integrity/ownership audits |
| `tests/todo/generic/` | Retained historical generic candidates, **not** active matrix tests |

## Verified integration state (2026-11-17)

- Compiler matrix: **2,135 sources** with no unowned test sources.
- Special registry: **284 entries**, including **234 enabled direct**,
  **44 manual** and **6 nested** registrations.
- Script ownership: **425** registered/delegated Python or shell scripts.
- Registered host verification: **20/20 passed** after the documentation
  path audit (no full compiler or OS sweep).
- Cross-repository migration: **127** former DAIMOS compiler/assembler
  identities (99 relocated, 28 deduplicated) and **23** OS test files
  relocated into `daimos-testkit`. Both v3 source manifests match.
- Historical upstream classification: **449 active**, **269 deferred**,
  **55 removed**, and **one** nonportable stress source. Classification
  does not establish that all active tests have executed successfully.

No full GCC/KCC or DAIMOS suite was run as part of the ownership split.
The previously observed compiler failures remain recorded, without
weakening their original assertions, in
`docs/PDP10-INITIAL-REGRESSION-SWEEPS-20261117-v1.md` and its failure TSV.

Subsequent focused prerequisite validation (no full matrix sweep) is in
`docs/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261117-v1.md`, including
DAS fast **10/10**, a new installed KCC/GCC freestanding archive and
PDP-6 execution test, targeted KCC-host/compatibility fixes, and
20 pilot cells from the 269-source deferred inventory. The
SHA256-pinned outcomes and remaining gates are in
`docs/PDP10-DEFERRED-BLOCKER-TRIAGE-20261117-v1.tsv`.
The next **2026-11-18 v2** focused checkpoint is
`docs/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261118-v2.md`: split
KCC-runtime prerequisite migration, 21/24 affected compatibility
scripts passing (three real assertion failures retained), 5/5 KCC
regression scripts passing, and 54 more deferred-source cells from
libc/header batches. Its 269-row source-preserving results ledger is
`docs/PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v2.tsv`.
The focused ABI/compiler repair checkpoint is
`docs/PDP10-ABI-COMPILER-REGRESSIONS-20261118-v3.md`. KCC's
previously unpreserved DImode scratch ACs are repaired upstream
(`948dd9f`), and the new registered five-target/two-mode regression
passes **10/10** with the operational compiler. The mixed-call
fixture's erroneous octal constant is corrected. GCC's packed
record-array pointer/storage mismatch remains a reproduced compiler
failure, not a silently skipped test.
The `2026-11-18 v4` focused checkpoint is
`docs/PDP10-VARARGS-AND-GCC-ICE-20261118-v4.md`. The genuine GCC
variable-sized `va_arg` ICE is repaired in `pdp10-gcc` `66f5a15`;
the installed compiler passes a new 16-cell compile-only regression.
Its original dynamic-aggregate semantic execution still fails and
remains deferred. All 26 historically deferred `varargs-abi` sources
(52 operational PDP-6 cells) are recorded, without activation, in
`docs/PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v4.tsv`.
The `2026-11-18 v5` focused compiler repair is in
`docs/PDP10-GCC-PACKED-RECORD-BYTEPOINTER-20261118-v5.md`. GCC
`c099c40` corrects nonvolatile explicitly packed nine-bit record
strides and byte-pointer field reads/writes. The previously failing
original test and a new stricter companion pass all 32 staged
CPU/optimization cells **and** all 32 operational installed-toolchain
cells. This does not alter the deferred VLA-copy
runtime blocker or imply a full matrix sweep.
The unresolved VLA block-copy investigation is recorded separately in
`docs/PDP10-GCC-VLA-AGGREGATE-COPY-20261118-v6.md`. The original
runtime assertion still fails; scratch-only pointer conversion trials
were insufficient and no compiler/libc change was deployed for them.

## Detailed documentation

- `TODO.md`: **open work**, source classification follow-ups and testkit
  verification priorities. Dated checked-off entries are historical
  milestones, not current registration totals.
- `docs/REGISTERED-TEST-PREFLIGHT-20261117-v1.md`: original registration,
  dispatcher and host-check preflight (historical snapshot).
- `docs/GCC-C-FINAL105-REVIEW-20261117-v1.md`: completed historical GCC C
  classification; source-level TSVs preserve rejected/deferred decisions.
- `docs/GCC-C-INAPPLICABLE-REMOVALS-REVIEW-20261117-v2.md`: original
  source tombstone justification and provenance.
- `docs/PDP10-CODEGEN-DECLARED-ORACLES-20261117-v1.md` and
  `docs/PDP10-DIAGNOSTIC-KCC-INTEGRATION-20261117-v1.md`: implemented
  compiler oracle policy, distinct from runtime results.
- `docs/PDP6-FP-SIMH-FIDELITY-20261021-v1.md`: DEC Type 166 hardware
  evidence and the remaining floating-point characterization work.
- `docs/PDP6-AAP-LOGICAL-TICK-OPTIMIZATION-20261015-v1.md`: historical
  processor timing work; DAIMOS-specific kernel coverage is now under
  `../daimos-testkit/tests/validation/`.
- `docs/PDP10-HISTORICAL-DOC-PATH-AUDIT-20261117-v1.md`: source-path
  reconciliation, historical-provenance crosswalk and missing-link
  regression policy (125 unchanged original source identities).

Dated integration reports remain evidence of what was checked at the
stated time; the current status of registrations comes from the TSVs
and their audits, **not** from historical counts in those reports.
