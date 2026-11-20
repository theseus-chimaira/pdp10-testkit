# Historical va-arg-21: native va_end pointer side-effect oracle (v1)

Date: 2026-11-20. Scope: `pdp10-testkit` only. The original source,
installed compilers, assemblers, linkers, target C libraries, headers,
emulators and sibling repositories have not been modified. The full
compiler/CPU/optimization sweep was not started.

## Unchanged upstream original and real hosted-link failures

The original `tests/semantic/upstream/extensions/va-arg-21.c`, SHA256
`dedc44188f3fd1c561cd63e1d964c7f0beb5c077b4802c961b0eb7f4a6c7fbd9`,
allocates two `va_list` objects using `malloc`, with a NULL pointer
between them. It performs `va_start`, calls `vprintf`, then invokes
the precise original expression `va_end(**ap_ptr++)`. The expected
side effect increments the pointer into the NULL middle slot; a
separate `ap_ptr++` skips the sentinel, and a second `va_start` and
`vprintf` access the third `va_list` object. The test checks that
this middle slot was skipped. No original result is a compiler PASS
merely because it can compile.

Fresh targeted native PDP-6 results against *compiler-owned*
`libp10c-v2.a` are both **link_fail**, with genuinely different
missing hosted services: KCC noopt reports `dlink: undefined symbol:
vprintf`; GCC O0 reports `dlink: undefined symbol: malloc`. Their
historical statuses remain provenance only, not proof of current
guest execution. No malloc or vprintf stub was introduced and no
DAIMOS/general OS libc was linked.

## Separate compiler-owned stdarg semantics oracle

`tests/semantic/regression/pdp10-vaend-pointer-sideeffect-v1.c`,
SHA256
`b117d54a8dbc8ffbed6be25e8c841a9c7f9d9edf25ad47ccb5014ceb4b0aa4c8`,
uses *actual compiler* `<stdarg.h>` and two automatic `va_list`
objects. It preserves the three-entry `va_list *ap_array[3]`,
the NULL middle pointer, two real `va_start` sequences, two real
`va_arg` reads of different integer values per sequence, and
`va_end(**ap_ptr++)` followed by an independent `ap_ptr++`.
It checks the side effect at the **immediately following** assertion,
before advancing past the NULL slot. This avoids accidentally
passing solely because the second pointer increment is correct.
The second `va_end(**ap_ptr)` and a third set of source/guard
checks ensure the pointer array and vararg values remain intact.
The companion neither defines its own `va_end` nor emulates hosted
formatting or allocation.

| Native PDP-6 profile | Actual companion guest outcome |
| --- | --- |
| KCC noopt | **run_fail**, `fail_id=4` |
| KCC opt | **run_fail**, `fail_id=4` |
| GCC O0 | PASS |
| GCC O1 | PASS |
| GCC O2 | PASS |
| GCC Os | PASS |

All six profiles reach real SIMH HALT with the compiler-only
`libp10c-v2.a` archive SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.
GCC reports have both `fail_id=0` and `__test_exit=0`. KCC reports
have `fail_id=4` and `__test_exit=1`, rather than silently passing.

The installed KCC target `<stdarg.h>` snapshot, SHA256
`99d3e321cd11dc44db2545be9c5b12f0336dcb12e002b0b504904a7e3723de42`,
explicitly contains:

```c
#define va_end(ap) ((void)0)
```

Consequently `va_end(**ap_ptr++)` does not evaluate `ap_ptr++`
under KCC. This explains the actual native failure at ID 4 and
identifies a **KCC compiler-header semantic defect**. The installed
GCC `<stdarg.h>` uses `__builtin_va_end`; its SHA256 is
`a43e740c99baa8b131033c467cbef49ebbf86761df76de321c0b23d893af1901`.
The failing KCC macro must be fixed in its owning compiler/header
project rather than worked around or replaced inside the testkit.

## Archived evidence, limitations and next repair

`PDP10-P1-VAARG21-VAEND-EVIDENCE-20261120-v1.tsv` contains all eight
real source/profile results and SHA256 of each saved output. The
versioned archive `refs/p10tk-p1-vaarg21-vaend-20261120-v1.tar.gz`
contains **38** members: original compiler/link logs, generated
assembly and status for two original cells; linked guest reports,
maps, assembly, logs and status for six companion cells; and
exact snapshot copies of both installed compiler `stdarg.h` headers.
Archive SHA256:
`dc8c475d760deb5c167e103846d9ac2f92a68a09a4cd31b6e88d0c4e843a3623`.

The registered validator `tools/test-p1-vaarg21-vaend-v1.py` verifies
exact source and header identities, original missing-provider
diagnostics, compiler runtime fingerprints, actual guest HALT and
octal assertion values, linker symbols, all evidence SHA256s and
11 negative mutation controls. It does not rerun a guest or change
any compiler files.

The P1 **test-oracle construction** for `va-arg-21.c` is covered, but
the original hosted `malloc`/`vprintf` runtime, the complete original
formatting output and KCC `va_end` behavior **remain unresolved**.
The source keeps its frozen batch 6, slot 9 assignment. The v25 P1
resolution ledger has **54 covered / 13 blocked**, and the 59 fixed
batch positions have **46 covered / 13 blocked**.

Focused reproduction (the companion command returns failure status
because KCC correctly remains a real failing native guest):

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-vaarg21-compiler-oracle-20261120-v1" \
  --source tests/semantic/regression/pdp10-vaend-pointer-sideeffect-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-vaarg21-vaend-v1.py
python3 tools/build-p1-semantic-resolution-v25.py
python3 tools/audit-p1-source-batches-v24.py
```
