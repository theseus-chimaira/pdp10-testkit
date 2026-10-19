#!/usr/bin/env python3
"""Check complete, source-pinned triage of upstream deferred tests.

This verifier checks that every currently deferred source has exactly one
actionable disposition and that no disposition is silently called a pass.
It does not infer compiler correctness or execute any source.
"""

import collections
import csv
import hashlib
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261014-v2.tsv"
DISPOSITIONS = ROOT / "docs/SEMANTIC-DEFERRED-DISPOSITION-20261019-v1.tsv"
VALID_CLASSES = frozenset((
    "compiler-ice-priority", "compiler-investigate", "evidence-retest",
    "feature-policy-decision",
    "header-integration", "hosted-runtime", "isa-harness", "libc-linkage",
    "linker-investigate", "nonasserting", "unsupported-kcc-extension",
    "varargs-abi", "width-or-source-adaptation",
))


def read(path):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def verify():
    source = [r for r in read(SOURCE) if r["activation"] == "deferred"]
    dispositions = read(DISPOSITIONS)
    expected = {r["classified_path"]: r for r in source}
    seen = set()
    errors = []
    if len(expected) != len(source):
        errors.append("duplicate deferred paths in upstream manifest")
    for row in dispositions:
        path = row["classified_path"]
        if path in seen:
            errors.append("duplicate disposition: " + path)
            continue
        seen.add(path)
        if path not in expected:
            errors.append("nondeferred/unknown disposition: " + path)
            continue
        upstream = expected[path]
        if (row["category"] != upstream["category"] or
                row["recorded_evidence"] != upstream["reason"]):
            errors.append("stale source-classification evidence: " + path)
        if row["disposition"] not in VALID_CLASSES or not row["next_action"].strip():
            errors.append("missing/unknown actionable class: " + path)
        source_path = (ROOT / path).resolve()
        if not source_path.is_relative_to(ROOT) or not source_path.is_file():
            errors.append("missing/outside source: " + path)
            continue
        actual = hashlib.sha256(source_path.read_bytes()).hexdigest()
        if row["source_sha256"] != actual:
            errors.append("source changed since disposition: " + path)

    for path in sorted(set(expected) - seen):
        errors.append("unclassified deferred source: " + path)

    print("deferred=%d dispositions=%d distinct=%d" %
          (len(source), len(dispositions), len(seen)))
    for name, count in sorted(collections.Counter(
            r["disposition"] for r in dispositions).items()):
        print("  %s: %d" % (name, count))
    for message in errors:
        print("ERROR: " + message, file=sys.stderr)
    print("deferred disposition: %s (%d error(s))" %
          ("FAIL" if errors else "PASS", len(errors)))
    return int(bool(errors))


if __name__ == "__main__":
    sys.exit(verify())
