# 941014 native volatile halfword and pointer-offset compiler oracle (v1)

Date: 2026-11-20. Scope: `pdp10-testkit` only. The complete
compiler/CPU/optimization sweep was **not** run; neither installed
compiler nor DAIMOS libc was modified.

## Unmodified historical source and real compiler-libc blockers

`tests/todo/generic/941014-2.c` remains unchanged, SHA256
`2e4ed285b175681b5c72b1de67f95329e915e0e2b88d25e004a68389f245cae9`.
The original `f()` obtains a `volatile foo_t *` via `malloc`, tests
`a & 0xf000`, conditionally calls hosted `printf`, writes `b = 0x0100`,
invokes `a1()` with the original `((unsigned long)pointer - 30)`,
`(+ 2)`, and `(- 30)` expressions, then returns the pointer. `main()`
checks only the final `b` value, aborting on failure.

Under the installed compiler-owned `libp10c-v2.a` policy, both
freshly selected original PDP-6 profiles are genuine **link_fail**:

* KCC noopt: `dlink: undefined symbol: printf`.
* GCC O0: `dlink: undefined symbol: malloc`.

This is not a demonstration that the historical code ran, nor evidence
for installing another OS's allocator, console, or termination ABI.
The original has no fabricated hosted services.

## Independent C89 compiler oracle and failures

The normal matrix now registers
`tests/semantic/regression/pdp10-volatile-short-offset-v1.c`, SHA256
`fed85b731df2c480eed32c1c3c174e6c19ebcb36ab546e63ff20f401495d3c26`.
It keeps the original two unsigned-short fields and real `volatile`
access, with static guarded storage in place of hosted `malloc`.
It explicitly checks 18-bit `unsigned short` occupying two native
9-bit bytes, both shorts occupying a single 36-bit native word,
the preserved `a` field, the `0x0100` write and readback of `b`, the
returned pointer, and two surrounding canaries. The original three
`a1()` pointer-to-unsigned-long arithmetic expressions are executed
in order and checked against the independently computed 36-bit
integer address, including the arithmetic difference of 32 between
`+2` and `-30`. The original diagnostic `printf` arm is deliberately
not exercised; its branch condition is checked without pretending
a freestanding console exists.

| Native PDP-6 compiler profile | Current real guest outcome |
| --- | --- |
| KCC noopt | PASS |
| KCC opt | PASS |
| GCC O0 | PASS |
| GCC O1 | **run_fail**, `fail_id=11` (first `-30` address value) |
| GCC O2 | **run_fail**, `fail_id=16` (integer address delta) |
| GCC Os | **run_fail**, `fail_id=16` (integer address delta) |

All six run through the compiler-only prefix (SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`),
with real source compilation, `dlink`, simulator HALT and
`__test_exit`/`fail_id` reports. For optimized GCC failures, the
real guest sets `__test_exit=1`. The compiler's O1 assembly folds
the first pointer conversion to a `POINT 17` constant while the
comparison computes `SUBI 036` from a `POINT 18` value. GCC O2/Os
fold the integer address expressions to byte-pointer constants,
and the independent subtraction fails the 32-unit invariant.
These are reproducible **compiler-code-generation regression
candidates** in 36-bit pointer/integer arithmetic; no compiler bug
has been repaired. They are never recorded as guest PASS.

The source-pinned manifest
`PDP10-P1-941014-VOLATILE-SHORT-EVIDENCE-20261120-v1.tsv` and raw
archive `refs/p10tk-p1-941014-volatile-short-20261120-v1.tar.gz`
contain the two original failed-link logs and assembly plus the six
companion native reports, maps and assembly, together with all eight
compiler-runtime-policy status checkpoints: **30 artifacts** total.
`tools/test-p1-941014-volatile-v1.py` validates all hashes,
source/matrix ownership, precise guest exit and failure IDs,
linker symbols and **11 negative mutation controls**.

The live P1 v21 ledger marks the **compiler oracle construction** for
the historical source as covered; its actual hosted malloc/printf
contract remains open, as do all three optimized GCC guest failures.
Frozen batch 5, slot 2 is not moved or renumbered. P1 counts become
50 covered, zero partial and 17 blocked; this count does **not**
claim success for the compiler under all profiles.

Focused reproduction only:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-941014-volatile-compiler-20261120-v1" \
  --source tests/semantic/regression/pdp10-volatile-short-offset-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-941014-volatile-v1.py
python3 tools/build-p1-semantic-resolution-v21.py
python3 tools/audit-p1-source-batches-v20.py
```

The `run-tests.sh` command is expected to exit nonzero on the three
real GCC optimization failures. That is intentional; do not suppress
the failures or substitute a test-only pointer implementation.
