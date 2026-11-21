# Packed aggregate: original semantic test accepted as P1 coverage

Date: 2026-11-20. Batch 4 slot 2,
`tests/semantic/upstream/extensions/20010518-2.c`,
already contains a substantive compiler test: a packed structure
initializer, two real `memcpy` operations, nested packed-field
assignment, and checks of all four scalar members and the nested
character field. The imported source and its original SHA256 are
**unchanged**. No companion, rewritten assertion or dummy libc
implementation is necessary for the testkit.

Both installed compiler profiles build and execute the unchanged
original with the selected real target `memcpy` assembly member:

| Profile | Actual PDP-6 result |
| --- | --- |
| KCC noopt | `run_fail`, HALT, `__test_exit=1` |
| GCC O0 | `run_fail`, HALT, `__test_exit=1` |

Both simulator reports have `rc=0`, `result=FAIL` and a completed
guest exit readback of one. Their corresponding target linker maps
contain resolved `memcpy`, `abort`, and `exit` symbols. No
unresolved libc symbol or timeout prevents the original assertions.
Earlier targeted diagnostics found the first scalar field already
incorrect immediately after aggregate initialization; the compiler
backend issues are **not** repaired here.

The installed-toolchain evidence is preserved in
`manifests/PDP10-P1-PACKED-ORIGINAL-EVIDENCE-20261120-v1.tsv`
and `refs/p10tk-p1-packed-original-evidence-20261120-v1.tar.gz`.
The source hash, both guest reports, both map files, their checksums,
their genuine assertion failures and matrix ownership are audited
by `tools/audit-p1-packed-original-oracle-v1.py`, with six negative
controls in `tools/test-p1-packed-original-oracle-v1.py`.

**P1 test construction is covered**, even though both compilers fail
it. The P1 v11 ledger retains compiler follow-up
`packed-aggregate-compiler` and does **not** mark either compiler
as passing. The previous v10 ledger remains a historical snapshot.

No compiler, assembler, installed library, test source, or simulator
was changed. The full compiler/CPU sweep remains deferred.
