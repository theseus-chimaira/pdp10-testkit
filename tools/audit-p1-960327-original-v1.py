#!/usr/bin/env python3
"""Audit real original 960327-1.c sprintf/string-mutation guest coverage.

The unchanged original and nine real KCC/GCC guest PASS reports are
required.  Historical missing GCC stdio.h diagnoses remain immutable
snapshots, not assertions about the currently installed GCC target.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/todo/generic/960327-1.c"
SOURCE_SHA = "4bec9f2b308084b20c8be0672382c8d787b83438283c9aa37bcb7fa985a77e3f"
HISTORICAL = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v13.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
MANIFEST = ROOT / "docs/PDP10-P1-960327-HOSTED-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-960327-hosted-20261120-v1.tar.gz"
FIELDS = ("source", "source_sha256", "profile", "cpu", "status",
          "report_member", "report_sha256", "map_member", "map_sha256")
CPUS = ("pdp6", "ka10", "ki10", "ks10")
PROFILES = tuple(("kcc-" + cpu + "-" + opt, cpu) for cpu in CPUS
                 for opt in ("noopt", "opt")) + (("gcc-pdp6-o0", "pdp6"),)


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream
             if line.strip() and (not comments or
                                  not line.startswith("#"))),
            delimiter="\t"))


def validate(rows, matrix, historical):
    if len(rows) != 9 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("original must have nine source-pinned guest results")
    original = ROOT / SOURCE
    if (not original.is_file() or
            hashlib.sha256(original.read_bytes()).hexdigest() != SOURCE_SHA):
        raise ValueError("original 960327 source was modified")
    source = original.read_text(encoding="ascii")
    for expression in (
            "#include <stdio.h>", "char s[] = \"abcedfg012345\"",
            "char *sp = s + 12;", "switch (g ())", "while (*--sp == '0')",
            'sprintf (sp + 1, "X")', "if (s[12] != 'X')",
            "abort ();", "exit (0);"):
        if expression not in source:
            raise ValueError("original string-mutation assertion weakened")
    frozen = [r for r in historical if r["original_source"] == SOURCE]
    if (len(frozen) != 1 or frozen[0]["p1_state"] != "blocked" or
            frozen[0]["original_sha256"] != SOURCE_SHA):
        raise ValueError("historical blocked status/source hash was changed")
    owners = [r for r in matrix if r["test"] == SOURCE]
    if (len(owners) != 1 or
            owners[0]["group"] != "semantic-upstream-deferred" or
            owners[0]["pdp6"] != "semantic" or
            owners[0]["pdp6_gcc_o0"] != "semantic" or
            any(owners[0][cpu] != "pending" for cpu in CPUS[1:])):
        raise ValueError("original compiler matrix owner no longer valid")
    for row, (profile, cpu) in zip(rows, PROFILES):
        stem = cpu + "/" + profile
        if (row["source"] != SOURCE or
                row["source_sha256"] != SOURCE_SHA or
                row["profile"] != profile or row["cpu"] != cpu or
                row["status"] != "pass" or
                row["report_member"] != stem + ".report.txt" or
                row["map_member"] != stem + ".map" or
                any(re.fullmatch("[0-9a-f]{64}", row[key]) is None
                    for key in ("report_sha256", "map_sha256"))):
            raise ValueError("incorrect original CPU/profile evidence")


def validate_archive(rows, payload):
    names = {r[key] for r in rows for key in
             ("report_member", "map_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 18 or
                    {member.name for member in members} != names or
                    any(not member.isfile() for member in members)):
                raise ValueError("incomplete/unsafe original evidence archive")
            for row in rows:
                content = {}
                for key, digest in (("report_member", "report_sha256"),
                                    ("map_member", "map_sha256")):
                    stream = archive.extractfile(row[key])
                    if stream is None:
                        raise ValueError("missing original guest report/map")
                    payload = stream.read()
                    if hashlib.sha256(payload).hexdigest() != row[digest]:
                        raise ValueError("original guest evidence hash mismatch")
                    content[key] = payload.decode("utf-8", errors="replace")
                report = content["report_member"]
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=PASS$", report, re.M) or
                        "HALT instruction" not in report or
                        "Step expired" in report or
                        not re.search(
                            r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                            r"[^\n]+\t000000000000\b", report)):
                    raise ValueError("original guest did not complete assertion")
                if not re.search(r"^sprintf\s+[0-7]+\s*$",
                                 content["map_member"], re.M):
                    raise ValueError("original formatted write not linked")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt archived original execution") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(HISTORICAL))
    validate_archive(rows, ARCHIVE.read_bytes())
    print("PASS: 960327-1.c unchanged original: 8 KCC and 1 GCC "
          "native guest PASS, all sprintf link maps verified")


if __name__ == "__main__":
    audit()
