# Extension suitability classification: second bundle (2026-10-14, v2)

Eight manifest-ordered `review-extension` tests were attempted on PDP-6
with installed KCC and GCC `-O0`. No compiler, libc, or test sources were
changed; non-ICE failures remain deferred.

| Test | KCC | GCC -O0 | Disposition |
| --- | --- | --- | --- |
| `20010209-1.c` | Compile rejection | PASS | Deferred: GNU nested function and VLA argument |
| `20010518-2.c` | Link failure: `memcpy` | Link failure: `memcpy` | Deferred: packed struct and compound literals; bare-metal linking |
| `20010605-1.c` | Compile rejection | PASS | Deferred: GNU block-scope function |
| `20010605-2.c` | Compile rejection | PASS | Deferred: GNU complex numbers and argument passing |
| `20010904-1.c` | Compile rejection | Runtime fail | Deferred: `aligned(32)` assertion excluded by `__pdp10__` |
| `20010904-2.c` | Compile rejection | Runtime fail | Deferred: `aligned(32)` assertion excluded by `__pdp10__` |
| `20011024-1.c` | Compile rejection | Link failure: `memcpy` | Deferred: `pure` attribute and memory/string calls |
| `20011113-1.c` | Compile rejection | Link failure: `memcpy` | Deferred: `restrict`, aggregate ABI, and memory copy |

The installed shared assembler libc already implements `memcpy`; its
absence from these ad hoc bare-metal test links does not demonstrate a
missing library implementation. Preserve linkage as a separate follow-up.
The `20010904-*` tests bypass their alignment assertions entirely under
`__pdp10__`, so a successful exit would not establish coverage. All cases
remain unregistered until their intended behavior is genuinely exercised.
