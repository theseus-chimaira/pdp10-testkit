# GCC flexible-array member ICE repair (2026-11-23)

## Source and diagnosis

The existing testkit source
`tests/codegen/kcc-ported/flexible-array-members-semantic.c` checks
the layout of structs with trailing `char[]` and `int[]` flexible array
members and stores to an allocated object through such a member.

Before the fix, 16 GCC cells crashed in RTL expansion, at the final
statement of `main`. AddressSanitizer established the stack:

```text
host_integerp (tree.c)
tree_low_cst (tree.c)
single_component_in_word_p (expr.c)
expand_assignment (expr.c)
```

`single_component_in_word_p` scanned all fields and unconditionally
read `DECL_SIZE_UNIT` even for a valid flexible-array member, where
this value is absent. The optimized whole-word store cannot be proven
safe if a member has an unknown extent. The compiler now rejects the
shortcut when any scanned field has an unavailable size/offset, and
uses normal assignment expansion. This is not a test exclusion.

## Results

The repaired compiler built without sanitizer and was staged using
the existing testkit GCC driver. All 414 cells from the original GCC
ICE baseline were rerun, with exact matching test/profile keys.

Result file: `workdir/ice-retest-20261123-v6/results-v1.tsv`.

| Outcome | Previous v5 | Current v6 |
| --- | ---: | ---: |
| `compiler_ice` | 79 | 63 |
| `pass` | 126 | 142 |
| `compile_fail` | 176 | 176 |
| `run_fail` | 33 | 33 |
| Total | 414 | 414 |

Exactly 16 cells transitioned from `compiler_ice` to `pass`, all from
the flexible-array source. No other cell changed status. The new
compiler was not installed in `$PDP10_PREFIX` during these checks.

## Remaining work

The 63 remaining GCC ICE cells cover eight sources. `20020617-3.c`,
`goto-1.c` and `20010329-1.c` each have 11 ICE cells. The other
failures are `20011217-2.c` (9), `991228-1.c` (9), `BLT.c` (7),
`20020321-1.c` (3), and `pdp10-gnu-dec-signbit-function-v1.c` (2).
The 33 independent runtime failures in `libgcc_helper_ownership_fp.c`
still need runtime analysis.
