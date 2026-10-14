# Width classification: third eight-test batch (2026-10-14, v6)

Eight consecutive remaining `review-width` cases were evaluated. The only
source change is conditional inclusion of the debugging-only `stdio.h` in
`960311-3.c`; normal execution has no hosted I/O dependency.

| Test | KCC PDP-6 | GCC PDP-6 -O0 | Decision |
| --- | --- | --- | --- |
| `950426-2.c` | Runtime fail | PASS | Deferred: signed negative shift |
| `950511-1.c` | Runtime fail | PASS | Deferred: unsigned 72-bit multiplication |
| `950605-1.c` | Runtime fail | Runtime fail | Deferred: existing 9-bit character expectation |
| `950607-2.c` | Runtime fail | PASS | Deferred: wide signed cross-product |
| `950704-1.c` | Runtime fail | Runtime fail | Deferred: already supplies 71/72-bit MSB values |
| `960116-1.c` | PASS | PASS | Active without changes; low-bit pointer test |
| `960311-3.c` | PASS | PASS after one-line conditional include | Active; fixed 32-bit patterns inside a 36-bit word |
| `960321-1.c` | Runtime fail | PASS | Deferred: long-index subtraction |

No non-ICE compiler behavior was debugged, and none of the failing tests
were altered to conceal failures. Both activated sources have semantic
matrix rows; other CPU/compiler optimization profiles remain unverified.
