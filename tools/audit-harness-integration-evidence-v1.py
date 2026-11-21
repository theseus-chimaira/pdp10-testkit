#!/usr/bin/env python3
"""Pin actual PDP-6 ICE-focused original-source and C-to-ISA harness runs.

This is a source/profile ownership and *observation* archive, not a
semantic success archive.  Raw non-ICE compiler/guest failures remain
failure statuses; real compiler internal errors are required to remain
ICEs.  No guest assertion or historical P1 disposition is changed.
"""

import argparse
import collections
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
MANIFEST = ROOT / "manifests/PDP10-HARNESS-NATIVE-OBSERVATIONS-20261121-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-harness-native-observations-20261121-v1.tar.gz"
ORIGINALS = ROOT / "manifests/PDP10-P1-HARNESS-OBSERVATIONS-20261121-v1.txt"
ISA = ROOT / "manifests/PDP10-ISA-C-SOURCES-20261121-v1.txt"
CASES = (
    ("original-gcc-o0", "p10tk-p1-observations-gcc-o0-20261121-v1",
     "gcc-pdp6-o0", ORIGINALS, 38),
    ("original-kcc-noopt", "p10tk-p1-observations-kcc-noopt-20261121-v1",
     "kcc-pdp6-noopt", ORIGINALS, 38),
    ("isa-kcc-noopt", "p10tk-isa-c-kcc-noopt-20261121-v1",
     "kcc-pdp6-noopt", ISA, 99),
)
FIELDS = ("role", "source", "source_sha256", "compiler", "profile",
          "machine", "kind", "status", "compiler_sha256",
          "compiler_stdlib_sha256", "status_member", "status_sha256",
          "log_member", "log_sha256", "asm_member", "asm_sha256",
          "map_member", "map_sha256", "report_member", "report_sha256")
EXITS = {"pass", "compile_only", "compiler_ice", "compile_fail",
         "link_fail", "run_fail", "timeout", "policy_fail", "setup_fail",
         "unexpected_compile_success"}
COUNTS = {
    "original-gcc-o0": {"pass": 15, "run_fail": 15, "link_fail": 3,
                        "timeout": 4, "compiler_ice": 1},
    "original-kcc-noopt": {"pass": 11, "compile_fail": 18,
                            "link_fail": 4, "run_fail": 4, "timeout": 1},
    "isa-kcc-noopt": {"pass": 99},
}
CORE_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
COMPILER_SHAS = {
    "kcc": "fbe85b127e2004fac0538b338101a5bca9b155bdf7aad3cd06d0917671ba538b",
    "gcc": "67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7",
}
ICE_SOURCE = "tests/semantic/upstream/extensions/991228-1.c"
ORIGINAL_CODEGEN = frozenset(
    row.split("\t")[2]
    for row in (ROOT / "manifests/PDP10-P1-HARNESS-ORIGINALS-20261121-v1.tsv")
    .read_text(encoding="ascii").splitlines()[1:]
    if row.split("\t")[5] == "codegen-p1-original-observation")
SUFFIX = {"status": ".status", "log": ".log.txt", "asm": ".s",
          "map": ".map", "report": ".report.txt"}
KINDS = ("status", "log", "asm", "map", "report")


def sha(data):
    return hashlib.sha256(data).hexdigest()


def sources(path):
    return tuple(line for line in path.read_text(encoding="ascii").splitlines()
                 if line)


def expected_identity():
    return {role: (set(sources(selection)), profile, total)
            for role, _folder, profile, selection, total in CASES}


def verify_rows(rows):
    ident = expected_identity()
    if len(rows) != 175 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("expected 175 real native compiler observations")
    found = {name: set() for name in ident}
    states = collections.defaultdict(collections.Counter)
    for row in rows:
        role = row["role"]
        if role not in ident:
            raise ValueError("unknown native observation role")
        eligible, profile, count = ident[role]
        src = row["source"]
        compiler = profile.split("-", 1)[0]
        if (src not in eligible or src in found[role] or
                row["compiler"] != compiler or
                row["profile"] != profile or row["machine"] != "pdp6" or
                row["kind"] != ("codegen" if role == "isa-kcc-noopt" else
                                "codegen" if src in ORIGINAL_CODEGEN else "semantic") or
                row["status"] not in EXITS or
                row["source_sha256"] != sha((ROOT / src).read_bytes()) or
                row["compiler_stdlib_sha256"] !=
                ("-" if row["kind"] == "codegen" else CORE_SHA)):
            raise ValueError("wrong source/profile/true compiler status")
        if row["compiler_sha256"] != COMPILER_SHAS[compiler]:
            raise ValueError("observed compiler executable SHA changed")
        for kind in KINDS:
            item = row[kind + "_member"]
            digest = row[kind + "_sha256"]
            if item == "-":
                if digest != "-" or kind in ("status", "log"):
                    raise ValueError("missing mandatory raw status/log")
            elif (item != role + "/" + profile + "/" +
                  sha(src.encode("ascii"))[:16] + SUFFIX[kind] or
                  not re.fullmatch(r"[0-9a-f]{64}", digest)):
                raise ValueError("raw evidence path/hash invalid")
        found[role].add(src)
        states[role][row["status"]] += 1
    for role, (eligible, profile, total) in ident.items():
        if len(found[role]) != total or not found[role].issubset(eligible):
            raise ValueError("a required original/ISA native test is omitted")
        if dict(states[role]) != COUNTS[role]:
            raise ValueError("non-ICE original failures or genuine ICE were hidden")
    if sum(c["compiler_ice"] for c in states.values()) != 1:
        raise ValueError("actual compiler ICE lost")


def verify_archive(rows, data):
    expected = {r[kind + "_member"] for r in rows for kind in KINDS
                if r[kind + "_member"] != "-"}
    try:
        with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
            actual = archive.getmembers()
            if (len(actual) != len(expected) or
                    set(m.name for m in actual) != expected or
                    any(not m.isfile() for m in actual)):
                raise ValueError("raw guest archive membership changed")
            for row in rows:
                output = {}
                for kind in KINDS:
                    name = row[kind + "_member"]
                    if name == "-":
                        continue
                    stream = archive.extractfile(name)
                    if stream is None:
                        raise ValueError("raw output missing")
                    payload = stream.read()
                    if sha(payload) != row[kind + "_sha256"]:
                        raise ValueError("raw compiler/simulator output modified")
                    output[kind] = payload.decode("utf-8", "replace")
                status = output["status"]
                required = ("test=" + row["source"] + "\n",
                            "status=" + row["status"] + "\n",
                            "profile=" + row["profile"] + "\n",
                            "kind=" + row["kind"] + "\n")
                if any(part not in status for part in required):
                    raise ValueError("checkpoint contradicts claimed source/status")
                if row["kind"] == "semantic" and (
                        "runtime_library_policy=compiler-stdlib-v1\n" not in status or
                        "runtime_library_sha256=" + CORE_SHA + "\n" not in status):
                    raise ValueError("guest used non-compiler libc")
                if row["status"] == "compiler_ice":
                    if (row["source"] != ICE_SOURCE or
                            "Internal compiler error in instantiate_virtual_regs_1"
                            not in output["log"]):
                        raise ValueError("wrong/compiler ICE artifact")
                if row["status"] == "pass" and row["kind"] == "semantic":
                    if ("result=PASS\n" not in output.get("report", "") or
                            "__P10RUN_EXPECT__ __test_exit" not in
                            output.get("report", "")):
                        raise ValueError("unverified semantic guest PASS")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("raw native observation archive unreadable") from error


def audit():
    with MANIFEST.open(encoding="ascii", newline="") as stream:
        rows = list(csv.DictReader(stream, delimiter="\t"))
    verify_rows(rows)
    verify_archive(rows, ARCHIVE.read_bytes())
    return rows


def write():
    rows = []
    stored = {}
    for role, folder, profile, selection, total in CASES:
        cells = tuple((TMP / folder / "cells").glob("*"))
        allowed = set(sources(selection))
        if len(cells) != total:
            raise ValueError("expected %d real guest cells: %s" % (total, role))
        for cell in sorted(cells):
            if not cell.is_dir():
                raise ValueError("unexpected cell artifact")
            status_path = cell / "status"
            record = dict(line.split("=", 1)
                          for line in status_path.read_text(
                              encoding="utf-8").splitlines()
                          if "=" in line and not line.startswith("#"))
            src = record["test"]
            if src not in allowed or record["profile"] != profile:
                raise ValueError("unmatched original/ISA source result")
            compiler = profile.split("-", 1)[0]
            prefix = Path(os.environ["PDP10_PREFIX"])
            binary = (prefix / "bin/kcc" if compiler == "kcc" else
                      prefix / "lib/gcc-lib/pdp10-dec-none/3.2/cc1")
            row = {"role": role, "source": src,
                   "source_sha256": sha((ROOT / src).read_bytes()),
                   "compiler": compiler, "profile": profile,
                   "machine": "pdp6", "kind": record["kind"],
                   "status": record["status"],
                   "compiler_sha256": sha(binary.read_bytes()),
                   "compiler_stdlib_sha256": (
                       CORE_SHA if record["kind"] == "semantic" else "-")}
            paths = {"status": status_path, "log": cell / "cell.log"}
            for kind, directory, extension in (
                    ("asm", "asm", ".s"),
                    ("map", "run", ".map"),
                    ("report", "run", ".report.txt")):
                items = list((cell / directory).glob("*" + extension))
                if len(items) > 1:
                    raise ValueError("ambiguous raw guest " + kind)
                paths[kind] = items[0] if items else None
            for kind in KINDS:
                path = paths[kind]
                if path is None:
                    row[kind + "_member"] = "-"
                    row[kind + "_sha256"] = "-"
                else:
                    name = (role + "/" + profile + "/" +
                            sha(src.encode("ascii"))[:16] + SUFFIX[kind])
                    payload = path.read_bytes()
                    if name in stored:
                        raise ValueError("duplicate archive output")
                    stored[name] = payload
                    row[kind + "_member"] = name
                    row[kind + "_sha256"] = sha(payload)
            rows.append(row)
    rows.sort(key=lambda row: (row["role"], row["source"]))
    verify_rows(rows)
    with MANIFEST.open("w", encoding="ascii", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=FIELDS, delimiter="\t",
                                lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    buffer = io.BytesIO()
    with gzip.GzipFile(fileobj=buffer, mode="wb", filename="", mtime=0) as zipf:
        with tarfile.open(fileobj=zipf, mode="w") as archive:
            for name in sorted(stored):
                payload = stored[name]
                member = tarfile.TarInfo(name)
                member.size = len(payload)
                member.mtime = 0
                member.mode = 0o644
                archive.addfile(member, io.BytesIO(payload))
    ARCHIVE.write_bytes(buffer.getvalue())
    audit()
    print("WROTE: 175 true native observations, %d SHA-pinned raw artifacts, "
          "archive %s" % (len(stored), sha(ARCHIVE.read_bytes())))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.write:
        write()
    else:
        rows = audit()
        print("PASS: 38 GCC originals (15 pass/22 non-ICE failures/1 ICE), "
              "38 KCC originals (11 pass/27 non-ICE failures), "
              "99 ISA KCC codegen PASS; %d genuine original+ISA observations" %
              len(rows))


if __name__ == "__main__":
    main()
