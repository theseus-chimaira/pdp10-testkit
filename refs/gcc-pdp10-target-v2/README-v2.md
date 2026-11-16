# PDP-10 GCC regression source ownership v2

These 18 source files were moved from the GCC 3.2 source repository before
the DejaGNU test tree was removed.  Their original revision is
`pdp10-gcc` commit `b0f5374`.  The files are unchanged reference inputs
and remain accessible through that revision's Git history as well.

The twelve applicable compile/codegen regression sources are executed by
`misc/validation/test-gcc-target-codegen-v2.py`, registered in
`SPECIAL_TESTS.tsv`.  The runner is independent of DejaGNU and uses fixed
compiler flags and fixed positive/negative assembler assertions.  It does
not interpret the historical `dg-*` comments left in these source files.

`bare-dlink-libgcc-1.c` and `wide-int-mode-macros.c` are companion sources
for dedicated shell probes, not standalone compile-only semantic tests.
The four historical `.sh` files are retained for future source-level
adaptation.  They are **not** independently enabled, and registration must
wait for a verified test oracle and correct source/tree prerequisites.

The ITS-only `its-circ-1.c` is intentionally absent.  It was removed from
the GCC repository as inapplicable and must not be recreated as a generic
PDP-10 regression.  Its deletion is documented in
`docs/GCC-PDP10-TARGET-FEASIBILITY-20261116-v1.tsv`.

The rest of the old GCC DejaGNU corpus was deliberately not imported here.
The historical source files remain reachable from `pdp10-gcc` commit
`b0f5374`; the review queue and SHA-256 hashes remain in
`docs/GCC-C-FEASIBILITY-PREFLIGHT-20261116-v1.tsv`.  A source must be
reviewed for 36-bit words, 9-bit bytes, non-IEEE floating point, CPU/ISA
features, available libc, and preservation of the original assertion
before it is eligible for testkit integration.
