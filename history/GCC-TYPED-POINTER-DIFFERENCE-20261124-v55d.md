# GCC typed pointer difference v55c/v55d

GCC master 8a214a9 preserves typed C pointer difference expressions
until RTL expansion. Ordinary integer reassociation of encoded byte
pointers is invalid. Each pointer operand is evaluated once. For local
native nine-bit and halfword pointers, the distance is computed from
word and slot coordinates, returning C storage units before element-size
division. The old optimization-specific raw-pointer compensation and
its late instruction-sequence deletion are removed. Optimized global
first-byte extraction preserves the already selected physical word.
Appending the new tree code preserves existing code numbers; the C
frontend make dependency now includes c-common.def. The initial v55a
incremental build failed with stale tree-code consumers; v55b rebuilt
those objects. v55c additionally corrects first-byte output and removes
the obsolete compensation. This is C acceptance, not C++ acceptance.

Staged v55c cc1 SHA256:
cfad2531771dff435fec6d947409e2fff106c7535c77453e5b5eb94ab0f53035.
The new regression covers mixed integer sums, signed distances, calls,
postincrement, nine-bit and halfword pointers, native word pointers,
and physical word boundaries. All 44 cells pass; the same test on
v54b produces 44 ICEs in instantiate_virtual_regs_1. These new ICE
recoveries are not historical runtime recoveries.

The DevSpace2 connection interrupted v55c replay. Restart checkpoints
were preserved and both replays resumed. Six additional related cells
missing from the interrupted selection were replayed separately.
Final candidate acceptance: 1188 pass (300 related, 44 new regression,
844 cumulative guards), 36 compile-only, 44 existing switch failures.
No cumulative guard failure. All 99 historical recoveries are matched
against the v54c remainder by exact test/machine/compiler/profile/kind
key. The remaining count is 2223 minus 99, or 2124 cells across
80 distinct sources.

Cross-word object words summed over 44 configurations: 7249 -> 7412;
all grow. Their baseline failed runtime correctness. For 844 prior
correct guard images: 381424 -> 381539 words, 22 smaller, 772 equal,
50 larger. Prior guard baselines are the v53b and v54b staged builds;
these are object sizes, not native RAM measurements or speed evidence.

The 44 switch failures remain. In the native record-array initializer,
the dynamic inner byte index is lowered without the enclosing dynamic
record index: gi[i].data[j] accesses the same record for all i. The
existing native record scalar walker rejects dynamic subword strides.
Investigate the physical address representation before extending that
path. Keep record pointer representation and layout ABI unchanged
unless a separate verified ABI defect requires it.

No full matrix, extended-address or C++ acceptance, calibrated timing,
native compiler RAM measurement, or production installation claimed.
