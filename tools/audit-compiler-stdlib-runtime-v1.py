#!/usr/bin/env python3
"""Audit compiler-only target stdlib against eight focused PDP-6 cells.

Unchanged imported tests that need hosted malloc/isspace/printf must
remain link failures with the compiler's own libp10c-v2.a. Two real
record-copy/memset guest passes prove ordinary C library selection.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "manifests/PDP10-COMPILER-STDLIB-RUNTIME-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-compiler-stdlib-runtime-20261120-v1.tar.gz"
LIB_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
FIELDS = ("role", "source", "source_sha256", "compiler", "profile",
          "cpu", "status", "expected_link_error", "runtime_archive_sha256",
          "status_member", "status_sha256", "log_member", "log_sha256",
          "asm_member", "asm_sha256", "report_member", "report_sha256",
          "map_member", "map_sha256")
CASES = (
    ("original", "tests/todo/generic/920810-1.c",
     "23405fde00c057160ef5881b0561d2e5921be68a07cb11f7b2f2e6e66952dbb5",
     "kcc-pdp6-noopt", "link_fail", "malloc"),
    ("original", "tests/todo/generic/920810-1.c",
     "23405fde00c057160ef5881b0561d2e5921be68a07cb11f7b2f2e6e66952dbb5",
     "gcc-pdp6-o0", "link_fail", "malloc"),
    ("original", "tests/todo/generic/980707-1.c",
     "43c389a719d17d876d0f9f942d5db81f737c8eed7608de204862f23a6359e7b7",
     "kcc-pdp6-noopt", "link_fail", "isspace"),
    ("original", "tests/todo/generic/920501-8.c",
     "21884df76c9d24d4d4808d78de8e8a4e7909fffd1ee26a72f96f4be00a22b56a",
     "gcc-pdp6-o0", "link_fail", "printf"),
    ("original", "tests/todo/generic/990628-1.c",
     "eae56aa6d888dbdab7d545d7146e40153a3fd5a2663e741c97a9cf6a2bae212c",
     "kcc-pdp6-noopt", "link_fail", "malloc"),
    ("original", "tests/todo/generic/990628-1.c",
     "eae56aa6d888dbdab7d545d7146e40153a3fd5a2663e741c97a9cf6a2bae212c",
     "gcc-pdp6-o0", "link_fail", "malloc"),
    ("companion", "tests/semantic/regression/pdp10-record-fetch-copy-v1.c",
     "1b1ec7a6e10d90916748dd17ccc06d0e3331bc220db66fe018389a1bf33ea486",
     "kcc-pdp6-noopt", "pass", "none"),
    ("companion", "tests/semantic/regression/pdp10-record-fetch-copy-v1.c",
     "1b1ec7a6e10d90916748dd17ccc06d0e3331bc220db66fe018389a1bf33ea486",
     "gcc-pdp6-o0", "pass", "none"),
)


def read_manifest():
    with MANIFEST.open(encoding="ascii", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def digest(data):
    return hashlib.sha256(data).hexdigest()


def validate(rows, payload):
    if len(rows) != 8 or tuple(rows[0]) != FIELDS:
        raise ValueError("compiler stdlib must have eight exact guest cells")
    expected_names = set()
    for n, (row, case) in enumerate(zip(rows, CASES), 1):
        role, source, sha, profile, status, symbol = case
        if (row["role"] != role or row["source"] != source or
                row["source_sha256"] != sha or
                row["compiler"] != profile.split("-", 1)[0] or
                row["profile"] != profile or row["cpu"] != "pdp6" or
                row["status"] != status or row["expected_link_error"] != symbol or
                row["runtime_archive_sha256"] != LIB_SHA):
            raise ValueError("compiler stdlib evidence profile/original changed")
        if digest((ROOT / source).read_bytes()) != sha:
            raise ValueError("historical C source or companion source changed")
        prefix = "%02d-%s/" % (n, profile)
        for kind in ("status", "log", "asm"):
            member = prefix + ("asm.s" if kind == "asm" else kind + ".txt")
            if row[kind + "_member"] != member:
                raise ValueError("compiler stdlib source output missing")
            expected_names.add(member)
        for kind in ("report", "map"):
            if status == "pass":
                member = prefix + kind + ".txt"
                if row[kind + "_member"] != member:
                    raise ValueError("successful guest report/map not archived")
                expected_names.add(member)
            elif (row[kind + "_member"] != "-" or
                  row[kind + "_sha256"] != "-"):
                raise ValueError("link failure invented a guest report/map")
    files = {}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 28 or
                    {member.name for member in members} != expected_names or
                    any(not member.isfile() for member in members)):
                raise ValueError("compiler stdlib archived evidence incomplete")
            for row in rows:
                for kind in ("status", "log", "asm", "report", "map"):
                    member = row[kind + "_member"]
                    if not member or member == "-":
                        continue
                    stream = tar.extractfile(member)
                    if stream is None:
                        raise ValueError("compiler evidence archive member missing")
                    data = stream.read()
                    if digest(data) != row[kind + "_sha256"]:
                        raise ValueError("compiler stdlib evidence SHA mismatch")
                    files[(row["profile"], row["source"], kind)] = data.decode(
                        "utf-8", "replace")
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("compiler stdlib evidence archive corrupt") from exc
    for row in rows:
        key = (row["profile"], row["source"])
        status_text = files[key + ("status",)]
        log = files[key + ("log",)]
        if ("\nstatus=" + row["status"] + "\n" not in status_text or
                "\nruntime_library_policy=compiler-stdlib-v1\n" not in status_text or
                "\nruntime_library_sha256=" + LIB_SHA + "\n" not in status_text):
            raise ValueError("cell checkpoint did not use compiler stdlib")
        if ("runtime_library_policy=compiler-stdlib-v1\n" not in log or
                "runtime_library_sha256=" + LIB_SHA + "\n" not in log or
                "freestanding/libp10c-v2.a" not in log or
                "libp10stdio-daimos" in log):
            raise ValueError("compiler runtime archive provenance not logged")
        asm = files[key + ("asm",)]
        if "main:" not in asm:
            raise ValueError("compiler did not emit original native C main")
        if row["status"] == "link_fail":
            if ("dlink: undefined symbol: " + row["expected_link_error"] not in log or
                    "p10run: link failed" not in log or
                    "dlink: duplicate global:" in log):
                raise ValueError("unexpected hosted fallback or suppressed linker error")
        else:
            report = files[key + ("report",)]
            mapping = files[key + ("map",)]
            if (re.search(r"^rc=0$", report, re.M) is None or
                    re.search(r"^result=PASS$", report, re.M) is None or
                    "HALT instruction" not in report or
                    re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+ 000000000000",
                              report) is None):
                raise ValueError("compiler stdlib companion guest did not PASS")
            for name in ("memset", "main", "abort", "exit"):
                if re.search(r"^" + name + r"\s+[0-7]+\s*$",
                             mapping, re.M) is None:
                    raise ValueError("compiler library-linked symbol missing: " + name)
    return True


def audit():
    validate(read_manifest(), ARCHIVE.read_bytes())
    print("PASS: compiler-only stdlib: 6 exact hosted-symbol link_fail, "
          "2 real guest PASS, 28 SHA-pinned artifacts")


if __name__ == "__main__":
    audit()
