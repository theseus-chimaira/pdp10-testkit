# P1 unresolved native matrix admission v5

The original 920726-1.c is now P1 testkit-covered after real
GCC/KCC hosted-formatting executions and independent varargs
return-value checks. Its existing matrix registrations stay
intact, including the GCC PDP-6 O0 cell, which now PASSES
in the normal matrix. The broader four-CPU GCC O0/O2 runs
are registered as a separate compatibility test.

The unresolved admission has **25 obligations**, comprising
**24 C originals** plus one KL10 assembler fixture.
The 24 C sources have **105 additionally enabled native
profile columns**, or **216 scheduled native compiler/mode
cells** including KCC opt and noopt.

The current manifest is
PDP10-P1-MATRIX-ADMISSION-20261120-v5.tsv, checked by
tools/audit-p1-matrix-admission-v5.py and 16 negative
controls in tools/test-p1-matrix-admission-v5.py.
All prior admission snapshots remain historical.
