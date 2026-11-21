# Upstream semantic import: third batch of eight (2026-10-14, v3)

Eight consecutive candidates were inspected and compiled with PDP-6 KCC;
compilable sources were executed with `__test_exit=0`. No compiler fixes.

| Source | Observed result | Classification |
| --- | --- | --- |
| `20000419-1.c` | PASS; struct argument and branch assertion | active |
| `20000422-1.c` | PASS; sorting assertion | active |
| `20000503-1.c` | PASS; unsigned arithmetic boundary | active |
| `20000511-1.c` | PASS; precedence and compound assignment | active |
| `20000519-1.c` | Missing installed `stdarg.h`; KCC self header triggers `include_next` preprocessor ICE | deferred in `tests/todo/generic/` |
| `20000519-2.c` | PASS; signed comparison | active |
| `20000523-1.c` | Real KCC division runtime linked; test exits before assertions because `sizeof(long long) < 64` | removed (vacuous) |
| `20000528-1.c` | PASS; integer narrowing | active |

Only the generic `20000528-1.c` was tested; the distinct PDP-10-specific
source with the same basename remains a candidate. Six generic tests now
have matrix entries. Other profiles remain unverified. No compiler changes.
