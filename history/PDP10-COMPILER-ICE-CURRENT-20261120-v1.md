# Current installed PDP-6 compiler ICE revalidation (v1)

Date: 2026-11-20. Scope: `pdp10-testkit` compiler-testkit only.
No compiler, linker, assembler, runtime, installed library or other
repository was changed. This is a targeted revalidation, **not** the
full compiler/CPU/optimization sweep.

## What was rechecked

The frozen `PDP10-INITIAL-SWEEP-FAILURES-20261117-v1.tsv` contains nine
`compiler_ice` codegen rows: six GCC and three KCC. Each original
source was selected individually at the historical native PDP-6
compiler/optimization profile. The selection command omitted the
`--family native` restriction, so each invocation also selected the
matching PDP-6 `base` profile: 18 selected cells total. **Only the nine
historical native cells are source/status-SHA-pinned by this report**.
The exact native-profile classification is `compiler_ice` for all nine.

| Source under `tests/codegen/` | Installed profile | Current failure |
| --- | --- | --- |
| `upstream-gcc/compile/20011217-2.c` | GCC PDP-6 O0 | `instantiate_virtual_regs_1` (function.c:4444) |
| `upstream-gcc/compile/20020617-3.c` | GCC PDP-6 O0 | `instantiate_virtual_regs_1` (function.c:4444) |
| `upstream-gcc/compile/930120-1.c` | GCC PDP-6 O2 | `instantiate_virtual_regs_1` (function.c:4290) |
| same source | GCC PDP-6 O1 | same internal error |
| same source | GCC PDP-6 Os | same internal error |
| `upstream-gcc/compile/goto-1.c` | GCC PDP-6 Os | `cc1` segmentation fault |
| `upstream-gcc/compile/920501-22.c` | KCC PDP-6 noopt | `simsmove: bad size 0` and `gizlist` internal errors |
| `upstream-gcc/compile/init-1.c` | KCC PDP-6 noopt | `gizlist: bad size 0` |
| `gcc-historical-b08-v1/line4.c` | KCC PDP-6 noopt | No compiler diagnostic; direct command exits on SIGSEGV |

`line4.c` is not a normal source diagnostic. A second, direct KCC
invocation with the same options produced **returncode -11** (signal
11 / SIGSEGV), with no standard output. Its signal result is archived
separately to prevent a blank log from being mistaken for an ordinary
compile failure or source rejection.

## Archived, fail-closed evidence

The exact source identity, SHA256, compiler/profile, diagnostic class,
raw compiler log and native `status` checkpoint are pinned in
`manifests/PDP10-COMPILER-ICE-CURRENT-20261120-v1.tsv` and the versioned
`refs/p10tk-compiler-ice-current-20261120-v1.tar.gz` archive.
`tools/test-compiler-ice-current-v1.py` verifies source bytes,
historical provenance, live normal-matrix codegen ownership, all nine
reported `compiler_ice` statuses, exact compiler diagnostics where
available, the direct KCC SIGSEGV result, and all archived SHA256s.
Ten negative controls reject fabricated passes, source changes,
wrong profiles, missing matrix ownership and corrupted archived output.

All nine compiler defects remain **open and high priority**. The
testkit must neither suppress them nor mark their source rows
unsupported. Compiler repair requires separate work in the actual
compiler repository; this task did not change any compiler source.

For narrowly selected native reproductions only (not a general sweep):

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-ice-one-v1" \
  --source tests/codegen/upstream-gcc/compile/20011217-2.c \
  --compiler gcc --family native --cpu pdp6 --opt o0 -j 1
python3 tools/test-compiler-ice-current-v1.py
```
