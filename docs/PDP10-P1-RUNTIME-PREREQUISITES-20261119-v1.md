# P1 libc/header/variadic prerequisite evidence (2026-11-19, v1)

This is a **host-only historical evidence audit**, not a retest or a
statement that any failed compiler cell now passes. Its authoritative
inputs are the original v4 deferred blocker triage and the v21 duplicate
consolidation ledger. Original imported tests and their assertions remain
untouched. The generated 53-row TSV pins the historical and current
source paths and SHA256 values separately, with per-compiler PDP-6
observed outcomes. Twelve old paths are historical duplicate aliases;
two historical source hashes differ from the current canonical files.
These differences are retained, not silently rewritten or called equal.

The 53 cases comprise 27 previously probed libc/header cases and 26
variadic ABI cases. The conservative, source-token-based **review queues**
are:

| Review queue | Cases |
| --- | ---: |
| Hosted allocation or stdio required | 6 |
| Compiler stack/runtime alloca review | 1 |
| GNU built-in / size-type feature review | 13 |
| Variadic ABI review | 15 |
| Freestanding or source-specific review | 18 |

These queues are mutually exclusive convenience labels, **not** final
failure root causes. Source-token inspection can overapproximate actual
link dependencies and does not resolve the execution failures. The
per-compiler status fields remain the historical evidence. A GNU built-in
must not be confused with an external libc function, nor can a header
alone satisfy malloc/printf. The freestanding archive does not supply a
hosted allocator or stdio implementation. No dummy stubs are introduced.

Files:

- `docs/PDP10-P1-RUNTIME-PREREQUISITES-20261119-v1.tsv`
- `tools/audit-p1-runtime-prerequisites-v1.py`
- `tools/test-p1-runtime-prerequisites-v1.py`

The registered host-only check verifies current file SHA pins, historical
identity, exact manifest reproduction and negative controls for missing
results and ambiguous evidence batches. A future source modification
must be reviewed and explicitly versioned, not silently accepted.

Still open: individual runtime/link/varargs ABI diagnoses, source-specific
oracle policies, installed header contracts, and missing hosted-service
policy. The full matrix sweep remains deferred.

## Host launcher versus guest outcome

The semantic runner now treats p10run's reserved launcher exits 125-127
and host signal termination as `setup_fail`, rather than attributing
them to a PDP-10 assertion (`run_fail`). A nonzero ordinary return with
`p10run: link failed` remains `link_fail`; an actual guest assertion
failure remains `run_fail`; timeout remains `timeout`. This classification
does not infer which hosted service is missing and does not turn any
failed test into a pass. Synthetic accounting checks cover the precedence
and the distinct failure outcomes without executing the compiler matrix.
