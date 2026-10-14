# Extension suitability classification: sixth bundle (2026-10-14, v6)

Eight manifest-ordered extension cases were attempted on PDP-6 under KCC
and GCC `-O0`. Only cases with meaningful assertions passing both compilers
were activated; no non-ICE compiler or runtime bugs were investigated.

| Test | KCC | GCC -O0 | Decision |
| --- | --- | --- | --- |
| `960512-1.c` | Compile rejection | PASS | Deferred: GNU complex values |
| `960608-1.c` | Compile rejection | PASS | Deferred: unsigned-char bitfields |
| `980505-1.c` | PASS | PASS | Active unchanged: `const`-attributed function results; optimizer behavior not verified |
| `980526-1.c` | Compile rejection | PASS | Deferred: computed goto/local label |
| `990326-1.c` | PASS | PASS | Active unchanged: enabled struct comparison; other upstream branches disabled |
| `991118-1.c` | Compile rejection | Runtime fail | Deferred: wide bitfields and long-long size guard |
| `991228-1.c` | Compile rejection | Compile rejection | Deferred: designated union initialization and data layout |
| `align-1.c` | Compile rejection | PASS | Deferred: aligned typedef not actually asserted by main |

The installed test harness checked only PDP-6 and GCC `-O0`; other CPU and
optimization settings are not claimed to pass. Both activated sources have
new semantic matrix rows. No test source, compiler or libc was modified.
