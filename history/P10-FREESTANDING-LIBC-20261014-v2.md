# Freestanding PDP-10 C library and packed-byte extension (2026-10-14, v2)

## Scope and ownership

Both KCC and GCC install matching, OS-independent PDP-6-compatible
`libp10c-v2.a` archives. The code has no DAIMOS system calls, filesystem
dependencies, heap, or writable library-global state. It is deliberately
**separate** from compiler-generated arithmetic helpers (`libgcc`, KCC RT)
and from the operating system's hosted libc.

The 9-bit C-byte API supplies `memcpy`, `memmove`, `memset`, `memcmp`,
`strlen`, `strcmp`, `strncmp`, and the remaining useful pure string routines.
The existing DAIMOS `memcpy`/`memmove` assembly provided the initial
word-oriented correctness baseline. KCC's own code generator still builds
some less frequent string primitives from their C implementation.

## Explicit native byte-pointer extension

`p10bytes-v2.h` declares three functions operating on raw, one-word PDP-10
byte-pointer descriptors rather than on `char *`:

- `p10bcopy_v2(dst, src, elements)` returns the destination pointer;
  source and destination ranges must not overlap.
- `p10bfill_v2(dst, value, elements)` returns the destination pointer.
- `p10bcmp_v2(a, b, elements)` returns -1/0/+1 using **unsigned** byte values.

Each call uses the common three-register C ABI (AC1–AC3); only call-clobbered
registers are modified. The caller supplies valid memory bounds and pointer
encodings. Conversion from a C pointer to the raw descriptor is a documented
target-specific operation, not an ISO C pointer conversion guarantee.

The PDP-10 hardware supports 1–36-bit byte-pointer sizes. `LDB`, `DPB`,
and `IBP` handle the general paths. A common `MOVE`/`MOVEM` loop handles
6-, 9-, 18-, and 36-bit pointers **only at matching canonical word starts**
with enough bytes remaining; otherwise it uses the byte path. The fill
path builds repeated values for each supported whole-word width. The
comparison path checks whole words but determines the first mismatching
element byte-by-byte, including correct unsigned 36-bit ordering.

The normal C `char` layout remains unchanged (9-bit). In particular,
`char6 *` and `char *` are not interchangeable interfaces.

## Validation in the PDP-6 test harness

- `tests/semantic/kcc-libc-freestanding-v1.c`: PASS under KCC and GCC.
- `tests/semantic/kcc-libc-memcmp-words-v2.c`: PASS under KCC and GCC;
  lengths 0–32, all four starting-byte offsets, each mismatch position.
- `tests/semantic/p10bytes-api-c-v2.c`: PASS under KCC and GCC, using the
  raw-descriptor ABI with 9-bit C arrays.
- `misc/compat/test-p10byte-widths-v2.sh`: PASS with native PDP-6 assembly;
  6/7/8/9/18/36-bit pointers, aligned copies/fills, byte fallback, and
  unsigned 36-bit comparisons.
- KCC and GCC produce **identical** `libp10c-v2.a` archives when built from
  the current matching source files and object order.

The tests used versioned staging directories, the installed PDP-6 simulator,
and explicit freestanding library paths. The operating-system installation
and other CPU/compiler optimization profiles have not been updated or swept.

## Remaining work

- Measure peak memory/code size and execution counts against byte loops;
  correctness is established, but speed advantages have not been measured.
- Expand corner-case coverage for differing pointer widths, tails,
  unaligned destinations, and byte sizes beyond those tested.
- Investigate remaining libc-dependent test failures, particularly hosted
  I/O, allocation and variadic functions; do not fake these with stubs.
- Verify installed archive extraction with normal production link scripts;
  `p10run` currently consumes assembly sources directly, not `.a` inputs.
