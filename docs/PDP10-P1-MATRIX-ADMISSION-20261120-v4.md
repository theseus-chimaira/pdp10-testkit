# P1 unresolved native matrix admissions v4

The original variable-sized `va_arg` test
`20020412-1.c` has now received P1 testkit coverage (without
a successful compiler run). Its original compiler matrix entry
and all scheduled profiles stay intact. The latest unresolved
admission v4 excludes that **covered** obligation.

Current unresolved admission has **26 source obligations**:
**25 C originals** and one KL10-only ISA assembler fixture.
Among the unresolved C sources, **108 extra native profile
columns** were previously added, giving **225 scheduled native
compiler/mode cells**, including KCC opt and noopt.

`docs/PDP10-P1-MATRIX-ADMISSION-20261120-v4.tsv` is checked by
`tools/audit-p1-matrix-admission-v4.py` and its 16 negative
controls in `tools/test-p1-matrix-admission-v4.py`.
All earlier admission manifests remain historical snapshots.
