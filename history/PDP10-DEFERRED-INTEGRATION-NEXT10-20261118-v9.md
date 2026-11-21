# Deferred integration: second ten-source review (2026-11-18, v9)

## Scope and decision policy

Review exactly the first ten entries of the previously current
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v2.tsv`, in declaration
order. This includes `20000914-1.c`, which had also been retained by
the first batch. Review only the original source, prerequisites,
assertions and narrow PDP-6 KCC/GCC execution evidence; no full
compiler matrix, manual special-test suite or OS tests were started.
Do not fix compiler defects at this stage.

Outcome: **six sources connected**, **three remain deferred**, and
**one Alpha-only source removed** after explaining its lack of a
PDP-10 assertion. No genuine failing semantic test was deleted.
No original assertion was weakened. The original source and all
historical pre-integration manifests are preserved in Git history.

The exact ten-row source-pinned evidence is
`PDP10-DEFERRED-INTEGRATION-NEXT10-20261118-v9.tsv`.
Current authoritative classifications:

- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v4.tsv`:
  464 active, 253 deferred, 56 removed, one nonportable stress test;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v3.tsv`:
  253 outstanding SHA256-pinned sources.

## Per-source decisions

| Original | Decision | Explicit reason |
| --- | --- | --- |
| `20000914-1.c` | Retain deferred | KCC rejects GNU `__SIZE_TYPE__`; GCC cannot link actual hosted `malloc`. Its enum/bitfield/aggregate switch requires real allocated storage. This is the previously reviewed outstanding source, not a new failure or deletion candidate. |
| `20001229-1.c` | **Remove as inapplicable** | The intended alignment fault, Alpha `setsysinfo`/SIGBUS setup and OS-specific kernel checking are all under `__alpha__`. On PDP-10, `foo` has an empty body and `main` simply calls it before `exit(0)`. KCC/GCC `-O0` passes are thus **vacuous**: no PDP-10 ISA or inline assembly is tested. This specific reason was provided before deletion. The historical file remains recoverable from the preceding Git commit. |
| `20010119-1.c` | Activate **optimized GCC only** | `__OPTIMIZE__` gates an extern-inline `__builtin_constant_p` branch and potential undefined `undef` call. GCC PDP-6 `-O1/-O2/-Os` compile, link and execute its real optimized branch. An erroneously retained `undef` call would fail linkage; the test does **not** assert a unique `bar` versus `baz` branch, so claim only that narrow optimization/link oracle. KCC and GCC `-O0` select an empty branch: mark `no_test`, never a semantic pass. |
| `20010122-1.c` | Retain deferred | `__builtin_return_address(0/1)`, `alloca`, frame depth and original pointer-equality assertions are meaningful. KCC cannot compile the extension; GCC PDP-6 `-O0` actually executes but fails its return-address checks. This is a compiler/ABI issue for later sweep, not a test to drop. |
| `20010124-1.c` | Activate GCC | The local `memcpy` intentionally aborts when wrongly invoked for overlapping data. Correct generated structure-return/union copies call `memmove` instead. GCC PDP-6 `-O0/-O1/-O2/-Os` all pass with real freestanding linkage; the negative memcpy oracle remains present and unchanged. KCC rejects GNU `__SIZE_TYPE__` and void-pointer arithmetic. |
| `20010209-1.c` | Activate GCC | A GNU nested function uses a VLA argument to calculate a six-element recurrence and asserts the exact result 15. All four GCC PDP-6 optimizations pass; KCC lacks nested-function support. |
| `20010325-1.c` | Activate GCC | Mixed wide/narrow string literal concatenation must yield `L'b'` at index 1; an explicit `abort` checks this. GCC PDP-6 all four optimizations pass. KCC's wide-string-concatenation parser failure remains an observed compiler error, not ignored as a pass. |
| `20010409-1.c` | Activate GCC | Calls real freestanding `strlen`, passes rearranged arguments and checks zero `w` in `bar` (which aborts if nonzero), then explicitly exits. All four GCC PDP-6 optimizations pass. KCC rejects `__SIZE_TYPE__`. |
| `20010518-2.c` | Retain deferred | Real `memcpy`, packed/misaligned compound literals and volatile field readback are asserted. KCC and GCC PDP-6 `-O0` both reach execution but fail the source assertion. The compiler/ABI defects belong in the later compiler sweep; no stubs or changed expected values. |
| `20010605-1.c` | Activate GCC | The block-scope GNU `static inline` function must calculate 42 times 10; `main` returns a failing status if it does not. GCC PDP-6 all four optimizations pass; KCC rejects the GNU syntax. |

Each new `COMPILER_MATRIX.tsv` row activates **only** the
profile-specific cases above. Other CPU/family combinations remain
`pending` or `unsupported` as applicable. The source with an
optimized-only oracle does not enter the inactive GCC `-O0` cell.
The 44 manually registered special tests were neither altered nor
executed.

## Independent duplicate-source ownership

`20010124-1.c` also has a byte-identical copy under
`tests/todo/generic/20010124-1.c`. Its historical review
recorded a deferred/deferred pair. Promoting the verified generic
owner without reconciling its twin failed the fail-closed inventory
audit, as intended.

The new `DEFERRED-SOURCE-DUPLICATES-20261118-v2.tsv` census and
`DEFERRED-SOURCE-DUPLICATES-20261118-v3.tsv` review preserve the
original source hash and all **50** source-pair identities. Only
this pair's state was updated: generic source A is the GCC-verified
active owner; identical PDP-10 source B stays deferred for independent
KCC GNU-header/dialect evidence. No second matrix entry was added.

The static auditor now checks that **the actual active side** is the
canonical owner, instead of assuming that a historical active owner
must always be the lexically second source. Both previously recorded
active-KCC/GCC-failure pairs retain their original review statuses
and compiler gates. The new active-GCC/KCC-failure pair has its own
explicit compiler gate, selected canonical source and audit checks.
There are three active/deferred pairs and six disposition-conflict
pairs in the current 50-pair review. No silent double execution.

## Actual bounded validation

- Ten originals: 20 PDP-6 native cells, KCC `-n` and GCC `-O0`.
- Six initially GCC-passing, meaningful or potentially meaningful
  candidates: 18 more PDP-6 GCC cells (`-O1/-O2/-Os`), **18/18 pass**.
- Optimized `20010119-1.c` assembly and `__OPTIMIZE__` predefinition
  separately inspected. Its `-O0`/KCC passes remain recorded but
  deliberately not activated.
- `20010124-1.c` assembly independently checked to call real
  `memmove`, not the locally aborting `memcpy`, in the passing path.
- All remaining deferred hashes rechecked; matrix, source, script
  and duplicate ownership audits pass after the reconciliation.

Local diagnostics:

- `$TMPDIR/p10tk-deferred-integration-next10-20261118-v9`
- `$TMPDIR/p10tk-deferred-integration-next10-gccopts-20261118-v9`

## Next batch cursor

The next group must contain **ten distinct, not-yet-reviewed deferred
source identities**. Do not repeatedly select the first ten rows
of the current manifest, because three already-reviewed failures
necessarily remain deferred. Select the first ten entries from
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v3.tsv` whose paths are
absent from **both** the v8 and v9 ten-row integration ledgers.
Those currently start at `20010605-2.c` and include the two
`20010904` tests. This selects ten *new* decisions, with no
repeated `20000914-1.c` work.

Continue to explain any proposed deletion before removing its source.
All 44 manual special tests remain on hold until deferred decisions
are complete. Full compiler/CPU sweeps are out of scope.
