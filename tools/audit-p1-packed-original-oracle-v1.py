#!/usr/bin/env python3
"""Verify original packed-aggregate assertions execute and fail genuinely.

Coverage of an original oracle is not compiler correctness. Both
installed PDP-6 compilers fail the real assertion after linking real
memcpy; no compiler or library source is changed here.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/semantic/upstream/extensions/20010518-2.c"
SHA = "7ed1a5988dbf615d39ff021a1b3c69b37f82d3a457a6d99ff74468e755a3e7b9"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
HISTORICAL = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v10.tsv"
LEDGER = ROOT / "docs/PDP10-P1-PACKED-ORIGINAL-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-packed-original-evidence-20261120-v1.tar.gz"
FIELDS = ("source", "source_sha256", "profile", "status", "report_member",
          "report_sha256", "map_member", "map_sha256")
PROFILES = ("kcc-pdp6-noopt", "gcc-pdp6-o0")


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def validate(rows, matrix, historical):
    if len(rows) != 2 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("exactly two installed native compiler cells required")
    path = ROOT / SOURCE
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != SHA:
        raise ValueError("original packed source modified")
    source = path.read_text(encoding="ascii")
    for token in (
            "__attribute__ ((packed)) b_struct",
            "__attribute__ ((packed)) a_struct",
            "*a = (a_struct){1,2,3,4}",
            "memcpy ((void *)a, &(a_struct){1,2,3,4}, sizeof (a_struct))",
            "memcpy ((void *)a, (void *)&b, sizeof (a_struct))",
            "a->e.b4 = 'c'",
            "a->a != 1", "a->b != 2", "a->c != 3",
            "a->d != 4", "a->e.b4 != 'c'", "abort ();"):
        if token not in source:
            raise ValueError("original packed assertion was lost")
    older = [r for r in historical if r["original_source"] == SOURCE]
    if (len(older) != 1 or older[0]["p1_state"] != "blocked" or
            older[0]["original_sha256"] != SHA or
            older[0]["compiler_followup"] != "packed-aggregate-compiler"):
        raise ValueError("historical packed compiler blocker altered")
    owners = [r for r in matrix if r["test"] == SOURCE]
    if (len(owners) != 1 or
            owners[0]["group"] != "semantic-upstream-deferred" or
            owners[0]["pdp6"] not in ("semantic", "fail") or
            owners[0]["pdp6_gcc_o0"] not in ("semantic", "fail")):
        raise ValueError("original executable compiler matrix owner missing")
    for row, profile in zip(rows, PROFILES):
        pre = "pdp6/" + profile
        if (row["source"] != SOURCE or row["source_sha256"] != SHA or
                row["profile"] != profile or row["status"] != "run_fail" or
                row["report_member"] != pre + ".report.txt" or
                row["map_member"] != pre + ".map" or
                any(re.fullmatch("[0-9a-f]{64}", row[key]) is None
                    for key in ("report_sha256", "map_sha256"))):
            raise ValueError("packed compiler/source/diagnostic identity changed")


def verify_reports(rows, payload):
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            names = {row[key] for row in rows for key in
                     ("report_member", "map_member")}
            if (len(members) != 4 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("incomplete packed original evidence")
            for row in rows:
                contents = {}
                for key, digest in (("report_member", "report_sha256"),
                                    ("map_member", "map_sha256")):
                    entry = archive.extractfile(row[key])
                    if entry is None:
                        raise ValueError("missing packed execution file")
                    raw = entry.read()
                    if hashlib.sha256(raw).hexdigest() != row[digest]:
                        raise ValueError("packed execution evidence tampered")
                    contents[key] = raw.decode("utf-8", errors="replace")
                report = contents["report_member"]
                symbols = contents["map_member"]
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=FAIL$", report, re.M) or
                        "HALT instruction" not in report or
                        "Step expired" in report or
                        not re.search(
                            r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                            r"[^\n]+\t000000000001\b", report)):
                    raise ValueError("no completed genuine packed assertion failure")
                for symbol in ("memcpy", "abort", "exit"):
                    if not re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                     symbols, re.M):
                        raise ValueError("missing linked runtime: " + symbol)
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt packed execution archive") from error


def audit():
    rows = read(LEDGER)
    validate(rows, read(MATRIX, True), read(HISTORICAL))
    verify_reports(rows, ARCHIVE.read_bytes())
    print("PASS: original packed-aggregate semantic oracle, two real "
          "PDP-6 compiler assertion failures, all runtime symbols linked")


if __name__ == "__main__":
    audit()
