# P1 original and independent struct-return oracle closure (v1)

Date: 2026-11-20. Four **targeted** GCC PDP-6 original-source runs,
not the requested deferred full compiler/CPU sweep.

The unchanged `tests/todo/generic/generic/struct-ret-1.c` has source
SHA256 `c9c28e7b4daa3d36e8be3590a722e8a22de63ce8d9e56927ed42bd03b7bccd74`.
It calls `f` both directly and via an `X (*fp)(B,char,double,B)` function
pointer, verifies that their formatted output strings match, and links
real `sprintf`, `strcpy`, `strcmp`, `abort` and `exit`. Its original
source **does not** assert any field in either returned `X` object.

The currently installed GCC target buffer formatter allows the
unchanged original to compile, link and complete with `rc=0`,
`result=PASS` and `__test_exit=0` for **O0, O1, O2 and Os**. Its
source- and report-SHA-pinned evidence is:

- `docs/PDP10-P1-STRUCTRET-HOSTED-EVIDENCE-20261120-v1.tsv`
- `refs/p10tk-p1-structret-hosted-20261120-v1.tar.gz`

The separately registered, freestanding C89 companion
`tests/semantic/regression/pdp10-large-struct-return-v1.c`
independently asserts the by-value `B` arguments (including floating
members), the returned `X` character array and final byte, direct
and function-pointer calls, and independent caller-side storage.
Its existing six SHA-pinned guest reports are preserved exactly:

| Profile | Companion outcome |
| --- | --- |
| KCC PDP-6 noopt / opt | 2 genuine SIMH timeouts |
| GCC PDP-6 O0 | `run_fail`, argument check ID 3 |
| GCC PDP-6 O1 / O2 / Os | 3 PASS |

The verifier `tools/audit-p1-structret-hosted-v1.py` checks **both**
the four new original source reports and the prior six independent
companion reports; the registered negative-control test rejects nine
manifest, profile, source-status and archive corruptions. No original
assertion is removed, no new libc/ABI stub is introduced and no compiler
failure is hidden or counted as a PASS.

The test-construction intent is therefore covered in current P1
resolution v16: **45 covered, 0 partial, 22 blocked**. This is not
compiler correctness closure or a claim of verified non-PDP-6 CPUs.
KCC timeouts and GCC O0 aggregate argument ABI failure remain
separate future compiler/runtime work.
