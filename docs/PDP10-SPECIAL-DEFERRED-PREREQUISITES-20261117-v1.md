# Specialized prerequisites, deferred semantic triage and installed libc (2026-11-17, v1)

## Scope and reproducibility

This is a focused PDP10 compiler/assembler testkit investigation, not a full
matrix sweep and not a DAIMOS kernel or OS test. The source worklist remains
the original SHA256-pinned
`SEMANTIC-DEFERRED-DISPOSITION-20261019-v1.tsv`. The matching 269-row
`PDP10-DEFERRED-BLOCKER-TRIAGE-20261117-v1.tsv` adds blocker families and
the *observed* PDP-6 native KCC `-n` and GCC `-O0` results for ten sources.
Every source hash was checked against the bytes on disk. An untested cell is
explicitly `not-probed`, not a passing result. No deferred source was
rewritten, promoted, or removed.

All tools came from the operational `PDP10_PREFIX=$HOME/cross`, on the
2026-11-17 checkout. The per-cell execution logs and simulator reports are
under `$TMPDIR/p10tk-deferred-probe-20261117-v1`; the independent active
variadic checks are under `$TMPDIR/p10tk-active-varargs-20261117-v1`.
The focused helper was `tools/probe-deferred-libc-v1.py`; it compiles
unchanged sources and checks `__test_exit=0` through the normal PDP-6
runner. Reproduce the ten-source sample by passing the ten paths in the
table below as repeated `--source` arguments, with `--compiler all` and
a versioned `--outdir`. The TSV preserves source identities and outcomes
independently of any temporary report directory.

## Specialized tests actually exercised

| Area | Executed prerequisite and result |
| --- | --- |
| DAS fast | `./run-misc-tests.sh das-fast`: **10/10 pass**; native relocation/bitmap probe emitted one host C pointer-to-int warning but its assertion passed |
| KCC host | Native build-directory topology and symbol-reuse checks pass. The array-bound test now passes after correcting its missing KCC repository include search and explicit assembly output name |
| KCC host make | GNU/BSD make portability check **not executable as configured**: `BMAKE` unset; `gmake` and `bmake` not found on PATH. This is a prerequisite blocker, not a compiler result |
| Compatibility | The mixed KCC/GCC varargs matrix passes after deleting its unused `ks10rt.s` input, which does not exist in the installed split runtime |
| Compatibility | New registered `installed-freestanding-archive-v1`: KCC and GCC both compile, archive-link and execute the C ABI test on PDP-6 |
| Compatibility | Existing `freestanding-search-v1`: **6/6 pass**, KCC optimized/noopt and GCC `-O0`/`-O1`/`-O2`/`-Os` on PDP-6 |
| Validation | KCC PDP-6 optimized and unoptimized floating-constant folding both pass |
| Host policy | Special-suite dispatch, deferred disposition, matrix inventory, fixture integrity and script-ownership audits pass |

The old `KCC_RT=$PDP10_PREFIX/lib/kcc/ks10rt.s` exported by
`tools/pdp10-env.sh` does not exist in the installed prefix. The real
runtime is separated into `*-adjbp.s`, `*-kdf*.s`, and common fragments.
Other legacy compatibility scripts still pass the old path. Each must be
audited for actual unresolved helpers; do **not** install a fake monolithic
runtime or link every helper unconditionally. A different runtime prerequisite
applies to KCC's host tests: tests requiring both GNU and BSD make need
those tools and `BMAKE`/`MAKESYSPATH` configured.

## Operational installed headers and freestanding library

The installed KCC `stdarg.h`, `stddef.h`, `string.h`, `stdlib.h`, and
`stdio.h` are byte-identical to `../kcc/self/include/`. KCC compiles
the new installed-header fixture. GCC's installed `string.h` is a C99
header using `restrict`, so GCC 3.2 is invoked with `-std=gnu99` and
`-fno-builtin`; its default language mode rejects the header.

The KCC and GCC installed `libp10c-v2.a` archives are byte-identical.
The new registered test assembles the CRT and compiler output with installed
DAS, links them with installed DLINK and the **installed** archive, and
requires exactly the independently referenced `memcpy`, `strlen`,
`strcmp`, and `strstr` member symbols. It rejects unrelated extracted
members such as `memset` or `strspn`. The GCC link additionally requires
installed `libgcc.a` for `__main`. Both links succeed, and independent
assembly-source execution of the same C program checks real calls and return
values on PDP-6 for KCC and GCC. This establishes operational archive
extraction and callable functionality; the simulator step does not itself
load the previously linked DXR.

This is **freestanding**, not hosted, libc validation. The installed target
`stdio.h` and `stdlib.h` declare routines such as `printf`,
`sprintf`, and `malloc` without supplying them in `libp10c-v2.a`.
The installed KCC header set also has no `varargs.h`, `stdbool.h`,
or `math.h`. Their use requires separate support/policy decisions. Do
not reclassify them as ordinary archive-extraction failures.

Three existing variadic examples (`va-arg-1.c`, `931004-10.c`, and
`pdp10/strct-stdarg-1.c`) pass under both KCC `-n` and GCC `-O0` on
PDP-6: **6/6 executions**. That is positive ABI evidence, not a claim
that every deferred historical varargs case passes.

## Current 269-source blocker breakdown

| Blocker family | Sources | Priority/gate |
| --- | ---: | --- |
| Compiler failure investigation | 51 | Preserve unchanged source and independent GCC/KCC diagnostics; investigate ICEs first |
| Freestanding libc linkage | 42 | Retest installed library and separate nonstandard built-ins |
| Extension feature policy | 38 | Verify target applicability before scheduling |
| Unsupported KCC extensions | 37 | GCC-only execution where meaningful; do not silently require KCC |
| Variadic ABI | 26 | Distinguish installed `stdarg.h` from unavailable old `varargs.h` and hosted varargs |
| Hosted libc | 23 | Requires real I/O/allocation services; not supplied by freestanding archive |
| Headers | 14 | Installed includes and compiler feature diagnostics, not merely file presence |
| Invalid/vacuous assertions | 12 | Reestablish meaningful observable assertion |
| Width/ABI adaptation | 10 | Independently derive PDP-10 byte/int/long expectations |
| Assembler and ISA | 8 | Explicit hardware/assembler prerequisites, including KL10-only input |
| Linker relocation | 4 | Diagnose object relocations and runtime-symbol resolution |
| Independent evidence retest | 4 | Reproduce historical failures and audit assertions |
| **Total** | **269** | **No automatic activation** |

For the 26 variadic ABI sources, 14 reference `stdarg.h` and 14 reference
`varargs.h` (some have both conditional paths). For the 42 libc-linkage
sources, 13 reference `strcmp`, ten `strcpy`, eight `strlen`, eight
`memcpy`, and six `memset`; these are source-text counts, not proven
undefined-symbol counts. The 23 hosted-libc sources include 15 `stdio.h`
references, making service availability a separate gating question.

## Ten unchanged deferred sources: observed results

| Source (under `tests/`) | KCC -n | GCC -O0 | Immediate interpretation |
| --- | --- | --- | --- |
| `todo/generic/20010124-1.c` | compile_fail | pass | KCC GNU size-type/pointer syntax remains a compiler/feature gate |
| `todo/generic/varargs/va-arg-2.c` | compile_fail | run_fail | Both toolchains need ABI/source investigation, not a dummy varargs fix |
| `todo/generic/generic/string-opt-13.c` | compile_fail | pass | GCC's installed string linkage works; KCC source/extension still unresolved |
| `todo/generic/20010915-1.c` | pass | pass | Historical GCC failure no longer reproduced; verify asserted meaning and other profiles |
| `todo/generic/20000822-1.c` | compile_fail | pass | KCC GNU nested-function policy versus supported GCC execution |
| `todo/generic/pdp10/920909-1.c` | link_fail | pass | KCC still reports `dlink: RH18 relocation overflow`; GCC does not |
| `todo/generic/pdp10/arith-ll.c` | link_fail | link_fail | Both require unavailable hosted `printf` |
| `todo/generic/20000227-1.c` | run_fail | pass | PDP-10 width/source-byte assertion still compiler-sensitive |
| `todo/generic/20000622-1.c` | run_fail | pass | KCC runtime semantic failure persists |
| `semantic/upstream/extensions/20000703-1.c` | link_fail | pass | KCC emits unresolved `__builtin_memcpy`; an ordinary `memcpy` archive cannot supply that symbol |

The overall sample is KCC **1 pass / 9 fail**, GCC **8 pass / 2 fail**,
for 20 cells total. These are not extrapolated to all 269 sources or to
other CPUs/optimization profiles. Compiler errors, link failures and failed
target execution remain distinct. In particular, a GCC-only pass cannot
validate an unsupported KCC extension or erase historical independent
compiler failure evidence.

## Follow-up gates before a full matrix sweep

1. Replace stale `KCC_RT` uses with actual per-program split runtime
   dependencies; run the remaining enabled compatibility and host tests
   with real make/BSD-make prerequisites.
2. Continue the deferred manifest in bounded disposition batches, starting
   with ordinary freestanding libc versus hosted runtime; then headers and
   old-style varargs. Keep the original source hashes and assertions.
3. Isolate the KCC RH18 relocation error, `__builtin_*` unresolved names,
   and KCC variadic runtime/type failures as separate compiler/linker work.
4. Validate library archive extraction and variadic results across additional
   CPU and optimization profiles before changing matrix classification.

This checkpoint does not authorize a full compiler matrix sweep.
