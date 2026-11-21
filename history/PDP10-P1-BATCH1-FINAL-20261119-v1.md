# PDP10 P1 Batch 1 completed test construction (2026-11-19 v1)

## Scope and closure distinction

The ten frozen original-source positions of Batch 1 are now **10/10
covered for test construction**. The exact original imported files and
historical deferred status are unchanged. A P1 coverage closure means
that a source has a valid, independently examined test expectation,
normal compiler-matrix admission, genuine execution observations and
checksum-verified evidence. It **does not** mean that every compiler,
linker, emulator or original source succeeds.

The initial Batch 1 admissions and 40 target execution logs remain in
`PDP10-P1-BATCH1-ADMISSION-20261119-v1.md`. This phase adds five
versioned sources with 28 more real PDP-6 compiler/profile observations:

| Original | Supplemental source | PDP-6 compiler results |
| --- | --- | --- |
| `20000914-1.c` | `pdp10-enum-bitfield-policy-v1.c` | KCC 2 PASS; GCC 4 PASS |
| `920302-1.c` | `pdp10-label-offset-identity-v1.c` | GCC 4 PASS |
| `920302-1.c` | `pdp10-label-direct-dispatch-v1.c` | KCC 2 PASS; GCC 4 PASS |
| `920501-2.c` | `pdp10-pollard-factor-original-v1.c` | KCC 2 link_fail; GCC O0 step_limit; GCC O1/O2/Os 3 PASS |
| `920501-6.c` | `pdp10-original-prime-interval-v1.c` | GCC O0 real assertion failure; KCC 2 and GCC O1/O2/Os 3 step_limit |

The 28 profiles comprise **19 real PASS, one failing guest numeric
assertion, six instruction-step-limit results, and two genuine missing
KCC runtime symbol failures**. These classifications are not silently
merged into a single `run_fail` compiler defect label. The standalone
matrix source for the original combined label-offset dispatch retains
four separate **SIMH wall timeouts** with no readable guest result.

## Enum bitfield: target-dependent signedness

The original C test stores `AMBIG_CONV` (independent enum value **222**)
into an eight-bit `enum tree_code` bitfield. A signed eight-bit field
cannot represent 222; an unsigned eight-bit field can. Its signedness
and out-of-range conversion are implementation dependent. The new
policy source explicitly checks signed eight-bit **-34** and unsigned
eight-bit **222**, accepts the enum-field interpretation of either
**-34 or 222**, and independently checks subsequent switch behavior.
Both compiler families PASS in all native PDP-6 modes. KCC failure of
the old unsigned-assuming example must not be asserted to be a compiler
error solely on this implementation-defined choice.

## GNU computed goto: verified expectation, unresolved target hang

The original sequence is **x, y, x, y, z**. The combined
`pdp10-label-offset-dispatch-v1.c` passes on the host GNU C compiler
(`-std=gnu89`), proving its test/control flow is not inherently an
infinite loop. On PDP-6 all four GCC modes still time out with no
readable guest exit.

Two separately bounded real PDP-6 controls distinguish the operations:
**short label-offset subtraction/readdition passes GCC 4/4**, and
**direct labels-as-values dispatch passes KCC/GCC 6/6**. The combined
failure is retained as a *timeout diagnosis*, not a proven compiler
assertion error or a fake passing PDP-6 case. Further attribution to
compiler code generation vs emulator behavior is P2/P3, not missing
P1 test construction. AAP architecture correctness remains P3.

## Full 71-bit Pollard factorization: original arithmetic oracle

The complete original factor-search loop, gcd, modular exponentiation,
unsigned long-long wrap and factor readback are exercised. Unlike the
previous bounded powmod fixture, this executes the actual mathematical
factorization of `2**27-1=134217727` for the original seed/power.
Independent Python unbounded arithmetic, masking intermediate
multiplication/accumulation results modulo `2**71`, derives the
factor checkpoints **(iteration 1, 7)**, **(4, 73)**, and
**(277, 262657)**. Their product equals 134217727.

GCC PDP-6 O1/O2/Os complete the full test and PASS. GCC O0 exhausts
the 100-million-instruction budget without an assertion. KCC
opt/noopt cannot link the genuine absent `__kcc_umoddi3` helper. The
KCC runtime repair belongs after P1; no local fake modulo function is
linked to force this test to pass.

## Exact 1,234,111,111 through 1,234,111,127 prime interval

The full original decimal parser, 71-bit integer square root and odd
trial division are exercised over the **exact original range**.
Independent Python `math.isqrt` and trial divisibility prove its three
primes are **1234111117**, **1234111121**, **1234111127**. GCC PDP-6 O0
reaches a genuine nonzero guest assertion (the number of returned
primes differs). GCC O1/O2/Os and KCC opt/noopt run out of instruction
steps before a readable final assertion. The bounded predecessor
`pdp10-wide-isqrt-prime-v1.c` already passes GCC Os and separates
numerical suboperations. The original complete range is now present
as an assertive, live matrix test without removing expensive work or
replacing the algorithm; execution quota and implementation failures
remain explicitly recorded for P2/P3.

## Evidence and maintenance

`PDP10-P1-BATCH1-FINAL-RESULTS-20261119-v1.tsv` pins the source,
original owner, profile, status, precise observed outcome and per-log
SHA256. `refs/pdp10-p1-batch1-final-20261119-v1.tar.gz` contains the
real compiler, linker and simulator guest reports. The registered
`tools/verify-p1-batch1-final-v1.py` recomputes all independent
71-bit Pollard, prime and enum references, checks label source
operations, original source hashes, matrix registration, and all 28
archived results. No compiler or emulator implementation was changed.

The complete current status is `PDP10-P1-SEMANTIC-RESOLUTION-20261119-v4.tsv`;
the unchanged 59 original assignment positions, refreshed to the
latest statuses, are in `PDP10-P1-SOURCE-BATCHES-20261119-v3.tsv`.
Batch 1 remains ten original sources, **10 covered**. Across all 67
historical originals the distribution is **18 covered, 6 partial,
43 blocked**, leaving **49 actionable P1 construction obligations**.
Batch 2 can now begin without putting compiler/runtime implementation
repairs or AAP hardware correctness back in the P1 queue.
