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
import tarfile


ROOT = Path(__file__).resolve().parents[1]
MAP = ROOT / "manifests/UPSTREAM-DUPLICATE-CONSOLIDATION-20261118-v21.tsv"
GATES = ROOT / "manifests/UPSTREAM-CONSOLIDATED-COMPILER-GATES-20261118-v21.tsv"
GATE_RESULTS = (ROOT / "manifests" /
                "PDP10-COMPILER-GATES-MATRIX-RESULTS-20261119-v1.tsv")
GATE_EVIDENCE = (ROOT / "refs" /
                 "compiler-gates-pdp6-matrix-20261119-v1.tar.gz")
BEFORE = ROOT / "manifests/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v15.tsv"
BEFORE_DEFERRED = ROOT / "manifests/SEMANTIC-DEFERRED-DISPOSITION-20261118-v14.tsv"
BEFORE_REVIEW = ROOT / "manifests/DEFERRED-SOURCE-DUPLICATES-20261118-v19.tsv"
STDARG_PATCH_LEDGER = (ROOT / "manifests" /
                       "PDP10-DEFERRED-INTEGRATION-BATCH19-20261118-v27.tsv")
STDARG_CANONICAL = "tests/todo/generic/varargs/strct-varg-1.c"
STDARG_TARGET_PREFIX = (
    b"/* PDP-10 has stdarg.h, not the obsolete varargs.h interface. */\n"
    b"#if defined(__PDP10__) || defined(__pdp10__)\n"
    b"#define NO_VARARGS 1\n"
    b"#endif\n\n")

# Statuses consumed by tools/run-tests.py as executable semantic cells.
# In particular, 'error' and 'fail' remain scheduled: those values are
# historical observations, never a reason to skip a compiler defect.
ACTIVE_GATE_MATRIX_STATUSES = frozenset((
    "semantic", "run", "runtime", "ok", "pending", "fail", "timeout",
    "error",
))


def records(path):
    with path.open(encoding="utf8", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def audit_gate_matrix_evidence(gates, problems):
    """Verify all 38 archived results from the normal compiler matrix.

    This is a static provenance audit of the initial PDP-6 observation,
    not a test-run substitute or an expected-failure masking mechanism.
    The normal matrix must still return nonzero on failing compiler cells.
    """
    expected = {}
    for i, gate in enumerate(gates, 1):
        compiler = gate["compiler"].lower()
        profiles = (("kcc-pdp6-opt", "kcc-pdp6-noopt")
                    if compiler == "kcc" else
                    ("gcc-pdp6-o0", "gcc-pdp6-o1", "gcc-pdp6-o2",
                     "gcc-pdp6-os"))
        for profile in profiles:
            expected[(gate["canonical_path"], profile)] = (i, gate)
    try:
        evidence = records(GATE_RESULTS)
        with tarfile.open(GATE_EVIDENCE, "r:gz") as archive:
            files = {item.name: item for item in archive.getmembers()}
            if len(evidence) != 38 or len(files) != 38:
                problems.append("incomplete PDP-6 compiler gate evidence")
                return
            seen = set()
            members = set()
            for row in evidence:
                key = (row["canonical_path"], row["profile"])
                if key in seen or key not in expected:
                    problems.append("unexpected/duplicate compiler gate cell: " +
                                    str(key))
                    continue
                seen.add(key)
                number, gate = expected[key]
                status = row["status"]
                passing = gate["canonical_path"] == (
                    "tests/todo/generic/20011113-1.c")
                if ((status == "pass") != passing or
                        status not in ("pass", "run_fail", "compile_fail",
                                       "link_fail", "compiler_ice") or
                        row["gate_index"] != str(number) or
                        row["compiler"] != gate["compiler"].lower() or
                        row["source_sha256"] != gate["source_sha256"]):
                    problems.append("compiler gate result contradicts source/"
                                    "profile: " + str(key))
                member_name = "gate%02d/%s-v1.log" % (number, key[1])
                members.add(member_name)
                if row["archive_member"] != member_name:
                    problems.append("wrong gate archive member: " + str(key))
                item = files.get(member_name)
                if item is None or not item.isfile():
                    problems.append("missing genuine gate log: " + str(key))
                    continue
                stream = archive.extractfile(item)
                content = stream.read() if stream is not None else b""
                if (hashlib.sha256(content).hexdigest() !=
                        row["evidence_sha256"] or
                        (b"OBSERVED: " + status.encode("ascii") + b"\n")
                        not in content or
                        b"=== COMPILER AND LINKER ===\n" not in content):
                    problems.append("gate evidence checksum/content failure: " +
                                    str(key))
                if (status == "pass" and b"result=PASS" not in content or
                        status == "run_fail" and b"result=FAIL" not in content or
                        status == "compiler_ice" and not any(
                            needle in content.lower() for needle in
                            (b"[internal error]", b"internal compiler error")) or
                        status == "link_fail" and not any(
                            needle in content.lower() for needle in
                            (b"link failed", b"undefined symbol"))):
                    problems.append("gate log does not substantiate status: " +
                                    str(key))
            if seen != set(expected) or members != set(files):
                problems.append("compiler gate matrix snapshot incomplete")
    except (OSError, tarfile.TarError, KeyError, UnicodeError, ValueError) as exc:
        problems.append("cannot audit compiler gate evidence: %s" % exc)


def audited_stdarg_adaptation(path, original_sha, data, classification):
    """Verify the exact v27 target-only portability change, fail closed.

    The historical v21 hash remains a pinned identity for the *original*
    duplicate source pair. A later canonical owner can differ only if its
    v27 ledger records the original and new bytes, and deleting exactly the
    five prepended portability lines reconstructs those original bytes.
    """
    if path != STDARG_CANONICAL or classification is None:
        return False
    if classification["activation"] != "active":
        return False
    rows = [row for row in records(STDARG_PATCH_LEDGER)
            if row["classified_path"] == path]
    if len(rows) != 1:
        return False
    row = rows[0]
    if (row["original_source_sha256"] != original_sha or
            row["source_adaptation"] !=
            "select-existing-stdarg-on-pdp10-only" or
            row["activation"] != "active" or
            row["current_source_sha256"] !=
            hashlib.sha256(data).hexdigest() or
            not data.startswith(STDARG_TARGET_PREFIX)):
        return False
    return (hashlib.sha256(data[len(STDARG_TARGET_PREFIX):]).hexdigest() ==
            original_sha)


def audit_consolidated_sources(upstream, matrix, problems,
                               late_admissions=frozenset()):
    """Check the 97 retired aliases without accepting stale/missing sources."""
    previous = {r["classified_path"]: r for r in records(BEFORE)}
    previous_deferred = {r["classified_path"]: r
                         for r in records(BEFORE_DEFERRED)}
    previous_review = {r["canonical_owner"]: r
                       for r in records(BEFORE_REVIEW)}
    current = {r["classified_path"]: r for r in upstream}
    registered = {r["test"] for r in matrix}
    matrix_by_path = {r["test"]: r for r in matrix}
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
        if not survivor.is_file():
            problems.append("canonical SHA256 missing or changed: " + keep)
        else:
            data = survivor.read_bytes()
            if (hashlib.sha256(data).hexdigest() != sha and
                    not audited_stdarg_adaptation(keep, sha, data, canonical)):
                problems.append("canonical SHA256 missing or changed: " + keep)
        if (keep in registered) != (
                canonical is not None and
                (canonical["activation"] == "active" or
                 keep in late_admissions)):
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
        # The historical gate is a normal matrix source, not a parallel
        # executable test. KCC uses the one PDP-6 column for opt/noopt;
        # GCC uses four independently selected optimization columns.
        # Require all failing-compiler PDP-6 profiles to remain runnable.
        matrix_row = matrix_by_path.get(key)
        cols = (("pdp6",) if row["compiler"] == "KCC" else
                ("pdp6_gcc_o0", "pdp6_gcc_o1",
                 "pdp6_gcc_o2", "pdp6_gcc_os"))
        if (matrix_row is None or any(
                matrix_row.get(col, "").lower() not in
                ACTIVE_GATE_MATRIX_STATUSES for col in cols)):
            problems.append("compiler gate missing active PDP-6 matrix "
                            "profile: " + key)
    for key in sorted(expected_gates.keys() - seen_gates):
        problems.append("untracked active-owner compiler blocker: " + key)
    if (collections.Counter(r["compiler"] for r in gates) !=
            {"KCC": 13, "GCC": 3}):
        problems.append("consolidated compiler gate counts changed")

    audit_gate_matrix_evidence(gates, problems)

    print("consolidated_duplicate_pairs=%d retired_active=47 retired_deferred=50"
          " remaining_duplicate_pairs=%d compiler_gates=%d" %
          (len(mapping), sum(len(v) > 1 for v in hashes.values()), len(gates)))


if __name__ == "__main__":
    from p1_matrix_admissions_v1 import admitted_sources, observed_originals
    # Standalone verification shares the upstream and matrix inventories.
    def current_rows(p, skip_comments=False):
        with (ROOT / p).open(encoding="utf8", newline="") as stream:
            return list(csv.DictReader((line for line in stream
                                        if line.strip() and
                                        (not skip_comments or
                                         not line.startswith("#"))),
                                       delimiter="\t"))

    current_upstream = current_rows(
        "manifests/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv")
    current_matrix = current_rows("COMPILER_MATRIX.tsv", skip_comments=True)
    errors = []
    late_admissions = admitted_sources(current_upstream, current_matrix, errors)
    late_admissions.update(observed_originals(current_upstream,
                                              current_matrix, errors))
    audit_consolidated_sources(current_upstream, current_matrix, errors,
                               late_admissions=late_admissions)
    for error in errors:
        print("ERROR: " + error, file=sys.stderr)
    print("upstream consolidation: %s (%d errors)" %
          ("PASS" if not errors else "FAIL", len(errors)))
    sys.exit(bool(errors))
