#!/usr/bin/env python3
"""Authenticate installed KCC va_end header repair and native guest passes.

Historical KCC run_fail data is preserved by the independent v1
va-arg-21 validator. This repair validator records only newly executed
guests with the corrected, installed target header and real compiler
C library; no fake stdarg or hosted services are used.
"""

import csv
import hashlib
import io
import os
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/PDP10-KCC-VAEND-REPAIR-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-kcc-vaend-repair-20261120-v1.tar.gz"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
FIXED_HEADER = "headers/kcc-stdarg-fixed-v1.h"
FIXED_SHA = "f966aa2588b7d59dbf2bf704ffd87fb67097673455ee77fe86d8a75232f23e7f"
LIB_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
SOURCES = {
    "vaend": ("tests/semantic/regression/pdp10-vaend-pointer-sideeffect-v1.c",
              "b117d54a8dbc8ffbed6be25e8c841a9c7f9d9edf25ad47ccb5014ceb4b0aa4c8"),
    "variadic": ("tests/semantic/regression/pdp10-variadic-return-types-v1.c",
                 "eef5e1df955ac769117cf2a97013ab33e8e1d62bf776b00eac3b1b52d0b2062d"),
}
PROFILES = (
    ("vaend", "kcc-pdp6-noopt"),
    ("vaend", "kcc-pdp6-opt"),
    ("vaend", "gcc-pdp6-o0"),
    ("vaend", "gcc-pdp6-o1"),
    ("vaend", "gcc-pdp6-o2"),
    ("vaend", "gcc-pdp6-os"),
    ("variadic", "kcc-pdp6-noopt"),
    ("variadic", "kcc-pdp6-opt"),
)
KINDS = ("log", "status", "asm", "map", "report")
EXT = {"log": ".log.txt", "status": ".status", "asm": ".s",
       "map": ".map", "report": ".report.txt"}
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "header_sha256") + tuple(field for kind in KINDS for field in
                                     (kind + "_member", kind + "_sha256"))


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read_rows(path, comments=False):
    with path.open(encoding="ascii", newline="") as source:
        return list(csv.DictReader(
            (line for line in source if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def validate_rows(rows, matrix):
    if len(rows) != 8 or tuple(rows[0]) != FIELDS:
        raise ValueError("KCC va_end repair requires eight exact native guests")
    for role, (source, digest) in SOURCES.items():
        path = ROOT / source
        if not path.is_file() or sha(path.read_bytes()) != digest:
            raise ValueError("KCC repair companion source identity changed")
        matches = [r for r in matrix if r["test"] == source]
        if len(matches) != 1 or matches[0]["group"] != "semantic-regression":
            raise ValueError("KCC repair companion not matrix-owned")
        if matches[0]["pdp6"] != "semantic":
            raise ValueError("KCC repair PDP-6 source not scheduled")
    for row, (role, profile) in zip(rows, PROFILES):
        expected = {
            "role": role, "source": SOURCES[role][0],
            "source_sha256": SOURCES[role][1], "profile": profile,
            "cpu": "pdp6", "status": "pass", "header_sha256": FIXED_SHA,
        }
        prefix = role + "/pdp6/" + profile
        for kind in KINDS:
            expected[kind + "_member"] = prefix + EXT[kind]
        if any(row[k] != v for k, v in expected.items()):
            raise ValueError("KCC repair source/profile/pass claim changed")
        for kind in KINDS:
            if not re.fullmatch(r"[0-9a-f]{64}", row[kind + "_sha256"]):
                raise ValueError("KCC repair evidence digest invalid")


def expected_word(report, symbol):
    match = re.search(r"__P10RUN_EXPECT__ " + re.escape(symbol) +
                      r" [0-7]+ 000000000000\s*\n[0-7]+:\s*([0-7]{12})", report)
    if match is None:
        raise ValueError("KCC repair native guest expectation missing")
    return int(match.group(1), 8)


def validate_archive(rows, payload):
    names = {row[kind + "_member"] for row in rows for kind in KINDS}
    names.add(FIXED_HEADER)
    if len(names) != 41:
        raise ValueError("KCC repair evidence requires 41 raw members")
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 41 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("KCC repair archive membership invalid")

            def read_member(name):
                stream = tar.extractfile(name)
                if stream is None:
                    raise ValueError("KCC repair member not found: " + name)
                return stream.read()

            header = read_member(FIXED_HEADER)
            if (sha(header) != FIXED_SHA or
                    b"#define va_end(ap) ((void)(ap))" not in header or
                    b"#define va_end(ap) ((void)0)" in header or
                    b"#include_next <stdarg.h>" not in header):
                raise ValueError("KCC repair snapshot not corrected target header")
            for row in rows:
                data = {}
                for kind in KINDS:
                    content = read_member(row[kind + "_member"])
                    if sha(content) != row[kind + "_sha256"]:
                        raise ValueError("KCC repaired guest output altered")
                    data[kind] = content.decode("utf-8", "replace")
                status = data["status"]
                if ("profile=" + row["profile"] + "\n" not in status or
                        "status=pass\n" not in status or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in status or
                        "runtime_library_sha256=" + LIB_SHA + "\n" not in status):
                    raise ValueError("KCC repaired guest used wrong target runtime")
                report = data["report"]
                if ("machine=pdp6\n" not in report or "result=PASS\n" not in report or
                        "rc=0\n" not in report or "HALT instruction" not in report or
                        expected_word(report, "__test_exit") != 0 or
                        expected_word(report, "fail_id") != 0):
                    raise ValueError("KCC repaired native guest did not pass")
                if "main:" not in data["asm"]:
                    raise ValueError("KCC repaired guest assembly omitted main")
                for sym in ("main", "fail_id", "exit", "abort"):
                    if re.search(r"^" + sym + r"\s+[0-7]+\s*$",
                                 data["map"], re.M) is None:
                        raise ValueError("KCC repaired guest linker map missing " + sym)
                if row["role"] == "vaend" and "check_va_end_v1:" not in data["asm"]:
                    raise ValueError("KCC repaired native va_end body missing")
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("KCC repaired guest archive cannot be read") from exc


def installed_header():
    prefix = os.environ.get("PDP10_PREFIX")
    if not prefix:
        raise ValueError("PDP10_PREFIX must identify installed compiler headers")
    path = Path(prefix) / "lib/kcc/include/stdarg.h"
    if not path.is_file() or sha(path.read_bytes()) != FIXED_SHA:
        raise ValueError("installed KCC stdarg.h does not contain fixed va_end")


def audit():
    rows = read_rows(MANIFEST)
    validate_rows(rows, read_rows(MATRIX, True))
    validate_archive(rows, ARCHIVE.read_bytes())
    installed_header()
    return rows


def main():
    rows = audit()
    matrix = read_rows(MATRIX, True)
    count = 0
    for field, value in (("role", "variadic"), ("profile", "gcc-ka10-o0"),
                         ("cpu", "ka10"), ("status", "run_fail"),
                         ("source_sha256", "0" * 64),
                         ("header_sha256", "0" * 64),
                         ("report_sha256", "bad"),
                         ("report_member", "fake.report.txt")):
        changed = [dict(row) for row in rows]
        changed[0][field] = value
        try:
            validate_rows(changed, matrix)
        except ValueError:
            count += 1
        else:
            raise AssertionError("invalid KCC header repair claim accepted")
    try:
        validate_rows(rows[:-1], matrix)
    except ValueError:
        count += 1
    else:
        raise AssertionError("missing KCC guest accepted")
    corrupt = bytearray(ARCHIVE.read_bytes())
    corrupt[len(corrupt) // 2] ^= 1
    try:
        validate_archive(rows, bytes(corrupt))
    except ValueError:
        count += 1
    else:
        raise AssertionError("corrupted post-repair guest archive accepted")
    print("PASS: installed KCC va_end header repaired, 6 va_end guests and "
          "2 KCC variadic ABI guests PASS, 41 raw outputs, "
          "%d negative controls" % count)


if __name__ == "__main__":
    main()
