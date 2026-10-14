# Extension suitability classification: eleventh bundle (2026-10-14, v11)

Eight manifest-ordered extension-review cases were tested under KCC and
GCC `-O0` on PDP-6. KCC feature decisions follow the explicit support-policy
document. No test sources, compilers or libraries were changed.

| Test | KCC | GCC | Disposition |
| --- | --- | --- | --- |
| `packed-1.c` | PASS | PASS | **Active:** packed short field readback verified |
| `packed-2.c` | PASS | PASS | Deferred: assignment only, no readback assertion |
| `pdp10/920302-1.c` | Compile failure | Link failure: `strcmp` | Deferred: computed goto planned; separate libc linking |
| `pdp10/920415-1.c` | Compile failure | PASS | Deferred: local labels and nested functions intentionally unsupported |
| `pdp10/920721-4.c` | Compile failure | PASS | Deferred: local labels and nested functions intentionally unsupported |
| `pdp10/bcp-1.c` | Compile failure | PASS | Deferred: `__builtin_constant_p` undecided; -O0 misses optimizer cases |
| `pdp10/bf-layout-1.c` | Compile failure | PASS | Deferred: nonstandard long bitfields under consideration |
| `pdp10/bf-pack-1.c` | Compile failure | Runtime failure | Deferred: packed nonstandard long bitfield under consideration |

These `pdp10/` copies are distinct manifest entries from earlier upstream
sources and have therefore been reviewed separately. Shared assembler libc
does not automatically supply ordinary library functions to the minimal
`p10run` link unless those objects are linked. No unsupported KCC feature
was reimplemented or tested via a disabled fallback branch.

Only `packed-1.c` gained an active semantic compiler-matrix entry.
