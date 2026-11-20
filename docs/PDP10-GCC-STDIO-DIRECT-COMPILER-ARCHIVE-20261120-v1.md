# Direct GCC formatter scripts: compiler stdlib only (v1)

Date: 2026-11-20. Scope: `pdp10-testkit` only. Neither installed
compiler/library nor a sibling repository was modified. No full sweep.

The registered compatibility scripts
`misc/compat/test-gcc-p10stdio-v1.sh` and
`misc/compat/test-gcc-p10stdio-v2.sh` previously passed
`$PDP10_PREFIX/lib/libc.a` directly to `dlink` in their production
formatter extraction test. This resolved to the compiler library only
when launched through the new compiler-only dispatcher prefix. A raw
direct invocation with the ordinary installed prefix could instead
pull in unrelated hosted/DAIMOS C-library definitions.

Both scripts now explicitly select the actual installed GCC compiler
archive at
`$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10c-v2.a`.
They keep their separate real `libp10stdio-v1.a` or `-v2.a` formatter
test inputs and canonical `libgcc`. The original target programs and
their expected stdout-free assertions are unchanged. Neither
`lib/libc.a` nor a test-only replacement library is passed explicitly
to the linker.

`p10run` additionally appends `PDP10_PREFIX/lib/libc.a` on its own.
The two raw scripts therefore build a compiler-specific temporary
prefix using the same `prepare_script_prefix()` implementation as the
registered guest dispatcher. Every actual `p10run` invocation uses
that temporary prefix. Its `lib/libc.a` is a symlink to the installed
GCC `libp10c-v2.a`, even when the script is launched directly with an
ordinary installed `PDP10_PREFIX`. The generated prefix is checked
against the real compiler archive hash. KCC/GCC archive equality is
not required for this GCC-only fixture; mixed compiler test suites
still require it. The prefix is removed with the fixture's existing
temporary work directory unless `P10_STDIO_KEEP_WORK=1` is set.

The versioned registered host validator
`tools/test-gcc-p10stdio-compiler-archive-v1.py` checks both
compatibility scripts' exact compiler-archive contract, normal test
registration and twelve script negative mutations. With `--require-cross`,
it compiles the real GCC formatter client, assembles the real CRT,
exit and abort sources, and confirms successful `dlink` extraction
of all four formatter symbols from both production archives, linked
against compiler `libp10c-v2.a` and canonical libgcc. This focused
link check does not require or execute a full CPU matrix.

Four focused real PDP-6 `O0` guests were executed by calling the
**unaltered entrypoints of both raw scripts**, starting with the
ordinary installed prefix whose generic `lib/libc.a` has different
bytes from the compiler library. The optional
`P10_STDIO_CELLS=pdp6-O0` runs only the pair of selected native
assertion programs per script; the default retains the historic
16-cell, four-CPU execution list.

| Native compiler formatter | Test | Result |
| --- | --- | --- |
| GCC v1 | `gcc-p10stdio-memory-v1.c`; historical `920726-1.c` | 2 PASS |
| GCC v2 | `gcc-p10stdio-memory-v1.c`; historical `920726-1.c` | 2 PASS |

All four guests used the real installed GCC formatter assembly, real
compiler stdlib and upstream CRT. The exact real guest report, map,
compiler assembly and runtime compiler-policy stamp for each version,
plus both extraction maps, are SHA256-pinned in
`PDP10-GCC-STDIO-DIRECT-COMPILER-EVIDENCE-20261120-v1.tsv` and
`refs/p10tk-gcc-stdio-direct-20261120-v1.tar.gz` (16 artifacts).
Three additional negative controls reject missing/corrupted real
guest evidence, for **15 total controls**. These observations do not
replace the historical complete multi-CPU suite.

The other raw direct `p10run` scripts still require explicit
source/owner inspection. The registered compiler guest groups already
inherit the compiler-only prefix automatically, but an arbitrary
standalone raw script cannot be claimed isolated without tracing
its library and environment overrides. In particular, test-tool
install/cleanup fixtures deliberately construct isolated prefixes
and must not be silently rewritten as compiler semantic tests.

Focused non-sweep verification:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/test-gcc-p10stdio-compiler-archive-v1.py --require-cross
P10_STDIO_CELLS=pdp6-O0 sh misc/compat/test-gcc-p10stdio-v1.sh
P10_STDIO_CELLS=pdp6-O0 sh misc/compat/test-gcc-p10stdio-v2.sh
```
