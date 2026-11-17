# Deferred duplicate C source ownership: all 50 pairs reviewed (2026-11-17 v2)

## What was and was not changed

The original 50-pair historical evidence manifest
`docs/DEFERRED-SOURCE-DUPLICATES-20261116-v1.tsv` is unchanged. The new
`docs/DEFERRED-SOURCE-DUPLICATES-20261117-v2.tsv` retains its nine original
identity/hash/activation/disposition fields and adds, **for each pair**,
a canonical owner, preserved non-owner path, individual source assertion,
KCC/GCC profile gate, independently reconciled blockers, and evidence level.

All **50 duplicate pairs** have an owner decision, with 48 pairs still
**deferred** and two **active only in their existing matrix owner**.
There are zero pending source-identity reviews. Both file copies remain
on disk and their hashes remain unchanged. The non-owner is a provenance
snapshot, **not** a second executable test. No compiler matrix row or
original C file was modified to close the review.

## Six original disposition conflicts reconciled

| Original source | Two previously observed blockers | Reconciliation |
| --- | --- | --- |
| `bcp-1.c` | `nonasserting` / `feature-policy-decision` | The test actually has `__builtin_constant_p` truth-value assertions in `bad_t0`, `good_t0` and `opt_t0`; preserve both the misleading first classification and GCC-only builtin/dialect gate, but do not run an unverified KCC equivalent |
| `20011113-1.c` | `libc-linkage` / `feature-policy-decision` | Both are relevant: target `memcpy` and by-value struct/pointer ABI must preserve the three long payload fields |
| `20020406-1.c` | `hosted-runtime` / `header-integration` | Dynamic allocation and formatted output both need a target-compatible runtime; the polynomial argument-swap assertion is not a bare compiler-only check |
| `930111-1.c` | `compiler-investigate` / `evidence-retest` | Preserve the long-long switch-dispatch runtime assertion and request independent profiling if later activated |
| `991014-1.c` | `width-or-source-adaptation` / `feature-policy-decision` | Original `8 * sizeof(Size_t)` is a host-octet formula and must be rederived for 9-bit PDP-10 bytes; do not run its huge layout as written without validating sizes |
| `index-1.c` | `libc-linkage` / `linker-investigate` | Independently verify indexed array addressing and linker relocation for `a[n-100000]`, rather than assuming one blocker supersedes the other |

Neither blocker was erased from any conflicting row; the v2 crosswalk
retains the two original categories and names the intended assertion.

## Two active copies: real compiler-specific failures retained

`strct-pack-1.c` and `strct-pack-3.c` have an already registered
canonical source under `tests/semantic/upstream/pdp10/pdp10/`.
Their identical `tests/semantic/upstream/extensions/` copies remain
deferred. Earlier evidence of KCC success and GCC failure was
reproduced with the installed compiler/simulator and source bytes:

| Original source | PDP-6 KCC noopt | PDP-6 GCC `-O0` | PDP-6 GCC `-O2` |
| --- | --- | --- | --- |
| `strct-pack-1.c` | PASS | FAIL (guest abort) | FAIL (guest abort) |
| `strct-pack-3.c` | PASS | FAIL (guest abort) | FAIL (guest abort) |

The tests enforce real packed/aligned field-readback behavior; the
GCC failures occur **after successful compilation and target linking**.
They are compiler/runtime behavior evidence, not justification to
weaken the assertion or to suppress the GCC matrix cells. The
owner-selection decision is **one executable registration for each
source/profile**, not a new assertion, an expected failure, or a claim
that a KCC pass establishes GCC correctness.

## Other duplicate categories

* GNU labels as values, complex builtins and computed goto are gated
  separately for KCC and GCC. In particular, `NO_LABEL_VALUES` and
  `NO_VARARGS` compile-time fallbacks must not count as having checked
  the original extension or calling-convention assertion.
* GCC string optimization cases depend on the correct target libc
  functions and their aborting fallback stubs. The source must be
  tested in its intended optimization profiles, not simply linked.
* Wide-int, bitfield and aggregate cases require actual PDP-10
  9-bit-character, 18-bit-short and 36/71/72-bit long-long reasoning,
  including native alignment and signed promotions.
* The nine varargs cases require actual argument traversal and
  by-value aggregate layout; installing headers alone does not
  establish ABI correctness.
* Historical hosted `sprintf`, dynamic allocation and `setjmp`
  assertions retain their prerequisite gates; no no-op libc stubs
  have been installed to fabricate success.

`tools/audit-test-inventory-v1.py` now checks every source's original
SHA256, v1 classification stability, canonical/nonowner ownership,
non-empty source-specific assertion, separate GCC/KCC compatibility
gates, all six pairs' two independent blocker categories, and the two
active-copy GCC failure constraints. It rejects changed, missing,
newly duplicated or spuriously promoted source registrations.

**This task closes duplicate *ownership review*, not the outstanding
269 deferred upstream semantic tests or any compiler failure.** No C
snapshot or compiler was changed and none of the 48 deferred owners
was promoted to executable coverage.
