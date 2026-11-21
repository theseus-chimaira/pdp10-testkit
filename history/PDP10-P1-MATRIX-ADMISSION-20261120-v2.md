# P1 matrix admission v2: source coverage updated

The previous v1 native scheduling was completed for 29 unresolved
obligations. The new, verified invalid-address prefetch companion
closes one partial obligation without changing its original's
matrix registration. Accordingly v2 counts **28 remaining
unresolved obligations: 27 C originals and one KL10 assembly
fixture**. Their already enabled compiler profiles are unchanged.

For the 27 unresolved C originals, the admission manifest retains
**144 additional native profile columns**, or **273 native
compiler/mode cells in total** including KCC's two optimization
modes. These counts exclude the now-covered prefetch original,
whose expanded matrix profiles remain scheduled. No tests were
disabled as a result of P1 closure.

`manifests/PDP10-P1-MATRIX-ADMISSION-20261120-v2.tsv` is checked by
`tools/audit-p1-matrix-admission-v2.py` and
`tools/test-p1-matrix-admission-v2.py`, including the previous
three real target smoke runs and 16 negative controls. The
v1 admission manifest remains a historical snapshot; v2 is the
current unresolved-source admission policy. The first full
compiler/CPU sweep remains deferred.
