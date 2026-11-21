#!/usr/bin/env python3
"""Fail-closed verification of the 980707 compiler-only token evidence.

Original ctype/linkage failures are real. The separate 9-bit space
scanner and independent literal strcpy test must preserve every native
PASS and GCC optimization run_fail; no ctype implementation is faked.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "manifests/PDP10-P1-980707-SPACE-TOKEN-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-980707-space-token-20261120-v1.tar.gz"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v23.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
LIB_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"

SOURCES = {
    "original": ("tests/todo/generic/980707-1.c",
                 "43c389a719d17d876d0f9f942d5db81f737c8eed7608de204862f23a6359e7b7"),
    "scanner": ("tests/semantic/regression/pdp10-space-token-pointer-v1.c",
                "2f15918f9cc9fc3330356f0fd23a43af324c4dabfdac409af131a7f366e7559a"),
    "strcpy": ("tests/semantic/regression/pdp10-strcpy-space-literal-v1.c",
               "18cac972901cd3d56d397ea44969e48b96609e5a4b4eb57075db2fcd108fda4f"),
}
PROFILES = (
    ("original", "kcc-pdp6-noopt", "link_fail", "-"),
    ("original", "gcc-pdp6-o0", "compile_fail", "-"),
    ("scanner", "kcc-pdp6-noopt", "pass", "0"),
    ("scanner", "kcc-pdp6-opt", "pass", "0"),
    ("scanner", "gcc-pdp6-o0", "pass", "0"),
    ("scanner", "gcc-pdp6-o1", "run_fail", "8"),
    ("scanner", "gcc-pdp6-o2", "run_fail", "8"),
    ("scanner", "gcc-pdp6-os", "run_fail", "8"),
    ("strcpy", "kcc-pdp6-noopt", "pass", "0"),
    ("strcpy", "kcc-pdp6-opt", "pass", "0"),
    ("strcpy", "gcc-pdp6-o0", "pass", "0"),
    ("strcpy", "gcc-pdp6-o1", "run_fail", "3"),
    ("strcpy", "gcc-pdp6-o2", "run_fail", "3"),
    ("strcpy", "gcc-pdp6-os", "run_fail", "3"),
)
KINDS = ("log", "status", "asm", "map", "report")
EXTENSIONS = {"log": ".log.txt", "status": ".status",
              "asm": ".s", "map": ".map", "report": ".report.txt"}
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "fail_id") + tuple(item for kind in KINDS
                             for item in (kind + "_member", kind + "_sha256"))


def read_tsv(path, comments=False):
    with path.open(encoding="ascii", newline="") as stream:
        return list(csv.DictReader((line for line in stream if line.strip() and
                                   (not comments or not line.startswith("#"))),
                                   delimiter="\t"))


def verify_sources():
    required = {
        "original": ("#include <ctype.h>", "isspace ((unsigned char)*input)",
                     "arglist [numargs++] = input;", "*(input++) = 0;",
                     'strcpy(input, " a b");', 'strcmp (args[0], "a")',
                     'strcmp (args[1], "b")', "args[2] != NULL"),
        "scanner": ("return c == (unsigned char)' ';",
                    "arglist_v1[numargs++] = input;", "*(input++) = 0;",
                    "#define COPY_V1(dst, src) strcpy((dst), (src))",
                    'COPY_V1(buf, " a b")', "CHECK_V1(args[0] == buf + 1, 8)",
                    "CHECK_V1(strcmp(args[0], \"a\") == 0, 10)",
                    "CHECK_V1(storage_v1.before == LEFT_GUARD_V1, 2)",
                    "CHECK_V1(storage_v1.after == RIGHT_GUARD_V1, 3)"),
        "strcpy": ('p = strcpy(target_v1.content, " a b");',
                   "volatile char *readback;", "CHECK_V1(readback[0] == ' ', 2)",
                   "CHECK_V1(readback[1] == 'a', 3)",
                   "CHECK_V1(readback[3] == 'b', 5)",
                   "CHECK_V1(target_v1.before == P10_LITERAL_LEFT_V1, 7)",
                   "CHECK_V1(target_v1.after == P10_LITERAL_RIGHT_V1, 8)"),
    }
    for role, (path, digest) in SOURCES.items():
        f = ROOT / path
        if not f.is_file() or hashlib.sha256(f.read_bytes()).hexdigest() != digest:
            raise ValueError("980707 historical or companion source changed: " + path)
        source = f.read_text(encoding="ascii")
        for phrase in required[role]:
            if phrase not in source:
                raise ValueError("980707 assertion missing: " + phrase)


def verify_manifest(rows, matrix, previous):
    verify_sources()
    if len(rows) != 14 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("980707 requires 14 exact source/profile outcomes")
    historical = [r for r in previous if r["original_source"] == SOURCES["original"][0]]
    if (len(historical) != 1 or historical[0]["p1_state"] != "blocked" or
            historical[0]["original_sha256"] != SOURCES["original"][1] or
            historical[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("980707 original ctype requirement must remain separate")
    for role, (path, _) in SOURCES.items():
        matches = [r for r in matrix if r["test"] == path]
        if (len(matches) != 1 or matches[0]["group"] !=
                ("semantic-upstream-deferred" if role == "original" else "semantic-regression") or
                matches[0]["pdp6"] != "semantic" or
                (role != "original" and any(matches[0]["pdp6_gcc_" + opt] != "semantic"
                                            for opt in ("o0", "o1", "o2", "os")))):
            raise ValueError("980707 compiler matrix registration changed: " + role)
    for row, (role, profile, status, fail_id) in zip(rows, PROFILES):
        prefix = role + "/pdp6/" + profile
        expected = {"role": role, "source": SOURCES[role][0],
                    "source_sha256": SOURCES[role][1], "profile": profile,
                    "cpu": "pdp6", "status": status, "fail_id": fail_id}
        for kind in KINDS:
            exists = not (role == "original" and
                          (kind in ("map", "report") or
                           (profile == "gcc-pdp6-o0" and kind == "asm")))
            expected[kind + "_member"] = prefix + EXTENSIONS[kind] if exists else "-"
            if not exists:
                expected[kind + "_sha256"] = "-"
        if any(row[field] != value for field, value in expected.items()):
            raise ValueError("980707 profile/result/member changed: " + profile)
        for kind in KINDS:
            if row[kind + "_member"] != "-" and not re.fullmatch(
                    r"[0-9a-f]{64}", row[kind + "_sha256"]):
                raise ValueError("980707 malformed evidence SHA256")


def read_expected(report, symbol):
    match = re.search(r"__P10RUN_EXPECT__ " + re.escape(symbol) +
                      r" [0-7]+ 000000000000\s*\n[0-7]+:\s*([0-7]{12})", report)
    if match is None:
        raise ValueError("980707 guest report missing expected memory: " + symbol)
    return int(match.group(1), 8)


def verify_archive(rows, payload):
    all_names = {r[kind + "_member"] for r in rows for kind in KINDS
                 if r[kind + "_member"] != "-"}
    if len(all_names) != 65:
        raise ValueError("980707 must contain exactly 65 distinct raw artifacts")
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 65 or {m.name for m in members} != all_names or
                    any(not m.isfile() for m in members)):
                raise ValueError("980707 guest archive membership changed")
            for row in rows:
                data = {}
                for kind in KINDS:
                    name = row[kind + "_member"]
                    if name == "-":
                        continue
                    stream = archive.extractfile(name)
                    if stream is None:
                        raise ValueError("980707 raw evidence member missing")
                    raw = stream.read()
                    if hashlib.sha256(raw).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("980707 raw evidence hash mismatch")
                    data[kind] = raw.decode("utf-8", "replace")
                status = data["status"]
                if ("status=" + row["status"] + "\n" not in status or
                        "profile=" + row["profile"] + "\n" not in status or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in status or
                        "runtime_library_sha256=" + LIB_SHA + "\n" not in status):
                    raise ValueError("980707 guest used wrong compiler libc")
                if row["role"] == "original":
                    diagnostic = ("dlink: undefined symbol: isspace" if
                                  row["profile"].startswith("kcc") else
                                  "ctype.h: No such file or directory")
                    if diagnostic not in data["log"]:
                        raise ValueError("980707 genuine original failure concealed")
                    continue
                report = data["report"]
                if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                        "HALT instruction" not in report or
                        "result=" + ("PASS" if row["status"] == "pass" else "FAIL") +
                        "\n" not in report):
                    raise ValueError("980707 native guest did not reach HALT")
                if (read_expected(report, "fail_id") != int(row["fail_id"]) or
                        read_expected(report, "__test_exit") !=
                        (0 if row["status"] == "pass" else 1)):
                    raise ValueError("980707 native guest expected assertion mismatch")
                for symbol in ("main", "fail_id"):
                    if re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                 data["map"], re.M) is None:
                        raise ValueError("980707 native guest map lacks " + symbol)
                if row["role"] == "strcpy" and row["status"] == "run_fail":
                    asm = data["asm"]
                    if ("\tdpb 4,[POINT 9,target_v1+1,8]" not in asm or
                            re.search(r"(?i)pushj\s+17,strcpy", asm)):
                        raise ValueError("980707 saved GCC optimized copy pattern changed")
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("980707 raw evidence archive unreadable") from exc


def audit():
    rows = read_tsv(MANIFEST)
    verify_manifest(rows, read_tsv(MATRIX, True), read_tsv(PREVIOUS))
    verify_archive(rows, ARCHIVE.read_bytes())
    return rows


def main():
    rows = audit()
    matrix = read_tsv(MATRIX, True)
    previous = read_tsv(PREVIOUS)
    count = 0
    for field, value in (("source_sha256", "0" * 64), ("role", "original"),
                         ("status", "pass"), ("profile", "gcc-pdp6-o0"),
                         ("fail_id", "0"), ("asm_sha256", "bad"),
                         ("report_member", "altered.txt")):
        changed = [dict(row) for row in rows]
        changed[5][field] = value
        try:
            verify_manifest(changed, matrix, previous)
        except ValueError:
            count += 1
        else:
            raise AssertionError("false 980707 compiler result accepted: " + field)
    for altered, mx, old in ((rows[:-1], matrix, previous),
                             (rows, [dict(r) for r in matrix], previous),
                             (rows, matrix, [dict(r) for r in previous])):
        if mx is not matrix:
            for row in mx:
                if row["test"] == SOURCES["strcpy"][0]:
                    row["pdp6_gcc_o1"] = "no_test"
        if old is not previous:
            for row in old:
                if row["original_source"] == SOURCES["original"][0]:
                    row["p1_state"] = "covered"
        try:
            verify_manifest(altered, mx, old)
        except ValueError:
            count += 1
        else:
            raise AssertionError("980707 altered source matrix/ledger accepted")
    corrupted = bytearray(ARCHIVE.read_bytes())
    corrupted[len(corrupted) // 2] ^= 1
    try:
        verify_archive(rows, bytes(corrupted))
    except ValueError:
        count += 1
    else:
        raise AssertionError("980707 corrupted native report accepted")
    print("PASS: 980707 original KCC isspace link / GCC ctype compile failures; "
          "12 genuine PDP-6 companion results (6 PASS/6 GCC opt run_fail), "
          "65 raw outputs, %d negative controls" % count)


if __name__ == "__main__":
    main()
