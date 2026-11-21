# Width classification: seventh and final eight-test batch (2026-10-14, v10)

All eight remaining `review-width` entries were evaluated under the
classification-only policy. PDP-6 tests used installed KCC and GCC `-O0`,
with the bare-metal `__test_exit=0` assertion. These PDP-10-specific copies
remain distinct from related generic upstream tests; no source was changed.

| Test | KCC PDP-6 | GCC PDP-6 -O0 | Decision |
| --- | --- | --- | --- |
| `pdp10/980526-2.c` | Runtime fail | Runtime fail | Deferred; Linux device-encoding assumptions |
| `pdp10/990106-2.c` | Runtime fail | Runtime fail | Deferred; 36-bit modular arithmetic expectation |
| `pdp10/991014-1.c` | Runtime fail | PASS | Deferred; large structs, GNU `typeof` |
| `pdp10/arith-rand.c` | Runtime fail | Runtime fail | Deferred; randomized integer division and width assumption |
| `pdp10/ashldi-1.c` | Compile rejection | PASS | Deferred; already includes 71/72-bit left-shift vectors |
| `pdp10/ashrdi-1.c` | Compile rejection | PASS | Deferred; already includes 71/72-bit right-shift vectors |
| `pdp10/conversion.c` | Runtime fail | Link failure (`__fixunssfsi`) | Deferred; integer/floating conversion coverage |
| `wide-int/tstdi-1.c` | Runtime fail | Runtime fail | Deferred; already includes PDP-10 sign-boundary constants |

No compiler ICE was observed in this batch. No current compiler or test
failures were investigated or converted into passing tests. No new matrix
rows were enabled, because neither checked compiler pair passed the same
test. The 56 width-review cases have now been dispositioned over seven
eight-test batches; later investigation of `deferred` cases remains open.
