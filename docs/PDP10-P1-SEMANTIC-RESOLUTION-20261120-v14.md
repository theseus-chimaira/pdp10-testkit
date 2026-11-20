# P1 semantic resolution v14: 960327 original is covered

The latest live P1 resolution retains 67 historical original
identities, all original SHA256s, and the unchanged frozen
dispositions. Compared to v13, exactly one source changes
status: Batch 5 960327-1.c, blocked to covered,
based on nine completed native compiler guest PASS reports
with the real sprintf implementation and original assertion.

Current counts: **43 covered, 0 partial, 24 blocked**.
The generated TSV is:

    docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v14.tsv

It is generated and verified by
tools/build-p1-semantic-resolution-v14.py. The narrow
source/runtime evidence is described in
PDP10-P1-960327-ORIGINAL-CLOSURE-20261120-v1.md.
