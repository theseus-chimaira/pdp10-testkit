#!/usr/bin/env python3
"""Audit the unchanged 920726-1.c and its independent return-value oracle.

The original checks genuine hosted sprintf/strlen/strcmp formatting but
does NOT inspect its indeterminate returned objects. The companion
checks initialized scalar and struct returns without stdio. Their
separate evidence is required to accept P1 testkit coverage. A KCC
PASS never implies GCC target stdio availability or a GCC PASS.
"""

import csv
import hashlib
import importlib.util
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/todo/generic/920726-1.c"
SHA = "9e0cb6877e06fd241012cf216d8ad071d3061c7257f7ca17aea27d13f970e795"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v12.tsv"
MANIFEST = ROOT / "manifests/PDP10-P1-920726-HOSTED-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-920726-hosted-evidence-20261120-v1.tar.gz"
GCC_RECORDS = ROOT / "manifests/PDP10-GCC-STDIO-GUEST-EVIDENCE-20261120-v1.tsv"
GCC_ARCHIVE = ROOT / "refs/p10tk-gcc-stdio-guest-evidence-20261120-v1.tar.gz"
GCC_FIXTURE = "misc/compat/gcc-p10stdio-memory-v1.c"
GCC_FIELDS = ("kind", "source", "source_sha256", "profile", "cpu",
              "status", "report_member", "report_sha256",
              "map_member", "map_sha256")
FIELDS = ("source", "source_sha256", "profile", "cpu", "status",
          "report_member", "report_sha256", "map_member", "map_sha256")
CPUS = ("pdp6", "ka10", "ki10", "ks10")
OPTS = ("noopt", "opt")


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def validate(rows, matrix, previous):
    if len(rows) != 8 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("need eight original hosted KCC execution profiles")
    path = ROOT / SOURCE
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != SHA:
        raise ValueError("hosted original source has changed")
    source = path.read_text(encoding="ascii")
    for token in ("#include <stdio.h>", "#include <stdarg.h>",
                  "va_start(args, fmt)", "va_arg(args, int)",
                  "sprintf(bp, \"%d\", number)", "strlen(bp)",
                  'strcmp ("5 20 ", buf1)', 'strcmp ("5 20 ", buf2)',
                  "struct spurious second(", "return dummy;"):
        if token not in source:
            raise ValueError("original hosted varargs/return shape changed")
    frozen = [r for r in previous if r["original_source"] == SOURCE]
    if (len(frozen) != 1 or frozen[0]["p1_state"] != "blocked" or
            frozen[0]["original_sha256"] != SHA):
        raise ValueError("historical original state or SHA changed")
    owners = [r for r in matrix if r["test"] == SOURCE]
    if (len(owners) != 1 or
            owners[0]["group"] != "semantic-upstream-deferred" or
            owners[0]["pdp6"] != "semantic" or
            owners[0]["pdp6_gcc_o0"] != "semantic" or
            any(owners[0][cpu] not in ("pending", "semantic") for cpu in
                CPUS[1:])):
        raise ValueError("KCC or GCC original matrix registration lost")
    for row, (cpu, opt) in zip(rows, ((c, o) for c in CPUS for o in OPTS)):
        profile = "kcc-" + cpu + "-" + opt
        base = cpu + "/" + profile
        if (row["source"] != SOURCE or row["source_sha256"] != SHA or
                row["profile"] != profile or row["cpu"] != cpu or
                row["status"] != "pass" or
                row["report_member"] != base + ".report.txt" or
                row["map_member"] != base + ".map" or
                any(re.fullmatch("[0-9a-f]{64}", row[key]) is None
                    for key in ("report_sha256", "map_sha256"))):
            raise ValueError("KCC CPU/optimization or real evidence changed")


def validate_archive(rows, payload):
    names = {r[k] for r in rows for k in ("report_member", "map_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 16 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("incomplete/unsafe hosted evidence archive")
            for row in rows:
                contents = {}
                for key, sha in (("report_member", "report_sha256"),
                                 ("map_member", "map_sha256")):
                    obj = archive.extractfile(row[key])
                    if obj is None:
                        raise ValueError("hosted source report/map absent")
                    data = obj.read()
                    if hashlib.sha256(data).hexdigest() != row[sha]:
                        raise ValueError("hosted evidence SHA256 changed")
                    contents[key] = data.decode("utf-8", errors="replace")
                report = contents["report_member"]
                symbols = contents["map_member"]
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=PASS$", report, re.M) or
                        "HALT instruction" not in report or
                        "Step expired" in report or
                        not re.search(
                            r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                            r"[^\n]+\t000000000000\b", report)):
                    raise ValueError("formatted-output assertion did not pass")
                for name in ("sprintf", "strlen", "strcmp"):
                    if not re.search(r"^" + name + r"\s+[0-7]+\s*$",
                                     symbols, re.M):
                        raise ValueError("real hosted implementation not linked: " +
                                         name)
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt hosted target report archive") from error


def validate_gcc(rows, payload):
    """Pin native GCC stdio tests without claiming a GCC va_arg fix."""
    if (len(rows) != 16 or not rows or tuple(rows[0]) != GCC_FIELDS):
        raise ValueError("16 original/formatter GCC CPU profiles required")
    expected = []
    for cpu in CPUS:
        for opt in ("o0", "o2"):
            for kind, source in (("memory", GCC_FIXTURE),
                                 ("original", SOURCE)):
                expected.append((kind, source, "gcc-" + cpu + "-" + opt,
                                 cpu))
    for row, (kind, source, profile, cpu) in zip(rows, expected):
        prefix = kind + "/" + profile
        if (row["kind"] != kind or row["source"] != source or
                row["source_sha256"] != hashlib.sha256(
                    (ROOT / source).read_bytes()).hexdigest() or
                row["profile"] != profile or row["cpu"] != cpu or
                row["status"] != "pass" or
                row["report_member"] != prefix + ".report.txt" or
                row["map_member"] != prefix + ".map" or
                any(re.fullmatch("[0-9a-f]{64}", row[k]) is None for k in
                    ("report_sha256", "map_sha256"))):
            raise ValueError("false GCC stdio pass or incorrect source hash")
    names = {r[k] for r in rows for k in
             ("report_member", "map_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 32 or
                    {member.name for member in members} != names or
                    any(not member.isfile() for member in members)):
                raise ValueError("incomplete/unsafe GCC stdio guest archive")
            for row in rows:
                evidence = {}
                for key, sha in (("report_member", "report_sha256"),
                                 ("map_member", "map_sha256")):
                    stream = archive.extractfile(row[key])
                    if stream is None:
                        raise ValueError("missing GCC stdio report/map")
                    raw = stream.read()
                    if hashlib.sha256(raw).hexdigest() != row[sha]:
                        raise ValueError("GCC target evidence checksum differs")
                    evidence[key] = raw.decode("utf-8", errors="replace")
                report = evidence["report_member"]
                symbols = evidence["map_member"]
                if (not re.search(r"^rc=0$", report, re.M) or
                        not re.search(r"^result=PASS$", report, re.M) or
                        "HALT instruction" not in report or
                        "Step expired" in report or
                        not re.search(
                            r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                            r"[^\n]+\t000000000000\b", report)):
                    raise ValueError("GCC hosted guest pass not completed")
                if row["kind"] == "memory" and not re.search(
                        r"__P10RUN_EXPECT__ fail_id [^\n]+\n"
                        r"[^\n]+\t000000000000\b", report):
                    raise ValueError("GCC formatter assertions did not pass")
                needed = ("sprintf", "vsprintf", "snprintf", "vsnprintf")
                if row["kind"] == "original":
                    needed += ("strlen", "strcmp")
                for symbol in needed:
                    if not re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                     symbols, re.M):
                        raise ValueError(
                            "missing real GCC stdio symbol: " + symbol)
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt archived GCC stdio evidence") from error


def check_companion():
    """Do not infer returned-value correctness from the original alone."""
    spec = importlib.util.spec_from_file_location(
        "p10tk_earlier_return_oracles_v1",
        ROOT / "tools/audit-p1-return-oracles-v1.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    case = next(c for c in module.CASES if c["original"] == SOURCE)
    rows = module.read(ROOT / case["records"])
    module.validate_case(
        case, rows, module.read(module.MATRIX, True),
        module.read(module.LIVE))
    module.validate_archive(
        case, rows, (ROOT / case["archive"]).read_bytes())
    # The original compiler can pass without inspecting the returned
    # dummy. The new companion MUST have at least two real KCC PASS
    # profiles and preserve the known four genuine GCC failures.
    if [r["status"] for r in rows] != (
            ["pass", "pass"] + ["run_fail"] * 4):
        raise ValueError("freestanding return ABI oracle not verified")


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    validate_gcc(read(GCC_RECORDS), GCC_ARCHIVE.read_bytes())
    check_companion()
    print("PASS: 920726-1.c hosted KCC 8 PASS and GCC 8 PASS; "
          "GCC buffer formatter 8 PASS; return ABI independently verified")


if __name__ == "__main__":
    audit()
