# Extension suitability classification: fifth bundle (2026-10-14, v5)

Eight consecutive `review-extension` manifest entries were inspected and
attempted on PDP-6 with installed KCC and GCC `-O0`. No compiler, libc, or
source changes were made. Non-ICE failures were not investigated.

| Test | KCC | GCC -O0 | Decision |
| --- | --- | --- | --- |
| `921017-1.c` | Compile rejection | PASS | Deferred: VLA captured by GNU nested function |
| `921215-1.c` | Compile rejection | PASS | Deferred: nested trampolines/callbacks |
| `930126-1.c` | Compile rejection | PASS | Deferred: `long long` bitfields and aggregate return |
| `930406-1.c` | Compile rejection | PASS | Deferred: statement expression and local label |
| `931002-1.c` | Compile rejection | Run unconfirmed | Deferred: nested-function callbacks; no readable execution result |
| `931110-1.c` | Compile rejection | PASS | Deferred: signed `short` bitfields |
| `960117-1.c` | PASS | PASS | Deferred: packed/aligned attributes with no meaningful assertion |
| `960416-1.c` | Compile rejection | PASS | Deferred: integer-to-union cast, 32-bit-half assumptions |

`960117-1.c` exits after writing through an attributed pointer but never
validates alignment, packing, or stored contents. In addition, its `get_id`
function is declared to return a value but has no return statement. A pass
therefore cannot establish the intended extension semantics.

`960416-1.c` uses two conditional checks guarded by specific 64-bit union
representations; on PDP-10 neither is assured to execute. No tests were
registered in the active compiler matrix.
