# Remaining 19 PDP10 manual roots: ownership review (2026-11-19 v1)

All 19 manual `SPECIAL_TESTS.tsv` roots were inspected by entrypoint
and checked for use of the DAIMOS SIMH harness. None invokes the
DAIMOS boot/guest harness directly. A dependency on `DAIMOS_REPO`
source files or the host DAS toolchain is **not** evidence that the
primary assertion is a DAIMOS runtime integration test. All 19 remain
owned by PDP10; no second transfer is justified by this review.

| Manual ID | Category | Why retained outside the default matrix |
| --- | --- | --- |
| kcc-pdp6-rounded-fp-boundaries-v2 | arithmetic regression | native PDP-6 rounded-FP boundary checks |
| kcc-aap-pdp6-rounded-fp-v2 | arithmetic regression | AAP native floating-point comparison |
| freestanding-search-benchmark-v1 | benchmark | performance measurement, not correctness gate |
| deferred-libc-probe-v1 | diagnostic | deferred hosted-library capability probe |
| das-build-das-native | native build check | standalone DAS phase build; no guest boot harness |
| aap-illegal-relocation-diagnostic-v1 | diagnostic | negative relocation behavior |
| kcc-host-make-split-v1 | build regression | KCC Makefile graph/source inventory |
| kcc-host-stage-readonly-v1 | build regression | bootstrap staging immutability |
| kcc-rm-codegen-v1 | codegen regression | KCC cross-compiler output for RM |
| kcc-foldtrna-codegen-v1 | codegen regression | peephole conditional instruction behavior |
| kcc-kinit-adjsp-codegen-v1 | codegen regression | kernel-source ADJSP generation |
| kcc-preserved-arg-codegen-v1175 | ABI/codegen regression | argument preservation and compiler output |
| p10fold-io-skip-v1 | optimizer regression | skip-controlled IO semantics |
| p10fold-local-section-v1141 | optimizer regression | local-section identity folding |
| kcc-excluded-directive-v1070 | compiler regression | excluded long directive handling |
| kcc-indptr-call-v1395 | compiler regression | induction-pointer call safety |
| gcc-kcc-backend-20261012-v1 | backend regression | PDP10 GCC/KCC generated arithmetic |
| linker-xip-format-v218 | linker regression | raw XIP format and eligibility |
| das-dxr2-st2-v1070 | assembler regression | host DXR2 checker |

This is an **ownership and entrypoint** review, not a successful
execution report. The native DAS host build and KCC kernel-source
checks may be expensive; diagnostic/benchmark entries are intentionally
not automatic. Guest-native runtime execution remains exclusively in
`daimos-testkit`. The 19 tests may be run individually using
`./run-special-tests-v1.sh run ID`; the ordinary compiler matrix does
not dispatch them.

## Subsequent ownership correction (2026-11-19)

The KINIT production-source ADJSP check was moved to
`daimos-testkit` after this historical 19-entry review. Current
PDP10-testkit manual entries: 18. See
`docs/PDP10-FOLD-KINIT-AAP-MATRIX-20261119-v1.md`.
