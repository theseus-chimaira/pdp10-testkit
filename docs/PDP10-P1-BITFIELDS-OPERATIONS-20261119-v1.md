# PDP10 P1: signed 52/53-bit field XOR/OR and by-value records (2026-11-19 v1)

## Original source boundary

The two original GCC sources `tests/todo/generic/991118-1.c` and
`tests/todo/generic/bf64-1.c` are still deferred as
`width-or-source-adaptation`, with their bytes and source SHA256
preserved. They rely on 64-bit-style sign extension and, in one case,
an explicit `sizeof(long long)==8` guard. The PDP-10 GNU toolchain
uses a 71-bit `long long` with signed 52/53-bit bitfields, so the old
64-bit masks do not establish the actual required field value.

## Executable companion and independent oracle

`tests/semantic/regression/pdp10-signed-bitfields-operations-v1.c`
implements the original XOR/OR operations over both field/pad orders,
using return-by-value structs and checking preserved 11/12-bit pads.
The nonzero operation masks come through volatile `signed long long`
variables and every result has a numbered abort checkpoint.

Three independent host-integer reference computations are checked:

| Width and operation | Input | Expected signed result |
| --- | --- | ---: |
| 52-bit XOR | `0x123456789ABCD` XOR `0x0008765412345678` | -1876791358784075 |
| 53-bit XOR | `0x1FFFF00000000` XOR `0x0018765412345678` | -1818956999141768 |
| 52-bit OR | `0xFFF000FFF000F` OR `0x0008765412345678` | -738197547393 |

The independent reference applies the bitwise operation with arbitrary
precision, masks to exactly the field's declared 52/53-bit width, and
then subtracts `2**width` when the field's sign bit is set. This is
not derived from an observed compiler output or the original 64-bit
constant. The test includes both field orders and six pad/value
assertion sites.

The ordinary compiler matrix registers all four PDP-6 native GCC
optimization profiles. **GCC O0/O1/O2/Os all reproduce a runtime
failure at checkpoint 1**, not a compiler-ICE or a simulated timeout.
KCC rejects GNU signed long-long bitfields at compile time, so this
fixture explicitly marks KCC PDP-6 as unsupported rather than
installing a fake runtime or accepting compilation failure as a
semantic success.

Execution evidence and source checksums are retained in
`PDP10-P1-BITFIELDS-OPERATIONS-RESULTS-20261119-v1.tsv` and
`refs/pdp10-p1-bitfields-operations-20261119-v1.tar.gz`.
The registered `tools/verify-p1-bitfields-operations-v1.py` verifies
all recorded source hashes, reference calculations, source assertions,
profile selection, run logs, and the original deferred classifications.

## Remaining P1

The original tests remain deferred. A passing companion or corrected
field arithmetic alone does not establish all original 64-bit-to-71-bit
ABI contracts, signed-field layout rules or record-return semantics on
non-PDP6 CPUs. GCC compiler failures must be repaired **after** P1
testkit construction, not as part of oracle construction.
