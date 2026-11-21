# P1 conversion.c: native PDP-6 unchanged original fully covered (v1)

Date: 2026-11-21. The unchanged historical GNU source
`tests/semantic/upstream/pdp10/pdp10/conversion.c` has SHA256
`2736912e40e1dabd84f7f193ddaaf5ddf9bf00e76edb0cca0611b3f49e5c1beb`.
**All six native PDP-6 KCC/GCC compiler profiles PASS the original**,
with every original assertion intact. This closes P1 Batch 4, slot 4
at the original-source construction level. It does not authorize the
full CPU/compiler/optimization sweep or imply untested CPU PASS.

## Owning compiler/runtime fixes

KCC commit `bea2680` already corrected the 36-bit signed conversion
and optimized target-width constant folding and installed a true
signed D-format runtime archive. The unchanged original passed KCC
noopt/opt, but GCC's GNU-only signed and unsigned `long long`
conversion operations genuinely failed linking and later failed
executing. All earlier results remain immutable in the old KCC and
36-bit conversion evidence archives; they were not relabeled PASS.

GCC commit `bca60ef` provides real native PDP-6 libgcc1 DOBJ
members for these six public 71-bit helper entry points:

* `__fixunssfdi` / `__fixsfdi`: unsigned and signed SF to DImode;
* `__fixunsdfdi` / `__fixdfdi`: unsigned and signed D-format double
  to DImode;
* `__floatdidf` / `__floatdisf`: signed 71-bit DImode integer
  to D-format double and directly to single precision.

The DImode ABI uses AC1 as a 36-bit high word and AC2 for 35
low payload bits, with AC2 bit 35 copying the sign of AC1. The
float input/output ABI is AC1 (single) or AC1:AC2 (double). In
the fixed helper code, input magnitudes and sign carry propagate
correctly across both words. Negative fractional-to-integer casts
truncate to canonical integer zero. The integer-to-SF path rounds
directly from all 71 bits with guard and sticky, nearest/ties-even,
avoiding double rounding from a D-format intermediate. The direct
DF-to-71-bit fix helpers avoid the generic hosted floating division
and subtraction that previously stalled the full native guest.

All six are independently selectable DOBJ archive members in
`gcc/config/pdp10/libgcc1.s` and are registered in the bare target
`gcc/config/pdp10/t-none`. They use the PDP-6 ISA and bounded stack
scratch; there is no test-local substitute, heap, hosted C runtime
or new OS dependency. The older compiled libgcc archive was preserved
in full and unchanged old DOBJ members were reused in the final
archive.

## Exact native PDP-6 verification

| Source | KCC noopt/opt | GCC O0/O1/O2/Os |
| --- | --- | --- |
| **Unchanged upstream `conversion.c`** | 2 PASS | 4 PASS |
| Original-source assertion-line diagnostic | 2 PASS | 4 PASS |
| C89 direct signed 71-bit -> SF/DF libgcc ABI | Not applicable | 4 PASS |
| Original GNU 71-bit integer -> SF/DF section | Not applicable | 4 PASS |
| Original GNU 71-bit SF/DF -> integer section | Not applicable | 4 PASS |

The 24 source/profile outcomes are genuine PDP-6 simulator guests,
with `result=PASS`, `rc=0`, a SIMH HALT, and `__test_exit=0`.
The asserting companion and two original GNU-only section wrappers
also have `fail_id=0`. The wrappers include unchanged original
assertions, do not replace original functions, and do not supply
fake runtime operations. The normal six-profile `conversion.c`
guest is the authoritative full original-source acceptance.

The independent C89 direct-ABI test passes the actual public
`__floatdisf` and `__floatdidf` routines as a raw 36+35-bit ABI
interface. It covers full signed extrema and zero, plus a
precision discriminator near 2^69: an exact half-ULP at SF
precision rounds to even, while adding the lowest integer bit
sets sticky and forces a round upward. Both input values have the
correct, same target D-format result. This avoids claiming that
source constant folding by itself tested the runtime helper.

Additionally, the eight earlier C89 36-bit conversion oracle
sources were rerun against the final installed libgcc and KCC
compilers, with **48 more native PASS** across the six profiles.
The historical GCC missing `__fixunssfdi` / `__fixsfdi` links,
71-bit assertion `run_fail` and native timeouts remain separate
historical evidence, not current failures.

## Binary/source provenance

Installed GCC `cc1` stayed byte-identical, SHA256:
`67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7`.

Pre-repair original installed libgcc SHA256:
`afd520fbbff5db32466d887e49136f09ee2c4517b63eded83325cd721505f960`.

Final compiler-owned GCC libgcc SHA256:
`f9b1720d59df7b0e8868e27a0aa036a222472a820d7080a3e008f61b0b4bed6c`.

Installed KCC compiler remains SHA256:
`49d749e3670e0b3e9abf13e4cb6eb0bc6b9c3dbc39fe43379ed504f9e34fb952`.

The versioned manifest
`PDP10-P1-CONVERSION-FULL-EVIDENCE-20261121-v1.tsv` records
24 full source/profile identity, runtime core library and raw
artifact SHA256 sets. The deterministic archive
`refs/p10tk-p1-conversion-full-20261121-v1.tar.gz` contains
**129** complete raw artifacts: guest logs, statuses, assembly,
linker maps and simulator reports, old/fixed complete libgcc
archives, the installed `cc1`, and all six actual GCC conversion
DOBJ members. Archive SHA256:
`69e6201f2e0c901bd67d892945b623205f907ccc44e2b7348959aef51d5f4c1c`.

`tools/build-p1-conversion-full-v1.py` authenticates this evidence,
including unchanged original source, independent raw-ABI assertions,
real native SIMH guest exits, correct compiler/stdlib isolation,
actual linker-map symbols, target compiler and runtime archive
identities, every raw SHA256, and the separately authenticated
pre-repair archive. `tools/test-p1-conversion-full-v1.py` adds
17 negative mutation controls. The old KCC checkpoint continues
to authenticate the genuine original GCC pre-provider link failures.

## P1 construction state and reproduction

The new live P1 v29 ledger retains all **67** historical original
source identities and advances only this source to covered:
**56 covered / 11 blocked**, zero partial. The same frozen
59-source batch/slot positions remain intact; **48 covered /
11 blocked**, with Batch 4 slot 4 now complete.

The complete compiler/CPU/optimization sweep is still forbidden
until the remaining 11 P1 original-source construction blockers are
resolved. In particular, PDP-6 execution says nothing about
untested KA10, KI10, KL10 or KS10 conversion behavior.

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh \
  --out-dir "$TMPDIR/p10tk-p1-conversion-fully-corrected-20261121-v1" \
  --source tests/semantic/upstream/pdp10/pdp10/conversion.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/build-p1-conversion-full-v1.py
python3 tools/test-p1-conversion-full-v1.py
python3 tools/build-p1-semantic-resolution-v29.py
python3 tools/audit-p1-source-batches-v28.py
```
