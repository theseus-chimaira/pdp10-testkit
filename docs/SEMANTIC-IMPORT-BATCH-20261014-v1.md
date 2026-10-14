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

## Follow-up: existing string runtime and exact width result

KCC provides `self/include/string.h`; DAIMOS already implements `strchr`
in `userland/libc/string.c`. The local test prefix lacks the installed
header and `libc.a`. Compiling the unmodified `20000112-1.c` against the
existing KCC header and linking DAIMOS's unmodified `string.c` assembly
with the bare-metal startup **passes on PDP-6**. Automatic runner integration
is still required before activating that source in the matrix.

For `20000227-1.c`, a temporary diagnostic copy recorded the actual array
members. Both arrays have size three; `f[1]`, from `\\377`, holds octal
`377` (255), while `g[1]`, from a raw `0xff` source byte, holds octal
`177` (127). The failure is specifically the `f[1] != g[1]` comparison,
not a size mismatch. This is consistent with seven-bit processing of a
raw source character; the octal escape retains 255. Keep this test in
`review-width` pending an explicit decision on byte-source semantics.
