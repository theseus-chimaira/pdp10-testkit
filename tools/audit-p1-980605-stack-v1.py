#!/usr/bin/env python3
"""Audit the exact-sized stack and argument oracle for original 980605-1.c.

The original's stack array is unused.  A separate, C89-compatible PDP-10
regression preserves its 100000-byte extent and reads volatile cells before
and after a nested ten-argument call.  The original and companion are both
required: a compiler PASS of the original alone does not prove the array.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = "tests/todo/generic/980605-1.c"
ORIGINAL_SHA = "c39f1bc923a64bec734b111ff3b9025da1095a3471a7e568b2b32ff9fb951642"
COMPANION = "tests/semantic/regression/pdp10-stack-tenargs-fp-frame-v1.c"
COMPANION_SHA = "44d73345e7186c1f0a7bf60e545e91eabac6cbcabb814759ab59ab084cef11d6"
PREVIOUS = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v16.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
MANIFEST = ROOT / "docs/PDP10-P1-980605-STACK-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-980605-stack-20261120-v1.tar.gz"
PROFILES = (
    ("original", "kcc-pdp6-noopt"),
    ("original", "kcc-pdp6-opt"),
    ("original", "gcc-pdp6-o0"),
    ("companion", "kcc-pdp6-noopt"),
    ("companion", "kcc-pdp6-opt"),
    ("companion", "gcc-pdp6-o0"),
    ("companion", "gcc-pdp6-o1"),
    ("companion", "gcc-pdp6-o2"),
    ("companion", "gcc-pdp6-os"),
)
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "report_member", "report_sha256", "map_member", "map_sha256",
          "asm_member", "asm_sha256")


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(
            (line for line in handle if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def check_source(path, digest, expressions):
    source = ROOT / path
    if (not source.is_file() or
            hashlib.sha256(source.read_bytes()).hexdigest() != digest):
        raise ValueError("source is missing or no longer byte-identical: " + path)
    text = source.read_text(encoding="ascii")
    for expression in expressions:
        if expression not in text:
            raise ValueError("source assertion/operation missing: " + expression)
    return text


def validate(rows, matrix, previous):
    if len(rows) != 9 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("nine original/companion PDP-6 cells required")
    check_source(ORIGINAL, ORIGINAL_SHA, (
        "#define STACK_SIZE 200000", "char ar[STACK_SIZE/2];",
        "s = x;", "k = f2 (17.0);", "sprintf (buf, \"%d\\n\"",
        "!= 227", "abort ();", "exit (0);"))
    companion = check_source(COMPANION, COMPANION_SHA, (
        "volatile unsigned char frame_v1[100000]",
        "frame_v1[99999] = (unsigned char)0x155",
        "index_v1 < 100000", "frame_v1[99840] != 395",
        "checksum_v1 != 78200", "frame_v1[99999] != 0x155",
        "total_v1 != 227 || next_value_v1 != 21",
        "second_stage_v1(17.0)", "converted = (unsigned short)input",
        "sprintf(formatted_v1, \"%d\\n\", total_v1) != 4",
        "formatted_v1[4] != '\\0'", "return 0;"))
    if companion.count("= getval_v1();") != 20:
        raise ValueError("all twenty distinct argument evaluations required")
    previous_rows = [r for r in previous if r["original_source"] == ORIGINAL]
    if (len(previous_rows) != 1 or
            previous_rows[0]["p1_state"] != "blocked" or
            previous_rows[0]["original_sha256"] != ORIGINAL_SHA):
        raise ValueError("historical P1 original identity/state not preserved")
    original_rows = [r for r in matrix if r["test"] == ORIGINAL]
    companion_rows = [r for r in matrix if r["test"] == COMPANION]
    if (len(original_rows) != 1 or len(companion_rows) != 1 or
            original_rows[0]["group"] != "semantic-upstream-deferred" or
            companion_rows[0]["group"] != "semantic-regression" or
            original_rows[0]["pdp6"] != "semantic" or
            original_rows[0]["pdp6_gcc_o0"] != "semantic" or
            companion_rows[0]["pdp6"] != "semantic" or
            any(companion_rows[0]["pdp6_gcc_" + opt] != "semantic"
                for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("original or companion is not normally registered")
    for row, (role, profile) in zip(rows, PROFILES):
        source = ORIGINAL if role == "original" else COMPANION
        digest = ORIGINAL_SHA if role == "original" else COMPANION_SHA
        prefix = role + "/pdp6/" + profile
        if (row["role"] != role or row["source"] != source or
                row["source_sha256"] != digest or
                row["profile"] != profile or row["cpu"] != "pdp6" or
                row["status"] != "pass" or
                row["report_member"] != prefix + ".report.txt" or
                row["map_member"] != prefix + ".map" or
                row["asm_member"] != prefix + ".s" or
                any(re.fullmatch(r"[a-f0-9]{64}", row[field]) is None
                    for field in ("report_sha256", "map_sha256", "asm_sha256"))):
            raise ValueError("source/profile evidence does not match fixed gate")


def validate_archive(rows, payload):
    names = {r[key] for r in rows for key in
             ("report_member", "map_member", "asm_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 27 or
                    {member.name for member in members} != names or
                    any(not member.isfile() for member in members)):
                raise ValueError("missing or unsafe compiler/guest archive member")
            for row in rows:
                content = {}
                for kind in ("report", "map", "asm"):
                    handle = tar.extractfile(row[kind + "_member"])
                    if handle is None:
                        raise ValueError("missing source-specific output")
                    raw = handle.read()
                    if hashlib.sha256(raw).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("archived output SHA256 mismatch")
                    content[kind] = raw.decode("utf-8", "replace")
                report = content["report"]
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=PASS$", report, re.M) or
                        "HALT instruction" not in report or
                        "Step expired" in report or
                        re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                  r"[^\n]+\t000000000000\b", report) is None):
                    raise ValueError("compiler guest did not finish with exit zero")
                for symbol in ("main", "sprintf", "abort", "__test_exit"):
                    if re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                 content["map"], re.M) is None:
                        raise ValueError("missing linked routine: " + symbol)
                if ("main:" not in content["asm"] or
                        (row["role"] == "companion" and
                         ("getval_v1:" not in content["asm"] or
                          "ten_values_v1:" not in content["asm"]))):
                    raise ValueError("missing relevant compiler-generated body")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("invalid compressed evidence archive") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    print("PASS: 980605 original 3/3 and full-sized 9-bit stack companion "
          "6/6 PDP-6 real guests, 27 SHA-pinned source outputs")


if __name__ == "__main__":
    audit()
