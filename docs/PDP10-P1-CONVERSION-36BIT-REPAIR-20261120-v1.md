# P1 conversion.c: native PDP-6 36-bit signed and unsigned FP repair (v1)

Date: 2026-11-20. This is a **completed focused compiler repair**,
but **not** a closure of the original `conversion.c` P1 source.
The full compiler/CPU/optimization sweep is still prohibited until
all 12 remaining P1 construction positions have a validated oracle.
No historical imported source was modified or given a fake helper.

## Defects in the owning compiler code

GCC PDP-10's old `gcc/config/pdp10/libgcc1.s` `__floatsisf`
scaled a raw integer using `FSC 1,0233`. That produces a noncanonical
PDP-10 floating word: for `+1024`, observed octal `233000002000`
instead of canonical `213400000000`; for `-1024`, the old KCC
and GCC values similarly differed from the expected signed word.
This caused all six real PDP-6 signed-conversion companion guests
to fail before the repair. The GNU/PDP-10 backend's other defects
included unsigned-integer-to-float loss of low bits, incorrect
rounding of upper-range values, a signed `__fixsfsi` conversion
returning zero at the representable minimum `-2^35`, and a
`floatunssidf2` lowering through 27-bit SF before widening to
62-bit D-format. GCC also lacked a real `__fixunssfsi` entry.

GCC now uses canonical normalized single-precision fractions,
nearest/ties-to-even with explicit guard and carry handling,
correct signed minimum conversion, and dedicated real helpers
`__fixunssfsi` and `__floatunsidf`. The latter retains all 36
unsigned input bits in the two-word D-format fraction. This is
implemented in `gcc/config/pdp10/libgcc1.s`, target library build
registration in `t-none`, and the backend selection in `pdp10.md`.
It does **not** use an SF intermediate for exact unsigned DF.

KCC's PDP-6 integer-to-SF path had the same nonnormalized-FSC
error, plus a lossy nine-bit truncation and incorrect rounding
for the full 36-bit unsigned range. The signed `FIX` path could
not handle conversion results with bit 35 set. The owning KCC
code generator now makes ordinary ABI calls with register liveness
preserved, rather than inserting an unsafe post-register-allocation
runtime call or test-only substitute. The separate
`runtime/libc/kcc-libc-fp36-pdp6-v1.s` implements six real
compiler-facing entry points:

* `__kcc_floatunssisf`, `__kcc_floatunsidf`;
* `__kcc_fixunssfsi`, `__kcc_fixunsdfsi`;
* `__kcc_floatsisf`, `__kcc_fixsfsi`.

The signed SF conversions reuse the magnitude-correct unsigned
conversion paths, handling `-2^35` and ties-to-even. KCC's normal
register allocator accounts for the helper call and one/two-word
arguments; the helpers save necessary scratch accumulators and
use only bounded stack, with no heap or writable library globals.
This is a **compiler-owned real runtime library**, not a test
workaround. The versioned archive `libp10fp36-pdp6-v1.a`, SHA256
`de4aa2f79db32c5c95747a658c2f4d6366e69efbb626b0f2ff3b21f847e2e7b2`,
is installed byte-identically into both compiler freestanding
directories. Its source SHA256 is
`69eaf3c43297b67955adcb77bdde3b54ea785900102bbf9850ea226296dfa6b4`.
The established compiler C archive `libp10c-v2.a` remains unchanged,
SHA256 `ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.

## Exact native PDP-6 results, full compiler optimization profiles

| Test source | KCC noopt/opt | GCC O0/O1/O2/Os |
| --- | --- | --- |
| Original signed-36 companion, before repair | 2 `run_fail` (mask 003/017) | 4 `run_fail` (mask 001) |
| Original signed-36 companion, after repair | 2 PASS | 4 PASS |
| Independent signed conversion locator | 2 PASS | 4 PASS |
| Unsigned-36 SF/DF input-output locator | 2 PASS | 4 PASS |
| Unsigned-36 SF rounding, including half-ULP ties | 2 PASS | 4 PASS |
| Signed-36 boundary, including `-2^35` and half-ULP ties | 2 PASS | 4 PASS |

These 30 successful guests reach actual SIMH HALT with
`__test_exit=0`, `fail_id=0`. The independent test inputs use
volatile source values and constant numeric expectations, and
their operations use the real installed compiler code and libc.
No partial result is misclassified as an original-source PASS.

The unchanged historical
`tests/semantic/upstream/pdp10/pdp10/conversion.c` and an
independent line-mapping wrapper are also still exercised.
The wrapper includes the **unchanged original** and only reports
the original source line on a real `abort()`; it does not change
the original's assertions or runtime services. The current
results are:

* KCC noopt: original `run_fail`, line 266 (signed D-format
  `-2^35` back to signed 36-bit integer).
* KCC opt: original `run_fail`, line 58 (`fnear` on the largest
  unsigned integer converted to float).
* GCC O0/O1/O2/Os: original `link_fail`, missing real GNU 71-bit
  floating-to-unsigned conversion entry `__fixunssfdi`.

Historical original missing `__fixunssfsi` and signed-family errors
remain recorded; those earlier failures have not been relabeled
as PASS. The new GCC `__fixunssfsi` resolves that former link
prerequisite, exposing the **next** genuine missing 71-bit symbol.
The KCC signed 36-bit/D-format full-limit and `fnear` behaviors
and the GCC unsigned/signed 71-bit conversions still need owning
compiler/runtime work before source construction can be closed.

## Installed binary provenance and reproducible evidence

The old GCC libgcc DARC archive, SHA256
`9bead1fd78365d1fa96f868c24e3234d035673e16db01301946f553aa4b097d2`,
was preserved. Real built DOBJ members were changed or added in
a new libgcc archive with all untouched original members retained.
The installed new libgcc SHA256 is
`afd520fbbff5db32466d887e49136f09ee2c4517b63eded83325cd721505f960`.
Installed GCC `cc1` SHA256 is
`67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7`;
installed KCC compiler SHA256 is
`0574417c52be0fdd7e4595ba4a23a91967a703f8cd522b9d7c58688985b7a35b`.
The original compiler binaries were preserved in versioned
`$TMPDIR` backups before installation. No unrelated assembler,
simulator, generic DAIMOS libc, or test CRT was changed.

`PDP10-P1-CONVERSION-36BIT-REPAIR-EVIDENCE-20261120-v1.tsv`
pins all **48** source/profile results: 30 actual new PASS,
six pre-repair signed failures, and 12 current genuine original
and original-line failures. The archived
`refs/p10tk-p1-conversion-36bit-repair-20261120-v1.tar.gz`
contains **230** raw output and compiler-runtime artifacts, SHA256
`82d885cbc4cf8319600c05c8138789bf19333322d8896e9586d201e42cda40dd`.
It retains old and new complete libgcc archives, both versions of
the real KCC/GCC FP36 library/source, per-guest status, compiler
assembly, linker maps, logs, and SIMH reports.

`tools/build-p1-conversion-36bit-evidence-v1.py` authenticates
source identities, original assertions, exact profile membership,
compiler-stdlib isolation, native HALTs and octal assertion IDs,
all raw SHA256s and genuine missing 71-bit symbol failures.
`tools/test-p1-conversion-36bit-repair-v1.py` adds 13 fail-closed
negative controls. The installed-library auditor additionally
checks KCC/GCC FP36 source and archive parity and rejects mismatches.

**Acceptance boundary:** This closes the focused native PDP-6
36-bit compiler conversion repair, **not** the original P1
`conversion.c` obligation. P1 remains **55 covered / 12 blocked**,
and frozen 59-source batches **47 covered / 12 blocked**.
The full compiler/CPU/optimization sweep is deferred until all
12 blocked original sources have validated construction coverage.

## Focused validation

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/build-p1-conversion-36bit-evidence-v1.py
python3 tools/test-p1-conversion-36bit-repair-v1.py
python3 tools/test-freestanding-selection-v1.py
python3 tools/audit-installed-freestanding-v1.py
python3 tools/test-installed-freestanding-audit-v1.py
python3 tools/build-p1-semantic-resolution-v28.py
python3 tools/audit-p1-source-batches-v27.py
```
