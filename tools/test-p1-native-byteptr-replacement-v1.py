#!/usr/bin/env python3
"""Verify the sole PDP-10-native byte-pointer test and its six matrix cells.

Historical compiler logs are retained as immutable evidence for the
deleted import, not reinterpreted as results for the new C source.
"""

import argparse
import csv
from pathlib import Path
import re

from p1_source_replacement_v1 import (
    ROOT, CURRENT_PATH, HISTORICAL_PATH, HISTORICAL_SHA,
    check_replacement, source_matches_historical,
)

MATRIX = ROOT / "COMPILER_MATRIX.tsv"
LIVE = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v9.tsv"
BATCH = ROOT / "manifests/PDP10-P1-SOURCE-BATCHES-20261120-v8.tsv"
PROFILE_FAILURES = {
    "kcc-pdp6-opt": ("pdp6", "000000000014"),
    "kcc-pdp6-noopt": ("pdp6", "000000000012"),
    "gcc-pdp6-o0": ("pdp6_gcc_o0", "000000000025"),
    "gcc-pdp6-o1": ("pdp6_gcc_o1", "000000000034"),
    "gcc-pdp6-o2": ("pdp6_gcc_o2", "000000000034"),
    "gcc-pdp6-os": ("pdp6_gcc_os", "000000000034"),
}


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream
             if line.strip() and (not comments or
                                  not line.startswith("#"))),
            delimiter="\t"))


def verify(rows, ledger, batch):
    if not source_matches_historical(HISTORICAL_PATH, HISTORICAL_SHA):
        raise ValueError("old imported source was recreated or replacement changed")
    actual = [row for row in rows if row["test"] == CURRENT_PATH]
    if len(actual) != 1 or any(
            row["test"] == HISTORICAL_PATH for row in rows):
        raise ValueError("duplicate/original matrix owner remains")
    row = actual[0]
    if (row["group"] != "semantic-regression" or
            row["name"] != "pdp10-byte-pointer-torture-v1" or
            row["pdp6"] not in ("semantic", "fail") or
            any(row[name] != "fail" for name in
                ("pdp6_gcc_o0", "pdp6_gcc_o1", "pdp6_gcc_o2",
                 "pdp6_gcc_os")) or
            any(row[name] != "pending" for name in
                ("ka10", "ki10", "ks10"))):
        raise ValueError("native compiler matrix scheduling changed")
    current = [r for r in ledger if r["original_source"] ==
               HISTORICAL_PATH]
    if len(current) != 1 or (
            current[0]["original_sha256"] != HISTORICAL_SHA or
            current[0]["p1_state"] != "blocked" or
            current[0]["compiler_followup"] != "pdp10-byte-pointer-abi" or
            CURRENT_PATH not in current[0]["p1_remaining_action"]):
        raise ValueError("historical source incorrectly closed or preserved")
    assigned = [r for r in batch if r["original_source"] == HISTORICAL_PATH]
    if (len(assigned) != 1 or assigned[0]["batch"] != "6" or
            assigned[0]["slot"] != "3" or
            assigned[0]["source_sha256"] != HISTORICAL_SHA or
            assigned[0]["live_state"] != "blocked" or
            assigned[0]["remaining_action"] !=
            current[0]["p1_remaining_action"]):
        raise ValueError("frozen Batch 6 historical identity was changed")


def verify_runner(failures):
    observed = read(failures)
    if len(observed) != 6:
        raise ValueError("expected six actual native PDP-6 matrix outcomes")
    seen = set()
    for row in observed:
        profile = row["profile"]
        if profile not in PROFILE_FAILURES or profile in seen:
            raise ValueError("duplicate/unknown profile: " + profile)
        seen.add(profile)
        if (row["test"] != CURRENT_PATH or row["machine"] != "pdp6" or
                row["status"] != "run_fail" or
                row["compiler"] != profile.split("-", 1)[0]):
            raise ValueError("old source or nonfailure mistaken for current")
        cell_log = Path(row["report"])
        if not cell_log.is_file():
            raise ValueError("missing native guest cell log: " + str(cell_log))
        log = cell_log.read_text(errors="replace")
        found = re.search(r"(?m)^see report: (\S+\.report\.txt)$", log)
        if found is None:
            raise ValueError("runner did not record actual SIMH report")
        report = Path(found.group(1))
        if not report.is_file():
            raise ValueError("missing native guest report: " + str(report))
        text = report.read_text(errors="replace")
        actual_fail_id = PROFILE_FAILURES[profile][1]
        if (not re.search(r"^rc=0$", text, re.M) or
                not re.search(r"^result=FAIL$", text, re.M) or
                "HALT instruction" not in text or
                "Step expired" in text or
                not re.search(
                    r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                    r"[^\n]+\t000000000001\b", text) or
                not re.search(
                    r"__P10RUN_EXPECT__ fail_id [^\n]+\n"
                    r"[^\n]+\t" + actual_fail_id + r"\b", text)):
            raise ValueError("native guest failure evidence mismatched: " +
                             profile)


def rejected(rows, ledger, batch):
    try:
        verify(rows, ledger, batch)
    except ValueError:
        return
    raise AssertionError("mutation of native test ownership was accepted")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--failures", type=Path,
                        help="optional six-cell normal runner failures.tsv")
    args = parser.parse_args()
    check_replacement()
    rows, ledger, batch = read(MATRIX, True), read(LIVE), read(BATCH)
    verify(rows, ledger, batch)
    mutated = [dict(r) for r in rows]
    next(r for r in mutated if r["test"] == CURRENT_PATH)["group"] = "codegen"
    rejected(mutated, ledger, batch)
    mutated = [dict(r) for r in rows]
    next(r for r in mutated if r["test"] == CURRENT_PATH)[
        "pdp6_gcc_o0"] = "no_test"
    rejected(mutated, ledger, batch)
    mutated = [dict(r) for r in rows]
    mutated.append(dict(next(r for r in rows if r["test"] == CURRENT_PATH)))
    rejected(mutated, ledger, batch)
    mutated = [dict(r) for r in ledger]
    next(r for r in mutated if r["original_source"] ==
         HISTORICAL_PATH)["p1_state"] = "covered"
    rejected(rows, mutated, batch)
    mutated = [dict(r) for r in batch]
    next(r for r in mutated if r["original_source"] ==
         HISTORICAL_PATH)["slot"] = "4"
    rejected(rows, ledger, mutated)
    if args.failures:
        verify_runner(args.failures)
    print("PASS: retired import replaced by native matrix test, "
          "6 scheduled PDP-6 cells, 5 negative controls" +
          (", 6 actual guest failures" if args.failures else ""))


if __name__ == "__main__":
    main()
