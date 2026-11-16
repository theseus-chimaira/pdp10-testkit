# Cross-repository toolchain test census (2026-11-16, v1)

This is a **static inventory**, not a test run. Registration, textual script
references, matching filenames, and identical source bytes do not prove
execution, equivalent assertions, or correctness. The accompanying 334-row
manifest is `CROSS-REPO-TEST-CENSUS-20261116-v1.tsv`.

Reproduce from the `pdp10-testkit` checkout:

```
python3 tools/census-cross-repo-v1.py \
    --output docs/CROSS-REPO-TEST-CENSUS-20261116-v1.tsv
```

Without `--output` the census reads repositories and prints a summary only.
The script uses tracked Git files; it does not compile, link, assemble, or
run guests. Static references may occur in comments, and dynamic dispatch
may evade the scanner. Source equivalence needs assertion-level review.

## Local source revisions

| Checkout | HEAD |
| --- | --- |
| `pdp10-testkit` | `df13c99b62f6` |
| `kcc` | `dfad3b9ef840` |
| `gcc-pdp10` | `ab490b4b3d68` |
| `das` | `a956d0c4e2f5` |
| `pdp10-tools` | `fbef3d0334d9` |
| `DAIMOS` (host tools) | `baed9e39a84c` |

Independent KCC, DAS, and PDP10-TOOLS do not have tracked standalone test
directories analogous to GCC's `gcc/testsuite`. Their focused tests mainly
reside in `pdp10-testkit`; this does not prove full behavioral coverage.

## Central registrations

| Item | Count |
| --- | ---: |
| Registered compiler matrix sources | 1,986 |
| Specialized registrations | 211 |
| Enabled / manual special entries | 206 / 5 |
| Tracked `misc/` shell/Python scripts | 302 |
| `misc/` scripts with special registration | 201 |
| Registry-dispatched `misc/` entries | 179 |
| Registered DAS scripts on aggregate-only dispatcher | 19 |
| Registered manual `misc/` entries | 3 |
| Unregistered `misc/` scripts with static reference | 95 |
| Unregistered `misc/` scripts with no discovered static reference | 6 |

Ten more special registrations name `tools/` or `tests/` paths. The normal
`verify` suite includes 153 enabled entries across `verify`, `compat`, and
`validation`, **not** all 206 enabled entries. Other suites need explicit
selection. This census did not exercise any matrix cell or special suite.

The six static no-reference candidates are:

```
misc/compat/test-aap-illegal-relocation-probe-v1.py
misc/compat/test-aap-timing-trace-v1.py
misc/compat/test-pdp6-opcode-report-v1.py
misc/compat/test-pdp6-profile-comparison-v1.py
misc/das/check-das-native-image.py
misc/validation/analyze-aap-pdp6-emnf-case9-v1.py
```

These may be diagnostics or dynamically invoked utilities, not necessarily
six missed tests. Three unregistered UTF-9 compatibility scripts **are**
referenced by the independent `pdp10-tools/Makefile` `check-utf9` target.

## GCC imports versus original testsuite

| GCC source directory | C sources | Filename match in testkit `tests/` | Byte-identical in testkit `tests/` |
| --- | ---: | ---: | ---: |
| `gcc.c-torture/execute` | 790 | 734 | 714 |
| `gcc.c-torture/compile` | 433 | 426 | 422 |
| `gcc.dg` | 635 | 93 | 43 |

These are **source** matches, not active matrix entries or execution results.
Tests needing DejaGNU directives, unavailable hosted APIs, other CPUs,
unsupported extensions, or unsupported target profiles may be excluded
deliberately. The central upstream classification retains 269 deferred cases
requiring separate compiler/runtime/portability review.

All 19 tracked files in `gcc.target/pdp10/` (15 `.c`, four `.sh`) have neither
an identical basename nor identical bytes in the testkit `tests/` tree:

```
bare-dlink-libgcc-1.c          bare-dlink-libgcc.sh
blt-component-word-offset-1.c bss-word-reserve-1.c
bss-zero-aggregate-1.c        char6-cast-1.c
char6-sixbit-1.c              char6-type-1.c
cross-word-bitfield-store-1.c das-octal-adjbp-1.c
das-octal-immediate-1.c       default-base-stack-1.c
its-circ-1.c                  libgcc-badptr-octal.sh
libgcc-empty-static-members.sh
udivmod-general-positive-divisor-1.c
wide-convert-71.c             wide-int-mode-macros.c
wide-int-mode-options.sh
```

Some behavior could be tested under renamed/adapted files. Review source
assertions, compile flags, assembler/linker expectations, and CPU constraints
before marking any of these as untested or importing a duplicate.

## DAS assembler

All 19 DAS special registrations are marked `yes`, but
`tools/run-misc-suites.py` executes hardcoded aggregate lists rather than
those registry rows. Eleven DAS script filenames occur directly in that
dispatcher; seven others are mentioned by nested aggregate scripts. The
registered `build-das-native.sh` has no discovered static caller.

Of 104 tracked shell/Python scripts under `misc/das/`, 19 have direct
registration. The remaining 85 are mostly internal checker/helper scripts,
not 85 demonstrated missing tests. The standalone
`check-das-native-image.py` needs ownership review. Individually recorded
per-DAS-test statuses and timeouts do not yet follow from the registry.

## Independent PDP10-TOOLS versus DAIMOS host tools

The specialized tools suite defaults to `../DAIMOS/tools/host`, not
`../pdp10-tools`. Its aggregate runner assumes the DAIMOS `BUILD_ROOT` and
`build/tools/host` output layout; the independent Makefile differs. Merely
overriding the source path cannot establish equivalent execution.

The source trees share 33 tracked C/header paths; **13 differ in bytes**,
including `dlink.c`, `p10fold.c`, and `p10run.c`. The versioned TSV lists
all 13. The independent Makefile builds 30 utilities; selected object,
linker, folding, runner, CSIX, and install tests are aggregated, but there is
no proven per-utility regression matrix. Its `TODO.MD` specifically requests
direct `mkdt`, `mkstream`, and `words2pt` tests.

## Priority for the next integration stage

1. Fix independent `pdp10-tools` build/source selection, and record the
   actual revision tested. Do not conflate it with DAIMOS host tools.
2. Dispatch DAS/tool specials from authoritative registration rows while
   preserving prerequisites, fast/full/native groupings, and avoiding double
   execution of nested tests.
3. Perform an assertion-level crosswalk of the 19 GCC-specific files and
   document equivalent, incompatible, deferred, or genuinely absent checks.
4. Review the six static no-reference scripts and classify the indirect
   scripts as helpers, independently runnable checks, or optional diagnostics.
5. Only then conduct a **separate execution audit** with source hashes,
   compiler flags, CPU profiles, timeouts, and explicit success/failure data.

No compiler or assembler tests were executed to create this census.
