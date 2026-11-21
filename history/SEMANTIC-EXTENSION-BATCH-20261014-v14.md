# Extension suitability classification: fourteenth bundle (2026-10-14, v14)

Eight manifest-ordered `review-extension` cases were tested on PDP-6 with
installed KCC and GCC `-O0`. No compiler, libc or test source changes were
made. Activation requires a meaningful test passing both compilers.

| Test | KCC PDP-6 | GCC -O0 PDP-6 | Decision |
| --- | --- | --- | --- |
| `stdio-opt-3.c` | Compile failure | Compile failure | Deferred: hosted `fprintf` and optimizer built-ins |
| `strct-pack-1.c` | PASS | Runtime failure | Deferred: packed/aligned short and double |
| `strct-pack-2.c` | PASS | PASS | Deferred: pointer assignment without readback, no substantive assertion |
| `strct-pack-3.c` | PASS | Runtime failure | Deferred: packed/aligned int array indexing |
| `strct-pack-4.c` | PASS | PASS | **Active unchanged:** packed char and short field readback |
| `string-opt-1.c` | Link failure: `strstr` | Link failure: `strstr` | Deferred: string libc linkage/built-in optimization |
| `string-opt-10.c` | Compile failure | Link failure: `strcpy` | Deferred: `strncat` optimization and string libc linkage |
| `string-opt-11.c` | Compile failure | Link failure: `strspn` | Deferred: `strspn` optimization and string libc linkage |

The activated `strct-pack-4.c` verifies both stored field values; unlike
`strct-pack-2.c`, its passing run is not vacuous. `strct-pack-4.c` is now
registered in the semantic compiler matrix. The minimal `p10run` link does
not automatically supply all shared assembler libc routines; unresolved
library references remain separate from compiler language support and may
require later libc implementation or link integration. No optimization-mode
coverage is claimed from GCC `-O0`.
