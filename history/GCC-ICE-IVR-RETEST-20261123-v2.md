# GCC virtual-register instantiation ICE repair (2026-11-23)

## Reproducer and root cause

The existing upstream GCC source
`tests/codegen/upstream-gcc/compile/930120-1.c` failed in
`instantiate_virtual_regs_1` (`gcc/function.c`) in 27 optimized GCC
profiles. At the failure, the containing RTL was a store whose source
was a nested subregister of the following form:

```text
(set (mem:SI (plus:SI (reg/f:SI virtual-outgoing-args)
                      (const_int -2)))
     (subreg:SI (subreg:DF (reg/v:DI 36) 0) 0))
```

The source was not recognizable as a PDP-10 word-move operand, even
after replacing the virtual outgoing argument pointer. The normal
virtual-register-instantiation fallback could not validate the full
instruction and aborted. This was not a problem with the address
offset alone.

The compiler now calls its standard `simplify_subreg` routine to
canonicalize the nested `SImode`/`DFmode`/`DImode` source in the
`SET` case before virtual-register substitution. The transform is
restricted to this exact sequence. Other nested subregister shapes,
including the separately recognized `CDImode` patterns, are preserved.

Temporary RTL diagnostics were removed from the final compiler patch.

## Staged rerun

Source: `workdir/ice-retest-20261123-v5/results-v1.tsv`.

The rerun covers exactly the same 414 original GCC ICE cells as
`workdir/ice-retest-20261123-v4/results-v1.tsv`.

| Outcome | Before IVR fix | After IVR fix |
| --- | ---: | ---: |
| `compiler_ice` | 106 | 79 |
| `pass` | 99 | 126 |
| `compile_fail` | 176 | 176 |
| `run_fail` | 33 | 33 |

The only 27 state transitions were for `930120-1.c`, from
`compiler_ice` to `pass`. No previously passing cell regressed.

## Still open

The 79 remaining GCC ICE cells cover nine sources:

| Source | ICE cells |
| --- | ---: |
| `tests/codegen/kcc-ported/flexible-array-members-semantic.c` | 16 |
| `tests/codegen/upstream-gcc/compile/20020617-3.c` | 11 |
| `tests/codegen/upstream-gcc/compile/goto-1.c` | 11 |
| `tests/semantic/upstream/generic/20010329-1.c` | 11 |
| `tests/codegen/upstream-gcc/compile/20011217-2.c` | 9 |
| `tests/semantic/upstream/extensions/991228-1.c` | 9 |
| `tests/isa/pdp10-insn/BLT.c` | 7 |
| `tests/semantic/gcc-historical-b01-v1/20020321-1.c` | 3 |
| `tests/semantic/regression/pdp10-gnu-dec-signbit-function-v1.c` | 2 |

The 33 `libgcc_helper_ownership_fp.c` runtime failures remain separate
from compiler ICEs. The installed GCC was not modified for this test;
all results came from the rebuilt compiler staged through the official
testkit cell runner. Do not describe compiler error recovery as
successful execution of an unsupported source.
