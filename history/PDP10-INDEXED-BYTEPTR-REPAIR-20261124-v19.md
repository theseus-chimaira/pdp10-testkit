# GCC indexed byte-pointer lowering repair v19

Date: 2026-11-24

## Reproducer

The GCC O1 `runtime-byte-pointer-diff.c` case `0250` failed on eight
profiles. A separate reduction with a volatile integer index and
`char9 *p = &arr[3]; p += index; p - &arr[3]` reproduced the failure
at O1/O2. The old assembly used `MOVEI` on a `POINT 9` constant with
an index register. MOVEI writes only an 18-bit effective address,
losing the P/S selector of the full 36-bit byte pointer.

## Compiler correction

`gcc-pdp10/gcc/config/pdp10/pdp10.c`, `pdp10.md` and
`pdp10-protos.h` now recognize symbolic word36 byte-pointer constants
in the indexed `*addsi3` alternative. They emit a two-instruction
sequence: MOVEI to compute the 18-bit word address with index,
followed by HRLI to install the pointer's upper selector half.
The instruction-length attribute is two only for this variant.
No scratch register is needed, and this form works if the destination
and index share an AC. Other word addresses retain a one-word MOVEI.

## Tests

The reduced `char9` pointer difference program passes all 16 manual
CPU x optimization checks against the staged GCC compiler.

The new permanent C89 test
`tests/semantic/regression/pdp10-indexed-byte-pointer-v19.c`
checks 9-bit and signed 6-bit array pointer construction, element
differences, and readback with a volatile index. It was registered
for 36 GCC matrix profiles and passed **36/36** in the isolated
`workdir/pdp10-indexed-byteptr-v19-isolated` directory with strict
exit policy. No PASS cells were skipped on that first run.

The original comprehensive `runtime-byte-pointer-diff.c` source
was also rerun on its nine GCC O1 profiles in this isolated directory.
Results: **0 PASS, 1 run_fail, 8 timeout**. Previously eight of those
profiles failed promptly at case `0250`; the corrected pointer
now allows execution past that early assertion, exposing later
timeout behavior. That is *not* a full regression pass or an
explanation of the remaining optimized failures. The KS10 O1
runtime failure remains distinct.

The source-linked compiler build and regression log are under
`$HOME/tmp/pdp10-byteptr-o1-v19` on the development host. Other
testkit failures are not reset or counted as green by this repair.

To check for regressions against the prior fixes, the isolated runner
re-executed all **180/180** cells of the v18 short16 regression and
the four v17 unsigned division/remainder regressions. Every cell
passed under strict exit policy; none was skipped as an old PASS.
