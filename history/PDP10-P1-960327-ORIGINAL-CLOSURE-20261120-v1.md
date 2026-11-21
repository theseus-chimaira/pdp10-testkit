# P1 original 960327-1.c: genuine sprintf stack-buffer oracle

Date: 2026-11-20. Batch 5 slot 3 is the original, unchanged
tests/todo/generic/960327-1.c. It checks a local string
manipulation across a switch and a pre-decrement pointer loop.
The key assertion is the actual sprintf(sp + 1, "X") write
to s[12], followed by a test of s[12] and abort on mismatch.

The source needs actual formatting semantics: an unresolved
symbol or a no-op replacement would not satisfy the assertion.
The GCC target now has a real freestanding formatter with a
proper GCC varargs entry; KCC uses its separate real hosted
formatting library. No original source edits or libc stubs
were needed.

## Executed native profiles

| Native CPU | KCC noopt | KCC opt | GCC O0 |
| --- | --- | --- | --- |
| PDP-6 | PASS | PASS | PASS |
| KA10 | PASS | PASS | Not executed |
| KI10 | PASS | PASS | Not executed |
| KS10 | PASS | PASS | Not executed |

All nine simulator reports have rc=0, result=PASS,
guest HALT, and __test_exit=0. Their individual linker
maps resolve the actual sprintf symbol. The source SHA256
and all 18 reports/maps are recorded in:

    manifests/PDP10-P1-960327-HOSTED-EVIDENCE-20261120-v1.tsv
    refs/p10tk-p1-960327-hosted-20261120-v1.tar.gz

The exact source/profile evidence, unchanged historical
disposition, normal matrix ownership, and archived report
contents are fail-closed verified by:

    tools/audit-p1-960327-original-v1.py
    tools/test-p1-960327-original-v1.py

Eight negative controls reject missing profiles, changed
source hashes, false results, matrix deactivation, premature
historical closure, and archive tampering.

The original is now testkit-covered, not automatically
compiler-verified on every GCC CPU/optimization combination.
Previous missing-stdio-header observations in the frozen
Batch 5 v1 manifest remain historical records, not
current GCC prerequisite claims.

The original 991112-1.c remains blocked: it calls the
genuine isprint character classifier through an indirect
function call. Both installed compilers previously had
unresolved isprint linkage. A test-only boolean substitute
would not establish the intended stdlib semantics.

No compiler, library, DAIMOS, or simulator source was
modified, and no full compiler/CPU sweep was executed.
