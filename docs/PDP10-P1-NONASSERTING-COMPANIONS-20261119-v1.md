# PDP10 P1: four additional nonasserting-source companion regressions v1

Date: 2026-11-19. This is test construction, **not** compiler repair.

Four upstream sources originally exited successfully (or executed a
minimal store) without checking the operations they purported to test.
They remain unchanged, checksum-pinned and deferred. Four new, separate
C regression sources provide explicit, nonvacuous expectations and
independent current matrix registrations.

| Original upstream source | Companion | PDP-6 outcomes |
| --- | --- | --- |
| `931110-1.c` | `pdp10-bitfield-array-writeback-v1.c` | GCC O0/O1/O2/Os: **four run_fail**, checkpoint 2; KCC does not support signed-short bitfields |
| `921215-1.c` | `pdp10-nested-trampoline-call-v1.c` | GCC O0 **PASS**, O1/O2/Os **SIMH timeout rc124**; KCC does not implement GNU nested closures |
| `960117-1.c` | `pdp10-packed-union-identifier-v1.c` | KCC optimized/unoptimized **PASS**, GCC O0/O1/O2/Os **four run_fail**, numbered checkpoints |
| `920415-1.c` | `pdp10-nested-label-indirect-goto-v1.c` | GCC O0/O1/O2/Os **four PASS**; KCC GNU nested-label syntax unsupported |

## Assertion construction

The signed-short bitfield array test checks all ten original-style
array entries, multiple signed bitfield values, and both adjacent
integer sentinels. The earlier source only wrote zero into the first
field. Its GCC failure is in the nonzero signed-field readback, not
an unrelated I/O dependency. This is a compiler regression *test*;
compiler repair remains deferred.

The GNU nested trampoline case has a callback through a captured local
variable, verifies the callback's modification to the enclosing stack
frame and checks accumulated output. No `NO_TRAMPOLINES` bypass is
permitted. Only the unoptimized case terminates. Optimized runs
reach the emulator's 18-second timeout with no readable `__test_exit`,
so they remain **unresolved runtime timeouts**, *not* proven assertion
failures or compiler ICEs.

The packed union/record test exercises the original packed aligned
pointer and short declarations, checking both identifier bytes,
target pointer identity, short position and absence of accidental
mutation to the previous identifier. GCC reports actual assertion
failures; KCC passes both optimization modes. The original had a
non-void helper falling through without returning and never validated
what it stored. The companion does not depend on that undefined return.

The nested-label indirect goto uses a GNU nested helper returning the
address of an enclosing local label. It must enter the computed goto,
skip a deliberate abort and update a caller-validated volatile total.
It passes GCC's four optimization profiles, with no vacuous
compile-only branch.

## Evidence and audit

All **18** actual PDP-6 cells are in
`PDP10-P1-NONASSERTING-COMPANION-RESULTS-20261119-v1.tsv`:
7 successful executions and 11 recorded `run_fail` statuses (eight
assertion failures and three optimizer-profile timeouts). Full original
compiler and simulator logs are archived in
`refs/pdp10-p1-nonasserting-companions-20261119-v1.tar.gz`.
The registered host verifier
`tools/verify-p1-nonasserting-companions-v1.py` checks each source
SHA256, precise optimizer/matrix selection, evidence archive integrity,
expected successful exits, observed failed assertions, and recorded
SIMH timeout classification. Negative controls for changed status and
altered SHA256 are both correctly rejected.

None of these tests changes a compiler, linked runtime, emulator, or
original upstream source. The entire group remains within the P1
compiler testkit construction priority. The remaining nonasserting
sources, especially GNU prefetch behavior, need independent codegen
and side-effect oracles rather than superficial runtime success.
