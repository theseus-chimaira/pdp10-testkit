# Original 980707 space-token compiler-oracle construction (v1)

Date: 2026-11-20. Scope: `pdp10-testkit` only. The full
compiler/CPU/optimization sweep remains deferred. No compiler,
assembler, linker, emulator, library or sibling repository was changed.

## Unchanged original and remaining hosted prerequisites

The historical original `tests/todo/generic/980707-1.c` has SHA256
`43c389a719d17d876d0f9f942d5db81f737c8eed7608de204862f23a6359e7b7`.
It copies `" a b"` into a 256-byte input, scans characters with
`isspace((unsigned char)*input)`, writes pointers into `arglist`,
overwrites delimiters with NUL, and checks `strcmp` against `"a"`
and `"b"`. The original also requires a compatible `<ctype.h>`,
real `isspace` and valid CRT `abort`/`exit` semantics.

Two current native PDP-6 cells were executed with the *compiler-owned*
`libp10c-v2.a`, not generic DAIMOS libc. KCC noopt **link_fail**
with `dlink: undefined symbol: isspace`; GCC O0 **compile_fail**
because target `ctype.h` is absent. These are original-source
failures, not a successful original guest execution. Earlier
hosted-DAIMOS-libc experiments identified a separate genuine
two-provider `exit`/`abort` conflict; that historical result is
preserved in `PDP10-P1-980707-CTYPE-PROVIDER-CLOSURE-20261120-v1.md`
and must not be conflated with the present compiler-stdlib outcomes.

## Separate native 9-bit scanner compiler oracle

`tests/semantic/regression/pdp10-space-token-pointer-v1.c`
has SHA256
`2f15918f9cc9fc3330356f0fd23a43af324c4dabfdac409af131a7f366e7559a`.
It preserves the original nested scan loops, `(unsigned char)`
conversion, pointer writes into `arglist`, NUL replacement, real
`strcpy`/`strcmp`, exact byte positions, and static guard words.
Additional inputs test repeated delimiters, empty input, trailing
spaces and three tokens. The deliberately narrowed predicate
`is_original_space_v1()` recognizes **only ASCII space**, which
is the sole delimiter in the original input; it is NOT an `isspace`
implementation and does not prove other ctype cases. No hosted
stdio, ctype or allocator is faked.

The default build calls `strcpy` directly, allowing normal compiler
optimization. The source also retains an explicitly named
`PDP10_TOKEN_REAL_STRCPY_V1` diagnostic variant that calls the real
compiler-library `strcpy` through a volatile function pointer; this
variant was **not** used to change or reclassify the pinned default
native results.

## Independent optimized GCC literal-copy failure

The minimal C89 test
`tests/semantic/regression/pdp10-strcpy-space-literal-v1.c`, SHA256
`18cac972901cd3d56d397ea44969e48b96609e5a4b4eb57075db2fcd108fda4f`,
calls `strcpy(content, " a b")`, then checks each byte via a
`volatile char *` and checks surrounding static guard words. There
is no alternative string routine or replacement `strcpy`.

| PDP-6 native compiler profile | Scanner result | Literal-copy result |
| --- | --- | --- |
| KCC noopt | PASS | PASS |
| KCC opt | PASS | PASS |
| GCC O0 | PASS | PASS |
| GCC O1 | `run_fail`, `fail_id=8` | `run_fail`, `fail_id=3` |
| GCC O2 | `run_fail`, `fail_id=8` | `run_fail`, `fail_id=3` |
| GCC Os | `run_fail`, `fail_id=8` | `run_fail`, `fail_id=3` |

Guest report values are **octal**: `000000000010` means decimal 8,
not decimal 2. The scanner fails its first token pointer comparison
`args[0] == buf + 1`; it does **not** report a damaged guard.
The independent literal-copy test fails its volatile read of the
second byte, expected `'a'` (`fail_id=3`).

In GCC O0, the generated code calls real compiler-library `strcpy`
and the guest passes. In GCC O1/O2/Os, the generated assembly omits
the `strcpy` call and emits a single `DPB` of ASCII space into the
first 9-bit buffer byte; no stores for the following characters are
present. All three optimized native guests then fail. This is
source-specific, independently reproduced evidence of a genuine
**optimized GCC literal `strcpy` code-generation defect**. The
defect has not been repaired or hidden by a direct-call bypass.

## Pinned evidence and remaining work

`PDP10-P1-980707-SPACE-TOKEN-EVIDENCE-20261120-v1.tsv` records
all 14 real profile outcomes with source/status/report/map/assembly
SHA256 hashes. The archive
`refs/p10tk-p1-980707-space-token-20261120-v1.tar.gz` contains
**65 raw artifacts**, SHA256
`bef018cea61cff50ae22a00c0e822f07c4ba8384bedce1329e6b2d6f4e10d983`.
Every cell records `compiler-stdlib-v1` and the installed target C
archive SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.

`tools/test-p1-980707-space-token-v1.py` authenticates all source
identities, matrix registration, original diagnostics, real SIMH
HALTs, actual failure IDs and target exit values, source-specific
optimized assembly, map symbols and archive members. Eleven
fail-closed negative controls reject corrupt or fabricated evidence.

This closes only **P1 compiler-oracle construction** for the space
token, byte-pointer and string-copy behavior. The complete hosted
`isspace` contract, original target headers, original executable
and optimized GCC correctness remain unresolved. The live v24 ledger
retains `gcc-optimized-strcpy-literal-and-hosted-ctype` as an explicit
compiler follow-up; its original source stays in frozen batch 5,
slot 6. P1 now has 53 construction-covered and 14 blocked identities
(45 covered, 14 blocked in the 59 fixed batch positions).

Focused reproduction only; the two companion commands are *expected*
to return failure status due to the real optimized GCC regressions:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-980707-space-pointer-compiler-20261120-v1" \
  --source tests/semantic/regression/pdp10-space-token-pointer-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
./run-tests.sh --out-dir "$TMPDIR/p10tk-980707-strcpy-literal-compiler-20261120-v1" \
  --source tests/semantic/regression/pdp10-strcpy-space-literal-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-980707-space-token-v1.py
python3 tools/build-p1-semantic-resolution-v24.py
python3 tools/audit-p1-source-batches-v23.py
```
