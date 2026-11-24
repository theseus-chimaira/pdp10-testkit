# GCC packed element counts v42a

Review commit d30e21b (repair/packed-element-v42a), based on 3c547c4.
Staged cc1 SHA256:
3a978d119a1cf40ff6dbd0c7390dda2bcba1598a043e981c923d71eeb7be7c0e.

Separate explicit element-count adjustment from the legacy C storage
unit path. Direct packed ARRAY_REF, dynamic member address expansion
and precomputed field offsets no longer renormalize element counts.
The single-word pointer representation remains unchanged.

544/544 selected historical cells pass: 132 recoveries and 412 guards.
Recovered groups: packed-array-bitoffset, bitptr-callarith, and
bitptr-callstore. 308 exact-type cells remain, plus the separate 2614
earlier runtime failures. No original oracles changed or exclusions.
No full sweep, master merge, or installed compiler change.
Native RAM and extended addressing not measured.
