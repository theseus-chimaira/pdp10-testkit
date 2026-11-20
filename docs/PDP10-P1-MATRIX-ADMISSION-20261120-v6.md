# P1 unresolved original native matrix admission v6

The previous v5 unresolved manifest included original
960327-1.c. It is now testkit-covered because its unchanged
original asserts a real stack-buffer formatting result and
has nine actual CPU/compiler guest PASS results. It remains
in the normal compiler matrix; no source or profile was
removed or silently marked as passing.

The active unresolved list now contains **24 obligations**:
**23 C originals** and one KL10 assembler-only fixture.
For the 23 unresolved C sources, the earlier expansion
added **102 native profile columns**, corresponding to
**207 runnable native CPU/compiler/mode cells** including
both KCC optimization levels.

The source-pinned manifest is
PDP10-P1-MATRIX-ADMISSION-20261120-v6.tsv, verified
by tools/audit-p1-matrix-admission-v6.py and its 16
negative controls in tools/test-p1-matrix-admission-v6.py.
The earlier v5 manifest remains a historical snapshot.
