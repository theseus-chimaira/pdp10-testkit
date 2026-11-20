#!/usr/bin/env python3
"""Verify unchanged hosted struct-ret plus independently asserted return ABI.

The original checks formatted side effects, not returned fields. The
separate freestanding source checks those fields and is allowed to fail
genuine compiler assertions. Test construction must preserve both.
"""

import csv
import hashlib
import importlib.util
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/todo/generic/generic/struct-ret-1.c"
SOURCE_SHA = "c9c28e7b4daa3d36e8be3590a722e8a22de63ce8d9e56927ed42bd03b7bccd74"
PREVIOUS = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v15.tsv"
MANIFEST = ROOT / "docs/PDP10-P1-STRUCTRET-HOSTED-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-structret-hosted-20261120-v1.tar.gz"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
PROFILES = ("gcc-pdp6-o0", "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")
FIELDS = ("source", "source_sha256", "profile", "cpu", "status",
          "report_member", "report_sha256", "map_member", "map_sha256")


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def validate(rows, matrix, previous):
    if len(rows) != 4 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("four PDP-6 original GCC profiles required")
    source = ROOT / SOURCE
    if (not source.is_file() or
            hashlib.sha256(source.read_bytes()).hexdigest() != SOURCE_SHA):
        raise ValueError("unchanged historical original source is required")
    original = source.read_text(encoding="ascii")
    for assertion in ("typedef struct { double d; int i[3]; } B;",
                      "typedef struct { char c[33],c1; } X;",
                      "Xr = f (B1, c2, d3, B2);",
                      "Xr = (*fp) (B1, c2, d3, B2);",
                      "if (strcmp (tmp, out))", "abort ();", "exit (0);"):
        if assertion not in original:
            raise ValueError("original formatting/ABI source was weakened")
    historical = [r for r in previous if r["original_source"] == SOURCE]
    if (len(historical) != 1 or historical[0]["p1_state"] != "blocked" or
            historical[0]["original_sha256"] != SOURCE_SHA):
        raise ValueError("previous blocked P1 original is no longer intact")
    registrations = [r for r in matrix if r["test"] == SOURCE]
    if (len(registrations) != 1 or
            registrations[0]["group"] != "semantic-upstream-deferred" or
            registrations[0]["pdp6"] != "semantic" or
            any(registrations[0]["pdp6_gcc_" + opt] not in
                ("semantic", "pending") for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("original normal matrix cells were not preserved")
    for row, profile in zip(rows, PROFILES):
        prefix = "pdp6/" + profile
        if (row["source"] != SOURCE or row["source_sha256"] != SOURCE_SHA or
                row["profile"] != profile or row["cpu"] != "pdp6" or
                row["status"] != "pass" or
                row["report_member"] != prefix + ".report.txt" or
                row["map_member"] != prefix + ".map" or
                any(re.fullmatch(r"[0-9a-f]{64}", row[field]) is None
                    for field in ("report_sha256", "map_sha256"))):
            raise ValueError("unverified original/profile/evidence manifest")


def validate_archive(rows, payload):
    expected = {r[key] for r in rows for key in
                ("report_member", "map_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 8 or {m.name for m in members} != expected or
                    any(not m.isfile() for m in members)):
                raise ValueError("original guest evidence archive is incomplete")
            for row in rows:
                content = {}
                for name, digest in (("report_member", "report_sha256"),
                                     ("map_member", "map_sha256")):
                    handle = tar.extractfile(row[name])
                    if handle is None:
                        raise ValueError("missing archived original evidence")
                    data = handle.read()
                    if hashlib.sha256(data).hexdigest() != row[digest]:
                        raise ValueError("original evidence SHA mismatch")
                    content[name] = data.decode("utf-8", "replace")
                report = content["report_member"]
                linked = content["map_member"]
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=PASS$", report, re.M) or
                        "HALT instruction" not in report or
                        "Step expired" in report or
                        re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                  r"[^\n]+\t000000000000\b", report) is None):
                    raise ValueError("original formatting oracle did not finish")
                for symbol in ("f", "fp", "sprintf", "strcmp", "strcpy",
                               "exit", "abort"):
                    if re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                 linked, re.M) is None:
                        raise ValueError("real hosted symbol absent: " + symbol)
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt original guest archive") from error


def audit_companion():
    spec = importlib.util.spec_from_file_location(
        "p10tk_return_oracles_v1", ROOT / "tools/audit-p1-return-oracles-v1.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    case = module.CASES[0]
    rows = module.read(ROOT / case["records"])
    module.validate_case(case, rows, module.read(module.MATRIX, True),
                         module.read(module.LIVE))
    module.validate_archive(case, rows, (ROOT / case["archive"]).read_bytes())
    if ([r["status"] for r in rows] !=
            ["timeout", "timeout", "run_fail", "pass", "pass", "pass"]):
        raise ValueError("companion compiler failures were lost")


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    audit_companion()
    print("PASS: unchanged struct-ret original (4 GCC PASS) plus "
          "asserting return ABI companion (3 PASS, 1 run_fail, 2 timeout)")


if __name__ == "__main__":
    audit()
