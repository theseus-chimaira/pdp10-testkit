#!/usr/bin/env python3
"""Verify a freestanding four-family signed FP conversion diagnostic.

The original 36/71-bit and unsigned conversion coverage remains
blocked: the installed GCC runtime lacks __fixunssfsi. This companion
tests only defined signed 36-bit int/float/double conversions, keeps
all four families running even after a failure, and pins six real
guest results without ever claiming compiler correctness.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/semantic/regression/pdp10-fp-signed-conversion-v1.c"
ORIGINAL = "tests/semantic/upstream/pdp10/pdp10/conversion.c"
SHA = "90a627b3d14f427826fbc6291638824a485e95e65f1f451684b94a7c2ed468e5"
MANIFEST = ROOT / "docs/PDP10-P1-FP-SIGNED-CONVERSION-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-fp-signed-conversion-evidence-20261120-v1.tar.gz"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
RESOLUTION = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v12.tsv"
FIELDS = ("source", "source_sha256", "profile", "status",
          "failed_groups_octal", "report_member", "report_sha256",
          "map_member", "map_sha256")
CASES = (
    ("kcc-pdp6-noopt", "000000000003"),
    ("kcc-pdp6-opt", "000000000017"),
    ("gcc-pdp6-o0", "000000000001"),
    ("gcc-pdp6-o1", "000000000001"),
    ("gcc-pdp6-o2", "000000000001"),
    ("gcc-pdp6-os", "000000000001"),
)
REQUIRED_SOURCE = (
    "volatile int integer_inputs_v1[5]",
    "volatile float float_inputs_v1[7]",
    "volatile double double_inputs_v1[7]",
    "const float float_expected_v1[5]",
    "const double double_expected_v1[5]",
    "const int integer_expected_v1[7]",
    "int_to_float_v1(input)",
    "int_to_double_v1(input)",
    "float_to_int_v1(f)",
    "double_to_int_v1(d)",
    "fail_id |= group",
    "if (fail_id != 0)",
    "abort();",
)


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream
             if line.strip() and (not comments or not line.startswith("#"))),
            delimiter="\t"))


def validate(rows, matrix, resolution):
    if len(rows) != 6 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("six original compiler profiles required")
    source = ROOT / SOURCE
    if (not source.is_file() or
            hashlib.sha256(source.read_bytes()).hexdigest() != SHA):
        raise ValueError("signed conversion source SHA-256 changed")
    text = source.read_text(encoding="ascii")
    if any(token not in text for token in REQUIRED_SOURCE):
        raise ValueError("signed conversion arithmetic oracle weakened")
    if any(token in text for token in
           ("#include <stdio.h>", "malloc(", "printf(", "TOPS20",
            "unsigned long long", "__fixunssfsi")):
        raise ValueError("hosted or unsupported unsigned path introduced")
    previous = [r for r in resolution if r["original_source"] == ORIGINAL]
    if (len(previous) != 1 or previous[0]["p1_state"] != "blocked" or
            previous[0]["original_sha256"] != hashlib.sha256(
                (ROOT / ORIGINAL).read_bytes()).hexdigest()):
        raise ValueError("entire original conversion source wrongly closed")
    owners = [r for r in matrix if r["test"] == SOURCE]
    if (len(owners) != 1 or owners[0]["group"] != "semantic-regression" or
            owners[0]["name"] != "pdp10-fp-signed-conversion-v1" or
            any(owners[0][column] != "fail" for column in
                ("pdp6", "pdp6_gcc_o0", "pdp6_gcc_o1",
                 "pdp6_gcc_o2", "pdp6_gcc_os")) or
            any(owners[0][cpu] != "pending" for cpu in
                ("ka10", "ki10", "ks10"))):
        raise ValueError("incorrect runtime compiler matrix cells")
    for row, (profile, mask) in zip(rows, CASES):
        base = "pdp6/" + profile
        if (row["source"] != SOURCE or row["source_sha256"] != SHA or
                row["profile"] != profile or row["status"] != "run_fail" or
                row["failed_groups_octal"] != mask or
                row["report_member"] != base + ".report.txt" or
                row["map_member"] != base + ".map" or
                any(re.fullmatch("[0-9a-f]{64}", row[key]) is None
                    for key in ("report_sha256", "map_sha256"))):
            raise ValueError("compiler source/profile/failure-mask mismatch")


def verify_archive(rows, payload):
    names = {row[key] for row in rows for key in
             ("report_member", "map_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 12 or
                    {member.name for member in members} != names or
                    any(not member.isfile() for member in members)):
                raise ValueError("missing or unsafe guest archive member")
            for row in rows:
                output = {}
                for key, digest in (("report_member", "report_sha256"),
                                    ("map_member", "map_sha256")):
                    stream = archive.extractfile(row[key])
                    if stream is None:
                        raise ValueError("missing real conversion evidence")
                    data = stream.read()
                    if hashlib.sha256(data).hexdigest() != row[digest]:
                        raise ValueError("corrupted conversion evidence")
                    output[key] = data.decode("utf-8", errors="replace")
                report = output["report_member"]
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=FAIL$", report, re.M) or
                        "HALT instruction" not in report or
                        "Step expired" in report or
                        not re.search(
                            r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                            r"[^\n]+\t000000000001\b", report) or
                        not re.search(
                            r"__P10RUN_EXPECT__ fail_id [^\n]+\n"
                            r"[^\n]+\t" + row["failed_groups_octal"] +
                            r"\b", report)):
                    raise ValueError("guest failure-group mask not proved")
                if row["profile"].startswith("gcc"):
                    for helper in ("__floatsisf", "__floatsidf",
                                   "__fixsfsi", "__fixdfsi"):
                        if not re.search(r"^" + helper + r"\s+[0-7]+\s*$",
                                         output["map_member"], re.M):
                            raise ValueError("GCC conversion helper missing: " +
                                             helper)
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("cannot read archived guest conversion evidence") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(RESOLUTION))
    verify_archive(rows, ARCHIVE.read_bytes())
    print("PASS: signed native conversion companion, 6 PDP-6 run_fail "
          "reports, four conversion groups, original remains blocked")


if __name__ == "__main__":
    audit()
