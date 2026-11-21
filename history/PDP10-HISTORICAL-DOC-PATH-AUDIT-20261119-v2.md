# Historical PDP10 source path reconciliation - 2026-11-19 v2

## Why the 2026-11-17 audit failed

The historical documentation checker reported 162 problems: 109
missing literal documentation paths, 52 missing mapped current sources,
and one changed mapped source. The errors arose after the
2026-11-18 source reclassification/duplicate consolidation and the
purposeful PDP-10 stdarg portability adaptation. Old links were not
proof that historical compiler outcomes had changed.

## Identity-preserving reconciliation

- The 125-entry v1 source ledger is retained unchanged at
  `manifests/HISTORICAL-SEMANTIC-SOURCE-RELINK-20261117-v1.tsv`.
- The v2 ledger at
  `manifests/HISTORICAL-SEMANTIC-SOURCE-RELINK-20261119-v2.tsv` retains
  each original Git blob and SHA256, updates 52 current paths, and adds
  a separate current-source SHA256. Its 125 references resolve to 106
  distinct current files.
- Another 54 links in dated reports were displaced by the subsequent
  duplicate consolidation. The additional 54-row ledger at
  `manifests/HISTORICAL-ADDITIONAL-SOURCE-RELINK-20261119-v1.tsv` pins the
  original Git blob from the parent of commit `0b6baea`, its SHA256,
  the byte-identified current path, and its current SHA256.
- In total, 179 historical references resolve to 136 unique current
  sources. Every original Git blob was independently retrieved locally
  and checked against its retained SHA256: **179/179 matched**.
- One distinct current file, `tests/todo/generic/varargs/strct-varg-1.c`,
  intentionally changed in commit `055c047`: a five-line PDP-10-only
  `NO_VARARGS` definition. Two v2 crosswalk references and one
  supplementary reference lead to this source. For each of those three
  mappings, the audit pins the current checksum and verifies that
  stripping the exact reviewed prefix recovers the original SHA256.
  The original fingerprint is not replaced by the adapted fingerprint.

Three paths remain historical references to deliberately retired aliases,
not runnable current paths: `pdp10/pdp10/990106-2.c` in the v18
integration report, `pdp10/strct-varg-1.c` in the v27 integration
report, and `wide-int/conversion.c` in the v21 duplicate-consolidation
report. The checker permits only these precise document/path pairs
alongside its four earlier, already reviewed retired references. No
wildcard or prefix exemption was introduced.

## Static acceptance and scope

`python3 tools/test-historical-document-paths-v1.py` now reports:

```
Historical document source paths v2: PASS (125 original paths, 54 supplemental paths, 106 pinned current files, 3 reviewed adaptations, 0 problems)
```

The entrypoint filename stays v1 for compatibility with the registered
host-only test; its inputs and verification rules are now the v2
crosswalk plus supplemental ledger. It preserves the 125-row original
census and separately enforces the additional 54-row census. Source
content checks are strict. Dated compiler report results, classification
labels, and historical outcome observations were not changed and
**no compiler or guest execution is implied by these source relinks**.
