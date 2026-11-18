#!/usr/bin/env python3
"""Audit SHA256-pinned upstream source consolidation and open compiler gates.

The historical upstream and duplicate manifests are immutable evidence.
This checker enforces a single physical source per original byte sequence,
but does not infer that GCC and KCC have equal support for that source.
"""

import collections
import csv
import hashlib
import json
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
MAP = ROOT / "docs/UPSTREAM-DUPLICATE-CONSOLIDATION-20261118-v21.tsv"
GATES = ROOT / "docs/UPSTREAM-CONSOLIDATED-COMPILER-GATES-20261118-v21.tsv"
BEFORE = ROOT / "docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v15.tsv"
BEFORE_DEFERRED = ROOT / "docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v14.tsv"
BEFORE_REVIEW = ROOT / "docs/DEFERRED-SOURCE-DUPLICATES-20261118-v19.tsv"


def records(path):
    with path.open(encoding="utf8", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def audit_consolidated_sources(upstream, matrix, problems):
    """Check the 97 retired aliases without accepting stale/missing sources."""
    previous = {r["classified_path"]: r for r in records(BEFORE)}
    previous_deferred = {r["classified_path"]: r
                         for r in records(BEFORE_DEFERRED)}
    previous_review = {r["canonical_owner"]: r
                       for r in records(BEFORE_REVIEW)}
    current = {r["classified_path"]: r for r in upstream}
    registered = {r["test"] for r in matrix}
    mapping = records(MAP)
    gates = records(GATES)
    keep_paths = set()
    removed_paths = set()
    expected_gates = {}
    kinds = collections.Counter()

    if len(previous) != 774 or len(previous_deferred) != 184:
        problems.append("historical upstream snapshots are not complete")
    if len(mapping) != 97 or len(gates) != 16:
        problems.append("source consolidation must have 97 pairs and 16 gates")

    for row in mapping:
        keep = row["canonical_path"]
        retired = row["removed_path"]
        sha = row["sha256"]
        kind = row["pair_kind"]
        kinds[kind] += 1
        if (keep == retired or keep in keep_paths or retired in removed_paths
                or keep in removed_paths or retired in keep_paths):
            problems.append("repeated/cyclic consolidated source: " + retired)
        keep_paths.add(keep)
        removed_paths.add(retired)
        if kind not in ("deferred-containing", "active-active"):
            problems.append("unknown pair kind: " + retired)
        old_keep = previous.get(keep)
        old_retired = previous.get(retired)
        if old_keep is None or old_retired is None:
            problems.append("provenance path not present in prior snapshot: " +
                            retired)
            continue
        for role, old in (("canonical", old_keep),
                          ("removed", old_retired)):
            for col, key in (("activation_before", "activation"),
                             ("previous_path", "previous_path"),
                             ("category", "category"),
                             ("reason_before", "reason")):
                if row[role + "_" + col] != old[key]:
                    problems.append("historical %s %s changed: %s" %
                                    (role, col, retired))
            prior_disposition = previous_deferred.get(old["classified_path"])
            if row[role + "_disposition_before"] != (
                    prior_disposition["disposition"]
                    if prior_disposition else ""):
                problems.append("historical deferred reason changed: " +
                                retired)
            if row[role + "_next_action_before"] != (
                    prior_disposition["next_action"]
                    if prior_disposition else ""):
                problems.append("historical next action changed: " + retired)

        canonical = current.get(keep)
        if canonical is None:
            problems.append("lost canonical classification: " + keep)
        else:
            # Source consolidation preserves the 2026-11-18 baseline, but
            # deferred originals may later be verified and registered.
            # Such promotions do not revive their retired byte-identical
            # aliases. Never allow an active source to be demoted, and
            # never allow an unrelated status transition or changed origin.
            prior = old_keep["activation"]
            current_activation = canonical["activation"]
            if (canonical["previous_path"] != old_keep["previous_path"] or
                    (prior == "active" and current_activation != "active") or
                    (prior == "deferred" and
                     current_activation not in ("deferred", "active"))):
                problems.append("canonical activation/provenance changed: " +
                                keep)
            if (prior == "deferred" and current_activation == "active" and
                    not canonical["reason"].strip()):
                problems.append("promoted canonical lacks source evidence: " +
                                keep)
        if retired in current or retired in registered:
            problems.append("retired alias still registered/classified: " +
                            retired)
        if (ROOT / retired).exists():
            problems.append("retired alias recreated: " + retired)
        survivor = ROOT / keep
        if not survivor.is_file() or hashlib.sha256(
                survivor.read_bytes()).hexdigest() != sha:
            problems.append("canonical SHA256 missing or changed: " + keep)
        if (keep in registered) != (
                canonical is not None and
                canonical["activation"] == "active"):
            problems.append("canonical compiler ownership changed: " + keep)
        if old_retired["activation"] == "active" and kind != "active-active":
            problems.append("active retired alias not recorded as active pair: " +
                            retired)
        if kind == "active-active":
            if (old_keep["activation"] != "active" or
                    old_retired["activation"] != "active" or
                    row["matrix_profile_relation"] != "identical"):
                problems.append("active pair lost exact matrix equivalence: " +
                                retired)
            if (not row["canonical_matrix_profile_before"] or
                    row["canonical_matrix_profile_before"] !=
                    row["removed_matrix_profile_before"]):
                problems.append("lost historical active matrix profiles: " +
                                retired)
            else:
                profile = json.loads(row["canonical_matrix_profile_before"])
                if not profile or not all(isinstance(v, str)
                                          for v in profile.values()):
                    problems.append("bad historical matrix profile: " + retired)
        else:
            old_review = previous_review.get(keep)
            if (old_review is None or old_review["nonowner_copy"] != retired or
                    old_review["sha256"] != sha or
                    row["historical_required_gate"] !=
                    old_review["required_gate"] or
                    row["historical_original_assertion"] !=
                    old_review["original_assertion"] or
                    old_retired["activation"] != "deferred"):
                problems.append("historical deferred-pair gate lost: " + retired)
            if old_keep["activation"] == "active" and old_review:
                expected_gates[keep] = old_review
            if (old_keep["activation"] == "deferred" and
                    row["canonical_disposition_before"] !=
                    row["removed_disposition_before"] and canonical and
                    canonical["activation"] == "deferred" and
                    retired not in canonical["reason"]):
                problems.append("different deferred blocker lost: " + keep)
            if row["removed_matrix_profile_before"]:
                problems.append("deferred alias has an active matrix profile: " +
                                retired)

    if kinds != {"deferred-containing": 50, "active-active": 47}:
        problems.append("unexpected consolidation category counts: " +
                        str(dict(kinds)))
    if len(keep_paths) != 97 or len(removed_paths) != 97:
        problems.append("not exactly 97 distinct kept/retired aliases")
    if len(current) != 677:
        problems.append("consolidated upstream inventory must have 677 identities")

    # Fail closed on all duplicate hashes, not just previously recorded pairs.
    hashes = collections.defaultdict(list)
    for row in upstream:
        if row["activation"] not in ("active", "deferred"):
            continue
        p = ROOT / row["classified_path"]
        if p.is_file():
            hashes[hashlib.sha256(p.read_bytes()).hexdigest()].append(
                row["classified_path"])
    for paths in hashes.values():
        if len(paths) > 1:
            problems.append("reintroduced duplicate source: " + " ".join(paths))

    seen_gates = set()
    for row in gates:
        key = row["canonical_path"]
        old = expected_gates.get(key)
        if key in seen_gates or old is None:
            problems.append("unknown/duplicate consolidated compiler gate: " +
                            key)
            continue
        seen_gates.add(key)
        expected_compiler = ("GCC" if "GCC" in old["resolution"] else "KCC")
        if (row["retired_deferred_alias"] != old["nonowner_copy"] or
                row["required_gate"] != old["required_gate"] or
                row["original_assertion"] != old["original_assertion"] or
                row["profile_scope"] != old["profile_scope"] or
                row["compiler"] != expected_compiler or
                row["status"] != "open-compiler-gate" or
                row["source_sha256"] != hashlib.sha256(
                    (ROOT / key).read_bytes()).hexdigest()):
            problems.append("incorrect compiler-specific gate: " + key)
    for key in sorted(expected_gates.keys() - seen_gates):
        problems.append("untracked active-owner compiler blocker: " + key)
    if (collections.Counter(r["compiler"] for r in gates) !=
            {"KCC": 13, "GCC": 3}):
        problems.append("consolidated compiler gate counts changed")

    print("consolidated_duplicate_pairs=%d retired_active=47 retired_deferred=50"
          " remaining_duplicate_pairs=%d compiler_gates=%d" %
          (len(mapping), sum(len(v) > 1 for v in hashes.values()), len(gates)))


if __name__ == "__main__":
    # Standalone verification shares the upstream and matrix inventories.
    def current_rows(p, skip_comments=False):
        with (ROOT / p).open(encoding="utf8", newline="") as stream:
            return list(csv.DictReader((line for line in stream
                                        if line.strip() and
                                        (not skip_comments or
                                         not line.startswith("#"))),
                                       delimiter="\t"))

    current_upstream = current_rows(
        "docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v21.tsv")
    current_matrix = current_rows("COMPILER_MATRIX.tsv", skip_comments=True)
    errors = []
    audit_consolidated_sources(current_upstream, current_matrix, errors)
    for error in errors:
        print("ERROR: " + error, file=sys.stderr)
    print("upstream consolidation: %s (%d errors)" %
          ("PASS" if not errors else "FAIL", len(errors)))
    sys.exit(bool(errors))
