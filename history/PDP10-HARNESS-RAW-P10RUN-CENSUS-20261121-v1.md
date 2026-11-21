# Raw p10run caller census (v1)

Date: 2026-11-21. Harness-only; compiler changes remain deferred.

`tools/audit-raw-p10run-v1.py` performs a fail-closed source census
against `manifests/RAW-P10RUN-CALLERS-20261121-v1.tsv`. The ledger is
registered through the `raw-p10run-audit-v1` special-test ID.

| Static category | Scripts | Meaning |
| --- | ---: | --- |
| Registered with explicit script-level compiler prefix | 5 | Source contains compiler-prefix preparation; prior native tests establish only selected executions |
| Registered dispatcher-only | 60 | Safe library selection is provided by official `run-misc-tests.sh`; direct execution against the installed generic prefix is **not** certified |
| Superseded historical scripts | 3 | Retained for historical evidence, not active tests |
| Shared helper | 1 | Defines runner path; does not itself run a guest |
| **Total** | **69** | Lexical source candidates, not 69 confirmed dynamic guest runs |

The scan includes all tracked and untracked nonignored `misc/` shell
and Python scripts with explicit p10run invocation or runner-variable
references. It does not inspect arbitrary dynamically constructed
command strings, external repositories or simulator internals.

Every current candidate must have exactly one ledger entry; new callers,
removed/stale callers, duplicate entries, unknown owner classes,
unsupported direct policies, missing registered/superseded/helper
ownership and missing isolation markers fail the audit. An `isolated`
marker is a source-level check, not a substitute for a real runtime
archive-provenance test.

The 60 dispatcher-only scripts are deliberately marked `unreviewed`
for runtime type. Guessing GCC/KCC ownership from filenames is not
acceptable evidence, particularly for mixed-compiler ABI tests. A
future focused review must establish each script's actual linker
requirements and either harden direct invocation or explicitly limit
its supported entry point to the protected dispatcher.

Acceptance performed:

- Direct static census: PASS (69 classified, no gaps).
- `./run-misc-tests.sh run-id raw-p10run-audit-v1`: PASS.
- Updated inventory: PASS (2,358 sources, 413 special tests).
- Updated ownership: PASS (591 scripts, zero issues).
- Four negative controls rejected: missing ledger entry, duplicate
  ledger row, wrong superseded ownership, and newly injected caller.
- Python syntax compilation: PASS.

This completes the **static census**, not the full raw-call isolation
audit. Interrupt/restart acceptance and the full 123,576-cell matrix
sweep are still open. No compiler, simulator or guest semantics changed.
