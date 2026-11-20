# 920810 original child copy: native compiler oracle (v1)

Date: 2026-11-20. Scope: `pdp10-testkit` only. The full
compiler/CPU/optimization sweep was not started. The installed
compiler, assembler, linker, emulator and libraries were not modified.

## Original historical source (unaltered)

`tests/todo/generic/920810-1.c` has SHA256
`23405fde00c057160ef5881b0561d2e5921be68a07cb11f7b2f2e6e66952dbb5`.
Its function `f(t *clas, int size)` allocates `size` bytes using
`malloc`, copies exactly `clas->size` bytes with `memcpy`, then sets
`child->super=clas`, `child->name=0`, `child->size=size`. The caller
fills a three-field structure with 9-bit byte value 37 using
`memset`, overwrites its size, calls `f`, and checks all three
inherited child fields.

The original currently has two source-specific **link_fail** results
under real installed compiler-owned `libp10c-v2.a`: KCC PDP-6 noopt
and GCC PDP-6 O0 both report `dlink: undefined symbol: malloc`.
These are not executions of the original child allocation. No fake
allocator, DAIMOS libc, or change to the original source is allowed.

## Separate compiler-semantic oracle

`tests/semantic/regression/pdp10-memcpy-child-inheritance-v1.c`
has SHA256
`005d0573c2ad44d4881211a1c8b340b04cc4482e9c042d363f73e38a832e6a77`.
It uses one statically owned child in guarded storage while retaining
the original three-field structure and exactly the same *real*
`memcpy(child, clas, clas->size)` call. The input still undergoes
the original real `memset(..., 37, sizeof(t))`; the test asserts the
full 9-bit byte-repeat pattern in its `name` word. The original
source pointer is initialized to NULL before being read so that no
invalid fabricated pointer is consumed.

Before the original three inheritance-field assignments, the test
asserts that the copied `super`, `name` and `size` fields match the
source. It then checks the child parent pointer, zero name, size,
unchanged source, exactly one copy and both adjacent memory guards.
It also asserts the native 36-bit integer/word storage and 12-byte
structure size. Real installed compiler library functions are
required: all six native link maps define both `memcpy` and
`memset`, and all six generated assembly files contain direct calls
to both.

| Native PDP-6 compiler profile | Actual companion guest result |
| --- | --- |
| KCC noopt | PASS |
| KCC opt | PASS |
| GCC O0 | PASS |
| GCC O1 | PASS |
| GCC O2 | PASS |
| GCC Os | PASS |

Every guest completed SIMH with a real HALT, `__test_exit=0`, and
`fail_id=0`. The compiler runtime policy for each cell is
`compiler-stdlib-v1`, with target C archive SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.

Two original compiler-only link-failure logs and four saved artifacts
per companion profile yield **30 raw evidence artifacts**. The
SHA256 manifest
`PDP10-P1-920810-CHILD-COPY-EVIDENCE-20261120-v1.tsv` and archive
`refs/p10tk-p1-920810-child-copy-20261120-v1.tar.gz` preserve all
eight source/profile outcomes. The registered validator
`tools/test-p1-920810-child-copy-v1.py` verifies the original source,
companion assertions, compiler matrix ownership, exact expected
failures and passes, status/stdlib provenance, actual linker symbols,
guest HALT and expected zero results. Eleven negative controls
reject modified or missing evidence.

The P1 **compiler-oracle construction** is covered; the historical
`malloc` runtime, complete original execution and other CPUs are not
verified. `PDP10-P1-SEMANTIC-RESOLUTION-20261120-v22.tsv` records the
separate remaining `hosted-malloc-original-runtime` follow-up and
the frozen batch-4 slot 10 stays in its original position. Current
test construction totals become 51 covered, zero partial, 16 blocked.

Focused reproduction (not the full compiler sweep):

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-920810-child-compiler-20261120-v1" \
  --source tests/semantic/regression/pdp10-memcpy-child-inheritance-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-920810-child-copy-v1.py
python3 tools/build-p1-semantic-resolution-v22.py
python3 tools/audit-p1-source-batches-v21.py
```
