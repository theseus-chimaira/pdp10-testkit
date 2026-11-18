# Focused PDP10 testkit prerequisite and deferred evidence (2026-11-18, v2)

## Scope and source integrity

Continuation of the 2026-11-17 v1 checkpoint, based on Git commit
`1140c1f`. This is exclusively `pdp10-testkit` compiler, linker,
assembler and ABI work; it does not run the DAIMOS OS tests or the full
GCC/KCC/CPU/optimization matrix. Original imported C tests and their
assertions are unchanged. The independent 269-source SHA256 dispositions
remain deferred. This version adds observations without activating sources.

The matching `PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v2.tsv` retains
all v1 fields and adds two **separate**, profile-specific 2026-11-18 status
columns and a test-batch marker. All 269 original file hashes were checked
again. Unexecuted sources are `not-probed`, never `pass`.

## Split KCC runtime and compatibility tests

Previously, 24 compatibility scripts and five KCC regression scripts passed
a nonexistent monolithic `$KCC_RT` source to `p10run`. That masked their
real compiler/link/runtime results. The unused argument was removed from
all 29 scripts, and the dead `KCC_RT` export removed from both test
environment scripts and the compiler matrix environment setup. The
matrix's existing **symbol-specific** KCC runtime resolver remains intact.
It still selects actual installed machine-specific fragments if a semantic
test genuinely calls one.

The *actual* 24 compatibility tests were run and then rerun after the final
fixes, separately from the broader 124-entry compatibility registry.
The final focused execution again reports **21/24 pass**. All **5/5**
affected KCC regression scripts pass, including the
PDP-6/KA10/KI10/KS10 ADJBP-marshalling assertions and packed
byte-pointer/aggregate tests.

Specific repairs and verified reruns:

- `test-kcc-gcc-direct-abi.sh` supplies
  `$PDP10_PREFIX/lib/kcc/ks10rt-kdfad.s` *only* for an assembly input
  referencing `$KDFAD`; both mixed-direction runtime checks pass.
- Two tests used the obsolete monolithic `libgcc1.s`, whose assembly
  fails with duplicate local symbol `%L1`. Their input is removed:
  `p10run` already extracts the needed members of the installed canonical
  GCC `libgcc.a`. The GCC signed/unsigned 71-bit divide/modulo test
  now passes; the combined compiler runtime-helper test progresses to an
  actual failed result.
- `mixed-call-support.s` defines both `__main` and
  `__test_exit`. Several unchanged C main sources also define their own
  `__test_exit`. Removing the duplicate support object where unnecessary
  resolves the duplicate-global link failure, while leaving the startup,
  original source and `--expect __test_exit=0` assertion in place.
  Negative-DImode ABI, relocations and the two packed-bit-pointer tests
  now pass.
- Existing `TMPDIR` fallbacks touched in these scripts use
  `$HOME/tmp` rather than `/tmp`.

Three *real*, still failing compatibility results must not be hidden:

| Script | Observed status | Failed original assertion |
| --- | --- | --- |
| `test-mixed-call-depth.sh` | run failure (`__test_exit=4`) | `abi_check_preserved_v24()`: saved-register integrity across a mixed deep call |
| `test-packed-char.sh` | GCC run failure (`__test_exit=010`, octal 8) | `check_pointer(values)`: pointer step over a packed 3-character aggregate |
| `test-kcc-gcc-runtime-helper.sh` | run failure (`__test_exit=2`) | `kcc_mod_v34(-12345,37)`: negative 71-bit remainder differs from `-24` |

The installed split-runtime migration is complete for the tested compatibility
and KCC regression scripts. This does **not** prove the entire compatibility
registry or cross-CPU/compiler matrix passes. Three further KCC-host
prerequisite tests pass: `daimos-kcc-findptr-reverse-20261010`,
`daimos-kcc-typed-pointer-reverse-20261011`, and
`kcc-native-short-paths-20261010` (all 86 original commands retain
arguments/destinations).

The outstanding `make` prerequisite for several other `kcc-host` tests
has not changed: the available `make` is GNU Make 4.4.1, but the scripts
require a `gmake` executable, which is absent, and genuine BSD make
(`bmake`, `BMAKE`, `MAKESYSPATH`) is not available/configured.

## Two new bounded batches of deferred semantic sources

The unmodified 269-row original disposition is still the source of truth
for blocker categories. The v2 triage TSV records **27 distinct** source
identities and **54 executed PDP-6 cells** in two focused batches, not a
full matrix sweep.

| Source category | Sources | KCC `-n` passes | GCC `-O0` passes |
| --- | ---: | ---: | ---: |
| Previous `libc-linkage` | 13 | 5 | 10 |
| Previous `header-integration` | 14 | 5 | 8 |
| **Total new** | **27** | **10** | **18** |

Reproduction uses `tools/probe-deferred-libc-v1.py --compiler all` and
repeated `--source` paths as enumerated in the v2 TSV, with separate
`--outdir` values. Full compiler/linker/simulator logs, diagnostic excerpts
and per-cell statuses are preserved in the operator's scratch directories:

- `$TMPDIR/p10tk-deferred-libc-20261118-v2`
- `$TMPDIR/p10tk-deferred-headers-20261118-v2`

The 24-script final compatibility rerun is recorded under
`$TMPDIR/p10tk-compat-split-runtime-20261118-v3/results-v3.tsv`.
The five KCC-regression logs are under
`$TMPDIR/p10tk-kcc-regression-runtime-20261118-v2`; the three
additional KCC-host logs are under
`$TMPDIR/p10tk-kcc-host-prereq-20261118-v2`.

Concrete results from the libc-linked group:

- KCC and GCC both pass unchanged `921117-1.c`, `930725-1.c`,
  `950426-1.c`, `980506-3.c` and `memcpy-bi.c`. Installed
  freestanding memory/string implementations can satisfy these cases,
  but additional profile and assertion reviews are still required.
- GCC passes `string-opt-4.c`; KCC links against an **unprovided**
  `__builtin_strchr` symbol. That is not the same symbol as the
  installed plain `strchr`.
- `extensions/20010518-2.c` and its PDP10 copy run but fail their
  assertions under both compilers. `pdp10/20020507-3.c` passes only
  under GCC. These are no longer appropriately described as *only*
  missing `memcpy` linkage.
- KCC still lacks a linkable `alloca` in `20020314-1.c` and
  `__kcc_umoddi3` in `920501-2.c`. GCC runs the latter but fails.
  Compiler language diagnostics also persist for GNU-specific
  `__SIZE_TYPE__` and `restrict` cases.

Concrete results from all 14 header-dependent sources:

- Both compilers pass `990513-1.c`, `wide-int/strcmp-1.c` and
  `wide-int/strncmp-1.c`.
- `960521-1.c` and `990628-1.c` compile but **both** fail to link
  `malloc`. GCC `pdp10/20020406-1.c` has the same hosted-allocator
  prerequisite; its KCC compilation fails earlier. Installed header
  presence is not evidence of an allocator implementation.
- KCC passes `memcpy-2.c` and `memset-1.c`, but GCC fails runtime
  assertions in those two sources; both compilers fail `memcpy-1.c`.
  Preserve the failing assertions before investigating compiler lowering
  or target byte semantics.
- KCC fails `loop-3c.c` at runtime despite GCC passing; unsupported
  source constructs or parser diagnostics remain for other KCC cases
  such as `builtin-abs-1.c` and `widechar-2.c`.

The findings require **refinement of blocker evidence**, not blanket
reclassification: plain `malloc` is hosted-runtime, GNU
`__builtin_*` is compiler-feature/lowering policy, and executed
assertion mismatches are real semantic issues until investigated. No
dummy function implementations, fake termination stubs or altered source
assertions were introduced.

## Prerequisites before the complete matrix

1. Diagnose and fix the three newly unmasked compatibility runtime
   regressions in their owning compiler/ABI, without weakening test oracles.
2. Address `malloc`/hosted-service prerequisites independently from
   production freestanding archive extraction.
3. Review GNU compiler feature policy and the missing KCC unsigned-DImode
   modulo helper; determine if the helper is a compiler or runtime library
   integration defect.
4. Continue the remaining source categories and verify meaningful passing
   assertions across CPU/optimization profiles before any matrix activation.
5. Provide real GNU/BSD make prerequisites and execute the rest of the
   registered `kcc-host` tests before claiming complete special-suite
   coverage.

No full compiler/CPU matrix sweep was started.
