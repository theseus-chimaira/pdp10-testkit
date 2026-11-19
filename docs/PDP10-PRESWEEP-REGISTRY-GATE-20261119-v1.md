# PDP10 testkit pre-sweep registration gate v1 (2026-11-19)

Scope: static test ownership and P1 admission coherence only. No normal
compiler matrix sweep, CPU emulator tests, compiler repairs or linked
KL10 execution are claimed here. All original upstream bytes, historical
classification records and compiler failure evidence remain unchanged.

## Problems found and addressed

Initial source inventory audit: **36 errors**. Twenty-eight were original C
sources now scheduled by the P1 admission but still correctly classified
as historically deferred, seven were canonical survivor cross-checks
using that same obsolete activation-equals-registration assumption, and
one was the DAS-port assembly source lacking a declared script owner.

Initial script ownership audit: **12 errors** describing six newly added
script paths (each flagged twice): the DAS port helper, the P1 admission
writer, three deferred batch probe/report utilities, and an unregistered
KCC C89 constant-expression execution test. The C89 test is now registered
for later execution. The ad hoc matrix admission and probe/report commands
are explicitly manual tools, not automatically scheduled compiler tests.

The SHA-pinned P1 v7 resolution ledger identifies exactly 28 C sources
and one original KL10 assembly fixture among its 29 unresolved obligations.
The new shared audit helper validates each original SHA256, the historical
source classification, an active canonical C matrix owner and the scheduled
PDP-6 native KCC/noopt and GCC/O0 cells. The original KL10 source remains
outside the C matrix; its separate DAS port is script-owned as an
assembly-only fixture. The standalone duplicate-provenance auditor uses
these same exact late-admission exceptions rather than weakening checks
for other deferred sources or changing historical classifications.

## Current live registry

| Registry or audit | Validated state |
| --- | --- |
| Compiler matrix | 2,289 unique source rows |
| Special registry | 296 unique entries: 272 enabled direct, 18 manual, 6 nested |
| Owned shell/Python paths | 435 |
| Source inventory | PASS, 0 errors, 0 unowned test sources |
| Script ownership | STATIC COMPLETE, 0 issues |
| Consolidated duplicate-provenance audit | PASS, 0 errors, 97 retired pairs |
| Special suite dispatch | PASS, selected-suite routing only |
| Original late P1 admissions | 28 C sources with 56 scheduled PDP-6 cells |
| P1 guard negative controls | PASS: disabled cell, wrong owner, missing row, provenance mutation rejected |

## Reproduction (host-only)

```
python3 tools/audit-test-inventory-v1.py
python3 tools/audit_consolidated_upstream_v21.py
python3 tools/audit-script-ownership-v4.py
python3 tools/test-p1-matrix-admissions-v1.py
python3 tools/test-special-suite-dispatch-v1.py
python3 tools/test-run-special-tests-v2.py
```

## Still open before any large sweep

Independent semantic oracles and hosted dependency policy for the P1
original sources; source-reviewed diagnostic oracles; remaining real
assembler/linker/runtime fixture contracts; runner resumability, result
identity and fail-closed classification verification; final host-only
preflight and documentation review. Genuine compile/link/runtime failures
are intended outputs of the future sweep and must not be hidden.
