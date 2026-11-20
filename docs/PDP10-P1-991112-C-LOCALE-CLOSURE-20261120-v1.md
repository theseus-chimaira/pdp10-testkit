# P1 991112: real compiler C-locale isprint, isspace and original-source closure

Date: 2026-11-20. The full compiler/CPU/optimization sweep remains
**blocked** until all remaining P1 source-construction slots close.
No historical imported source was modified, and no substitute or
test-local `isprint`/`isspace` implementation was introduced.

## Original failure, preserved

Batch 4, slot 3 is unchanged `tests/todo/generic/991112-1.c`,
SHA256 `8c6dd7a6a2a80914012a04aa95b1ab303b678087036b4c19df63e2f700aee9c4`.
The test invokes `rl_character_len` through an `int (*)(int,int)`
pointer; it must return length 1 for printable `'a'` and length 2
for control character octal `002`. Both original abort assertions
are intact. A fresh pre-provider PDP-6 run reconfirmed genuine
`dlink: undefined symbol: isprint` for KCC noopt and GCC O0.
Those two link failures remain source-pinned historical evidence,
not retroactively converted to PASS.

## Actual compiler-owned C-locale runtime

KCC's owning source now supplies
`runtime/libc/kcc-libc-ctype-c-locale-v1.s` (commit `5264ccc`).
This is a small, PDP-6-compatible assembly implementation of real
`isprint` and `isspace`: no stack, heap, writable global data,
syscall or other library dependency. Each returns a boolean in AC1.

The implementation covers all 512 values in the unsigned 9-bit
character domain and EOF (-1) according to the **C locale**:

* `isprint`: octal `040` through `0176` inclusive.
* `isspace`: octal `011` through `015`, or `040`.
* Other input values, including `0200` through `0777`, are neither
  printable nor whitespace in this locale.

The same assembly source is compiled into the independently
linkable `libp10ctype-c-locale-v1.a` installed under **both**
compiler-owned freestanding directories. Its SHA256 is
`790b064ecef6857d98c9a30b326c638af839b70931b19fc603fbe9b10aee99a3`;
source SHA256 is
`2b010cf9591dd57c508cbd233be05ddb7744ea817db51a291c780e7ee954cc23`.
Both installed KCC/GCC copies match exactly. Their original
`libp10c-v2.a` archives remain *unchanged*, SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.
No general DAIMOS OS libc was linked.

The KCC `<ctype.h>` now declares `isprint`; GCC's new
`gcc/ginclude/ctype.h` declares both functions (GCC owning
commit `4fb9555`), and its PDP-10 build header list installs it.
These are target C-locale declarations, **not** a claim of complete
`<ctype.h>` or Unicode/UTF-9 classification.

## Independent full-domain and unchanged original guest results

The normal compiler matrix selects the real installed classifier
fragment by actual external symbol reference. To support GCC's
`static int (*volatile f)(int) = isprint` initialization correctly,
the freestanding member selector now recognizes real `.long` and
`.word` symbol relocations as well as `.extern`/`PUSHJ`/`JRST`.
Locally defined symbols remain excluded; 20 positive/negative
selection controls pass. The installed freestanding source/archives
have matching compiler identities and five fail-closed audit
negative controls.

The independent C89 test
`tests/semantic/regression/pdp10-ctype-c-locale-exhaustive-v1.c`
has SHA256
`016959400ed5b9a57d4b984fd800d3d2cc856d682a1c60e5245856bb36c2cb78`.
It calls the actual functions through volatile function pointers
for every unsigned 9-bit value from 0000 through 0777, then EOF,
and separately verifies the original printable and control inputs.

| Native PDP-6 compiler | Unchanged `991112-1.c` | Full 9-bit C locale | Unchanged `980707-1.c` |
| --- | --- | --- | --- |
| KCC noopt | PASS | PASS | PASS |
| KCC opt | PASS | PASS | PASS |
| GCC O0 | PASS | PASS | PASS |
| GCC O1 | PASS | PASS | PASS |
| GCC O2 | PASS | PASS | PASS |
| GCC Os | PASS | PASS | PASS |

All 18 newly executed compiler guests reach real PDP-6 SIMH HALT,
with `result=PASS` and `__test_exit=0`. The full-domain companion
also has `fail_id=0` and counts exactly 512 tested values. This is
real native guest execution, not a compile-only status.

The already construction-covered `980707-1.c` has SHA256
`43c389a719d17d876d0f9f942d5db81f737c8eed7608de204862f23a6359e7b7`.
Its real installed `<ctype.h>` and `isspace` now allow the
**unchanged original** to compile, link and pass all six profiles,
instead of depending only on the prior compiler-only scanner. The
historical missing-header/`isspace` errors and optimized GCC
`strcpy` bug remain immutable in their earlier evidence archives.

## Evidence and limits

`PDP10-P1-991112-C-LOCALE-EVIDENCE-20261120-v1.tsv` records
20 results: two actual historical missing-`isprint` link failures
and the 18 post-provider guest PASS. The versioned archive
`refs/p10tk-p1-991112-c-locale-20261120-v1.tar.gz` has **102**
raw artifacts (compiler logs, statuses, assembly, maps, simulator
reports, both installed classifier sources/archives, and both
target headers). Archive SHA256:
`e50853fbab4d755f3edd2ffdecd3326db2e502c221469e50ae3a5774a4698b3b`.

`tools/test-p1-991112-c-locale-v1.py` authenticates exact source
and installed provider identities, full profile membership, actual
guest exit/assertion values, linked real target ctype symbols,
all 102 raw SHA256s, and 11 negative mutation controls.

Only **P1 source construction** now closes `991112-1.c` (batch 4,
slot 3). The other 66 original source identities and all frozen
batch/slot positions stay fixed. P1 totals advance to **55 covered /
12 blocked**, and 59 frozen batches to **47 covered / 12 blocked**.
The previous `980707-1.c` is already covered and does not increase
the count again. Other CPU targets, the full compiler matrix and
Unicode/UTF-9 character properties are still unverified.

Focused reproduction:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-p1-991112-c-locale-original-20261120-v1" \
  --source tests/todo/generic/991112-1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
./run-tests.sh --out-dir "$TMPDIR/p10tk-c-locale-ctype-9bit-native-20261120-v2" \
  --source tests/semantic/regression/pdp10-ctype-c-locale-exhaustive-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
./run-tests.sh --out-dir "$TMPDIR/p10tk-p1-980707-c-locale-original-20261120-v1" \
  --source tests/todo/generic/980707-1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-991112-c-locale-v1.py
python3 tools/build-p1-semantic-resolution-v28.py
python3 tools/audit-p1-source-batches-v27.py
```
