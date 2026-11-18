# Deferred integration: fifth ten-source batch (2026-11-18, v12)

## Scope

Exactly ten previously unreviewed source identities, selected in order
from `SEMANTIC-DEFERRED-DISPOSITION-20261118-v5.tsv` after excluding
all paths in the v8, v9, v10 and v11 ten-row decision ledgers. No
full compiler matrix, other CPU targets, DAIMOS guest tests, or any
of the 44 manually registered special tests were run.

**Five source identities connected; five retained deferred; zero
removed.** Every original C or assembly source remains byte-identical.
This batch introduces:

- `PDP10-DEFERRED-INTEGRATION-BATCH05-20261118-v12.tsv`: ten exact
  original/current SHA256 pins, original disposition, PDP-6 KCC/GCC
  compiler-cell results, registration status, and decision explanation;
- `SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v7.tsv`:
  **481 active / 236 deferred / 56 removed / one stress-nonportable**;
- `SEMANTIC-DEFERRED-DISPOSITION-20261118-v6.tsv`:
  **236 current, SHA256-verified deferred source identities**;
- five new rows of `COMPILER_MATRIX.tsv`, reaching **2,140**
  unique source registrations, with no extra registration for a
  byte-identical deferred source.

Earlier manifests are retained as historical evidence. No compiler
regression was fixed or incorrectly treated as a passing test.

## Per-source decisions

| Source | Decision | Actual PDP-6 evidence and oracle |
| --- | --- | --- |
| `20020828-3.c` | Connect GCC O0 only | Twelve `memcpy` lengths 1..12 assert that the copied byte prefix equals the source and the untouched destination suffix remains zero. GCC O0 **passes**, O1/O2/Os **runtime fail**. KCC noopt **runtime fails**. The KCC CPU-wide matrix status is `fail`; GCC is `semantic/fail/fail/fail`. |
| `20021022-2.c` | Connect GCC | GNU `void *` arithmetic must give identical results when the cast occurs before or after adding three bytes to the address of a struct member. GCC O0/O1/O2/Os **4/4 pass**. KCC rejects unsupported GNU void-pointer arithmetic; do not schedule a KCC failure as if the feature were supported. |
| `920302-1.c` | **Retain deferred** | Tests GNU label-address differences, computed goto, and final string equality to `xyxyz`. GCC O0 compiled and linked using the **actual installed `strcmp`**, but the PDP-6 simulator **timed out (rc 124)** with no readable `__test_exit`. This is an execution timeout, **not evidence the final `strcmp` assertion was reached and failed**. KCC rejects computed labels. The exact copy under `tests/todo/generic/pdp10/` stays deferred. |
| `920411-1.c` | Connect GCC | Reassembles a `long` object byte-by-byte and asserts equality to the replicated space-character pattern `~0UL/(unsigned char)~0*' '`. GCC O0/O1/O2/Os **4/4 pass**. KCC noopt **runtime fails**; register its real failure for later compiler investigation. |
| `920415-1.c` | **Retain deferred** | Original GNU nested-function label-address/computed-goto code passes GCC O0/O1/O2/Os, but inspection of emitted assembly shows **no computed jump and no abort path**; O1/O2/Os also eliminate the nested-function call. Its passes do not validate an actual indirect jump. Scratch-only variants using a volatile label-pointer load also fell through; a strengthened volatile label-address equality assertion triggered a GCC-generated undefined local label `%L5` at link time in all four optimizations. **No experimental adaptation was applied to the source**, and no vacuous pass was registered. The byte-identical PDP-10 copy stays deferred. |
| `920428-1.s` | **Retain deferred** | KL10 `.DIRECTIVE KL10` assembler fixture uses `.PSECT`, global byte pointer constructs, `XMOVEI`, `ADJBP`, `LDB/DPB`, and external `%ONE`, `%BADX*`, `..main` symbols. Treating this `.s` file as C with either PDP-6 compiler predictably **fails compilation**; that is **not** a valid assembler test. Requires its own KL10-capable assembler/linker and associated symbols before it can serve as an ISA fixture. Do not execute it via the C semantic matrix, fabricate external symbols, or discard it. |
| `920428-2.c` | Connect GCC | GNU nested function performs a cross-scope goto to `l1` when called with argument 2; `x` asserts results of `s(0)`, `s(1)`, `s(2)`, and main aborts on failure. GCC O0/O1/O2/Os **4/4 pass**. The O0 PDP-6 assembly includes a **real indirect `JRST (3)`** and reachable abort path. KCC nested-function/cross-scope goto syntax unsupported. |
| `920501-2.c` | **Retain deferred** | Actual unsigned wide-integer `powmod_ll`, `gcd_ll`, multiplication and modulo used for factorization, with exact expected factors 7, 73, 262657. KCC cannot link `__kcc_umoddi3`; GCC O0 **executes but aborts** on the result assertion. These are separate runtime-helper and compiler/semantic defects for the later sweep. |
| `920501-3.c` | Connect GCC | GNU label-address arithmetic and computed goto must fill a table with exactly 0,1,2,0. GCC O0/O1/O2/Os **4/4 pass** with the original abort checks. KCC rejects GNU computed label syntax. This is not a PDP-10 machine-ISA test despite exercising emitted indirect control flow. |
| `920501-6.c` | **Retain deferred** | Original decimal parser, unsigned `long long` square root, trial-division prime list and exact three-prime result assertions remain meaningful. GCC O0 cannot compile unused `#include <stdio.h>` because hosted GCC `stdio.h` is unavailable; KCC noopt **runtime fails**. Removing **only** the unused include in a scratch copy allows GCC O0 compilation, but execution still **aborts** on the original prime-table assertion. Thus missing `stdio.h` is **not the only blocker**. The original source and assertion were not changed or promoted. |

The five retained tests each have a specific reason for not being
connected. In particular, the KL10 assembler auxiliary is a
prerequisite/ownership issue, `920415-1.c` lacks meaningful executed
computed-goto coverage, and the others have actual compiler or math
execution failures. **None was a justified deletion candidate.**

## Narrow execution results

The original-source PDP-6 probe ran **20 cells** (ten sources, one
KCC noopt and one GCC O0 per identity, with the KL10 assembler
auxiliary explicitly recognized as an inapplicable C probe). Six
originals had GCC O0 success. Their **18 further GCC executions**
at O1/O2/Os resulted in **15 passes and three runtime failures**,
all three failures coming from `20020828-3.c`.

However, one of those six (`920415-1.c`) proved vacuous after
actual assembly inspection and remained deferred. The **five**
connected sources contribute precisely **20 GCC PDP-6 profiles**:
**17 passing** and **three explicitly failing**. Two of them
(`20020828-3.c`, `920411-1.c`) additionally register KCC's
observed failure in the CPU-wide native slot (four selected KCC
optimization cells; only the noopt failures were independently
executed). All other CPU and compiler-family profiles remain
pending/unsupported, never inferred as passing.

Scratch-only diagnostic experiments, **not promoted as source tests**:

- `920501-6.c` minus unused `stdio.h`, GCC O0: compilation passes
  but original runtime prime assertion fails.
- `920415-1.c` with a volatile computed-target variable, GCC
  O0/O1/O2/Os: runs but emitted assembly still falls through.
- `920415-1.c` with an explicit volatile label pointer equality
  check, GCC O0/O1/O2/Os: compiler-generated undefined local symbol
  `%L5` at link time.

Versioned local evidence directories:

- `$TMPDIR/p10tk-deferred-integration-batch05-20261118-v12`
- `$TMPDIR/p10tk-deferred-integration-batch05-gccopts-20261118-v12`
- `$TMPDIR/p10tk-batch05-unused-stdio-20261118-v12`
- `$TMPDIR/p10tk-batch05-computed-goto-20261118-v12`

## Ownership and next cursor

The two byte-identical deferred pairs `920302-1.c` and
`920415-1.c` **stay deferred on both sides**. None of the five
newly connected sources has a duplicate in the 50-pair ownership
census, so there are no new active/deferred owner transitions.
But the more precise current dispositions of these two retained
sources differ from their historical identical copies. To keep the
fail-closed ownership audit accurate, the authoritative
`DEFERRED-SOURCE-DUPLICATES-20261118-v8.tsv` census and
`DEFERRED-SOURCE-DUPLICATES-20261118-v9.tsv` review now record
both as **deferred/deferred disposition conflicts**, with the
separate GCC runtime/oracle and KCC feature-policy blockers
retained. All 50 SHA256-pinned pairs remain accounted for:
five active/deferred pairs and seven disposition conflicts.
The prior v6/v7 duplicate records remain as historical snapshots.

For batch 6, select the first **ten paths still deferred and absent
from all five v8/v9/v10/v11/v12 ten-source ledgers**. On the
`SEMANTIC-DEFERRED-DISPOSITION-20261118-v6.tsv` version this
begins with `tests/semantic/upstream/extensions/920501-7.c`.
Do not reclassify older still-blocked entries as fresh work.
Continue to explain *before* any source removal. The 44 manual
tests and broad compiler matrix remain out of scope.
