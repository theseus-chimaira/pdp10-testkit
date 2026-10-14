# Width classification: fourth eight-test batch (2026-10-14, v7)

Eight consecutive remaining `review-width` cases were assessed unchanged
on PDP-6 using installed KCC and GCC `-O0`. No compiler bugs beyond ICEs
were investigated, and no source was modified in this batch.

| Test | KCC PDP-6 | GCC PDP-6 -O0 | Decision |
| --- | --- | --- | --- |
| `960402-1.c` | PASS | PASS | Active: signed multiword comparisons with fixed threshold values |
| `961017-2.c` | Runtime fail | Runtime fail | Deferred: 36-bit unsigned wraparound loop and limit |
| `961122-1.c` | Runtime fail | Runtime fail | Deferred: fixed bit-pattern wide-integer accumulation |
| `961206-1.c` | Runtime fail | PASS | Deferred: unsigned wide-integer comparisons |
| `970217-1.c` | Runtime fail | PASS | Deferred: VLA parameter post-increment |
| `980526-2.c` | Runtime fail | Runtime fail | Deferred: Linux-style device encoding and pointer arithmetic |
| `990106-2.c` | Runtime fail | Runtime fail | Deferred: existing PDP-10 modular arithmetic expectation |
| `990127-2.c` | Runtime fail | PASS | Deferred: floating expression comparison |

The `960402-1.c` comparisons use intentional 32-bit thresholds that remain
valid values within the PDP-10's wider signed integer representation; there
is no need to change the bit patterns. Its new compiler-matrix row does not
claim unexecuted CPU/optimization combinations have passed. All remaining
failures are preserved for later phases under the classification-only policy.
