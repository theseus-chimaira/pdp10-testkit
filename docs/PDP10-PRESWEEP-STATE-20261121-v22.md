# PDP-10 testkit live stop point before full sweep (v22)

Date: 2026-11-21. Supersedes v21 as the current acceptance gate.
Earlier versioned state notes and raw guest archives are immutable
and remain authoritative for their own historical checkpoints.

| Item | Current measured |
| --- | ---: |
| Compiler matrix sources | 2,319 |
| Special test registrations | 405 |
| Owned scripts | 578 |
| Unowned source files or scripts | 0 |
| P1 original identities covered / blocked | **56 / 11** |
| Frozen 59-source positions covered / blocked | **48 / 11** |

The live original P1 ledgers remain
`PDP10-P1-SEMANTIC-RESOLUTION-20261121-v29.tsv` and
`PDP10-P1-SOURCE-BATCHES-20261121-v28.tsv`. The previous closed
GNU 71-bit `conversion.c` source still has six real PDP-6
KCC/GCC original guest PASS with unchanged source assertions.
No broad compiler/CPU/optimization sweep has been run.

## Current compiler repair: halfword pointer canonical comparison

KCC `46d0181` correctly preserves an unknown native byte/halfword
pointer representation when a `void *` value is copied to another
`void *`, without re-encoding the pointer as S=9. KCC `4a61c53`
also fixes the optimized `==`/`!=` comparison of representation-
polymorphic pointers: one transient stack word protects the first
canonical value while the second may use scratch registers/labels.

The independent halfword-pointer C89 multi-argument regression now
PASSes six native PDP-6 profiles. The earlier independent
9/18/36-bit `void *` roundtrip also remains six-profile PASS.
The full existing 9/18/36-bit pointer torture now has one
**KCC opt PASS**, KCC noopt `run_fail` decimal ID 10, GCC O0 `run_fail`
ID 21 and GCC O1/O2/Os `run_fail` ID 28.

Current source-pinned evidence is
`PDP10-P1-BYTE-POINTER-CANONCMP-20261121-v2.md`: 18 real
source/profile cells, **13 native guest PASS, five genuine
`run_fail`, 90 SHA256-pinned raw outputs, seven negative controls**.
The old v1 pointer archive remains immutable and verified against
the older KCC compiler; do not retroactively turn its old KCC
failures into PASS. The historical `old.tort.c` import itself
was removed in favor of a freestanding C89 companion. The original
P1 identity remains **blocked** until correct construction coverage
and the remaining owning compiler failures are addressed.

## Independent KL10 original still blocked

The unchanged MACRO-10 original `920428-1.s` remains blocked at the
real assembler `DEFINE` macro and nested expression semantics.
The lower-level tested `BYTE (9)0`, KL10 directive, DOBJ/DLINK
and simulator result-accounting repairs are prerequisites only,
not a native original PASS. The port still exhausts the SIMH
KL10 step budget. See
`PDP10-P1-920428-KL10-TOOLCHAIN-PREREQS-20261121-v1.md`.

The DAS assembler repository retains local commit `aa74f42`
ahead of its remote; an attempted push was blocked by missing
GitHub authentication. The testkit source registrations and
KCC compiler repairs have been pushed normally.

## Gate

**Do not start the full compiler/CPU/optimization sweep** until
all eleven remaining P1 original source-construction obligations
have been closed with genuine source-pinned evidence. Never weaken
an unchanged original, misstate a SIMH step timeout as PASS, or
substitute a fake source/provider. Zero-unowned-source and
zero-unconnected-script audits remain mandatory.
