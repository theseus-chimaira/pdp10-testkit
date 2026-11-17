# KCC sharing for historical GCC C regressions (2026-11-17 v1)

## Source-level review

All 30 previously registered historical GCC C runtime sources received a
separate KCC applicability review. They comprise 17 adapted GCC batch-01
sources and 13 earlier original PDP-10 GCC regressions. Each decision and
its rationale are pinned by source path in
`GCC-C-KCC-CROSS-COMPILER-20261117-v1.tsv`.

| Source set | Reviewed | KCC pending | GCC-only |
| --- | ---: | ---: | ---: |
| GCC batch 01 PDP-10 adaptations | 17 | 17 | 0 |
| Earlier PDP-10 GCC regressions | 13 | 3 | 10 |
| **Total** | **30** | **20** | **10** |

KCC PDP-6 `pdp6` (native) and `pdp6_base` cells are `pending` for the
20 shared sources: 40 added matrix cells, not 40 observed passes. A KCC
matrix cell is also reused for the optimized and `-n` compiler variants,
so it does not represent one test execution. GCC optimization cells and
all other CPU/profile choices are unchanged. No KCC PDP-6 `pdp10` profile
is valid. We have **not compiled, assembled, linked or run tests**.

## Shared source semantics

KCC supports the canonical normalized 71-bit `long long` contract, in
contrast to a flat 72-bit integer; the adapted arithmetic values and
shift counts stay within the common representable range. It supports
`static inline`, `noinline`, the tested simple `aligned` and `packed`
attribute semantics, as well as the ordinary C89 pointer, loop and
aggregate operations. Existing KCC regressions exercise these features,
but do not constitute a pass for the newly registered sources.

Two batch-01 files needed source-level adjustments without weakening the
original oracle:

* `20011115-1.c`: KCC's predefined `__COMPILER_KCC__` selects the
  intentionally unreachable undefined-reference path, so its
  function-designator self-comparison remains a real regression.
* `20020402-2.c`: the large register-pressure test also selects the
  original short PDP-10 symbol spellings under KCC, preserving the
  structure and pointer-field readbacks.

The earlier three sources shared with KCC are:

* `alignas-frame-byteptr-v1.c`: aligned struct-member offsets from 9-bit
  char pointers are observable, though GCC's virtual-frame register bug
  is specific to its code generator.
* `packed-char-store-1.c`: KCC's packed struct-character stores retain
  the same 9-bit C-field oracle.
* `sibcall-fallthrough-1.c`: KCC's recognized `noinline` annotation and
  branch/call implementation preserve the observable two-call contract.

The other ten earlier GCC runtime sources depend on GCC-only exact-width
`size(8)`/`size(16)`/`mode(SI)` attribute meaning, packed cross-word
member layouts, and noncanonical byte-pointer ABI expectations. KCC may
accept some such annotations as metadata without implementing the same
layout, so simply enabling their cells would give misleading coverage.
They remain GCC-only; the TSV records each original reason.

The 17 adapted sources were not duplicated into a KCC-specific tree:
one shared source and separate matrix compiler cells avoid divergent
oracles. The original GCC snapshots under `refs/gcc-c-unmirrored-v1/`
remain unchanged and hash-pinned. The existing static GCC inventory
verifier also checks KCC eligibility and matrix cell status.

## Rule for subsequent 50-source batches

For every historical GCC source, review KCC applicability alongside
PDP-10 compatibility. Only share a test when the original oracle remains
meaningful for both compilers with the same C semantics, target ABI and
available runtime. Permit narrowly guarded source variants if required
to preserve an equivalent assertion; do not drop a diagnostic, target
feature or format-sensitive expectation to make it compile. A GCC-only
extension or codegen assembly pattern remains GCC-only until a genuine
KCC equivalent is identified. Record KCC disposition per file and leave
all unexecuted cells `pending`, never `ok` or `semantic` based on static
reasoning alone.
