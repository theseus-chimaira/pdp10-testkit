#!/usr/bin/env python3
"""Audit two freestanding PDP-10 return-value companion oracles.

The archived guest observations are source-specific, not generic
compiler success claims.  Both hosted originals remain blocked in P1.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
LIVE = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v9.tsv"
FIELDS = ("source", "source_sha256", "profile", "status",
          "fail_id_octal", "archive_member", "report_sha256")
PROFILES = ("kcc-pdp6-noopt", "kcc-pdp6-opt", "gcc-pdp6-o0",
            "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")

CASES = (
    {
        "source": "tests/semantic/regression/pdp10-large-struct-return-v1.c",
        "sha": "144ac5f05455e69a0d72eb2ad41d4d707aa4a672af3926cdc7106a0d97c8e754",
        "original": "tests/todo/generic/generic/struct-ret-1.c",
        "disposition": "hosted-runtime",
        "name": "pdp10-large-struct-return-v1",
        "records": "docs/PDP10-P1-STRUCTRET-ORACLE-EVIDENCE-20261120-v1.tsv",
        "archive": "refs/p10tk-p1-structret-oracle-evidence-20261120-v1.tar.gz",
        "stages": ("timeout", "timeout", "run_fail", "pass", "pass", "pass"),
        "failure_ids": ("-", "-", "000000000003", "000000000000",
                        "000000000000", "000000000000"),
        "matrix_kcc": "timeout",
        "matrix_gcc": ("fail", "semantic", "semantic", "semantic"),
        "tokens": ("char c[33]", "char c1", "double d",
                   "return_x_v1", "(*volatile call_v1)",
                   "check_x_v1(&direct", "check_x_v1(&indirect",
                   "direct.c[32] = '?'", "abort()"),
    },
    {
        "source": "tests/semantic/regression/pdp10-variadic-return-types-v1.c",
        "sha": "eef5e1df955ac769117cf2a97013ab33e8e1d62bf776b00eac3b1b52d0b2062d",
        "original": "tests/todo/generic/920726-1.c",
        "disposition": "varargs-abi",
        "name": "pdp10-variadic-return-types-v1",
        "records": "docs/PDP10-P1-VARARGSRETURN-ORACLE-EVIDENCE-20261120-v1.tsv",
        "archive": "refs/p10tk-p1-varargsreturn-oracle-evidence-20261120-v1.tar.gz",
        "stages": ("pass", "pass", "run_fail", "run_fail",
                   "run_fail", "run_fail"),
        "failure_ids": ("000000000000", "000000000000",
                        "000000000012", "000000000012",
                        "000000000012", "000000000012"),
        "matrix_kcc": "semantic",
        "matrix_gcc": ("fail", "fail", "fail", "fail"),
        "tokens": ("#include <stdarg.h>", "va_start(args, format)",
                   "va_arg(args, int)", "va_end(args)",
                   "first_v1(", "second_v1(",
                   "check_v1(sum == 25, 10)",
                   "check_v1(result.sum == 25, 20)",
                   "check_v1(result.arguments == 2, 21)",
                   "check_buffer_v1(second_buffer, 22)", "abort()"),
    },
)


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream
             if line.strip() and (not comments or line[0] != "#")),
            delimiter="\t"))


def validate_case(case, rows, matrix, live):
    if len(rows) != 6 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("six original compiler observations required")
    source = case["source"]
    path = ROOT / source
    if (not path.is_file() or
            hashlib.sha256(path.read_bytes()).hexdigest() != case["sha"]):
        raise ValueError("companion source SHA changed: " + source)
    registrations = [r for r in matrix if r["test"] == source]
    if len(registrations) != 1:
        raise ValueError("missing/duplicate companion matrix registration")
    item = registrations[0]
    if (item["group"] != "semantic-regression" or
            item["name"] != case["name"] or
            item["pdp6"] != case["matrix_kcc"] or
            any(item["pdp6_gcc_" + opt] != expected for opt, expected in
                zip(("o0", "o1", "o2", "os"), case["matrix_gcc"])) or
            any(item[cpu] != "pending" for cpu in
                ("ka10", "ki10", "ks10"))):
        raise ValueError("matrix compiler profiles were changed: " + source)
    originals = [r for r in live if
                 r["original_source"] == case["original"]]
    if (len(originals) != 1 or originals[0]["p1_state"] != "blocked" or
            originals[0]["historical_disposition"] !=
            case["disposition"] or
            hashlib.sha256((ROOT / case["original"]).read_bytes()).hexdigest()
            != originals[0]["original_sha256"]):
        raise ValueError("hosted original silently changed or closed")
    content = path.read_text(encoding="ascii")
    if any(token not in content for token in case["tokens"]):
        raise ValueError("essential C89 assertion/ABI contract was removed")
    if any(token in content for token in
           ("#include <stdio.h>", "sprintf(", "printf(", "malloc(",
            "TOPS20", "XKL")):
        raise ValueError("unwanted hosted or system-specific dependency")

    for i, row in enumerate(rows):
        profile = PROFILES[i]
        if (row["source"] != source or
                row["source_sha256"] != case["sha"] or
                row["profile"] != profile or
                row["status"] != case["stages"][i] or
                row["fail_id_octal"] != case["failure_ids"][i] or
                row["archive_member"] !=
                "pdp6/" + profile + ".report.txt" or
                re.fullmatch("[0-9a-f]{64}", row["report_sha256"]) is None):
            raise ValueError("incorrect source/profile/guest status: " +
                             source + " " + profile)


def has_examine(text, symbol, value):
    pattern = (r"__P10RUN_EXPECT__ " + re.escape(symbol) +
               r" [^\n]+\n[^\n]+\t" + re.escape(value) + r"\b")
    return re.search(pattern, text) is not None


def validate_archive(case, rows, payload):
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 6 or
                    {m.name for m in members} !=
                    {r["archive_member"] for r in rows} or
                    any(not m.isfile() for m in members)):
                raise ValueError("incomplete or unsafe guest report archive")
            for row in rows:
                stream = archive.extractfile(row["archive_member"])
                if stream is None:
                    raise ValueError("missing guest report data")
                raw = stream.read()
                if hashlib.sha256(raw).hexdigest() != row["report_sha256"]:
                    raise ValueError("guest report checksum mismatch")
                text = raw.decode("utf-8", errors="replace")
                if row["status"] == "timeout":
                    if (not re.search(r"^rc=124$", text, re.M) or
                            not re.search(r"^result=FAIL$", text, re.M) or
                            "HALT instruction" in text or
                            "__P10RUN_EXPECT__ __test_exit" in text):
                        raise ValueError("SIMH timeout misreported as guest failure")
                else:
                    is_pass = row["status"] == "pass"
                    if (not re.search(r"^rc=0$", text, re.M) or
                            not re.search(
                                r"^result=" + ("PASS" if is_pass else "FAIL") +
                                r"$", text, re.M) or
                            "HALT instruction" not in text or
                            not has_examine(
                                text, "__test_exit",
                                "000000000000" if is_pass else "000000000001") or
                            not has_examine(
                                text, "fail_id", row["fail_id_octal"])):
                        raise ValueError("completed guest report does not prove result")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("cannot read intact report archive") from error


def audit():
    matrix = read(MATRIX, True)
    live = read(LIVE)
    totals = {"pass": 0, "run_fail": 0, "timeout": 0}
    for case in CASES:
        rows = read(ROOT / case["records"])
        validate_case(case, rows, matrix, live)
        validate_archive(case, rows, (ROOT / case["archive"]).read_bytes())
        for row in rows:
            totals[row["status"]] += 1
    if totals != {"pass": 5, "run_fail": 5, "timeout": 2}:
        raise ValueError("wrong return-oracle compiler outcome census")
    print("PASS: two P1 return-value oracles, 12 PDP-6 guest reports "
          "(5 pass, 5 run_fail, 2 timeout); both originals remain blocked")


if __name__ == "__main__":
    audit()
