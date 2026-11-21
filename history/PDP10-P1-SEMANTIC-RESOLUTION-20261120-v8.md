# P1 semantic resolution v8: packed aggregate blocker correction

Date: 2026-11-20. This supersedes the **live classification** in v7,
not the historical P1 original-source inventory. No compiler sources,
original tests, guest assertions, or compiled artifacts are modified.

## Exact original source

Original: `tests/semantic/upstream/extensions/20010518-2.c`

The historical disposition `libc-linkage` is preserved as historical
evidence. A narrow installed-toolchain recheck used the original source,
the actual installed freestanding memcpy assembly, and the installed
KCC/GCC compilers, CRT, linker, and PDP-6 simulator:

| Compiler/profile | Installed-toolchain result |
| --- | --- |
| KCC PDP-6 native noopt | `run_fail` |
| GCC PDP-6 native O0 | `run_fail` |

Reproduction, bounded to this one source:

```
python3 tools/probe-deferred-libc-v1.py \
  --source tests/semantic/upstream/extensions/20010518-2.c \
  --compiler all --outdir "${TMPDIR:-$HOME/tmp}/p10tk-p1-packed-installed-20261120-v1"
```

The execution and assertion failures are **compiler-facing packed
aggregate semantics**, not an unresolved libc symbol or a missing hosted
service. The separate staged GCC fixes allow the unchanged original to
pass O0/O1/O2/Os on PDP-6. This is staged compiler evidence only; the
installed GCC has **not** been replaced. KCC's failure is independent.
See `history/PDP10-GCC-PACKED-HALFWORD-READBACK-20261120-v2.md`.

The current live `compiler_followup` is
`packed-aggregate-compiler`; `p1_state` remains `blocked`.
No compiler success is inferred from the diagnostic stage, and the
old v7 compiler/runtime baseline statuses remain unchanged.

## Frozen source batches

The v7 batch ledger
`manifests/PDP10-P1-SOURCE-BATCHES-20261120-v7.tsv`
retains all 59 original source identities and the 10+10+10+10+10+9
assignments. Only the remaining-action text for Batch 4 slot 2 changes.
The active run/admission/summary tools read the new live ledgers.
Historical v7 resolution and v6 batch ledger are unmodified.

Current totals are unchanged: 38 covered, 1 partial, 28 blocked
among 67 original obligations. The full matrix sweep remains deferred.
Compiler work is explicitly outside this testkit task.

Reproducible host-only gates:

- `tools/build-p1-semantic-resolution-v8.py`
- `tools/audit-p1-source-batches-v7.py`
- `tools/test-p1-packed-blocker-classification-v1.py`

The final gate checks all 67 resolution identities and all 59 batch
assignments, verifying that no unrelated row changed, the original SHA256
is unchanged, and a staged compiler's success cannot close the original.
Four negative controls check source promotion, lost compiler diagnosis,
historical reclassification, and changed batch assignment.
