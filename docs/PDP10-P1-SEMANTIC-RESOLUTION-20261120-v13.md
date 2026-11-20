# P1 semantic resolution v13: 920726-1.c closure

The live v13 ledger retains all 67 historical source identities
and their original source hashes. Exactly one P1 state has
changed since v12: the unmodified 920726-1.c, previously blocked
for GCC target stdio, is now testkit-covered.

KCC and GCC execute its genuine hosted formatting checks
on PDP-6, KA10, KI10 and KS10 (16 PASS profiles). A separate
freestanding variadic scalar/struct return-value regression
covers the original's unchecked return objects; its GCC
scalar-return failures remain recorded.

Current P1 counts: **42 covered, 0 partial, 25 blocked**.
The generated ledger is
PDP10-P1-SEMANTIC-RESOLUTION-20261120-v13.tsv, verified by
tools/build-p1-semantic-resolution-v13.py.
See PDP10-P1-920726-STDIO-CLOSURE-20261120-v1.md for
source-pinned reports and limitations.
