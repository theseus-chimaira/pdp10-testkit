# Upstream semantic import: next eight candidates (2026-10-14, v2)

Eight consecutive `candidate` rows following the first reviewed batch were
compiled using KCC targeting PDP-6. Compilable sources were run unmodified
through the bare-metal termination contract (`__test_exit=0`). Neither KCC
nor GCC was modified. The two unresolved originals are in `tests/todo/generic`.

| Source | Observed PDP-6 KCC result | Classification |
| --- | --- | --- |
| `20000314-3.c` | Compile error: returning a void-valued expression in a void function; C99 permits this | deferred; compiler language support |
| `20000403-1.c` | Runtime PASS, but `sizeof(long) * 8 - 1` is beyond PDP-10 `long` width, making the shift undefined | review-width; result not trustworthy |
| `20000412-1.c` | PASS; array address calculation assertion | active |
| `20000412-2.c` | PASS; recursive argument/local lifetime assertion | active |
| `20000412-3.c` | PASS; structure passing by value and byte fields | active |
| `20000412-4.c` | PASS; bounds condition in nested loop | active |
| `20000412-5.c` | PASS; local aggregate initialization assertion | active |
| `20000412-6.c` | PASS; unsigned-short array pointer arithmetic | active |

Six active tests have compiler matrix rows mirroring the other generic
semantic tests. Their successful execution was checked only under PDP-6 KCC;
other target/compiler/optimization cells are scheduled but unverified.
No compiler defects were addressed while classifying these sources.
