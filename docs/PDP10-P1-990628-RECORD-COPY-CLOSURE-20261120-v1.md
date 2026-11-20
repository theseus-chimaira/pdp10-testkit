# P1 990628 real byte memset and record-copy semantics (v1)

Date: 2026-11-20. Only `pdp10-testkit` was changed. The full
compiler/CPU/optimization sweep is not authorized or performed.

## Historical original: unchanged hosted allocator test

`tests/todo/generic/990628-1.c` is unchanged at SHA256
`eae56aa6d888dbdab7d545d7146e40153a3fd5a2663e741c97a9cf6a2bae212c`.
Its original data record contains one `int dummy` and 100 further
`int` array elements. `load_data()` allocates the destination with
`malloc`, fills it with `0xaa`, fetches a `0x55` byte-initialized
temporary, and performs a true whole-structure `*p++ = data_tmp`.
The second fetch sets `sqlca.sqlcode = 100`, ending the loop. The
original then checks `data_ptr[0].dummy` against a repeated 9-bit
byte pattern for PDP-10.

The freshly reproduced unchanged original KCC PDP-6 noopt and GCC
PDP-6 O0 both link *real* `malloc`, `memset`, `fetch`, `load_data`,
`abort`, `exit` and `main` objects, but SIMH reports `rc=124` and
no HALT. These are **timeouts**, not observed assertion failures
and not evidence that the compiler semantics passed.

## Independent freestanding compiler oracle

`tests/semantic/regression/pdp10-record-fetch-copy-v1.c` retains
the original 101-int struct, two real `memset` calls, exact 9-bit
repeated-byte integer pattern `0x55 * 01001001001`, fetch-state loop,
pointer-postincrement aggregate assignment and final assertions.
It uses an actual static record instead of a fabricated `malloc`
implementation, so the compiler/byte-layout/aggregate-copy
questions can be tested separately. It additionally checks all
100 record array elements, the copied `dummy` field, `data_tmp`
contents, both destination canaries, the precise two fetch calls,
one store, and `sqlcode` termination. The record occupies 404
9-bit bytes (101 PDP-10 native integers).

The selected installed native PDP-6 profiles are:

| Profile | Result |
| --- | --- |
| KCC noopt, opt | 2 guest PASS |
| GCC O0, O1, O2, Os | 4 guest PASS |

All six linked maps define actual `memset` (the compiler-generated
GCC O0 body also contains two `pushj 17,memset` references).
These PASS results are **not a claim of hosted heap correctness**.
The original source remains present, still has two real
`timeout` outcomes, and is not replaced by the companion.

The original/companion source SHA256, eight exact guest outcomes,
maps and emitted assembler sources are pinned in
`PDP10-P1-990628-RECORD-COPY-EVIDENCE-20261120-v1.tsv` and
`refs/p10tk-p1-990628-record-copy-20261120-v1.tar.gz`.
`tools/test-p1-990628-record-v1.py` verifies all 24 archived
artifacts and runs ten fail-closed negative controls for changed
source identities, profile/registry changes, false passes and
corrupted raw evidence.

The P1 v20 construction ledger records the compiler/representation
intent as covered, but preserves the distinct outstanding requirement
`hosted-malloc-original-runtime`. The full original execution,
heap service, other CPUs and full compiler matrix are **untested**.

To reproduce only the selected compiler-oracle cells:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-990628-record-native-20261120-v1" \
  --source tests/semantic/regression/pdp10-record-fetch-copy-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-990628-record-v1.py
python3 tools/build-p1-semantic-resolution-v20.py
```
