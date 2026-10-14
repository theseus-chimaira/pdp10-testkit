# Width classification: fifth eight-test batch (2026-10-14, v8)

Eight consecutive `review-width` entries were inspected and attempted on
PDP-6 using installed KCC and GCC `-O0`. No source changes or compiler
debugging were made. A non-ICE failure remains deferred regardless of its
possible value as a regression.

| Test | KCC PDP-6 | GCC PDP-6 -O0 | Decision |
| --- | --- | --- | --- |
| `990324-1.c` | Runtime fail | Runtime fail | Deferred: existing PDP-10 signed-char cast expectation |
| `990525-1.c` | Runtime fail | PASS | Deferred: structure-array assignment and loop semantics |
| `991014-1.c` | Runtime fail | PASS | Deferred: GNU `typeof`, huge target-width-dependent arrays |
| `991030-1.c` | Runtime fail | PASS | Deferred: hexadecimal floating constant |
| `991221-1.c` | PASS | PASS | Active unchanged: long-size guard and comparisons |
| `arith-rand.c` | Runtime fail | Runtime fail | Deferred: 8-bit assumption in random bitstring generator; nontrivial execution issue |
| `ashldi-1.c` | Compile rejection | PASS | Deferred: existing 71/72-bit left-shift tables |
| `ashrdi-1.c` | Compile rejection | PASS | Deferred: existing 71/72-bit right-shift tables |

The last two tests already contain dedicated PDP-10 long-long tables and
therefore should not be deleted merely for their large constants.
`991221-1.c` exercises its condition because 36-bit `long` occupies four
9-bit bytes. Its fixed 32-bit values are valid on PDP-10 without rewriting.
Only that verified passing source was registered in the compiler matrix.
All other CPU and optimization profiles remain unverified.
