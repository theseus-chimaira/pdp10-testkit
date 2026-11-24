# PDP-10 exact v28 linker-failure replay and ownership (v29)

Date: 2026-11-24. Scope: 50 historical link-failing semantic cells,
not the full compiler matrix. All originals and all semantic oracles
were left unchanged. No linker, compiler runtime, or test stub was
installed to turn an unresolved symbol into a false PASS.

## Source evidence and reproducible selection

The complete v28 selected-cell run covered 4,216 historical failed or
incomplete checkpoints: 327 PASS (80 prior PASS, 247 fresh), 2,810
run_fail, 1,029 compile_fail, 50 link_fail, zero timeout and zero
compiler_ice. Only the 50 link_fail rows were extracted into the
permanent six-column manifest:

`manifests/PDP10-V28-LINKER-FAILURE-CELLS-20261124-v29.tsv`

Manifest SHA256:
`2099dc6307fa415d5e6cd6f4369aafe9f00fa067bb1d4cf5de97db46735476a9`.

Fresh independent replay:

```sh
export TMPDIR=${TMPDIR:-$HOME/tmp}
export PDP10_PREFIX=${PDP10_PREFIX:-$HOME/cross}
python3 tools/run-tests.py \
  --cell-file manifests/PDP10-V28-LINKER-FAILURE-CELLS-20261124-v29.tsv \
  --out-dir workdir/known-link-failures-v29 \
  --exit-policy ice-only -j4
```

Actual result: 50/50 were reexecuted with zero old-green skips;
50 link_fail, zero PASS, zero ICE, zero timeout or incomplete cells.
The ice-only process exit was zero, but the raw result was 50 failures;
this is *not* strict acceptance. Exact local reports:

* `workdir/known-link-failures-v29/summary.txt`;
  SHA256 `497cc5aacd43b6596f49d181d3edabde4a99562d6135bf226d75cc62447d49a8`.
* `workdir/known-link-failures-v29/failures.tsv`;
  SHA256 `a5e5ee3fa8103cb666e04712c224fee0b437d46acd19585568da6b5f02ada2ee`.

## Exact missing-symbol census

| Compiler | Original source | Cells | Unresolved symbol | Cause / owner |
| --- | --- | ---: | --- | --- |
| KCC | `tests/todo/generic/20020314-1.c` | 22 | `alloca` | KCC lacks a proper function-local dynamic stack allocation builtin |
| GCC | `tests/semantic/gcc-historical-b08-v1/digraphs.c` | 4 | `puts` | OS console provider absent from bare-machine compiler stdlib |
| GCC | `tests/semantic/gcc-historical-b09-v1/macro1.c` | 4 | `puts` | Same runtime boundary |
| KCC | `tests/semantic/gcc-historical-b09-v1/macro1.c` | 4 | `puts` | Same runtime boundary |
| GCC | `tests/semantic/gcc-historical-b09-v1/paste2.c` | 4 | `puts` | Same runtime boundary |
| GCC | `tests/semantic/gcc-historical-b09-v1/strify3.c` | 4 | `puts` | Same runtime boundary |
| KCC | `tests/semantic/gcc-historical-b01-v1/20011115-1.c` | 4 | `undefined_reference` | KCC retains an unused `static inline` body |
| KCC | `tests/semantic/gcc-historical-b09-v1/macro3.c` | 4 | `c` | KCC macro rescanning/hideset semantics |
| **Total** | **7 distinct originals, 8 compiler/source pairs** | **50** | | **34 KCC, 16 GCC** |

### `alloca`: 22 KCC cells

The unchanged 20020314-1.c does `p = alloca(16)` in `g` between
double-precision calculations and a call that consumes `p`. KCC
diagnoses an undeclared function, implicitly converts the integer
result to a pointer, and emits `PUSHJ 17,alloca`; the linker correctly
reports an unresolved external. A separately linked ordinary helper
cannot provide the same caller-frame lifetime and stack restoration
as a compiler builtin. This must use KCC's real per-function dynamic
stack allocation machinery, preserve the frame/AC16 across calls, and
restore the original stack on return. Do not provide a dummy alloca
or change the original assertion. All 22 KCC native/base/PDP10
machine/optimization profiles are affected.

### `puts`: 20 GCC/KCC cells

All four original sources call `puts` from a reachable error-report
path before `abort()`. Their correct code generation therefore keeps
the reference even when the success path does not print anything.
The compiler-owned, OS-independent `libp10c-v2.a` intentionally has
no console backend. GCC's *separate* optional
`libp10stdio-daimos-v1.a` does implement `puts` with the real
DAIMOS WRITECHAR veneer; this functionality was validated in a
booted DAIMOS guest on 2026-11-23 (see pdp10-doc
`TOOLCHAIN/GCC-DAIMOS-CONSOLE-ARGV-GUEST-20261123-V1822.MD`).
The current bare-machine upstream semantic test runner must not
silently link the OS-specific provider. For KCC, a proper KCC ABI
console provider also requires concrete ownership/validation.
Neither a no-op `puts` nor an altered fail branch is acceptable.

### `undefined_reference`: 4 KCC cells

20011115-1.c deliberately guards an unresolved reference inside
`static inline foo` behind `if (foo == foo)`. The installed KCC
emits two MOVEI operands referencing the identical `$foo` address,
then a runtime CAME and a dead-edge JRST `$foo`. The `$foo` body is
also emitted with a relocation against `undefined_reference`.
An experimental targeted change to CCEVAL correctly reduced
`foo == foo` to 1 in the staged assembly, but KCC **still emitted
`$foo` and its unresolved relocation**. Therefore the experiment
did not repair linking and was reverted; the rebuilt local KCC
source was restored. The correct owner is KCC's treatment of unused
internal `inline` definitions and their reachability, not DLINK's
required-symbol resolver. Do not drop actual relocations in DLINK.

### `c`: 4 KCC cells

The C99 macro source macro3.c uses `#define c(x) d` and
`#define d(x) c(2)`. The intended `c(c)(c)` expression must
ultimately reference the initialized static variable `d`, not an
external function. The installed KCC `-E` output contains
`if (c(2) != 4)` and the assembly emits `PUSHJ 17,c` plus
`.extern c`. Other variadic-macro code in this source was already
reduced. This is a C preprocessor rescan/hideset boundary defect;
it is neither a missing libc entry nor a DLINK symbol-resolution bug.
Correct the macro-expansion algorithm and validate nested/recursive
macro negative cases rather than defining a synthetic `c` function.

## Disposition and priority

All 50 are reproduced; **none has been repaired or reclassified as
PASS**. There is no evidence of a genuine DLINK implementation
failure in this set: its unresolved-symbol diagnostics are accurate.

For subsequent fixes: first handle the 4-cell KCC macro rescan and
4-cell unreachable static-inline definitions (compiler correctness),
then evaluate real KCC `alloca` with its 22-cell stack/ABI oracle,
and keep the 20 hosted-console cases blocked until an actual
runtime/guest backend is explicitly selected. Each fix needs an
independent new strict runner output and adjacent-source checks.
