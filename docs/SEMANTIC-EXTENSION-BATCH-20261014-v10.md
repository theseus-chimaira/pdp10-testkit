# Extension suitability classification: tenth bundle (2026-10-14, v10)

Eight consecutive extension-review entries were compiled and attempted
under KCC and GCC `-O0` using PDP-6. The feature-support decisions in
`KCC-EXTENSION-SUPPORT-POLICY-20261014-v1.md` are authoritative for
whether KCC implementation work is planned.

| Test | Feature | KCC PDP-6 | GCC PDP-6 | Decision |
| --- | --- | --- | --- | --- |
| `eeprof-1.c` | Function-entry/exit instrumentation | Runtime failure | Runtime failure | Deferred |
| `loop-12.c` | GNU `pure` attribute and memory-dependent loop | PASS | PASS | **Active unchanged** |
| `memcpy-bi.c` | Assembler libc memory routines | Link failure: `memcmp` | Link failure: `memcmp` | Deferred: harness/archive linkage |
| `nest-stdar-1.c` | Nested function with variadic arguments | Compile rejection | PASS | Deferred: intentionally unsupported by KCC |
| `nestfunc-1.c` | Nested callback function | Compile rejection | PASS | Deferred: intentionally unsupported by KCC |
| `nestfunc-2.c` | Nested callback with seven parameters | Compile rejection | PASS | Deferred: intentionally unsupported by KCC |
| `nestfunc-3.c` | Nested function callback chain | Compile rejection | Execution failure (no readable examine output) | Deferred: intentionally unsupported by KCC |
| `old.tort.c` | PDP-10 byte-pointer torture/hosted I/O | Compile rejection | Link failure: `printf` | Deferred: hosted services |

The `loop-12.c` check is substantive: it calls a `pure`-attributed function
repeatedly while advancing a pointer to changing memory. Its `-O0` passes
do not claim optimization-specific coverage. Register it in the semantic
compiler matrix. For `memcpy-bi.c`, ordinary optimized assembler libc
functions already exist; missing `memcmp` in the minimal bare-metal link
does not authorize a duplicate built-in implementation.

The four nested-function cases are permanently out of scope for KCC;
retain them only as deferred upstream/GCC tests and do not add compiler
implementation TODOs. No compiler, libc or test source was changed.
