# Freestanding PDP-6 BLT acceleration — 2026-10-14, v3

## Implementation

The KCC and GCC freestanding archives use identical PDP-6-compatible
assembly. Large aligned 9-bit standard C `memcpy` and `memset` transfers
use BLT. The extended raw-byte-pointer `p10bcopy_v2` and `p10bfill_v2`
use BLT for aligned, compatible 6/9/18/36-bit layouts. The threshold is
**four complete words**; shorter operations retain the original MOVE/MOVEM
or byte-pointer loops. Unaligned pointers and partial-word tails use
LDB/DPB/IBP. `memmove` retains backward overlap-safe copying; its forward
nonoverlap/forward-safe path delegates to accelerated `memcpy`.

For fill, the first word is seeded then BLT copies that word forward into
the remainder of the destination. This deliberate overlap is safe for
uniform fill, unlike arbitrary overlapped `memcpy`. No heap, OS calls,
stack allocation, or writable library globals are added.

## Verification

- Staged libp10c-v2.a archives for GCC and KCC have identical SHA-256 hashes.
- Four C regression files each passed PDP-6 execution under both compilers
  (eight executions), including long aligned and unaligned memcpy/memset.
- `misc/compat/test-p10byte-widths-v2.sh` passed the base 6/7/8/9/18/36-bit
  pointer regression.
- `misc/compat/test-p10byte-blt-v3.sh` passed long word-transfer and
  fill tests for 6/9/18/36-bit pointers, with partial tails.
- The initial generated long-copy test had incorrect numeric notation:
  DAS read unprefixed `.word` constants as decimal. The test was fixed to
  use explicit octal constants; no library workaround was used.

The timing-table rationale favors BLT for long transfers, but precise
speedup and optimal threshold remain unmeasured. Other CPUs and compiler
optimization profiles are not yet swept; the operational prefix is not
replaced. The current `p10run` accepts assembly sources, not .a archives,
so production archive extraction remains to be tested separately.
