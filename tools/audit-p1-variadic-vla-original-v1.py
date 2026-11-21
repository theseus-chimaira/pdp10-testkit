#!/usr/bin/env python3
"""Verify real original variable-sized va_arg compiler outcomes.

The original GNU test is preserved byte-for-byte. It checks two
five-character variable-sized aggregates through genuine va_arg;
four GCC guest runs fail this assertion, and KCC cannot compile
the GNU extension. None of these observations is called a PASS.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/todo/generic/20020412-1.c"
SHA = "e3ba27c686930bd2109700edb3c66a7d8b0d643f08be3cb89ae809aac6985c82"
MANIFEST = ROOT / "manifests/PDP10-P1-VARIADIC-VLA-ORIGINAL-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-variadic-vla-original-evidence-20261120-v1.tar.gz"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
HISTORICAL = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v11.tsv"
FIELDS = ("source", "source_sha256", "profile", "status",
          "evidence_member", "evidence_sha256", "map_member", "map_sha256")
PROFILES = ("kcc-pdp6-noopt", "gcc-pdp6-o0", "gcc-pdp6-o1",
            "gcc-pdp6-o2", "gcc-pdp6-os")


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(
            (line for line in handle
             if line.strip() and (not comments or
                                  not line.startswith("#"))),
            delimiter="\t"))


def validate(rows, matrix, historical):
    if len(rows) != 5 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("exactly five original compiler cells required")
    path = ROOT / SOURCE
    if (not path.is_file() or
            hashlib.sha256(path.read_bytes()).hexdigest() != SHA):
        raise ValueError("original variadic VLA source changed")
    source = path.read_text(encoding="ascii")
    for token in (
            "#include <stdarg.h>", "char x[size]", "va_start (ap, size)",
            "d = va_arg (ap, typeof (d))",
            "bar (d.x[i])", "va_end (ap)", "c != d++",
            "c < '0' || c > '9'", "abort ()",
            "foo (z, x, y)", "exit (0)"):
        if token not in source:
            raise ValueError("original VLA va_arg oracle weakened: " + token)
    if source.count("d = va_arg (ap, typeof (d))") != 2:
        raise ValueError("both distinct variadic aggregates required")
    frozen = [r for r in historical if r["original_source"] == SOURCE]
    if (len(frozen) != 1 or frozen[0]["p1_state"] != "blocked" or
            frozen[0]["original_sha256"] != SHA):
        raise ValueError("historical GNU extension prerequisite changed")
    owners = [r for r in matrix if r["test"] == SOURCE]
    if (len(owners) != 1 or
            owners[0]["group"] != "semantic-upstream-deferred" or
            owners[0]["pdp6"] not in ("semantic", "fail", "pending") or
            any(owners[0]["pdp6_gcc_" + opt] not in
                ("semantic", "fail", "pending")
                for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("original variadic test no longer in native matrix")
    for row, profile in zip(rows, PROFILES):
        status = "compile_fail" if profile.startswith("kcc") else "run_fail"
        base = "pdp6/" + profile
        evidence = base + (".cell.log" if status == "compile_fail"
                           else ".report.txt")
        map_name = "-" if status == "compile_fail" else base + ".map"
        if (row["source"] != SOURCE or row["source_sha256"] != SHA or
                row["profile"] != profile or row["status"] != status or
                row["evidence_member"] != evidence or
                row["map_member"] != map_name or
                re.fullmatch("[0-9a-f]{64}", row["evidence_sha256"]) is None or
                (row["map_sha256"] != "-" if status == "compile_fail"
                 else re.fullmatch("[0-9a-f]{64}", row["map_sha256"]) is None)):
            raise ValueError("unexpected compiler outcome/evidence identity")


def validate_archive(rows, payload):
    expected = {r["evidence_member"] for r in rows}
    expected.update(r["map_member"] for r in rows
                    if r["map_member"] != "-")
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 9 or
                    {m.name for m in members} != expected or
                    any(not m.isfile() for m in members)):
                raise ValueError("incomplete/unsafe archived VLA evidence")
            for row in rows:
                observed = {}
                for key, sha in (("evidence_member", "evidence_sha256"),
                                 ("map_member", "map_sha256")):
                    if row[key] == "-":
                        continue
                    stream = archive.extractfile(row[key])
                    if stream is None:
                        raise ValueError("missing compiler/guest evidence")
                    raw = stream.read()
                    if hashlib.sha256(raw).hexdigest() != row[sha]:
                        raise ValueError("original result SHA256 changed")
                    observed[key] = raw.decode("utf-8", errors="replace")
                text = observed["evidence_member"]
                if row["status"] == "compile_fail":
                    if (not re.search(r"KCC - 4 errors detected", text) or
                            text.count("Flexible array member") < 2 or
                            text.count("Left operand of assignment") < 2):
                        raise ValueError("KCC genuine extension rejection missing")
                else:
                    if (not re.search(r"^rc=0$", text, re.M) or
                            not re.search(r"^result=FAIL$", text, re.M) or
                            "HALT instruction" not in text or
                            "Step expired" in text or
                            not re.search(
                                r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                r"[^\n]+\t000000000001\b", text)):
                        raise ValueError("GCC source assertion did not execute")
                    mp = observed["map_member"]
                    for name in ("memcpy", "abort", "exit"):
                        if not re.search(r"^" + name + r"\s+[0-7]+\s*$",
                                         mp, re.M):
                            raise ValueError("original runtime missing " + name)
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt VLA guest evidence") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(HISTORICAL))
    validate_archive(rows, ARCHIVE.read_bytes())
    print("PASS: original VLA va_arg assertions, four completed GCC PDP-6 "
          "run_fail and one genuine KCC compile rejection")


if __name__ == "__main__":
    audit()
