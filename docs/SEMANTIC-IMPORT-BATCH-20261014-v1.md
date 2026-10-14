# Upstream semantic import: eight consecutive candidates (2026-10-14, v1)

The next eight candidate rows in manifest order were inspected without
modifying either compiler. Their unmodified sources were compiled with KCC
for PDP-6 and, when compilation succeeded, executed using the testkit's
bare-metal `exit()`/`abort()` contract (`__test_exit=0`).

| Source | Observed result | Classification |
| --- | --- | --- |
| 20000112-1.c | Compile fails: installed KCC lacks `string.h`; needs `strchr` | deferred (runtime/header dependency) |
| 20000121-1.c | Executes successfully, but calls empty `big(long long)` with no observable result | removed (vacuous semantic assertion) |
| 20000223-1.c | Compile fails on GNU `__alignof__` extension | review-extension |
| 20000224-1.c | PASS; loop branch and abort assertion | active |
| 20000225-1.c | PASS; do-while and abort assertion | active |
| 20000227-1.c | Runs and aborts; one of the size/byte comparisons fails (literal source byte 0xff versus `\\377` requires investigation) | review-width |
| 20000313-1.c | PASS; unsigned wrap and borrow checks | active |
| 20000314-1.c | PASS; dead loop and short-circuit checks | active |

The four active tests have new `COMPILER_MATRIX.tsv` semantic rows with the
same prospective compiler/CPU profile coverage as existing generic upstream
tests. Only PDP-6 KCC was actually exercised; those future matrix cells are
not claimed to pass. The failing and unsupported cases remain available for
target-specific classification and investigation, except the vacuous test,
which is removed as an executable semantic case. No compiler defects were
corrected or hidden during this batch.
