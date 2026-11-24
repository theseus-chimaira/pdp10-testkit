# GCC KS10 optimized signed byte-pointer load correction v27

Date: 2026-11-24

## Historical failure and original oracle

The comprehensive `tests/semantic/runtime/runtime-byte-pointer-diff.c`
test had exactly three KS10 optimized GCC assertion failures:

- `0245` at KS10 O1: signed nine-bit `char9` load from `q`
- `0344` at KS10 O2: signed eighteen-bit `short18` load from `p`
- `0344` at KS10 Os: same eighteen-bit load

The source verifies pointer offsets, loads and stores for all
supported scalar widths, including crossing PDP-10 word boundaries.
The expected scalar values are unchanged in v27.

## Root cause and correction

The GCC backend could identify a byte pointer stored in an aligned
frame slot as though the *pointed-to byte* were an aligned scalar
slot. The resulting word/shift shortcut discarded the encoded P/S
selector. Similarly, an optimized constant native `POINT 18` load
could use the left-half instruction despite the byte pointer
selecting the right half.

`gcc-pdp10` now limits the scalar-local shortcut to accesses with
appropriate object evidence, refuses to classify `MEM(MEM(...))`
pointer indirection as a scalar slot, and decodes native `POINT 18`
position before selecting HL/HR. Exact `POINT 16` loads continue
using precise LDB semantics.

## Independent acceptance

After rebuilding and installing GCC in `$HOME/cross`, the full
`runtime-byte-pointer-diff.c` matrix passed **36/36** GCC cells
under strict exit policy in
`workdir/pdp10-byteptr-ks10-v27-independent-b`.

The new C89/GNU target-type regression
`tests/semantic/regression/pdp10-ks10-byteptr-sign-half-v27.c`
repeats the original signed 9-bit and signed 18-bit pointer,
offset, load and store assertions without changing the oracle.
It passed **36/36** GCC cells under strict exit policy in
`workdir/pdp10-byteptr-ks10-v27-independent-test`.

An earlier concurrent run to a shared checkpoint directory was
not used as acceptance evidence because another process was writing
to the same directory. Both accepted runs used independent output
paths, ran all selected cells, and skipped no prior successes.

The repaired GCC `cc1` installed in `$HOME/cross` has SHA256
`b4a24517da632efb8134b81c38f1f18d4779c0ee16dc51c2ddb89814b939e151`.

Six neighboring sources, including the original packed-byvalue
fixture, its v26 permanent regression and the v18/v19/v20/v23
pointer/copy-loop regressions, were rerun independently at
`workdir/pdp10-byteptr-ks10-v27-independent-adjacent`:
**224/224 PASS** with strict exit policy, no skipped old greens.

An additional, broader ten-source independent sweep also covered
v17 unsigned division, historic wide-integer/control-flow tests,
the earlier pointer/copy-loop regressions and the v26 packed-byvalue
suite. It passed **392/392 GCC cells**, strict exit policy, with no
previous PASS results skipped. Its checkpoint is
`workdir/pdp10-byteptr-ks10-v27-regress`.
The expanded 392-cell run includes the six-source 224-cell selection,
so the latter is not double-counted. Together with the two primary
36-cell suites the final verified total is **464/464 distinct GCC
cells passing**. Other compiler/runtime failures and full-matrix
acceptance remain independent open tasks.
