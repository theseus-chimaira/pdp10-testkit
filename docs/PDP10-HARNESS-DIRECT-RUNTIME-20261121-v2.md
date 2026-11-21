# Direct p10run compiler-runtime isolation and ownership (v2)

Date: 2026-11-21. Scope: registered testkit harness only. Compiler,
library implementation, simulators, or guest assertions were not changed.

## Problem and resolution

Raw calls of installed `p10run` resolve `lib/libc.a` using their
`PDP10_PREFIX` environment. The default installed archive can instead
be an operating-system libc. The official special-test dispatcher
already selects a compiler freestanding runtime for registered guest
groups, but standalone scripts may be invoked without that dispatcher.

Two more registered tests now use the existing compiler-library-only
`prepare_script_prefix` mechanism with the installed GCC archive:

| Registered ID | Versioned active script | Native checks |
| --- | --- | --- |
| `badl-tables` | `misc/validation/test-badl-tables-v2.sh` | Five BADL helper references, original GCC driver link, PDP-6 and KA10 guest assertions and report provenance |
| `gcc-char-word-boundary-v45` | `misc/validation/pdp10-gcc-char-word-boundary-v46.sh` | Original v45 C fixture at O0, O1, O2 and Os on PDP-6 |

Their prior scripts are retained as historical inputs. The registered
IDs and test assertions are unchanged; only the execution scripts
have new versioned paths. The direct GCC compiler, assembler, linker,
and SIMH locations continue to be checked by the BADL test. Because
some shells expand a series of leading environment assignments in
order, BADL resolves its installed tool paths **before** passing the
temporary runtime-only `PDP10_PREFIX` to `p10run`.

## Ownership and audit integration

Versioned ownership audit `tools/audit-script-ownership-v5.py` now reads
`docs/TEST-SCRIPT-OWNERSHIP-20261121-v6.tsv`. Its `superseded`
disposition requires an exact approved historical-to-active path
mapping; it cannot silently retire an arbitrary script. Five older
scripts (three validation scripts and the two prior inventory auditors)
are preserved and mapped to their registered active versions.

Versioned inventory audit `tools/audit-test-inventory-v2.py` uses the
current BADL owner in the companion map and in the pinned GCC target
review `docs/GCC-PDP10-TARGET-OWNERSHIP-20261121-v3.tsv`. The original
GCC source SHA256 fields and historical feasibility classification are
unchanged. The two canonical BADL ownership references now point at v2.

These are **current registry ownership** changes, not claims that the
older historical shell scripts have been independently executed again.

## Executed acceptance evidence

Tests run against the installed toolchain (`PDP10_PREFIX=$HOME/cross`):

- `sh misc/validation/test-badl-tables-v2.sh`: PASS on PDP-6 and KA10.
- `./run-misc-tests.sh run-id badl-tables`: PASS on PDP-6 and KA10.
- `sh misc/validation/pdp10-gcc-char-word-boundary-v46.sh`: PASS at
  O0, O1, O2 and Os.
- `./run-misc-tests.sh run-id gcc-char-word-boundary-v45`: PASS at
  O0, O1, O2 and Os.
- `./run-misc-tests.sh run-id test-inventory-v2`: PASS (2,358 matrix
  sources, 412 registered special tests, zero inventory errors).
- `./run-misc-tests.sh run-id test-script-ownership-v5`: PASS
  (590 scripts, five explicitly superseded scripts, zero ownership errors).
- `tools/test-special-compiler-stdlib-dispatch-v1.py`: PASS.
- `tools/test-runner-result-accounting-v1.py`: PASS.
- `tools/test-registered-fixture-integrity-v1.py`: PASS.
- `tools/test-testkit-boundary-v1.py --require-cross`: PASS.
- Three injected ownership negative controls: a wrong supersession
  target, an orphaned historical script, and duplicate active ownership
  were each rejected by the v5 ownership audit.
- `sh -n` on both new scripts and `py_compile` on both current audits:
  PASS.

## Remaining gate

This is a **partial** audit of raw `p10run` callers. Many registered
compiler guest scripts still depend on entering through the protected
`run-misc-tests.sh` dispatcher; do not claim that those scripts are
safe to execute raw against an OS-libc prefix. The earlier limited
candidate scan found 73 possible direct callers/helpers; it was not
an exhaustive dynamic trace. The full caller review, interrupted-run
restart acceptance, and 123,576-cell matrix sweep remain outstanding.
Ordinary compiler, linker, or runtime defects remain recorded but are
not being repaired in this phase.
