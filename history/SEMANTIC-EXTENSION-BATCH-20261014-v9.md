# Extension suitability classification: ninth bundle (2026-10-14, v9)

Eight manifest-ordered extension cases were tried under KCC and GCC `-O0`
on PDP-6. No compiler, libc or test sources were changed.

| Test | Feature family | KCC | GCC -O0 | Decision |
| --- | --- | --- | --- | --- |
| `cbrt.c` | IEEE 32-bit layout / `mode(SI)` | Compile failure | Runtime failure | Deferred; core algorithm explicitly excluded on PDP-10 |
| `comp-goto-1.c` | Computed goto and width-sensitive simulator layout | Compile failure | Compile failure | Deferred |
| `comp-goto-2.c` | Computed goto, nested functions, local labels | Compile failure | PASS | Deferred |
| `complex-1.c` | Complex double and `__real__`/`__imag__` | Compile failure | PASS | Deferred |
| `complex-2.c` | Complex double arithmetic and ABI | Compile failure | Runtime failure | Deferred |
| `complex-4.c` | Complex signed-zero comparison | Compile failure | PASS | Deferred |
| `complex-5.c` | Complex float arithmetic | Compile failure | PASS | Deferred |
| `compndlit-1.c` | GNU compound literal, designators and statement expression | Compile failure | PASS | Deferred |

The `cbrt.c` source wraps its algorithm in `!defined(__pdp10__)`; enabling
the PDP-10 fallback would only test an unconditional exit. The other cases
primarily exercise GNU language semantics KCC currently rejects.

The manifest intentionally leaves the three separate `pdp10/` copies of
`comp-goto-1.c`, `complex-1.c`, and `complex-2.c` under review: they were
not part of this eight-source bundle. No test was activated or registered
in the compiler matrix, and no non-ICE failures were investigated.
