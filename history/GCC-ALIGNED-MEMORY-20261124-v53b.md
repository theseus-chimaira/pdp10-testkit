# GCC aligned memory operations v53a/v53b

Review fcad43e, based on ea38970, lowers aligned constant-size memory
builtins into physical word transfers and 9/18/27-bit tail operations.
Exact16 HImode must not be used for two nine-bit C characters. Large
copies use BLT; large fills seed a word and propagate it with BLT.
Return pointers and all nine fill bits are preserved. Standalone
right-justified subword scalars are not treated as word-aligned pointers.
The local-address implementation adds no permanent target storage.

Review e64cb87, based on fcad43e, removes redundant conversions of
native 36-bit integer pointers for source operands and unused return
values. Exact32 dual-representation pointers are not included in that
optimization. Extended-address behavior is not newly accepted.

Both staged candidates pass 318/318: 66 original cells (33 memset,
33 memcpy), 44 new regression cells (constant lengths, fill widths,
single evaluation, return value, boundaries), and 208 prior guards.
Hosted cc1 hashes:
v53a 362323e0e4a9d1ac34d4c810463f9a177be66bdc9f595aef37c826741bb0664c
v53b a18d9ae0bcb319597639875c2285399032f8a8c89ceff405f48780368ec0ebf5

Historical remainder: 2399 cells, 89 sources. The remaining manifest
preserves historic failure statuses, not a fresh full sweep.

Object TEXT+DATA+BSS totals for the 33 configurations per test:
memset v52a 4523 (failing), v53a 6273, v53b 4689;
memcpy v52a 13305 (failing), v53a 9324, v53b 6156.
All 66 images shrink versus the correct v53a baseline. Sums across
configurations are not a single executable's memory footprint.

Four sampled SIMH timing pairs are saved in the speed manifest.
PDP-6 O1 memcpy initial v53a/v53b 26114/161360 ticks; repeat pairs
26285/60114, 26285/161360, 26285/31765. The same saved images pass
their oracles throughout. The variation and apparent slowdown remain
unresolved; no speed acceptance claimed. No full sweep, master merge,
installation or native compiler memory measurement.
