# Deferred source identity and ownership audit (2026-11-16 v1)

## Scope and evidence

This audit covers only sources already present in `pdp10-testkit`.
It does not run compilers, assemblers, emulators, or tests. An identical
SHA-256 hash proves byte-for-byte source equality; it does **not** prove
equivalent compiler options, processor applicability, expected failure
behavior, ABI requirements, or useful nonvacuous assertions.

The versioned manifest
`docs/DEFERRED-SOURCE-DUPLICATES-20261116-v1.tsv` records every pair
of identical retained upstream sources in which at least one copy is
classified `deferred`. It records the upstream activation of each copy,
the independent per-copy deferred disposition where applicable, and a
pending-review flag. It deliberately does not select a canonical
execution owner or delete a source.

The existing `tools/audit-test-inventory-v1.py` static ownership check
now enumerates these pairs independently and fails closed if an
unregistered pair appears, a pinned source changes, an activation or
disposition changes, or an entry becomes stale. Its existing `verify`
registration in `SPECIAL_TESTS.tsv` owns this check; no duplicate
registry entry or extra test runner is needed. This integration has
**not been executed**.

## Static findings

The 269 current deferred manifest sources contain 48 byte-identical
deferred/deferred pairs. Two more deferred sources are byte-identical to
existing active matrix tests. Total: **50 distinct pairs**, all still
pending manual profile/ownership review:

* 42 deferred/deferred pairs with the same disposition class.
* 6 deferred/deferred pairs with differing disposition classes.
* 2 active/deferred pairs with conflicting cross-compiler evidence.

The six disposition differences are:

| Matching source basename | First disposition | Second disposition |
| --- | --- | --- |
| `bcp-1.c` | nonasserting | feature-policy-decision |
| `20011113-1.c` | libc-linkage | feature-policy-decision |
| `20020406-1.c` | hosted-runtime | header-integration |
| `930111-1.c` | compiler-investigate | evidence-retest |
| `991014-1.c` | width-or-source-adaptation | feature-policy-decision |
| `index-1.c` | libc-linkage | linker-investigate |

These differences may simply be separately observed failures in
distinct target contexts. They cannot safely be collapsed without
rechecking the intended compiler, CPU and language profiles.

The two active/deferred pairs are `strct-pack-1.c` and
`strct-pack-3.c`. The active copies live under
`tests/semantic/upstream/pdp10/pdp10/`; the deferred copies live under
`tests/semantic/upstream/extensions/`. Earlier classification says
the active copies passed PDP-6 KCC, whereas the extension copies
recorded PDP-6 GCC -O0 runtime failures. The sources are byte-for-byte
identical: the KCC result must not mask the GCC observation. Both
assertions are nonvacuous field-layout/readback checks.

## Remaining manual integration

For each manifest pair, review the original source purpose, any
compiler-specific harness or options, the meaningful assertions, and
processor/ABI applicability. Then select one executable registration
per distinct profile/assertion combination, and retain companion source
provenance without scheduling redundant equivalent executions. Confirm
that every deferred copy's evidence is either represented by a
registered cell or remains explicitly deferred for a reason. Only
after that review should source removals or classification updates be
considered; keep this manifest synchronized with such changes.

In particular, reconcile GCC behavior for the two packed-structure
tests before treating the already-active copies as broad cross-compiler
coverage. No compiler correctness or runtime outcome is claimed here.
