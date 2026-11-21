#!/usr/bin/env python3
"""Pin nine current compiler ICE profiles without scheduling a full sweep.

Frozen 2026-11-17 history identifies the exact source/profile pairs.
The current evidence is nine fresh PDP-6 native codegen observations.
Failing compilers are not disguised as expected negative-test successes.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
HISTORICAL = ROOT / "manifests/PDP10-INITIAL-SWEEP-FAILURES-20261117-v1.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
MANIFEST = ROOT / "manifests/PDP10-COMPILER-ICE-CURRENT-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-compiler-ice-current-20261120-v1.tar.gz"
FIELDS = ("source", "source_sha256", "compiler", "profile", "status",
          "diagnostic_class", "log_member", "log_sha256",
          "checkpoint_member", "checkpoint_sha256")
EXPECTED = (
    ("tests/codegen/upstream-gcc/compile/20011217-2.c", "gcc-pdp6-o0",
     "b933c029f8bcf31e1a42d70ea4bf67500a41b1c0db28e61621c8a49e266377d1",
     "gcc-virtual-reg"),
    ("tests/codegen/upstream-gcc/compile/20020617-3.c", "gcc-pdp6-o0",
     "8cfdbd640ae0a48fed9446cc1d88ba027ce13b9bf7928cf95df19393cbc328db",
     "gcc-virtual-reg"),
    ("tests/codegen/upstream-gcc/compile/930120-1.c", "gcc-pdp6-o2",
     "e0f82f6e5b6ee2f58f719936392143290be22d9a39d1eafe9abfa9040b2026d4",
     "gcc-virtual-reg"),
    ("tests/codegen/upstream-gcc/compile/930120-1.c", "gcc-pdp6-o1",
     "e0f82f6e5b6ee2f58f719936392143290be22d9a39d1eafe9abfa9040b2026d4",
     "gcc-virtual-reg"),
    ("tests/codegen/upstream-gcc/compile/930120-1.c", "gcc-pdp6-os",
     "e0f82f6e5b6ee2f58f719936392143290be22d9a39d1eafe9abfa9040b2026d4",
     "gcc-virtual-reg"),
    ("tests/codegen/upstream-gcc/compile/goto-1.c", "gcc-pdp6-os",
     "cd326c83555b4f5dfd99f51d6b764c7c1a2d6182f608f6f518be4e967b0e440a",
     "gcc-signal"),
    ("tests/codegen/upstream-gcc/compile/920501-22.c", "kcc-pdp6-noopt",
     "d5b8c2da55fd5f33f517ff7411c2b0cd88a7010575d1b093200150825727fcb6",
     "kcc-simsmove"),
    ("tests/codegen/upstream-gcc/compile/init-1.c", "kcc-pdp6-noopt",
     "372529f7278bba55dc9a15870c08fc5f94f888bab656e1ede21fbc6e4f09d47a",
     "kcc-gizlist"),
    ("tests/codegen/gcc-historical-b08-v1/line4.c", "kcc-pdp6-noopt",
     "1e532017c9d268f0f5fe790838b3c1ba749609ce1ae547ad308998f96d8340c7",
     "kcc-segv-no-diagnostic"),
)
DIAGNOSTICS = {
    "gcc-virtual-reg": "Internal compiler error in instantiate_virtual_regs_1",
    "gcc-signal": "Internal error: Segmentation fault (program cc1)",
    "kcc-simsmove": "[Internal error] simsmove: bad size 0",
    "kcc-gizlist": "[Internal error] gizlist: bad size",
}
SIGNAL_MEMBER = "signal/kcc-line4-direct.txt"


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def validate(rows, historical, matrix):
    actual_history = [r for r in historical if r["status"] == "compiler_ice"]
    if (len(actual_history) != 9 or len(rows) != 9 or not rows or
            tuple(rows[0]) != FIELDS):
        raise ValueError("historical/current compiler ICE cardinality changed")
    for index, (row, old, expect) in enumerate(zip(rows, actual_history, EXPECTED), 1):
        path, profile, sha, diagnostic = expect
        compiler = profile.split("-", 1)[0]
        if (old["test"] != path or old["profile"] != profile or
                old["status"] != "compiler_ice" or
                row != dict(source=path, source_sha256=sha, compiler=compiler,
                            profile=profile, status="compiler_ice",
                            diagnostic_class=diagnostic,
                            log_member="native/%02d/cell.log" % index,
                            log_sha256=row["log_sha256"],
                            checkpoint_member="native/%02d/status" % index,
                            checkpoint_sha256=row["checkpoint_sha256"])):
            raise ValueError("source/profile is not the original ICE evidence")
        if (hashlib.sha256((ROOT / path).read_bytes()).hexdigest() != sha or
                any(re.fullmatch(r"[0-9a-f]{64}", row[key]) is None for key in
                    ("log_sha256", "checkpoint_sha256"))):
            raise ValueError("source or evidence digest not independently pinned")
        matches = [r for r in matrix if r["test"] == path]
        column = "pdp6_gcc_" + profile.rsplit("-", 1)[1] if compiler == "gcc" else "pdp6"
        if (len(matches) != 1 or matches[0][column] not in
                ("codegen", "fail", "pending", "error", "timeout")):
            raise ValueError("source must retain its native codegen matrix cell")


def validate_archive(rows, payload):
    expected_names = {r[k] for r in rows for k in
                      ("log_member", "checkpoint_member")}
    expected_names.add(SIGNAL_MEMBER)
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 19 or
                    {m.name for m in members} != expected_names or
                    any(not m.isfile() for m in members)):
                raise ValueError("ICE source/report archive is incomplete")
            for row in rows:
                result = {}
                for kind in ("log", "checkpoint"):
                    stream = archive.extractfile(row[kind + "_member"])
                    if stream is None:
                        raise ValueError("missing compiler log or checkpoint")
                    data = stream.read()
                    if hashlib.sha256(data).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("compiler ICE evidence digest mismatch")
                    result[kind] = data.decode("utf-8", "replace")
                status = result["checkpoint"]
                if ("\nstatus=compiler_ice\n" not in status or
                        "\nkind=codegen\n" not in status or
                        "\nprofile=" + row["profile"] + "\n" not in status or
                        "\ntest=" + row["source"] + "\n" not in status):
                    raise ValueError("ICE checkpoint not tied to exact profile")
                diagnostic = row["diagnostic_class"]
                if diagnostic in DIAGNOSTICS:
                    if DIAGNOSTICS[diagnostic] not in result["log"]:
                        raise ValueError("missing exact compiler-internal diagnostic")
                elif diagnostic != "kcc-segv-no-diagnostic" or "kcc -S" not in result["log"]:
                    raise ValueError("missing original KCC silent-signal record")
            direct = archive.extractfile(SIGNAL_MEMBER)
            if (direct is None or
                    "returncode=-11\n" not in direct.read().decode("utf-8", "replace")):
                raise ValueError("KCC line4 missing independent SIGSEGV evidence")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt compressed compiler ICE archive") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(HISTORICAL), read(MATRIX, True))
    validate_archive(rows, ARCHIVE.read_bytes())
    print("PASS: nine current native PDP-6 compiler ICE/signal records "
          "(6 GCC, 3 KCC); history, sources and raw failures SHA-pinned")


if __name__ == "__main__":
    audit()
