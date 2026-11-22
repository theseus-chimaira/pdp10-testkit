# DAS DOBJ1 independent-symbol difference regression v1817

The original `cross-object-v1453.s`, `same-object-v1453.s`,
`definitions-v1453.s` and `run-v1453.sh` were recovered byte-for-byte
from the historical dirty DAIMOS testkit worktree
`daimos-testkit-c4674ddc`. Compiler/assembler-only regression ownership
is PDP10-testkit, so the restored fixture and expanded cases live here.

`misc/das/check-symbol-difference-v1817.sh` is registered in
`SPECIAL_TESTS.tsv` as a DAS fast test. Its required source is the
current DAS checkout, built by `./run-misc-tests.sh das-fast`.

DOBJ1 supports one relocation base plus an addend per relocation. A
subtraction of two independent undefined exports or of two separately
relocated sections cannot be encoded by simply dropping their relocation
markers when the signed relocation count becomes zero. DAS must reject
such expressions, including unary-reordered subtraction. The test
requires the precise unsupported-difference diagnostic, not merely any
assembler failure. Two labels in one TEXT section and repeated uses of
the same external symbol are valid absolute differences, and must pass.

The historical original on current DAS before v1817 accepted the
cross-object difference silently. With the v1817 source change, the
four invalid cases are rejected and both valid cases pass.

The v1817 DAS fast suite passes 13/13, including the corrected existing
native relocation-spill test. Its original host mock omitted
`dsys_writechar`, which is required by the native DAS diagnostic
interface; a bounded stderr diagnostic sink now supplies that exact
missing syscall without weakening the physical relocation assertions.

Native DAS1 and DAS2 target objects and DXRs compile and link. Their
object and generated-assembly bytes match the pre-v1817 source build;
this particular source correction changes the host DAS path, not native
resident phase size. No new in-guest native assembler run is claimed.
