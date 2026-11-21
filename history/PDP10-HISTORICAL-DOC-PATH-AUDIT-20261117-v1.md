# Historical testkit documentation path audit (2026-11-17 v1)

## Purpose and scope

Documentation is not a compiler regression result. This audit cleans up
source locations from October/November historical reports while retaining
each report's original measured compiler outcome, source identity,
classification, and explicit uncertainty. No GCC/KCC, assembler, native
DAIMOS guest, or full OS suite was run for the path reconciliation.

The review included all active root README/TODO content and the
PDP10 `docs/*.md` tree, as well as the DAIMOS testkit's historical
host/validation reports. Retired paths explicitly described as retired
are not runnable commands and remain distinguishable from broken active
source references.

## 125 exact source identity resolutions

Four previously imported historical compiler reports had **125**
backticked test paths no longer present at the locations recorded:

| Historical report | Old paths relinked | Result |
| --- | ---: | --- |
| `KCC-HEADER-SEMANTIC-RETEST-20261014-v3.md` | 46 | 46 hash-verified |
| `SEMANTIC-IMPORT-BATCHES-20261014-v11.md` | 31 | 31 hash-verified |
| `SEMANTIC-IMPORT-BATCHES-20261014-v12.md` | 36 | 36 hash-verified |
| `SEMANTIC-IMPORT-FINAL-20261014-v13.md` | 12 | 12 hash-verified |
| **Total** | **125** | **125 verified** |

`manifests/HISTORICAL-SEMANTIC-SOURCE-RELINK-20261117-v1.tsv` records
each old and current source path, a SHA256 fingerprint, the historical
Git blob identifier used for content comparison, and the resolution
basis. Sources are resolved by **byte-identical contents**, not a
matching basename alone: many generic/varargs/PDP10 and codegen cases
reuse the same basename but need different ownership or assertions.

For two same-content originals (`920625-1.c` and `931004-6.c`), the
historical generic source and the PDP10-specific source have identical
bytes. The explicit `varargs` category from
`SEMANTIC-UPSTREAM-CLASSIFICATION-20261014-v2.tsv` determines the
correct canonical current location of the generic originals. The
PDP10-specific copies keep their own namespace.

The inline source links in the four reports now point to files present
in the testkit. Original source paths and original Git identifiers
remain recoverable from the sidecar and Git history. No existing
compile, link, runtime, or diagnostic result was promoted to PASS.

## Other historical report corrections

* `CODEGEN-IMPORT-AUDIT-20261014.md`: distinguish the retired staging
  directory from the retained `tests/codegen/upstream-gcc/` import.
* `SEMANTIC-TODO-PORTABILITY-AUDIT-20261014.md`: point to the classified
  source tree and explicit classification manifest, not the removed
  2026-10-14 staging directory.
* `KCC-71BIT-FLOAT-CONVERSION-INVESTIGATION-20261019-v1.md` and
  `TEST-INVENTORY-RECONCILIATION-20261019-v1.md`: resolve the historical
  `930622-2.c` to its identical current `wide-int` source. The older
  `vrwiden` ICE observation is not an unresolved current acceptance
  claim; the 2026-10-20 D-format follow-up documents its resolution.
* `SEMANTIC-UPSTREAM-SUITABILITY-20261014-v1.md` and `TODO.md`: qualify
  the retained KL10 auxiliary assembler source using its existing
  `tests/semantic/upstream/support/` location.
* `GCC-C-FEASIBILITY-REVIEW-20261116-v1.md`: preserve two deliberately
  deleted codegen fixture basenames as historical evidence, not links
  to files expected to exist in today's compiler testkit.
* `DAIMOS-TESTKIT-SCRIPT-CENSUS-20261116-v1.md`: mark its old 1,680
  script / 969 no-static-caller discovery as a **pre-migration**
  historical census, not the current DAIMOS ownership status.
* `SPECIAL-SCRIPT-OWNERSHIP-AUDIT-20261116-v2.md`: distinguish the
  retired single-image DAS checker from current native-phase checks.

Separately, five DAIMOS OS reports now identify their production
`d6fsck.c` and `mkdtfs.c` sources as
`$DAIMOS_REPO/tools/host/...`, rather than implying those sources
are inside `daimos-testkit`. Both production files were checked in
the separate DAIMOS source checkout. Historical test observations in
those reports were not rerun.

## Permanent static regression guard

`tools/test-historical-document-paths-v1.py` is a registered host
`verify` test. It checks the versioned TSV structure and exact census,
old/current path pairing, current file existence and content SHA256,
and that each corrected report displays its current path. It also
checks literal local paths across current PDP10 Markdown documentation.
Four explicitly annotated removed/retired path references remain
permitted: two already-absent `tests/todo` placeholders in TODO,
the former codegen staging directory, and the deliberately retired
DAS single-image checker. Newly introduced broken local paths fail.

This is a **static documentation integrity** check, not source
provenance re-execution or a full historic Git archive scan. The
historical Git blob references were independently validated during
this audit and are recorded for future reproducibility. The original
compiler and OS test assertions remain unchanged.
