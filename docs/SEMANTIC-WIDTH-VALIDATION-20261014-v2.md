# PDP-10 integer-width semantic validation — 2026-10-14

The 35 flagged width-sensitive sources were first attempted with PDP-6 KCC
unoptimized. The first run was invalidated by an incomplete toolchain prefix;
a retry with a complete prefix produced 11 compiler rejections and 24 link
failures because legacy tests call `exit`/`abort` and do not define
`__test_exit`. **These are not counted as semantic failures or passes.**

Two useful checks were adapted to report results through the existing
bare-metal `main` return-code and `__test_exit` convention, preserving their
integer tests. Both passed PDP-6 KCC unoptimized and optimized, and GCC O0:

- `generic/920711-1.c`: positive decrement/comparison of `0x80000000L`,
  which lies within positive 36-bit `long` range.
- `wide-int/20011126-1.c`: 32-bit threshold constants used intentionally
  as ordinary values in a multiword signed-conversion test.

Both are active matrix rows for KCC/GCC. Other CPU/optimization combinations
are scheduled but **not yet executed**.

Four tests were deleted as intrinsically tied to 64-bit storage or 32-bit
halves: `wide-int/20000314-2.c`, `wide-int/20000402-1.c`,
`wide-int/longlong.c`, and `wide-int/920501-9.c`. The first two are
conditional on a host storage width and can silently succeed without testing
anything on PDP-10; `longlong.c` tests an Alpha bit-extraction idiom gated by
`sizeof(uint64)==8`; `920501-9.c` constructs hexadecimal output from fixed
32-bit halves of a 64-bit integer.

The remaining **29** flagged sources stay classified for individual code
adaptation and execution, not active matrix entries. Source-level fixed-width
constants alone are not sufficient reason to delete them. The PDP-10-specific
`pdp10/990106-2.c` has a deliberately different expected result but currently
fails under the installed PDP-6 KCC test environment, so it remains inactive
pending investigation. There was no blanket rewrite of 32 to 36 or 64 to 72.
