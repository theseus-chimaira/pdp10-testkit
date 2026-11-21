#!/usr/bin/env python3
"""Authenticate historical isprint failures and genuine C-locale guest PASS.

This verifies 991112-1.c without changing its assertions, a separate
full 9-bit C-locale isprint/isspace oracle, and the unchanged 980707-1.c.
The old missing-provider link failures remain immutable evidence.
"""

import csv
import hashlib
import io
import os
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "manifests/PDP10-P1-991112-C-LOCALE-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-991112-c-locale-20261120-v1.tar.gz"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v27.tsv"
LIB_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
CTYPE_SHA = "790b064ecef6857d98c9a30b326c638af839b70931b19fc603fbe9b10aee99a3"
CTYPE_SOURCE_SHA = "2b010cf9591dd57c508cbd233be05ddb7744ea817db51a291c780e7ee954cc23"
KCC_HEADER_SHA = "86373c9fd4eff0762b5248eb53c47af3866f764f9f7673fab879f34388823b2f"
GCC_HEADER_SHA = "757cb9dd9532416539889b2c998f464ea5b96d7aecdca6516c2af3c44476f468"
ORIGINAL = "tests/todo/generic/991112-1.c"
FULL = "tests/semantic/regression/pdp10-ctype-c-locale-exhaustive-v1.c"
OTHER = "tests/todo/generic/980707-1.c"
SOURCES = {
    "original-old": (ORIGINAL, "8c6dd7a6a2a80914012a04aa95b1ab303b678087036b4c19df63e2f700aee9c4"),
    "original-pass": (ORIGINAL, "8c6dd7a6a2a80914012a04aa95b1ab303b678087036b4c19df63e2f700aee9c4"),
    "ctype-pass": (FULL, "016959400ed5b9a57d4b984fd800d3d2cc856d682a1c60e5245856bb36c2cb78"),
    "980707-pass": (OTHER, "43c389a719d17d876d0f9f942d5db81f737c8eed7608de204862f23a6359e7b7"),
}
PROFILES = ("kcc-pdp6-noopt", "kcc-pdp6-opt", "gcc-pdp6-o0",
            "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")
EXPECTED = (
    (("original-old", "kcc-pdp6-noopt", "link_fail"),
     ("original-old", "gcc-pdp6-o0", "link_fail"))
    + tuple(("original-pass", p, "pass") for p in PROFILES)
    + tuple(("ctype-pass", p, "pass") for p in PROFILES)
    + tuple(("980707-pass", p, "pass") for p in PROFILES)
)
KINDS = ("log", "status", "asm", "map", "report")
SUFFIX = {"log": ".log.txt", "status": ".status", "asm": ".s",
          "map": ".map", "report": ".report.txt"}
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "ctype_archive_sha256") + tuple(field for kind in KINDS
                                           for field in (kind + "_member", kind + "_sha256"))
EXTRAS = {
    "compiler/kcc-ctype-c-locale-v1.s": CTYPE_SOURCE_SHA,
    "compiler/gcc-ctype-c-locale-v1.s": CTYPE_SOURCE_SHA,
    "compiler/kcc-libp10ctype-c-locale-v1.a": CTYPE_SHA,
    "compiler/gcc-libp10ctype-c-locale-v1.a": CTYPE_SHA,
    "headers/kcc-ctype-v1.h": KCC_HEADER_SHA,
    "headers/gcc-ctype-v1.h": GCC_HEADER_SHA,
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read_tsv(path, comments=False):
    with path.open(encoding="ascii", newline="") as f:
        return list(csv.DictReader((line for line in f if line.strip() and
                                   (not comments or not line.startswith("#"))),
                                   delimiter="\t"))


def verify_source_and_matrix(matrix, previous):
    for role, (name, digest) in SOURCES.items():
        path = ROOT / name
        if not path.is_file() or sha(path.read_bytes()) != digest:
            raise ValueError("C-locale source changed: " + role)
        matches = [row for row in matrix if row["test"] == name]
        if len(matches) != 1 or matches[0]["pdp6"] != "semantic":
            raise ValueError("C-locale source matrix registration absent")
        if any(matches[0]["pdp6_gcc_" + opt] != "semantic" for opt in
               ("o0", "o1", "o2", "os")):
            raise ValueError("C-locale tested GCC optimization slot disabled")
    first = (ROOT / ORIGINAL).read_text(encoding="ascii")
    for text in ("int (*x)(int, int) = rl_character_len;",
                 "return isprint (c) ? 1 : 2;",
                 "if (x('a', 1) != 1)", "if (x('\\002', 1) != 2)"):
        if text not in first:
            raise ValueError("original indirect isprint assertion weakened")
    second = (ROOT / FULL).read_text(encoding="ascii")
    for text in ("#include <ctype.h>",
                 "static int (*volatile call_print_v1)(int) = isprint;",
                 "static int (*volatile call_space_v1)(int) = isspace;",
                 "for (i = 0; i <= 0777; ++i)",
                 "expected_print = i >= 040 && i <= 0176;",
                 "expected_space = i == 040 || (i >= 011 && i <= 015);",
                 "CHECK_V1(checks_v1 == 01000u, 5);"):
        if text not in second:
            raise ValueError("exhaustive genuine ctype oracle weakened")
    originals = [r for r in previous if r["original_source"] == ORIGINAL]
    if (len(originals) != 1 or originals[0]["p1_state"] != "blocked" or
            originals[0]["historical_disposition"] != "libc-linkage"):
        raise ValueError("unresolved historical isprint identity lost")


def verify_rows(rows):
    if len(rows) != 20 or tuple(rows[0]) != FIELDS:
        raise ValueError("20 exact C-locale source/profile results required")
    for row, (role, profile, outcome) in zip(rows, EXPECTED):
        prefix = role + "/pdp6/" + profile
        fields = {"role": role, "source": SOURCES[role][0],
                  "source_sha256": SOURCES[role][1], "profile": profile,
                  "cpu": "pdp6", "status": outcome,
                  "ctype_archive_sha256": CTYPE_SHA if outcome == "pass" else "-"}
        for kind in KINDS:
            present = outcome == "pass" or kind in ("log", "status", "asm")
            fields[kind + "_member"] = prefix + SUFFIX[kind] if present else "-"
            if not present:
                fields[kind + "_sha256"] = "-"
        if any(row[key] != val for key, val in fields.items()):
            raise ValueError("C-locale evidence cell modified: " + profile)
        for kind in KINDS:
            if row[kind + "_member"] != "-" and not re.fullmatch(
                    r"[a-f0-9]{64}", row[kind + "_sha256"]):
                raise ValueError("C-locale guest artifact SHA invalid")


def guest_word(report, symbol):
    match = re.search(r"__P10RUN_EXPECT__ " + re.escape(symbol) +
                      r" [0-7]+ 000000000000\s*\n[0-7]+:\s*([0-7]{12})", report)
    if not match:
        raise ValueError("C-locale guest exit/assertion not readable")
    return int(match.group(1), 8)


def verify_archive(rows, raw):
    names = {r[kind + "_member"] for r in rows for kind in KINDS
             if r[kind + "_member"] != "-"}
    names.update(EXTRAS)
    if len(names) != 102:
        raise ValueError("C-locale must retain exactly 102 raw artifacts")
    try:
        with tarfile.open(fileobj=io.BytesIO(raw), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 102 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("C-locale raw archive membership changed")

            def get(name):
                stream = archive.extractfile(name)
                if stream is None:
                    raise ValueError("C-locale artifact missing")
                return stream.read()

            for name, digest in EXTRAS.items():
                if sha(get(name)) != digest:
                    raise ValueError("C-locale installed compiler fingerprint changed")
            source = get("compiler/kcc-ctype-c-locale-v1.s").decode("ascii")
            if ("isprint:" not in source or "isspace:" not in source or
                    "caige\t1,040" not in source or "caile\t1,0176" not in source or
                    "caige\t1,011" not in source or "caile\t1,015" not in source):
                raise ValueError("real C-locale predicate source missing")
            for head in ("headers/kcc-ctype-v1.h", "headers/gcc-ctype-v1.h"):
                h = get(head).decode("ascii")
                if "int isprint(int);" not in h or "int isspace(int);" not in h:
                    raise ValueError("C-locale target header prototypes changed")
            for row in rows:
                artifacts = {}
                for kind in KINDS:
                    member = row[kind + "_member"]
                    if member == "-":
                        continue
                    body = get(member)
                    if sha(body) != row[kind + "_sha256"]:
                        raise ValueError("C-locale raw guest evidence corrupted")
                    artifacts[kind] = body.decode("utf-8", "replace")
                status = artifacts["status"]
                if ("status=" + row["status"] + "\n" not in status or
                        "profile=" + row["profile"] + "\n" not in status or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in status or
                        "runtime_library_sha256=" + LIB_SHA + "\n" not in status):
                    raise ValueError("C-locale guest used wrong core compiler library")
                if "main:" not in artifacts["asm"]:
                    raise ValueError("C-locale compiler did not generate main")
                if row["status"] == "link_fail":
                    if ("dlink: undefined symbol: isprint" not in artifacts["log"] or
                            "p10run: link failed" not in artifacts["log"]):
                        raise ValueError("historical unresolved isprint link hidden")
                    continue
                report = artifacts["report"]
                if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                        "HALT instruction" not in report or "result=PASS\n" not in report or
                        guest_word(report, "__test_exit") != 0 or
                        "kcc_freestanding=kcc-libc-ctype-c-locale-v1.s" not in artifacts["log"]):
                    raise ValueError("C-locale guest pass not observed")
                if row["role"] == "ctype-pass" and guest_word(report, "fail_id") != 0:
                    raise ValueError("9-bit exhaustive classifier assertion failed")
                for symbol in ("main", "isprint", "exit", "abort"):
                    if row["role"] == "980707-pass" and symbol == "isprint":
                        symbol = "isspace"
                    if re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                 artifacts["map"], re.M) is None:
                        raise ValueError("C-locale linked guest symbol absent: " + symbol)
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("C-locale evidence archive unreadable") from exc


def installed_provider():
    prefix = Path(os.environ["PDP10_PREFIX"])
    paths = (("lib/kcc/freestanding/libp10ctype-c-locale-v1.a", CTYPE_SHA),
             ("lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10ctype-c-locale-v1.a", CTYPE_SHA),
             ("lib/kcc/freestanding/kcc-libc-ctype-c-locale-v1.s", CTYPE_SOURCE_SHA),
             ("lib/gcc-lib/pdp10-dec-none/3.2/freestanding/kcc-libc-ctype-c-locale-v1.s", CTYPE_SOURCE_SHA),
             ("lib/kcc/include/ctype.h", KCC_HEADER_SHA),
             ("lib/gcc-lib/pdp10-dec-none/3.2/include/ctype.h", GCC_HEADER_SHA))
    for rel, digest in paths:
        path = prefix / rel
        if not path.is_file() or sha(path.read_bytes()) != digest:
            raise ValueError("installed C-locale target artifact changed: " + rel)


def audit():
    rows = read_tsv(MANIFEST)
    verify_source_and_matrix(read_tsv(MATRIX, True), read_tsv(PREVIOUS))
    verify_rows(rows)
    verify_archive(rows, ARCHIVE.read_bytes())
    installed_provider()
    return rows


def main():
    rows = audit()
    failures = 0
    for field, val in (("role", "ctype-pass"), ("profile", "gcc-ka10-o0"),
                       ("status", "link_fail"), ("source_sha256", "0" * 64),
                       ("ctype_archive_sha256", "-"),
                       ("report_sha256", "bad"), ("report_member", "fake"),
                       ("asm_sha256", "bad")):
        changed = [dict(r) for r in rows]
        changed[3][field] = val
        try:
            verify_rows(changed)
        except ValueError:
            failures += 1
        else:
            raise AssertionError("false C-locale guest evidence accepted: " + field)
    for bad in (rows[:-1], rows[1:]):
        try:
            verify_rows(bad)
        except ValueError:
            failures += 1
        else:
            raise AssertionError("incomplete C-locale guest profile accepted")
    damaged = bytearray(ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        verify_archive(rows, bytes(damaged))
    except ValueError:
        failures += 1
    else:
        raise AssertionError("corrupt C-locale archive accepted")
    print("PASS: 991112 historical 2 real isprint link failures, "
          "18 native PDP-6 original/9-bit C-locale PASS, "
          "102 raw artifacts, %d negative controls" % failures)


if __name__ == "__main__":
    main()
