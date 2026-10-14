# Width classification: second eight-test batch (2026-10-14, v5)

Eight consecutive `review-width` manifest entries were classified using
the minimal-adaptation-only policy. PDP-6 KCC and GCC `-O0` were exercised
where indicated, with genuine `__test_exit=0` assertions. No compiler source
was modified, and no non-ICE compiler behavior was investigated.

| Test | PDP-6 KCC | PDP-6 GCC -O0 | Classification |
| --- | --- | --- | --- |
| `920411-1.c` | Runtime fail | PASS | Deferred: long-object byte reconstruction; investigate later |
| `920603-1.c` | Runtime fail | Runtime fail | Deferred: already contains PDP-10 signed-char expectation |
| `920710-1.c` | Runtime fail | PASS | Deferred: floating conversion/rounding behavior |
| `920908-2.c` | Runtime fail | Runtime fail | Deferred: already contains PDP-10 bitfield/char expectation |
| `920922-1.c` | PASS | PASS | Active, unchanged: fixed bit-pattern shift and pointer arithmetic |
| `921029-1.c` | Runtime fail | PASS | Deferred: fixed 32-bit halves remain a meaningful bit-pattern exercise |
| `921202-2.c` | Link fail (`main` unresolved) | Link fail (`main` unresolved) | Deferred: byte extraction expression is meaningful; execution blocked |
| `930921-1.c` | Not run | Not run | Deferred: 32-bit reciprocal division algorithm needs nontrivial 36-bit redesign |

The 32-bit constants in `920922-1.c` are intentional fixed bit patterns,
not a requirement that `unsigned long` be 32 bits. Its existing assertion
passes on both checked PDP-6 compiler paths. All other CPU/optimization
profiles are pending verification; the new matrix row does not claim those
cells have passed.

Seven deferred cases retain their original source and recorded failure or
portability reason. A failed test is not treated as unsuitable merely because
a current compiler disagrees. No failure was hidden with a success stub.
