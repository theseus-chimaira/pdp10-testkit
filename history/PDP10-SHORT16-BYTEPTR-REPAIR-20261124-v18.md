# PDP-10 short16 pointer and byte-pointer runtime repair v18

Date: 2026-11-24

## Scope

This is a bounded GCC runtime repair, not a full byte-pointer or
full-sweep acceptance. Validation used the independent directory
`workdir/pdp10-short16-byteptr-v18-isolated` because another runner
was writing concurrently to `workdir/full-sweep-current`.

## Signed six-bit oracle versus unsigned SIXBIT

The original `runtime-byte-pointer-diff.c` failed GCC at octal ID
`0103`, expecting -31 after loading `char6`. GCC's built-in `char6`
is unsigned SIXBIT; KCC's `char6` is signed. The signed test now uses
the explicit signed six-bit `int6` alias, with all existing signed
expectations intact. A new GCC-only `char6` test checks the unsigned
values 33 and 57 for original inputs -31 and -7. No compiler or
test expectation was weakened to hide the mismatch.

## Confirmed GCC bugs and repairs

The next failure, ID `0310`, exposed double scaling of dynamic
`short16` pointer arithmetic. A short16 occupies two nine-bit C
storage units but one hardware 16-bit byte-pointer element. GCC's
generic expression expander already multiplied a dynamic index by two;
the PDP-10 pointer adjuster mistakenly treated that scaled RTL as
an element index. The backend now recognizes the original generic
multiply-by-two expression, and shifts the already-evaluated RTL back
into element units. Side-effectful input expressions are not
reevaluated. Packed-field indexing with unscaled element indices
continues through the existing path.

The early constant symbolic pointer fold also bypassed scaling
normalization; `&a[3]` could encode the incorrect 16-bit byte-pointer
position. This fold now applies the same short16 two-unit correction
before calculating the constant pointer.

Optimized signed dereferences from constant `POINT 16` addresses
could use `HLRZ` (18-bit extraction) followed by 16-bit sign
extension. For example, -32767 was read back as 4. The backend now
uses a precise `LDB` through the encoded native 16-bit pointer.

Finally, the native S=16 branch of dynamic adjustment could allocate
a fresh result register when TARGET overlapped the original pointer,
but the caller ignored that returned register. Optimized KS10
reverse adjustment therefore left the pointer unchanged. Both
native S=16 and logical S=1 paths now use a non-overlapping chosen
target register.

All compiler changes are in
`gcc-pdp10/gcc/config/pdp10/pdp10.c`.

## Verified results

The new permanent C89 test
`tests/semantic/regression/pdp10-short16-pointer-scaling-v18.c`
checks dynamic addition/subtraction, `&array[index]` constant
address construction, exact signed 16-bit reads, and return register
identity. Its registered GCC matrix has 36 cells. The isolated
official runner completed **36/36 PASS** with `--exit-policy strict`.

The original `tests/semantic/runtime/runtime-byte-pointer-diff.c`
in the same isolated output directory:

| Profile selection | PASS | run_fail | timeout |
| --- | ---: | ---: | ---: |
| All GCC O0 | 9 | 0 | 0 |
| GCC O1/O2/Os | 0 | 11 | 16 |
| **Total** | **9** | **11** | **16** |

The remaining 27 optimized failures have not been reclassified as
success. The isolated timeout checks are real recorded timeouts, not
accepted executions. This source covers substantially more than
short16 pointer arithmetic; the separate optimized byte-pointer
failures must be investigated independently.

As a regression check on the previously repaired unsigned 36-bit
division/modulo backend, the same isolated runner reran all **144/144**
GCC cells from four existing quotient, remainder, combined div/mod,
and constant-divisor sources. Every cell passed under strict exit
policy; no old PASS checkpoint was skipped.

The installed GCC was rebuilt from the corrected source using its
normal out-of-tree build and `$HOME/cross` installation prefix.
Build logs and an executable backup are under
`$HOME/tmp/pdp10-byteptr-signed-v18/` on the development host.

## Next investigation

Reduce the optimized byte-pointer first-failure signatures, including
the O1 unsigned/signed 9-bit cases and the O2/Os timeouts, without
changing these assertions or allowing a timeout to pass. Compare
native GCC and PDP-10 family code generation and distinguish a
semantic bad-pointer result from an unbounded loop.
