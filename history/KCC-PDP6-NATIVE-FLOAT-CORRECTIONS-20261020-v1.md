# KCC PDP-6 signed DImode and native single float (2026-10-20, v1)

## Distinct arithmetic representations

Signed PDP-10 DImode is 71 bits (high36:low35 with duplicated low-word
sign in memory). The portable C software D-format float is two words and
is implemented by integer-only PDP-6 assembler routines. The PDP-6 also
has *native 36-bit single-precision floating-point hardware*; it does
not implement later PDP-10 `FLTR`, `FIX` or D-format instructions directly.

## Compiler repairs

KCC previously compiled `(float) long_long_value` by treating the high36
half as a standalone integer, then invoking the simulated one-word `FLTR`
sequence. `10LL`, stored as high=0 and low=10, silently became `0.0F`.
The reverse `float` to signed 71-bit cast also ignored the full-width
representation. The fixed PDP-6 paths in `ccgen2.c` first convert the
complete DImode pair to the established software D-format, then narrow
and round to a single 36-bit float. The reverse widens a single to the
two-word D-format and calls the validated signed DImode conversion.

The PDP-6 double-to-single expansion in `ccout.c` also rounded halfway
cases upward rather than ties to even. It now uses the correct two-word
sign/borrow negation, then checks guard bit, sticky bits and retained
fraction parity before rounding; carry renormalization is handled.
This correction applies to `-x=pdp6` only.

Separately, KCC's host lexer and literal emitter cast `F`-suffixed
values through IEEE binary32. That format has only 24 significant bits,
whereas a PDP-10 single has 27; `134217732.0F` was emitted as
`134217728.0F`. `cclex.c` and `ccstmt.c` now retain the parsed host
double. The host side of `ccout.c` encodes the 27-bit target fraction
directly, with round-to-nearest-even, from the 53-bit host binary64
significand. Unary negation in `cceval.c` no longer introduces an early
host binary32 cast. No extra target runtime module is needed.

## Independent execution acceptance

The new bare-metal regressions in `pdp10-testkit` are:

- `tests/semantic/kcc-pdp6-dimode-nativefloat-v1.c`: 21 signed 71-bit
  integer/single-float conversions, including negative values, powers
  of two, ties to even and fractional rounding boundaries
- `tests/semantic/kcc-pdp6-float-literal-v1.c`: nine independently
  calculated target floating-point literal bit patterns, including the
  formerly miscompiled `134217732.0F` and its negative

Each passes on SIMH PDP-6 with both installed optimized and `-n` KCC.
The existing software D-format, original upstream `930622-2.c`,
negative double and signed DImode load tests also pass unchanged.
The independent AAP PDP-6 emulator executes the same new regressions
under both optimization modes, using real linked images and the
fail-closed guest exit sentinel; the immediate-HALT negative control
remains rejected. No deleted emulator debugging instrumentation was
restored.

The tests exercise PDP-6-native semantics only. KA10/KI10/KS10/KL10
floating conversions require their own execution evidence and have not
been activated by this change. KCC's other constant folding operations
on `TS_FLOAT` still contain host binary32 casts; correct target-precision
arithmetic folding remains a separate **open compiler task**.
