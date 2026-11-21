#!/usr/bin/env python3
"""Audit the complete native-width invalid-address prefetch companion.

An erased hardware prefetch instruction is permitted.  Its address
expression must still execute once, and the test must not dereference
any deliberately invalid pointer.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/semantic/regression/pdp10-prefetch-invalid-address-v1.c"
ORIGINAL = "tests/semantic/upstream/extensions/builtin-prefetch-6.c"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
HISTORICAL = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v9.tsv"
LEDGER = ROOT / "manifests/PDP10-P1-PREFETCH-INVALID-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-prefetch-invalid-evidence-20261120-v1.tar.gz"
FIELDS = ("source", "source_sha256", "profile", "status",
          "archive_member", "report_sha256")
PROFILES = ("gcc-pdp6-o0", "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")
SHA = "48c9115c99198f78e57b3361517eb72dffd63613cd8918ef20b25dc1073d27ec"


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream
             if line.strip() and (not comments or not line.startswith("#"))),
            delimiter="\t"))


def validate(rows, matrix, historical):
    if len(rows) != 4 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("expected four original PDP-6 compiler observations")
    path = ROOT / SOURCE
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != SHA:
        raise ValueError("native invalid-address source has changed")
    text = path.read_text(encoding="ascii")
    for token in (
            "ADDRESS_COUNT_V1 65", "TARGET_BITS_V1 9",
            "sizeof(void *) * TARGET_BITS_V1",
            "sizeof(unsigned long) * TARGET_BITS_V1 == 36",
            "1UL << i", "invalid_v1[i] = (void *)word",
            "__builtin_prefetch(address_v1(i), 0, 0)",
            "__builtin_prefetch(address_v1(i), 1, 0)",
            "evaluations_v1 == 2 * ADDRESS_COUNT_V1",
            "read_calls_v1 == ADDRESS_COUNT_V1",
            "write_calls_v1 == ADDRESS_COUNT_V1",
            "fail_id", "abort()"):
        if token not in text:
            raise ValueError("native-width prefetch check no longer substantive")
    original = [r for r in historical if r["original_source"] == ORIGINAL]
    if (len(original) != 1 or original[0]["p1_state"] != "partial" or
            original[0]["original_sha256"] != hashlib.sha256(
                (ROOT / ORIGINAL).read_bytes()).hexdigest()):
        raise ValueError("historical partial prerequisite was changed")
    matches = [r for r in matrix if r["test"] == SOURCE]
    if len(matches) != 1 or matches[0]["group"] != "semantic-regression":
        raise ValueError("wrong owner for native prefetch companion")
    owner = matches[0]
    if (any(owner["pdp6_gcc_" + opt] != "semantic"
            for opt in ("o0", "o1", "o2", "os")) or
            any(owner[cpu + "_gcc_" + opt] != "pending"
                for cpu in ("ka10", "ki10", "ks10")
                for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("incorrect compiler profile selection")
    seen = set()
    for i, row in enumerate(rows):
        profile = PROFILES[i]
        if (row["source"] != SOURCE or row["source_sha256"] != SHA or
                row["profile"] != profile or row["status"] != "pass" or
                row["archive_member"] !=
                "pdp6/" + profile + ".report.txt" or
                re.fullmatch(r"[0-9a-f]{64}", row["report_sha256"]) is None):
            raise ValueError("incorrect executed profile/source hash")
        if profile in seen:
            raise ValueError("duplicate PDP-6 profile")
        seen.add(profile)


def verify_reports(rows, payload):
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 4 or
                    {m.name for m in members} !=
                    {r["archive_member"] for r in rows} or
                    any(not m.isfile() for m in members)):
                raise ValueError("missing/unsafe guest evidence")
            for row in rows:
                stream = archive.extractfile(row["archive_member"])
                if stream is None:
                    raise ValueError("missing archived simulator report")
                raw = stream.read()
                if hashlib.sha256(raw).hexdigest() != row["report_sha256"]:
                    raise ValueError("modified simulator report")
                report = raw.decode("utf-8", errors="replace")
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=PASS$", report, re.M) or
                        "HALT instruction" not in report or
                        not re.search(
                            r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                            r"[^\n]+\t000000000000\b", report) or
                        not re.search(
                            r"__P10RUN_EXPECT__ fail_id [^\n]+\n"
                            r"[^\n]+\t000000000000\b", report)):
                    raise ValueError("missing completed guest assertion PASS")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupted prefetch evidence archive") from error


def audit():
    rows = read(LEDGER)
    validate(rows, read(MATRIX, True), read(HISTORICAL))
    verify_reports(rows, ARCHIVE.read_bytes())
    print("PASS: invalid-address prefetch, 4 source-pinned GCC PDP-6 "
          "guest executions, all completed assertions PASS")


if __name__ == "__main__":
    audit()
