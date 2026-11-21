# P1 conversion.c: complete original KCC PDP-6 execution (2026-11-21, v1)

This is a fully verified **KCC PDP-6 original-source execution**
checkpoint, not closure of the joint GCC/KCC source-construction
requirement. The full compiler/CPU/optimization sweep remains blocked
until all 12 outstanding P1 original sources are construction-covered.
The historical `conversion.c` has not been modified or weakened.

## Owning compiler fixes

KCC commit `bea2680` fixes three distinct implementation errors:

1. `cceval.c` converts folded integer constants according to their
   **target PDP-10 type width** before converting them to a floating
   constant. The optimized `(float)~0U` previously folded the host
   64-bit unsigned maximum, effectively producing `2^64`, instead of
   the 36-bit unsigned value that rounds to `2^36` in target SF.
2. `ccout.c` writes D-format double constants consistently for static
   data and optimized literals. The 36+35-bit significand/exponent
   representation preserves all source bits; two-word negative values
   propagate the low-word two's-complement carry into the high word.
3. `ccgen2.c` now uses the real compiler ABI for **signed 36-bit SI to
   D-format**, with a separate normalized full-width conversion rather
   than losing the low integer bits through 27-bit single precision.
   It also selects the real signed D-format to SI conversion.

The independent owning KCC source
`runtime/libc/kcc-libc-fp36-signed-df-pdp6-v1.s` exports
`__kcc_floatsidf` and `__kcc_fixdfsi`. Both reuse the previously
validated exact unsigned 36-bit D-format helper from
`libp10fp36-pdp6-v1.a`. The new separate signed D-format archive
`libp10fp36-signed-df-pdp6-v1.a` has SHA256
`fad2b3371567a2dde082bfbe2227220cd183ec9322eef6eaba763efd5f252b73`.
Its assembly source SHA256 is
`1ad2e2550bef270389322654cba02cf548972ca7aec4c060e4e590ae04117459`.
The installed KCC and GCC copies are byte-identical. The previous
FP36 archive (SHA256
`de4aa2f79db32c5c95747a658c2f4d6366e69efbb626b0f2ff3b21f847e2e7b2`)
and original compiler core `libp10c-v2.a` (SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`)
remain unchanged. No hosted DAIMOS libc, test substitute, writable
library table, or additional OS syscall was introduced.

## Native PDP-6 evidence

| Source/check | KCC noopt/opt | GCC O0/O1/O2/Os |
| --- | --- | --- |
| Signed 36-bit conversion | 2 PASS | 4 PASS |
| Signed conversion locator | 2 PASS | 4 PASS |
| Unsigned 36-bit SF/DF locator | 2 PASS | 4 PASS |
| Unsigned 36-bit SF ties-to-even | 2 PASS | 4 PASS |
| Signed 36-bit boundary and rounding | 2 PASS | 4 PASS |
| Optimized unsigned constant folding | 2 PASS | 4 PASS |
| Signed D-format to integer boundary | 2 PASS | 4 PASS |
| Exact signed integer to D-format and roundtrip | 2 PASS | 4 PASS |
| **Unchanged upstream `conversion.c`** | **2 PASS** | **4 `link_fail`** |
| Original-source assertion-line diagnostic | 2 PASS | 4 `link_fail` |

This totals **52 verified native PDP-6 guest PASS**, including
48 focused tests and four original/line-map executions. All successful
guests terminate via a real SIMH HALT with `__test_exit=0`; the
focused tests and assertion-line diagnostic also report `fail_id=0`.
The original source SHA256 remains
`2736912e40e1dabd84f7f193ddaaf5ddf9bf00e76edb0cca0611b3f49e5c1beb`.
The two KCC profiles use the installed compiler with SHA256
`49d749e3670e0b3e9abf13e4cb6eb0bc6b9c3dbc39fe43379ed504f9e34fb952`.

The earlier genuine KCC `run_fail` for original line 266 (noopt)
and line 58/87 (optimized, at different repair checkpoints) remain
in their earlier SHA256-pinned evidence. They are **not** relabeled
retroactively; the old evidence suite is still validated.

All four original GCC profiles still genuinely fail at the linker
with missing `__fixunssfdi`, a required GNU/PDP-10 71-bit unsigned
floating-to-integer helper. The preceding GCC `cc1` is unchanged,
SHA256 `67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7`.
**No full original GCC PASS is claimed.**

## Source-pinned evidence and acceptance

`PDP10-P1-CONVERSION-KCC-ORIGINAL-EVIDENCE-20261121-v1.tsv`
contains 60 exact compiler/source/profile outcomes: 52 real guest
PASS plus eight original/line-diagnostic GCC link failures. The
versioned archive
`refs/p10tk-p1-conversion-kcc-original-20261121-v1.tar.gz`
contains **289** raw files: genuine compiler logs, statuses,
assembly, linked maps, SIMH reports, the installed KCC compiler,
both matching signed D-format sources and both compiled archives.
Archive SHA256 is
`7d95a1d2024384eac7a01ecdf9d402c2928de416e9afa4b33c424a4ca2b71301`.

`tools/build-p1-conversion-kcc-original-v1.py` verifies the exact
source SHA256s, normal compiler matrix ownership, source assertions,
frozen old historical evidence, per-cell installed compiler and
compiler-owned runtime identities, actual successful exit/FAIL
semantics, and all archived SHA256s. The matching mutation verifier
`tools/test-p1-conversion-kcc-original-v1.py` rejects 14 invalid
evidence combinations. The installed-library audit also requires
KCC/GCC parity and the correct transitive helper dependencies.

Reproduction of the unchanged original:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh \
  --out-dir "$TMPDIR/p10tk-p1-conversion-after-signedidf-original-20261121-v1" \
  --source tests/semantic/upstream/pdp10/pdp10/conversion.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/build-p1-conversion-kcc-original-v1.py
python3 tools/test-p1-conversion-kcc-original-v1.py
python3 tools/audit-installed-freestanding-v1.py
python3 tools/test-freestanding-selection-v1.py
```

**Acceptance boundary:** The original P1 `conversion.c` remains
blocked on actual GCC 71-bit conversion support. The unchanged 67
original identities still have **55 covered / 12 blocked**; the
59 immutable batch positions still have **47 covered / 12 blocked**.
The full compiler/CPU/optimization sweep is still deferred.
