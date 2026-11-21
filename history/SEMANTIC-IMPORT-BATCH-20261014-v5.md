# Upstream semantic import: fifth batch of eight (2026-10-14, v5)

The next eight candidate rows were compiled and executed under PDP-6 KCC
with the bare-metal `__test_exit=0` contract. All eight passed; no compiler
sources were modified.

| Source | Assertion/behavior tested | Classification |
| --- | --- | --- |
| `20000706-4.c` | Address of an integer argument across a call | active |
| `20000706-5.c` | Address of a by-value structure argument | active |
| `20000707-1.c` | Structure argument fields across nested calls | active |
| `20000715-1.c` | Six conditional-expression/post-increment tests | active |
| `20000715-2.c` | Unsigned-character wraparound | active |
| `20000717-1.c` | Structure arguments across nested calls; discarded nonvoid function return | active |
| `20000717-2.c` | Long-long comparison with 4294967297LL and 8589934591LL | active |
| `20000717-3.c` | Indirect integer write and signed arithmetic | active |

The distinct PDP-10-specific tests sharing `20000707-1` and `20000717-1`
basenames were not included in this batch. Matrix activation schedules
additional profiles; only PDP-6 KCC execution was verified.
