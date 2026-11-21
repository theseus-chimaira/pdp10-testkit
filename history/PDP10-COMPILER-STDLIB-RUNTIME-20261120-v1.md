# Use the compiler standard library for PDP-10 compiler tests (v1)

Date: 2026-11-20. Scope: **`pdp10-testkit` normal compiler matrix**.
The large compiler/CPU/optimization sweep remains deferred.
No compiler, assembler, emulator, installed library, DAIMOS or other
repository was edited. No historical imported source was changed.

## Installed compiler standard library, not OS libc

The installed `p10run` implementation builds its link command around
`$PDP10_PREFIX/lib/libc.a` if that path exists. With the ordinary
prefix this implicitly brought in the installed generic/hosted libc
and gave many compiler tests an unrelated runtime provider. This
explains why old exact originals sometimes reached a hosted `malloc`
timeout or duplicate `exit`/`abort`/`vsprintf` instead of reporting
their missing *compiler-library* services. Those old genuine results
remain pinned in their original v1 evidence reports.

The compiler-owned KCC and GCC freestanding C archives are installed at:

* `$PDP10_PREFIX/lib/kcc/freestanding/libp10c-v2.a`
* `$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10c-v2.a`

Both installed archives currently have SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.
They provide genuine compiler library routines such as `memset`,
`memcpy`, string operations and PDP-6 floating conversion fragments.
Their installed KCC build manifest does **not** include a hosted
`malloc`, `isspace` or console `printf`. The testkit must not invent
these functions or substitute DAIMOS libc to turn a test green.

## Corrected normal semantic runner

The real compiler and assembler installations remain available from
the configured `$PDP10_PREFIX`. For each selected compiler, the
testkit now prepares a **versioned temporary runtime prefix** inside
the requested output directory:

`compiler-stdlib-prefix-v1/{kcc,gcc}/`

Each directory contains only a `bin` symlink to the real installed
tools, and `lib/libc.a` as a symlink to **that compiler's own**
`libp10c-v2.a`. Each child `p10run` invocation receives this runtime
prefix via its private environment. The parent process, compilers,
target headers, other test scripts, and actual installation are
unmodified. The installed compiler's own `libgcc.a` continues to be
selected by the GCC driver. The normal source compiler still loads
its genuine freestanding C library members where required. No
DAIMOS library is installed in, or selected by, these runtime
prefixes.

The prefix preparation rejects missing compiler archives, foreign
or redirected symlinks, non-symlink runtime libraries, changed
archive contents at a previously prepared prefix, and unknown
compilers. A normal semantic checkpoint now records the exact
`runtime_library_policy=compiler-stdlib-v1` and the archive SHA256.
An older semantic PASS/checkpoint with no valid policy, or the wrong
archive SHA256, **must be re-run**. Non-executing codegen and
diagnostic test checkpoints are not invalidated by the libc switch.

## Fresh selected PDP-6 results

Only eight selected cells were executed after the policy change:

| Unchanged original or native companion | KCC PDP-6 noopt | GCC PDP-6 O0 |
| --- | --- | --- |
| `920810-1.c` | `link_fail` missing `malloc` | `link_fail` missing `malloc` |
| `980707-1.c` | `link_fail` missing `isspace` | Not selected |
| `920501-8.c` | Not selected | `link_fail` missing `printf` |
| `990628-1.c` | `link_fail` missing `malloc` | `link_fail` missing `malloc` |
| `pdp10-record-fetch-copy-v1.c` | **PASS** | **PASS** |

The passing record-copy companion still links the real installed
compiler's `memset` and completes its 101-native-int aggregate-copy,
9-bit byte-pattern and guard assertions. The six original sources
are **not** compiler PASS results. The absence of hosted services
is now exposed as a real linker failure. The previous original
timeouts and duplicate-global diagnostics remain valid *historical*
outcomes for the old generic/hosted archive policy, not current
compiler-only outcomes. The original 67-source P1 ledger is unchanged
at **49 covered source constructions, zero partial, 18 blocked**.

The authoritative eight exact source/profile/status/checkpoint
records and 28 generated source outputs (including actual successful
SIMH reports and maps) are SHA256-pinned in
`PDP10-COMPILER-STDLIB-RUNTIME-EVIDENCE-20261120-v1.tsv` and
`refs/p10tk-compiler-stdlib-runtime-20261120-v1.tar.gz`.
`tools/test-compiler-stdlib-runtime-v1.py` has nine negative
controls. `tools/test-compiler-stdlib-prefix-v1.py` has ten
further controls covering library ownership, symlink safety and
checkpoint invalidation.

## Explicit limitation and next implementation step

The primary `run-tests.sh`/`tools/run-tests.py` semantic matrix
now enforces this policy by default. **Separately dispatched legacy
special/regression scripts that call the installed `p10run` directly
may still use the ordinary prefix and its generic libc**. They are
not covered by this change or by its PASS statement. Before the
deferred full sweep, bring those independent entrypoints under a
compiler-library-only runtime selection with equally strict
per-compiler ownership and checkpoint/provenance controls. Do not
silently alter their source or historical results.

For a focused native reproduction only:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh \
  --out-dir "$TMPDIR/p10tk-compiler-stdlib-probe-20261120-v1" \
  --source tests/semantic/regression/pdp10-record-fetch-copy-v1.c \
  --compiler all --family native --cpu pdp6 --opt noopt,o0 -j 2
python3 tools/test-compiler-stdlib-prefix-v1.py
python3 tools/test-compiler-stdlib-runtime-v1.py
```
