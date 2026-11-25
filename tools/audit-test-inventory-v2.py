#!/usr/bin/env python3
"""Validate testkit test ownership and upstream semantic classifications.

This is a static inventory check, not execution evidence.  Source existence,
one-owner registration, and upstream classification/matrix consistency are
checked without modifying any test or running a compiler.
"""

import argparse
import ast
import collections
import csv
import hashlib
from pathlib import Path
import re
import sys

from audit_consolidated_upstream_v21 import audit_consolidated_sources
from p1_matrix_admissions_v1 import admitted_sources, observed_originals
from p1_source_replacement_v1 import (
    CURRENT_PATH, HISTORICAL_PATH, HISTORICAL_SHA,
    source_matches_historical,
)


ROOT = Path(__file__).resolve().parents[1]
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
SPECIAL = ROOT / "SPECIAL_TESTS.tsv"
CLASSIFIED = (ROOT / "manifests" /
              "SEMANTIC-UPSTREAM-CLASSIFICATION-20261124-v26.tsv")
DEFERRED_DISPOSITIONS = (ROOT / "manifests" /
                         "SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv")
GCC_TARGET_FEASIBILITY = (ROOT / "manifests" /
                          "GCC-PDP10-TARGET-FEASIBILITY-20261116-v1.tsv")
GCC_TARGET_REVIEW = (ROOT / "manifests" /
                     "GCC-PDP10-TARGET-OWNERSHIP-20261121-v3.tsv")
REQUIRED_ACTIVATIONS = frozenset(("active", "deferred", "removed",
                                  "stress-nonportable"))

# These are companion translation units or standalone assembler fixtures
# executed by an owning registered script/source; they must not be scheduled
# as independent main programs.  Keep this map strict so new orphans fail.
SUPPORT_SOURCE_OWNERS = {
    "tests/codegen/kl10/gcc-global-exact32-v56z.c":
        "tools/test-gcc-global-exact32-v56z.py",
    "tests/codegen/kl10/gcc-global-exact-pointer-model-v56y.c":
        "tools/test-gcc-global-exact-model-v56y.py",
    "tests/codegen/kl10/gcc-global-packed-direct-v56t.c":
        "tools/test-gcc-global-wide-v56u.py",
    "tests/codegen/kl10/gcc-wide-truncation-v56u.c":
        "tools/test-gcc-global-wide-v56u.py",
    "tests/codegen/kl10/gcc-global-narrow-pointer-v56r.c":
        "tools/test-gcc-global-narrow-v56r.py",
    "tests/codegen/kl10/gcc-global-record-pointer-v56p.c":
        "tools/test-gcc-global-record-v56p.py",
    "tests/codegen/kl10/gcc-global-execution-v56m.c":
        "tools/test-kl10b-extended-link-v56m.py",
    "tests/codegen/kl10/gcc-global-static-pointer-v56h.c":
        "tools/test-gcc-global-static-pointer-v56i.py",
    "tests/diagnostic/kcc-fp-range-960405-1-v35b.c":
        "misc/validation/test-kcc-fp-range-diagnostics-v1.sh",
    "tests/semantic/kcc-pdp6-fp-hardware-case9-v1.c":
        "misc/validation/test-kcc-pdp6-fp-hardware-case9-v1.sh",
    "tests/semantic/kcc-pdp6-negative-halfway-aap-v3.c":
        "misc/validation/test-kcc-aap-dimode-float-pdp6-v1.py",
    "tests/semantic/kcc-pdp6-rounded-fp-boundaries-v2.c":
        "misc/validation/test-kcc-pdp6-rounded-fp-boundaries-v2.sh",
    "tests/semantic/kcc-pdp6-negative-fp-runtime-v1.c":
        "misc/validation/test-kcc-pdp6-negative-fp-runtime-v1.sh",
    "tests/semantic/kcc-pdp6-float-fold-v1.c":
        "misc/validation/test-kcc-pdp6-float-fold-v1.sh",
    "tests/semantic/kcc-pdp6-dimode-nativefloat-v1.c":
        "misc/validation/test-kcc-pdp6-dimode-nativefloat-v1.sh",
    "tests/semantic/kcc-pdp6-float-literal-v1.c":
        "misc/validation/test-kcc-pdp6-float-literal-v1.sh",
    "tests/semantic/kcc-dimode-float-pdp6-v1.c":
        "misc/validation/test-kcc-dimode-float-pdp6-v1.sh",
    "tests/semantic/kcc-dimode-local-load-v1.c":
        "misc/validation/test-kcc-dimode-storage-v1.sh",
    "tests/semantic/kcc-dformat-negative-v1.c":
        "misc/validation/test-kcc-dimode-storage-v1.sh",
    "tests/semantic/freestanding-search-benchmark-v1.c":
        "tools/benchmark-freestanding-search-v1.py",
    "tests/semantic/validation-gcc/gcc-addressof-pdp6-ice-v1.c":
        "misc/validation/test-gcc-addressof-pdp6-ice-v1.sh",
    "tests/semantic/validation-gcc/gcc-packed-block-bytepointer-v1.c":
        "misc/validation/test-gcc-packed-block-bytepointer-v1.sh",
    "tests/semantic/validation-gcc/gcc-packed-halfword-readback-v1.c":
        "misc/validation/test-gcc-packed-halfword-readback-v1.sh",
    "tests/semantic/freestanding-search-v1.c":
        "misc/compat/test-freestanding-search-v1.sh",
    "tests/semantic/freestanding-search-reference-v1.c":
        "misc/compat/test-freestanding-search-v1.sh",
    "tests/semantic/validation-gcc/pdp10-9bit-data-section-v1.c":
        "misc/validation/test-gcc-9bit-data-section-v1.sh",
    "tests/semantic/p10-byte-pointer-widths-v2.s":
        "misc/compat/test-p10byte-widths-v2.sh",
    "tests/semantic/p10-byte-blt-v3.s":
        "misc/compat/test-p10byte-blt-v3.sh",
    "tests/semantic/p10-byte-blt-fill-v3.s":
        "misc/compat/test-p10byte-blt-v3.sh",
    "tests/isa/das-port/920428-1-das-v1.s":
        "misc/das/check-920428-port-v1.sh",
    "tests/isa/das-port/pdp10-macro10-byte-directive-v1.s":
        "tools/test-p1-920428-kl10-toolchain-prereqs-v1.py",
    "tests/isa/das-port/pdp10-das-byte-equivalent-v1.s":
        "tools/test-p1-920428-kl10-toolchain-prereqs-v1.py",
    "tests/isa/das-port/pdp10-unused-extern-link-v1.s":
        "tools/test-p1-920428-kl10-toolchain-prereqs-v1.py",
    "tests/isa/das-port/pdp10-used-extern-negative-v1.s":
        "tools/test-p1-920428-kl10-toolchain-prereqs-v1.py",
    "tests/semantic/utf9-codec-pdp6-v1.c":
        "misc/compat/test-utf9-pdp6-runtime-v1.sh",
    "tests/semantic/utf9-codec-pdp6-v2.c":
        "misc/compat/test-utf9-pdp6-runtime-v1.sh",
    "tests/semantic/validation-gcc/bare-runtime/badl-tables.c":
        "misc/validation/test-badl-tables-v2.sh",
    "tests/semantic/validation-gcc/byteptr2/no-xkl2-byte-extend.c":
        "misc/validation/test-no-xkl2-byte-extend.sh",
    "tests/semantic/imported/gcc/pdp10-gcc-multidim-char-20261012.c":
        "tests/semantic/imported/gcc/pdp10-gcc-multidim-char-20261012.sh",
}
for _test in ("daimos-kcc-indexed-call-pdp6",
              "daimos-kcc-local-word-array-pdp6",
              "daimos-kcc-loop-return-pdp6",
              "daimos-kcc-pointer-scan-pdp6-20261009",
              "daimos-kcc-sixarg-char-pdp6"):
    _folder = "tests/semantic/imported/target/" + _test + "/"
    SUPPORT_SOURCE_OWNERS[_folder + "test.c"] = _folder + "matrix-semantic.c"


def rows(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        lines = (line for line in stream
                 if line.strip() and (not comments or
                                      not line.startswith("#")))
        yield from csv.DictReader(lines, delimiter="\t")


def duplicates(values):
    return sorted(key for key, count in collections.Counter(values).items()
                  if count > 1)


def audit_gcc_target_ownership(special, problems):
    """Verify all 19 original PDP-10 GCC cases have one real oracle owner.

    Read the static CASES tuple from the already-registered test runner.
    This is a source/dispatch audit, not a claim that compilation passed.
    """
    previous = list(rows(GCC_TARGET_FEASIBILITY))
    current = list(rows(GCC_TARGET_REVIEW))
    if len(previous) != 19 or len(current) != 19:
        problems.append("GCC target review must retain exactly 19 original sources")
    original_fields = ("source", "kind", "decision", "target_scope",
                       "original_assertion", "pdp10_feasibility",
                       "adaptation_or_gate", "central_overlap")
    registered = {r["path"]: r for r in special if r["enabled"] == "yes"}
    codegen = "misc/validation/test-gcc-target-codegen-v2.py"
    source = (ROOT / codegen).read_text(encoding="utf8")
    tree = ast.parse(source, filename=codegen)
    cases = None
    for node in tree.body:
        if isinstance(node, ast.Assign) and any(
                isinstance(t, ast.Name) and t.id == "CASES"
                for t in node.targets):
            cases = ast.literal_eval(node.value)
    if cases is None or len(cases) != 12:
        problems.append("GCC target codegen must retain 12 independent oracle cases")
        case_names = set()
    else:
        case_names = {row[0] for row in cases}
        for name, options, required, forbidden in cases:
            original_path = ROOT / "refs/gcc-pdp10-target-v2" / name
            if not original_path.is_file():
                problems.append("GCC target codegen original is missing: " + name)
                continue
            original_text = original_path.read_text(encoding="latin1")
            historical_options = re.findall(r'dg-options\s+"([^"]+)"',
                                           original_text)
            expected_options = historical_options[0] if historical_options else ""
            if len(historical_options) != 1 or options != expected_options:
                problems.append("GCC target compiler options changed: " + name)
            positives = len(re.findall(r'\bscan-assembler\s+"', original_text))
            negatives = len(re.findall(r'\bscan-assembler-not\s+"', original_text))
            if len(required) != positives:
                problems.append("GCC target lost positive assembler scans: " + name)
            if name == "das-octal-immediate-1.c":
                # The original three negatives are one equivalent alternation.
                if (negatives != 3 or len(forbidden) != 1 or
                        not all(token in forbidden[0] for token in ("42", "43", "53"))):
                    problems.append("GCC target octal forbidden alternatives lost")
            elif len(forbidden) != negatives:
                problems.append("GCC target lost forbidden assembler scans: " + name)
        if len(case_names) != len(cases):
            problems.append("duplicate GCC target source in codegen CASES")
        if any(not required and not forbidden and name != "wide-convert-71.c"
               for name, _options, required, forbidden in cases):
            problems.append("GCC target source has vacuous compile-only oracle")
    wrappers = {
        "bare-dlink-libgcc.sh": "misc/validation/test-badl-tables-v2.sh",
        "libgcc-badptr-octal.sh": "misc/validation/test-gcc-target-badptr-octal-v3.sh",
        "libgcc-empty-static-members.sh": "misc/validation/test-gcc-target-static-members-v3.sh",
        "wide-int-mode-options.sh": "misc/validation/test-gcc-target-wide-macros-v3.sh",
    }
    companions = {"bare-dlink-libgcc-1.c": "bare-dlink-libgcc.sh",
                  "wide-int-mode-macros.c": "wide-int-mode-options.sh"}
    direct_count = shell_count = companion_count = removed_count = 0
    for original, review in zip(previous, current):
        name = review["source"]
        if any(original.get(field) != review.get(field)
               for field in original_fields):
            problems.append("GCC target v2 rewrote feasibility evidence: " + name)
        retained = ROOT / "refs/gcc-pdp10-target-v2" / name
        if name == "its-circ-1.c":
            removed_count += 1
            if (retained.exists() or review["resolution"] != "inapplicable-its-only"
                    or review["canonical_runner"]):
                problems.append("original ITS CIRC must not become a generic test")
        else:
            if (not retained.is_file() or
                    (retained.is_file() and hashlib.sha256(retained.read_bytes()).hexdigest()
                     != review["source_sha256"])):
                problems.append("GCC target original missing or hash changed: " + name)
            owner = review["canonical_runner"]
            if owner not in registered:
                problems.append("GCC target original lacks enabled owner: " + name)
            if name in companions:
                companion_count += 1
                if (review["resolution"] != "original-companion-not-independent" or
                        owner != wrappers[companions[name]]):
                    problems.append("GCC target companion wrongly scheduled: " + name)
            elif name.endswith(".sh"):
                shell_count += 1
                if (review["resolution"] != "original-shell-oracle-delegated" or
                        owner != wrappers.get(name)):
                    problems.append("GCC target original shell misowned: " + name)
                if name != "bare-dlink-libgcc.sh" and owner in registered:
                    wrapper = (ROOT / owner).read_text(encoding="utf8")
                    if name not in wrapper:
                        problems.append("GCC target wrapper loses original shell: " + name)
            else:
                direct_count += 1
                if (name not in case_names or owner != codegen or
                        review["resolution"] != "direct-codegen-oracle"):
                    problems.append("GCC target codegen source has no real oracle: " + name)
        for field in ("original_assertion", "adaptation_or_gate",
                      "independence_check", "duplicate_policy"):
            if not review.get(field, "").strip():
                problems.append("GCC target review lacks assertion: %s %s" % (name, field))
    if (direct_count, shell_count, companion_count, removed_count) != (12, 4, 2, 1):
        problems.append("GCC target classification is not 12/4/2/1")
    if direct_count != len(case_names):
        problems.append("GCC target codegen case not in 19 original review")
    print("gcc_target_originals=%d codegen=%d shell=%d companions=%d its_excluded=%d" %
          (len(current), direct_count, shell_count, companion_count, removed_count))


def audit():
    problems = []
    matrix = list(rows(MATRIX, comments=True))
    special = list(rows(SPECIAL))
    upstream = list(rows(CLASSIFIED))
    late_admissions = admitted_sources(upstream, matrix, problems)
    late_admissions.update(observed_originals(upstream, matrix, problems))
    matrix_paths = set(row["test"] for row in matrix)
    special_paths = set(row["path"] for row in special)

    # DAS suites are dispatched from profile-ordered registry entries.
    # A nested checker is owned by its enclosing fast/native script and
    # must not run a second time as an independent suite entry.
    das_profiles = collections.Counter()
    for row in special:
        if row["group"] != "das":
            continue
        profile = row["profile"]
        enabled = row["enabled"]
        das_profiles[profile] += 1
        if profile not in ("fast", "full", "native", "nested", "manual"):
            problems.append("unknown DAS execution profile: %s" % row["id"])
        elif enabled != ("manual" if profile == "manual" else "yes"):
            problems.append("inconsistent DAS registration: %s" % row["id"])
    for profile in ("fast", "full", "native"):
        if not das_profiles[profile]:
            problems.append("missing DAS execution group: " + profile)

    # The independent tools build is prepared exactly once outside the
    # registry; each entry owns a single assertion suite, never a second
    # source build or a nested aggregate rerun.
    tool_rows = [row for row in special if row["group"] == "tools"]
    if not tool_rows:
        problems.append("missing independent PDP10-TOOLS test cases")
    for row in tool_rows:
        if (row["runner"] != "sh" or row["profile"] != "repository" or
                row["enabled"] != "yes" or
                not row["path"].startswith("misc/tools/cases/")):
            problems.append("invalid independent tool-case ownership: " +
                            row["id"])

    for label, keys in (("matrix source", [r["test"] for r in matrix]),
                        ("special ID", [r["id"] for r in special]),
                        ("special script", [r["path"] for r in special]),
                        ("upstream original", [r["previous_path"]
                                               for r in upstream]),
                        ("upstream destination", [r["classified_path"]
                                                  for r in upstream])):
        for key in duplicates(keys):
            problems.append("duplicate %s: %s" % (label, key))

    for label, paths in (("matrix", matrix_paths),
                         ("special", special_paths)):
        for rel in sorted(paths):
            # Refuse paths leaving the testkit, including traversal.
            full = (ROOT / rel).resolve()
            if not full.is_relative_to(ROOT) or not full.is_file():
                problems.append("invalid %s source: %s" % (label, rel))

    for rel in sorted(matrix_paths & special_paths):
        problems.append("matrix/special double ownership: %s" % rel)

    counts = collections.Counter()
    for row in upstream:
        activation = row["activation"]
        rel = row["classified_path"]
        full = (ROOT / rel).resolve()
        counts[activation] += 1
        if activation not in REQUIRED_ACTIVATIONS:
            problems.append("unknown activation: %s: %s" % (rel, activation))
        exists = full.is_relative_to(ROOT) and full.is_file()
        registered = rel in matrix_paths
        if activation == "removed":
            if exists or registered:
                problems.append("removed source still present/registered: %s" % rel)
        elif (rel == HISTORICAL_PATH and
              source_matches_historical(rel, HISTORICAL_SHA)):
            if exists or registered or CURRENT_PATH not in matrix_paths:
                problems.append("retired original has wrong matrix owner: " +
                                rel)
        else:
            if not exists:
                problems.append("missing retained upstream source: %s" % rel)
            if registered != (activation == "active" or
                              rel in late_admissions):
                problems.append("upstream registration mismatch: %s (%s)" %
                                (rel, activation))
        if rel in special_paths:
            problems.append("upstream source registered as special: %s" % rel)

    source_files = set(str(path.relative_to(ROOT)) for path in
                       (ROOT / "tests").rglob("*")
                       if path.is_file() and path.suffix in (".c", ".s", ".S"))
    known_deferred = set(r["classified_path"] for r in upstream
                         if r["activation"] in ("deferred", "stress-nonportable"))
    unowned = (source_files - matrix_paths - special_paths - known_deferred -
               set(SUPPORT_SOURCE_OWNERS))
    for source, owner in sorted(SUPPORT_SOURCE_OWNERS.items()):
        if source not in source_files:
            problems.append("missing declared companion: " + source)
        if owner not in matrix_paths and owner not in special_paths:
            problems.append("unregistered companion owner: %s (%s)" %
                            (source, owner))
    for source in sorted(unowned):
        problems.append("unowned test source: " + source)
    audit_consolidated_sources(upstream, matrix, problems,
                               late_admissions=late_admissions)
    audit_gcc_target_ownership(special, problems)
    print("matrix_sources=%d special_entries=%d special_unique_ids=%d" %
          (len(matrix), len(special), len(set(r["id"] for r in special))))
    print("upstream_classified=%d %s" %
          (len(upstream), " ".join("%s=%d" % (key, counts[key])
                                   for key in sorted(counts))))
    print("owned_companion_sources=%d unowned_test_sources=%d" %
          (len(SUPPORT_SOURCE_OWNERS), len(unowned)))

    for problem in problems:
        print("ERROR: " + problem, file=sys.stderr)
    print("inventory: %s (%d error(s))" %
          ("FAIL" if problems else "PASS", len(problems)))
    return int(bool(problems))


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description=__doc__)
    ap.parse_args()
    sys.exit(audit())
