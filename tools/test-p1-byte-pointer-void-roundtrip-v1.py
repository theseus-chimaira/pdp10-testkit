#!/usr/bin/env python3
"""Authenticate six PDP-6 void-pointer ABI profiles and previous torture.

The source and original companion are immutable.  --write collects raw
native compiler outputs from two already executed runner directories.
Normal verification is offline and fail-closed: a compiler abort remains
run_fail, not a PASS inferred from a successful SIMH HALT.
"""

import argparse
import csv
import gzip
import hashlib
import io
import os
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
TMP = Path(os.environ.get("TMPDIR") or Path.home() / "tmp")
MANIFEST = ROOT / "manifests/PDP10-P1-VOID-POINTER-ROUNDTRIP-EVIDENCE-20261121-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-void-pointer-roundtrip-20261121-v1.tar.gz"
PROFILES = ("gcc-pdp6-o0", "gcc-pdp6-o1", "gcc-pdp6-o2",
            "gcc-pdp6-os", "kcc-pdp6-noopt", "kcc-pdp6-opt")
SOURCES = (
    ("locator", "tests/semantic/regression/pdp10-void-pointer-roundtrip-locator-v1.c",
     "1e6fecf37745cfb9c111a10b35133d0b9802d044ba9d6960148d827cd526d3d1",
     "p10tk-p1-void-roundtrip-20261121-v2"),
    ("torture", "tests/semantic/regression/pdp10-byte-pointer-torture-v1.c",
     "2b7543b425ffa690cd73848b581bb18791989d07af5d7372969664cea1bfe534",
     "p10tk-p1-byte-pointer-20261121-v1"),
)
COMPILERS = {
    "gcc": "67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7",
    "kcc": "72f5d94c9a3fd21481928d9b47caa1451dfcd9bd61937f63da5b08c2f04b9fa6",
}
CORE = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
FAILS = {
    "locator": (0, 0, 0, 0, 0o1002, 0o1002),
    "torture": (0o25, 0o34, 0o34, 0o34, 0o12, 0o14),
}
KINDS = ("status", "log", "asm", "map", "report")
FIELDS = ("role", "source", "source_sha256", "profile", "cpu",
          "status", "fail_id_octal", "compiler_sha256", "core_sha256") + tuple(
          field for kind in KINDS for field in (kind + "_member", kind + "_sha256"))


def digest(data):
    return hashlib.sha256(data).hexdigest()


def rows_expected():
    rows = []
    for role, source, source_sha, _ in SOURCES:
        for index, profile in enumerate(PROFILES):
            compiler = profile.split("-", 1)[0]
            fail = FAILS[role][index]
            row = dict(role=role, source=source, source_sha256=source_sha,
                       profile=profile, cpu="pdp6",
                       status="run_fail" if fail else "pass",
                       fail_id_octal=format(fail, "o"),
                       compiler_sha256=COMPILERS[compiler], core_sha256=CORE)
            for kind in KINDS:
                row[kind + "_member"] = role + "/" + profile + "/" + kind
            rows.append(row)
    return rows


def verify_sources():
    matrix = (ROOT / "COMPILER_MATRIX.tsv").read_text(encoding="ascii")
    for _, source, sha, _ in SOURCES:
        if digest((ROOT / source).read_bytes()) != sha:
            raise ValueError("PDP-10 pointer source changed: " + source)
        if matrix.count("\n" + source + "\tsemantic-regression\t") != 1:
            raise ValueError("missing exact ordinary compiler-matrix source")
    text = (ROOT / SOURCES[0][1]).read_text(encoding="ascii")
    for word in ("(*invoke_v1)", "h_seen_v1 = *hp;", "hp != &h_v1",
                 "h_seen_v1 != 0400000U", "identity_mask_v1"):
        if word not in text:
            raise ValueError("halfword pointer identity or data oracle weakened")


def verify_rows(rows):
    expected = rows_expected()
    if len(rows) != 12:
        raise ValueError("expected 12 real native PDP-6 cells")
    for row, canonical in zip(rows, expected):
        for key, value in canonical.items():
            if row.get(key) != value:
                raise ValueError("pointer profile or status reclassified")
        for kind in KINDS:
            if not re.fullmatch(r"[0-9a-f]{64}", row[kind + "_sha256"]):
                raise ValueError("missing raw guest SHA256")


def check_report(row, report):
    for fragment in ("machine=pdp6\n", "rc=0\n", "HALT instruction",
                     "__P10RUN_EXPECT__ __test_exit"):
        if fragment not in report:
            raise ValueError("not a native completed simulator execution")
    if ("result=PASS\n" if row["status"] == "pass" else "result=FAIL\n") not in report:
        raise ValueError("SIMH runner outcome was relabeled")
    match = re.search(r"__P10RUN_EXPECT__ fail_id [0-7]+ [0-7]{12}\s*\n[0-7]+:\s*([0-7]{12})", report)
    if match is None or int(match.group(1), 8) != int(row["fail_id_octal"], 8):
        raise ValueError("native guest fail_id changed")


def verify_archive(rows, raw):
    expected = {row[kind + "_member"] for row in rows for kind in KINDS}
    try:
        with tarfile.open(fileobj=io.BytesIO(raw), mode="r:gz") as tf:
            members = tf.getmembers()
            if len(members) != 60 or {m.name for m in members} != expected:
                raise ValueError("raw byte-pointer evidence is incomplete")
            if any(not m.isfile() for m in members):
                raise ValueError("unexpected non-file archive entry")
            for row in rows:
                text = {}
                for kind in KINDS:
                    member = row[kind + "_member"]
                    fp = tf.extractfile(member)
                    if fp is None:
                        raise ValueError("missing native raw output")
                    data = fp.read()
                    if digest(data) != row[kind + "_sha256"]:
                        raise ValueError("raw native byte-pointer result altered")
                    text[kind] = data.decode("utf-8", "replace")
                if ("status=" + row["status"] + "\n" not in text["status"]
                        or "profile=" + row["profile"] + "\n" not in text["status"]
                        or "runtime_library_policy=compiler-stdlib-v1\n" not in
                        text["status"]
                        or "runtime_library_sha256=" + CORE + "\n" not in
                        text["status"]):
                    raise ValueError("compiler stdlib provenance is inconsistent")
                if "main:" not in text["asm"] or "main" not in text["map"]:
                    raise ValueError("native assembly/link map missing")
                check_report(row, text["report"])
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("native byte-pointer evidence unreadable") from error


def audit():
    verify_sources()
    with MANIFEST.open(encoding="ascii", newline="") as fp:
        rows = list(csv.DictReader(fp, delimiter="\t"))
    verify_rows(rows)
    verify_archive(rows, ARCHIVE.read_bytes())
    return rows


def write():
    verify_sources()
    rows = rows_expected()
    saved = {}
    for row in rows:
        directory = next(output for role, _, _, output in SOURCES
                         if role == row["role"])
        matches = list((TMP / directory / "cells").glob(
            "*__" + row["profile"] + "__pdp6__*"))
        if len(matches) != 1:
            raise ValueError("native profile not executed: " + row["profile"])
        cell = matches[0]
        paths = {"status": cell / "status", "log": cell / "cell.log",
                 "asm": list((cell / "asm").glob("*.s")),
                 "map": list((cell / "run").glob("*.map")),
                 "report": list((cell / "run").glob("*.report.txt"))}
        for kind in ("asm", "map", "report"):
            if len(paths[kind]) != 1:
                raise ValueError("native guest missing " + kind)
            paths[kind] = paths[kind][0]
        for kind in KINDS:
            data = paths[kind].read_bytes()
            member = row[kind + "_member"]
            if member in saved:
                raise ValueError("duplicate guest raw member")
            row[kind + "_sha256"] = digest(data)
            saved[member] = data
    with MANIFEST.open("w", encoding="ascii", newline="") as fp:
        writer = csv.DictWriter(fp, fieldnames=FIELDS, delimiter="\t",
                                lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    data = io.BytesIO()
    with gzip.GzipFile(fileobj=data, mode="wb", filename="", mtime=0) as gz:
        with tarfile.open(fileobj=gz, mode="w") as tf:
            for name in sorted(saved):
                content = saved[name]
                info = tarfile.TarInfo(name)
                info.size = len(content)
                info.mode = 0o644
                info.mtime = 0
                tf.addfile(info, io.BytesIO(content))
    ARCHIVE.write_bytes(data.getvalue())
    audit()
    print("WROTE: 4 real GCC PASS, 8 actual GCC/KCC run_fail, "
          "60 raw outputs, SHA256 " + digest(ARCHIVE.read_bytes()))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.write:
        write()
    else:
        rows = audit()
        negative = 0
        for index, key, value in ((0, "status", "run_fail"),
                                   (1, "fail_id_octal", "14"),
                                   (3, "compiler_sha256", "0" * 64),
                                   (4, "status", "pass"),
                                   (5, "fail_id_octal", "0"),
                                   (6, "source_sha256", "0" * 64)):
            mutated = [dict(row) for row in rows]
            mutated[index][key] = value
            try:
                verify_rows(mutated)
            except ValueError:
                negative += 1
            else:
                raise ValueError("misclassified guest result accepted")
        corrupt = bytearray(ARCHIVE.read_bytes())
        corrupt[len(corrupt) // 2] ^= 1
        try:
            verify_archive(rows, bytes(corrupt))
        except ValueError:
            negative += 1
        else:
            raise ValueError("corrupted guest archive accepted")
        if negative != 7:
            raise ValueError("evidence negative controls not all exercised")
        print("PASS: 12 source/profile native PDP-6 cells, 4 GCC PASS, "
              "8 genuine GCC/KCC run_fail, 60 raw outputs, "
              "7 negative controls")


if __name__ == "__main__":
    main()
