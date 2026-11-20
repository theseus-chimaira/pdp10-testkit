# 20020406 original recursive DUPFFexgcd pointer-swap oracle (v1)

Date: 2026-11-20. Scope: `pdp10-testkit` only. The compiler,
assembler, linker, emulators, installed C libraries and sibling
repositories were not modified. No full compiler/CPU/optimization
sweep was run.

## Historical source and real compiler-stdlib failure

The unchanged `tests/todo/generic/20020406-1.c` has SHA256
`25ba3fe43fc4109bd2eb1a2fb651f9ca0443800db46e67d60b4946e9c3e90e7c`.
It creates degree-one and degree-two DUPFF objects through
`malloc`/`calloc`, writes source coefficients, calls hosted `printf`,
then calls `DUPFFexgcd(&cf, &cg, f, g)`. The reachable path enters
`DUPFFexgcd(fcofac, gcofac, f, g)` with degrees one and two,
recursively invokes
`DUPFFexgcd(gcofac, fcofac, g, f)`, and returns the degree-two
`f` pointer from the second invocation when `f->coeffs[0]==0`.
The original marks its recursive call line as a historical bug
site. The following algebraic loops are never reached by this
particular historical input, nor does original `main()` assert the
result or cofactor outputs.

With the compiler-only target `libp10c-v2.a`, both freshly focused
original native PDP-6 cells, KCC noopt and GCC O0, **link_fail**:
`dlink: undefined symbol: malloc`. These are not compiler-run PASS
or successful hosted executions; the source's additional `calloc`
and `printf` contracts have not been independently validated. No test
stub or unrelated OS C library was introduced.

## Independent reachable-path compiler oracle

`tests/semantic/regression/pdp10-duptree-recursive-pointer-swap-v1.c`,
SHA256
`27b29ef587c6ac726bce5f84f83e6946b2f8d5f93ee4a0aad723584d51b73302`,
is registered as a normal compiler-semantic source. It retains the
original three-field DUPFF structure, exact degree and coefficient
setup, original recursive expression, degree check and early return.
The only substitution is statically owned structure/coefficients
in place of hosted allocation; a trace records two actual recursive
invocations instead of printing a diagnostic. This is not a fake
`malloc`, `calloc`, `printf` or algebra implementation.

The companion checks 20 independent failure checkpoints including
exactly two calls, the original `&cf`/`&cg` pointer-to-pointer slots,
their reversal in the second invocation, the reversal of both
structure input pointers, returned `g` identity, untouched cofactor
sentinels and preserved degrees, maxima and coefficient arrays.

| Native PDP-6 compiler profile | Actual guest result |
| --- | --- |
| KCC noopt | PASS |
| KCC opt | PASS |
| GCC O0 | PASS |
| GCC O1 | PASS |
| GCC O2 | PASS |
| GCC Os | PASS |

All six real guest reports include SIMH HALT, `__test_exit=0` and
`fail_id=0`, running against compiler-only `libp10c-v2.a` SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.
The generated assembly retains a genuine recursive `DUPFFexgcd`
call or tail jump, while the actual linker maps define the real
`DUPFFdeg`, `DUPFFexgcd`, `main`, `abort`, `exit` and `fail_id` symbols.

The versioned
`PDP10-P1-20020406-RECURSIVE-SWAP-EVIDENCE-20261120-v1.tsv`
and `refs/p10tk-p1-20020406-recursive-swap-20261120-v1.tar.gz`
preserve eight original/companion results and **30 SHA256-pinned
raw outputs** (failed original compiler logs and assembly, genuine
companion guest reports, maps, assembly, plus all policy statuses).
`tools/test-p1-20020406-recursive-swap-v1.py` validates source
identity, matrix registration, real compiler runtime fingerprints,
original link-fail diagnostics, genuine guest exit/assertions,
linker symbols, recursive assembly, and ten fail-closed mutations.

The P1 **compiler-oracle construction** for this particular
historical reachable path is covered; no full original hosted
execution or algebraic correctness is implied. The live P1 v23
ledger preserves `hosted-malloc-calloc-printf-original-runtime`
as a distinct follow-up. Batch 4, slot 9 remains unchanged.
Current P1 construction totals: 52 covered, 0 partial, 15 blocked;
frozen 59-source batch positions: 44 covered, 15 blocked.

Focused reproduction, not a full sweep:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-20020406-recursion-compiler-20261120-v1" \
  --source tests/semantic/regression/pdp10-duptree-recursive-pointer-swap-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-20020406-recursive-swap-v1.py
python3 tools/build-p1-semantic-resolution-v23.py
python3 tools/audit-p1-source-batches-v22.py
```
