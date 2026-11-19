# PDP10 P1 semantic original-source resolution: current v4

Date: 2026-11-19. V1 is the immutable source disposition and 59-open
baseline; v2 and v3 are the historical incremental admission snapshots.
All 67 original imported source bytes and SHA256 classifications remain
unchanged in the historical manifests. Neither a failing compiler nor
a timed-out emulator is silently reclassified as correct.

## Current P1 source-construction state

| State | Original source identities | Interpretation |
| --- | ---: | --- |
| Covered | **18** | Original tested intent now has an independently audited matrix oracle |
| Partial | **6** | More original semantics or prerequisites remain to construct |
| Blocked | **43** | Hosted libc, ABI, width/ISA harness or original admissions missing |
| **Total** | **67** | **49 remain actionable P1 source obligations** |

The frozen 59-source work assignment remains 10+10+10+10+10+9.
**Batch 1 is 10/10 covered for test construction.** The other eight
covered originals were already closed before those 59 positions were
frozen. The audit source of truth is
`docs/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v4.tsv`, regenerated or
checked by `tools/build-p1-semantic-resolution-v4.py`. The immutable
assignment and its current progress is version 3 of the source-batches
TSV, audited by `tools/audit-p1-source-batches-v3.py`.

## Four completed original-source intentions from v3 partial status

- `20000914-1.c`: independently derive enum value 222 and explicitly
  test *either* supported implementation-defined eight-bit enum field
  representation. The old KCC assumption of an unsigned enum bitfield
  is not portable C. The policy source passes all six PDP-6 profiles.
- `920302-1.c`: independent GNU C host execution confirms expected
  output `xyxyz`; four GCC PDP-6 labels/offset identities and six
  KCC/GCC direct indirect-label control profiles pass. The original
  combined PDP-6 implementation still times out with no guest
  assertion. The valid test is constructed; assigning the hang to
  the compiler versus emulator remains a separate investigation.
- `920501-2.c`: all original 71-bit Pollard factorization operations,
  the three independently derived factors and their stage-specific
  iteration counts now have a complete companion. GCC O1/O2/Os PASS;
  GCC O0 reaches a step limit, and KCC opt/noopt cannot link the real
  absent `__kcc_umoddi3` runtime helper. No replacement shim is added.
- `920501-6.c`: the full original prime interval is present, with
  independent host primality reference and nonvacuous assertions.
  GCC O0 genuinely fails the prime-count assertion; all other PDP-6
  compiler profiles reach the instruction-step budget. This is
  reproducible compiler/runtime evidence, not a guest PASS.

## Implementation follow-ups, outside P1 source construction

Compiler implementation repairs belong after testkit construction;
emulator architecture-correctness and timing expansion are **P3**:

| Original | Follow-up | Priority boundary |
| --- | --- | --- |
| `20000914-1.c` | Document native enum-field choice if exact historical GCC behavior becomes an ABI requirement | Source policy established; not a proven compiler bug |
| `920302-1.c` | Attribute four original target timeouts to compiler codegen or emulator behavior | P2 compiler investigation / P3 architecture correctness |
| `920501-2.c` | Provide genuine KCC unsigned 71-bit modulo and investigate GCC O0 step exhaustion | P2 compiler runtime; performance analysis outside P1 |
| `920501-6.c` | Repair prime-count regression under GCC O0; investigate step exhaustion in all other modes | P2 compiler / P3 simulator budget |

The supporting twenty-eight real execution records are pinned in
`PDP10-P1-BATCH1-FINAL-RESULTS-20261119-v1.tsv` and the matching
archive under `refs/`. The registered auditor independently
recomputes the reference cases, checks original SHA256 and active
normal compiler-matrix admission, and rejects false passing claims.

The next source-construction work starts with the **ten immutable
Batch 2 sources**, without changing Batch 1 assignments, upstream
source history, or the original documented failures.
