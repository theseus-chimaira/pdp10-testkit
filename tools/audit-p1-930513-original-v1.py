#!/usr/bin/env python3
"""Verify six real PDP-6 executions of the unchanged 930513-1.c oracle.

The original exercises floating argument passing through a sprintf function
pointer and checks both the generated character and the terminating NUL.
This is a test-construction gate, not a general compiler sweep.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/todo/generic/930513-1.c"
SOURCE_SHA = "0007986905cfa0ddbc7face84420a15d201b746a87e7a32440e5a4d3e442ba44"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v14.tsv"
MANIFEST = ROOT / "manifests/PDP10-P1-930513-ORIGINAL-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-930513-original-20261120-v1.tar.gz"
FIELDS = ("source", "source_sha256", "profile", "cpu", "status",
          "report_member", "report_sha256", "map_member", "map_sha256")
PROFILES = ("kcc-pdp6-noopt", "kcc-pdp6-opt", "gcc-pdp6-o0",
            "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def validate(rows, matrix, previous):
    if len(rows) != 6 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("original must have six complete PDP-6 profiles")
    source = ROOT / SOURCE
    if (not source.is_file() or
            hashlib.sha256(source.read_bytes()).hexdigest() != SOURCE_SHA):
        raise ValueError("original source hash differs from frozen import")
    data = source.read_text(encoding="ascii")
    for expression in ('#include <stdio.h>', 'char buf[2];',
                       'int (*fp)(char *, const char *, ...);',
                       '(*fp)(buf, "%.0f", 5.0);', 'f (&sprintf);',
                       "if (buf[0] != '5' || buf[1] != 0)",
                       'abort ();', 'exit (0);'):
        if expression not in data:
            raise ValueError("original floating-format assertion altered")
    previous_rows = [r for r in previous if r["original_source"] == SOURCE]
    if (len(previous_rows) != 1 or
            previous_rows[0]["p1_state"] != "blocked" or
            previous_rows[0]["original_sha256"] != SOURCE_SHA):
        raise ValueError("historical original status/hash changed")
    owners = [r for r in matrix if r["test"] == SOURCE]
    if (len(owners) != 1 or
            owners[0]["group"] != "semantic-upstream-deferred" or
            owners[0]["pdp6"] != "semantic" or
            any(owners[0]["pdp6_gcc_" + opt] not in ("pending", "semantic")
                for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("normal original matrix admission missing")
    for row, profile in zip(rows, PROFILES):
        stem = "pdp6/" + profile
        if (row["source"] != SOURCE or
                row["source_sha256"] != SOURCE_SHA or
                row["profile"] != profile or row["cpu"] != "pdp6" or
                row["status"] != "pass" or
                row["report_member"] != stem + ".report.txt" or
                row["map_member"] != stem + ".map" or
                any(re.fullmatch(r"[0-9a-f]{64}", row[key]) is None
                    for key in ("report_sha256", "map_sha256"))):
            raise ValueError("invalid original compiler/profile/hash evidence")


def validate_archive(rows, payload):
    names = {r[key] for r in rows for key in
             ("report_member", "map_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 12 or
                    {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("missing or unsafe guest report/map members")
            for row in rows:
                evidence = {}
                for member_key, sha_key in (("report_member", "report_sha256"),
                                            ("map_member", "map_sha256")):
                    handle = archive.extractfile(row[member_key])
                    if handle is None:
                        raise ValueError("missing archived guest evidence")
                    content = handle.read()
                    if hashlib.sha256(content).hexdigest() != row[sha_key]:
                        raise ValueError("archived report/map digest mismatch")
                    evidence[member_key] = content.decode("utf-8", "replace")
                report = evidence["report_member"]
                link_map = evidence["map_member"]
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=PASS$", report, re.M) or
                        "HALT instruction" not in report or
                        "Step expired" in report or
                        not re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                      r"[^\n]+\t000000000000\b", report)):
                    raise ValueError("original assertion did not complete")
                for symbol in ("f", "sprintf", "abort", "exit"):
                    if re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                 link_map, re.M) is None:
                        raise ValueError("missing real linked symbol: " + symbol)
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt evidence archive") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    print("PASS: original 930513-1.c six PDP-6 KCC/GCC executions, "
          "source and linker maps SHA-pinned")


if __name__ == "__main__":
    audit()
