# P1 old.tort native pointer-conversion locator (2026-11-21, v1)

The historical `old.tort.c` source is no longer the active compiler
matrix source. Its registered freestanding C89 replacement remains
`tests/semantic/regression/pdp10-byte-pointer-torture-v1.c`, SHA256
`2b7543b425ffa690cd73848b581bb18791989d07af5d7372969664cea1bfe534`.
It is **not** legitimate to claim its observed guest result as a PASS
of the deleted upstream file. Original P1 source construction is
unchanged at **56 covered / 11 blocked**, and frozen source batches
remain **48 covered / 11 blocked**. The full sweep is deferred.

## Real compiler failures, current native PDP-6

The full replacement source still encounters distinct compiler
failures on the installed KCC and GCC toolchains. They are not
conflated into a single pointer-format defect:

| Compiler profile | Replacement status | Actual fail_id (decimal) | Check |
| --- | --- | ---: | --- |
| KCC noopt | run_fail | 10 | Initial 9-bit pointer identity |
| KCC opt | run_fail | 12 | Initial 18-bit pointer identity |
| GCC O0 | run_fail | 21 | Initial 9-bit data read after void roundtrip |
| GCC O1 | run_fail | 28 | 18-bit array pointer stride |
| GCC O2 | run_fail | 28 | 18-bit array pointer stride |
| GCC Os | run_fail | 28 | 18-bit array pointer stride |

To avoid masking distinct failures behind the first abort, the new
independent C89 test
`tests/semantic/regression/pdp10-void-pointer-roundtrip-locator-v1.c`
(SHA256
`1e6fecf37745cfb9c111a10b35133d0b9802d044ba9d6960148d827cd526d3d1`)
passes 9-, 18- and 36-bit object addresses through an actual
volatile function-pointer call to a `void *` identity function.
The source compares both the original typed pointer identity and
its 9/18/36-bit data without stripping object qualifiers or
violating aliasing rules. The expected values are literal 0400,
0400000 and 0400000000000 (octal) from independent C constants.

| Profile | Independent locator result | fail_id (octal) |
| --- | --- | --- |
| GCC O0/O1/O2/Os | Four native PASS | 0000 |
| KCC noopt/opt | Two actual run_fail | 1002 |

The KCC mask `01002` is bit 1 (18-bit pointer identity) plus bit 9
(data mismatch from the same 18-bit pointer). It is not a generic
byte-pointer failure in the independent locator: 9-bit and 36-bit
objects survive the same function call. The full replacement source
still has earlier KCC and separate GCC failures, as preserved above.

The owning KCC pointer-lowering path in `cctype.c`/`ccgen2.c`
supports native byte/half pointers and a self-describing S=1 logical
form. It must preserve the 18-bit address and byte-size metadata
through ordinary `void *` storage, function ABI, and back-conversion.
A source-specific cast avoidance or forced word-pointer conversion
would be an invalid workaround. No compiler source has yet been
changed as part of this diagnostic checkpoint.

## Immutable raw evidence

`PDP10-P1-VOID-POINTER-ROUNDTRIP-EVIDENCE-20261121-v1.tsv`
identifies exactly twelve real compiler/source/profile cells.
`refs/p10tk-p1-void-pointer-roundtrip-20261121-v1.tar.gz`
retains 60 source/profile statuses, compiler logs, emitted assembly,
linker maps and native PDP-6 SIMH reports. Archive SHA256:
`cafd39d41f04ceec652b34ec458ccbad54bde8fa5ea25a538ea95a9d6cf48c35`.

The installed compiler SHA256s were KCC
`72f5d94c9a3fd21481928d9b47caa1451dfcd9bd61937f63da5b08c2f04b9fa6`
and GCC cc1
`67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7`.
All cells use the actual installed `libp10c-v2.a` SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.
Native guests terminate with actual HALT, but the eight failing
guests' `fail_id` and `result=FAIL` are required, not rewritten.
`tools/test-p1-byte-pointer-void-roundtrip-v1.py` checks every
source/compiler/profile, all raw SHA256s, outcome/failure IDs,
original function call and data assertions, and seven fail-closed
mutation controls. Verification does not require a live simulator;
regeneration uses `--write` and the two versioned runner folders.

Re-run the focused tests with the ordinary installed toolchain:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-p1-void-roundtrip-20261121-v2" \
  --source tests/semantic/regression/pdp10-void-pointer-roundtrip-locator-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
./run-tests.sh --out-dir "$TMPDIR/p10tk-p1-byte-pointer-20261121-v1" \
  --source tests/semantic/regression/pdp10-byte-pointer-torture-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-byte-pointer-void-roundtrip-v1.py
```

Both `run-tests.sh` invocations intentionally report real failures
until the owning KCC/GCC pointer-conversion code is corrected.
