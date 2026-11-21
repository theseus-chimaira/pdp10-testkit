#!/usr/bin/env python3
"""Audit all 67 P1 original test identities for genuine harness ownership.

This is an integration/ICE-hunting audit, *not* P1 semantic closure:
non-ICE compile, link, simulator and assertion failures remain intact.
The historic source whose bytes were retired is mapped only through
the independently reviewed byte-pointer replacement.  KL10 MACRO-10
remains in the special assembler harness, never the C compiler matrix.
"""

import argparse
import collections
import csv
import hashlib
from pathlib import Path

from p1_source_replacement_v1 import (
    HISTORICAL_PATH, CURRENT_PATH, source_matches_historical,
    current_path_for,
)

ROOT = Path(__file__).resolve().parents[1]
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
LEDGER = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261121-v29.tsv"
SPECIAL = ROOT / "SPECIAL_TESTS.tsv"
MANIFEST = ROOT / "docs/PDP10-P1-HARNESS-ORIGINALS-20261121-v1.tsv"
OBSERVATION_LIST = ROOT / "docs/PDP10-P1-HARNESS-OBSERVATIONS-20261121-v1.txt"
ALL_C_LIST = ROOT / "docs/PDP10-P1-HARNESS-ALL-C-20261121-v1.txt"
ISA = "tests/semantic/upstream/support/920428-1.s"
FIELDS = ("original_source", "original_sha256", "matrix_source",
          "registration", "historical_p1_state", "matrix_group",
          "active_profile_count")


def read(path, comments=False):
    with path.open(encoding="ascii", newline="") as stream:
        return list(csv.DictReader((line for line in stream
                                    if line.strip() and (not comments or
                                       not line.startswith("#"))),
                                   delimiter="\t"))


def cpu_columns(header):
    """The 55 distinct legal columns correspond to 66 runtime profiles."""
    excluded = {"pdp6_pdp10"}
    excluded.update("pdp6_gcc_pdp10_" + opt
                    for opt in ("o0", "o1", "o2", "os"))
    columns = tuple(c for c in header[3:] if c not in excluded)
    if len(header) != 63 or len(columns) != 55:
        raise ValueError("compiler profile columns changed unexpectedly")
    return columns, excluded


def missing_originals(ledger, matrix):
    installed = {row["test"] for row in matrix}
    return tuple(r for r in ledger
                 if r["original_source"] not in (ISA, HISTORICAL_PATH)
                 and r["original_source"] not in installed)


def nonasserting(disposition):
    return disposition == "nonasserting"


def row_for(original, header):
    source = original["original_source"]
    if not source.endswith(".c"):
        raise ValueError("C matrix admission requires .c source")
    group = ("codegen-p1-original-observation" if
             nonasserting(original["historical_disposition"]) else
             "semantic-p1-original-observation")
    result = dict.fromkeys(header, "no_test")
    result["test"] = source
    result["group"] = group
    result["name"] = Path(source).stem + "-p1-original-v1"
    allowed, excluded = cpu_columns(header)
    for name in allowed:
        result[name] = "pending"
    for name in excluded:
        result[name] = "unsupported"
    return result


def check(ledger, matrix, special, manifest):
    if len(ledger) != 67 or len({r["original_source"] for r in ledger}) != 67:
        raise ValueError("P1 original inventory must contain 67 unique sources")
    if (collections.Counter(r["p1_state"] for r in ledger) !=
            {"covered": 56, "blocked": 11}):
        raise ValueError("historical semantic closure ledger unexpectedly changed")
    if not matrix or len({r["test"] for r in matrix}) != len(matrix):
        raise ValueError("duplicate or missing compiler matrix rows")
    if len(manifest) != 67 or tuple(manifest[0]) != FIELDS:
        raise ValueError("all 67 original identities need a harness owner")
    header = tuple(matrix[0])
    allowed, excluded = cpu_columns(header)
    by_source = {row["test"]: row for row in matrix}
    by_special = {r["id"]: r for r in special}
    expected_missing = 38
    originals = set()
    added = 0
    for original, row in zip(ledger, manifest):
        src = original["original_source"]
        if src in originals:
            raise ValueError("duplicate original source identity")
        originals.add(src)
        current = current_path_for(src)
        if (not source_matches_historical(src, original["original_sha256"]) or
                row["original_source"] != src or
                row["original_sha256"] != original["original_sha256"] or
                row["matrix_source"] != current or
                row["historical_p1_state"] != original["p1_state"]):
            raise ValueError("original source provenance or status changed: " + src)
        if src == ISA:
            selected = by_special.get("p1-920428-kl10-toolchain-prereqs-v1")
            if (row["registration"] != "isa-special" or
                    row["matrix_group"] != "isa" or
                    row["active_profile_count"] != "0" or
                    current in by_source or selected is None or
                    selected["enabled"] != "yes" or
                    not (ROOT / selected["path"]).is_file()):
                raise ValueError("KL10 original must keep separate real ISA owner")
            continue
        matrix_row = by_source.get(current)
        if matrix_row is None:
            raise ValueError("C original lacks compiler matrix owner: " + src)
        if src == HISTORICAL_PATH:
            if (current != CURRENT_PATH or
                    row["registration"] != "reviewed-replacement"):
                raise ValueError("retired original replacement was not reviewed")
        elif matrix_row["group"].endswith("p1-original-observation"):
            if (matrix_row != row_for(original, header) or
                    row["registration"] != "original-observation"):
                raise ValueError("original admission lost a compiler profile: " + src)
            added += 1
        elif row["registration"] != "previously-registered":
            raise ValueError("existing matrix source was silently rewritten")
        if (row["matrix_group"] != matrix_row["group"] or
                row["active_profile_count"] != str(
                    sum((2 if c in ("pdp6", "ka10", "ki10", "ks10",
                                     "pdp6_base", "ka10_base", "ki10_base",
                                     "ks10_base", "ka10_pdp10", "ki10_pdp10",
                                     "ks10_pdp10") else 1)
                        for c in allowed if matrix_row[c] not in
                        ("no_test", "unsupported", "obsolete", "")))):
            raise ValueError("original has inconsistent active compiler cells")
    if added != expected_missing:
        raise ValueError("expected 38 newly scheduled historical C originals, got %d" % added)
    if any(r["test"] == ISA or r["test"] == HISTORICAL_PATH for r in matrix):
        raise ValueError("KL10/retired original illegally placed in C matrix")
    return added


def build(ledger, matrix, special):
    by_source = {r["test"]: r for r in matrix}
    header = tuple(matrix[0])
    allowed, _excluded = cpu_columns(header)
    records = []
    for original in ledger:
        source = original["original_source"]
        current = current_path_for(source)
        if source == ISA:
            registration, group, cells = "isa-special", "isa", 0
        else:
            matrix_row = by_source.get(current)
            if matrix_row is None:
                raise ValueError("missing original matrix source: " + current)
            if source == HISTORICAL_PATH:
                registration = "reviewed-replacement"
            elif matrix_row["group"].endswith("p1-original-observation"):
                registration = "original-observation"
            else:
                registration = "previously-registered"
            group = matrix_row["group"]
            cells = sum((2 if c in ("pdp6", "ka10", "ki10", "ks10",
                                  "pdp6_base", "ka10_base", "ki10_base",
                                  "ks10_base", "ka10_pdp10", "ki10_pdp10",
                                  "ks10_pdp10") else 1)
                        for c in allowed if matrix_row[c] not in
                        ("no_test", "unsupported", "obsolete", ""))
        records.append(dict(original_source=source,
                            original_sha256=original["original_sha256"],
                            matrix_source=current,
                            registration=registration,
                            historical_p1_state=original["p1_state"],
                            matrix_group=group,
                            active_profile_count=str(cells)))
    check(ledger, matrix, special, records)
    return records


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--integrate", action="store_true",
                        help="append only missing, source-pinned original C tests")
    args = parser.parse_args()
    ledger = read(LEDGER)
    matrix = read(MATRIX, True)
    special = read(SPECIAL)
    if args.integrate:
        missing = missing_originals(ledger, matrix)
        if len(missing) not in (0, 38):
            raise ValueError("unexpected count of missing original C sources")
        if missing:
            header = tuple(matrix[0])
            additions = [row_for(original, header) for original in missing]
            for original, row in zip(missing, additions):
                if (not source_matches_historical(original["original_source"],
                                                  original["original_sha256"]) or
                        not (ROOT / row["test"]).is_file()):
                    raise ValueError("missing source changed during integration")
            with MATRIX.open("a", encoding="ascii", newline="") as output:
                writer = csv.DictWriter(output, fieldnames=header,
                                        delimiter="\t", lineterminator="\n")
                writer.writerows(additions)
            matrix.extend(additions)
    records = build(ledger, matrix, special)
    observation_text = "".join(r["matrix_source"] + "\n" for r in records
                               if r["registration"] == "original-observation")
    all_c_text = "".join(r["matrix_source"] + "\n" for r in records
                         if r["registration"] != "isa-special")
    if (len(observation_text.splitlines()) != 38 or
            len(all_c_text.splitlines()) != 66 or
            len(set(all_c_text.splitlines())) != 66):
        raise ValueError("P1 source lists must cover 38 new and 66 total C owners")
    if args.write:
        with MANIFEST.open("w", encoding="ascii", newline="") as output:
            writer = csv.DictWriter(output, fieldnames=FIELDS, delimiter="\t",
                                    lineterminator="\n")
            writer.writeheader()
            writer.writerows(records)
        OBSERVATION_LIST.write_text(observation_text, encoding="ascii")
        ALL_C_LIST.write_text(all_c_text, encoding="ascii")
    else:
        if records != read(MANIFEST):
            raise ValueError("reviewed 67-source harness manifest was changed")
        if (OBSERVATION_LIST.read_text(encoding="ascii") != observation_text or
                ALL_C_LIST.read_text(encoding="ascii") != all_c_text):
            raise ValueError("one or more P1 source-selection lists changed")
    print("PASS: 67/67 P1 original harness identities, 38 newly observed C "
          "sources, one reviewed replacement, one separate KL10 ISA; "
          "historic 56/11 semantic states remain intact")


if __name__ == "__main__":
    main()
