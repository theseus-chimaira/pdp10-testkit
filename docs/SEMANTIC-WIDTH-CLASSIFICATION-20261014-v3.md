# PDP-10 width classification, first follow-up (2026-10-14, v3)

This continues `SEMANTIC-WIDTH-VALIDATION-20261014-v2.md`.
No compiler sources were modified.

## Reviewed cases

- `generic/20020216-1.c`: **restored** after review. The original layout
  guard wrongly rejected 9-bit chars even though 18-bit short and 36-bit int
  retain `sizeof(short)==2` and `sizeof(int)==4`. The PDP-10 branch now
  retains the original XOR expression and checks an independently derived
  expected value: 18-bit unsigned-short -1 XOR 36-bit sign-extended -103.
  Execution still required before activation.
- `wide-int/20020219-1.c`: a 63-bit left shift is within a 72-bit
  `unsigned long long`; shifting its result right by zero is a meaningful
  regression independent of a 64-bit storage layout. Retained for execution
  before activation, not yet an active matrix entry.
- `generic/20001009-1.c`: explicitly selects `0x1fe` on PDP-10 for a
  nine-bit signed character representation. The intended expression is
  meaningful, but the earlier KCC runtime abort requires investigation.
  It stays under review.
- `generic/20000227-1.c`: the existing diagnosis establishes that a raw
  0xff source byte and an octal escape are interpreted differently. The
  source encoding question is unresolved; do not normalize the source byte.
- `generic/20000403-1.c`: its `(sizeof(long)*8-1)` shift assumes eight-bit
  C bytes. The original expression is not a portable PDP-10 boundary
  calculation. Retain until a semantics-preserving test variant is decided.

## Execution blocker

The current `/home/theseus/cross` prefix contains KCC and `p10run`, but
`p10run` requires `bin/pdp10-dec-none-gcc`, which is missing from that prefix.
KCC generated assembly for `20020219-1.c` and `20001009-1.c`, but their
PDP-6 simulation attempts stopped at toolchain setup. Neither attempt is a
semantic pass or failure. An independently located GCC binary is not proof
of a coherent installed prefix. Restore a complete installed toolchain
before performing the executable classification and matrix activation.
