#!/usr/bin/env python3
"""Validate actual PDP-6 GCC packed-string builtin repair evidence.

The old and new compiler outputs are deliberately separate.  The new
independent 9-bit literal test also preserves two genuine KCC failures
for octal 0400; its KCC results are not silently called PASS.
"""

import csv
import hashlib
import io
import os
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/PDP10-GCC-STRING9-FOLD-REPAIR-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-gcc-string9-fold-repair-20261120-v1.tar.gz"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
SOURCES = {
    "strcpy-fixed": ("tests/semantic/regression/pdp10-strcpy-space-literal-v1.c",
                     "18cac972901cd3d56d397ea44969e48b96609e5a4b4eb57075db2fcd108fda4f"),
    "scanner-fixed": ("tests/semantic/regression/pdp10-space-token-pointer-v1.c",
                      "2f15918f9cc9fc3330356f0fd23a43af324c4dabfdac409af131a7f366e7559a"),
    "wide-old": ("tests/semantic/regression/pdp10-builtin-string9-constant-v1.c",
                 "9219c7a351e1f66b5f4fe4e0223fd3e5689a1dc2bad597c9d9b747cb0e6c8389"),
    "wide-fixed": ("tests/semantic/regression/pdp10-builtin-string9-constant-v1.c",
                   "9219c7a351e1f66b5f4fe4e0223fd3e5689a1dc2bad597c9d9b747cb0e6c8389"),
    "wide-kcc": ("tests/semantic/regression/pdp10-builtin-string9-constant-v1.c",
                 "9219c7a351e1f66b5f4fe4e0223fd3e5689a1dc2bad597c9d9b747cb0e6c8389"),
}
BEFORE = "d43034a6151e57787514ff6293b6d8da846de34a6192766d701505dab1eb6cc8"
AFTER = "0c33d1e7e93dd372e8b503aabf167c3299acdd830b289199c679ca07a7529b8a"
LIB = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
KINDS = ("log", "status", "asm", "map", "report")
EXT = {"log": ".log.txt", "status": ".status", "asm": ".s",
       "map": ".map", "report": ".report.txt"}
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "fail_id", "compiler_sha256") + tuple(
              f for kind in KINDS for f in (kind + "_member", kind + "_sha256"))
GCC_PROFILES = ("gcc-pdp6-o0", "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")
PROFILES = (
    tuple(("strcpy-fixed", p, "pass", "0", AFTER) for p in GCC_PROFILES)
    + tuple(("scanner-fixed", p, "pass", "0", AFTER) for p in GCC_PROFILES)
    + tuple(("wide-old", p, "run_fail", "1", BEFORE) for p in GCC_PROFILES)
    + tuple(("wide-fixed", p, "pass", "0", AFTER) for p in GCC_PROFILES)
    + (("wide-kcc", "kcc-pdp6-noopt", "run_fail", "6", "-"),
       ("wide-kcc", "kcc-pdp6-opt", "run_fail", "6", "-"))
)


def sha(blob):
    return hashlib.sha256(blob).hexdigest()


def read_tsv(path, comments=False):
    with path.open(encoding="ascii", newline="") as f:
        return list(csv.DictReader(
            (line for line in f if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def verify_sources():
    required = {
        "strcpy-fixed": ('p = strcpy(target_v1.content, " a b");',
                         "CHECK_V1(readback[1] == 'a', 3)"),
        "scanner-fixed": ('COPY_V1(buf, " a b")',
                          "CHECK_V1(args[0] == buf + 1, 8)"),
        "wide-old": ('CHECK_V1(strlen(" a b") == 4, 1);',
                     'CHECK_V1(strlen("\\400x") == 2, 6);',
                     'CHECK_V1(strcmp("\\400", "\\377") > 0, 10);',
                     'CHECK_V1(strncmp("\\400", "\\377", 1) > 0, 14);',
                     'CHECK_V1(memcmp("\\400\\377", "\\400\\376", 2) > 0, 15);',
                     'copy = strcpy(buffer_v1, "\\400x\\777");',
                     'CHECK_V1(readback[2] == 0777, 25);'),
    }
    for role, (name, digest) in SOURCES.items():
        path = ROOT / name
        if not path.is_file() or sha(path.read_bytes()) != digest:
            raise ValueError("GCC string-fold compiler source identity changed")
        source = path.read_text(encoding="ascii")
        for needle in required.get(role, ()):
            if needle not in source:
                raise ValueError("GCC string-fold oracle assertion missing: " + needle)


def verify_rows(rows, matrix):
    verify_sources()
    if len(rows) != 18 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("GCC string-fold evidence requires 18 exact guests")
    for role, (path, _) in SOURCES.items():
        entry = [r for r in matrix if r["test"] == path]
        if (len(entry) != 1 or entry[0]["group"] != "semantic-regression" or
                entry[0]["pdp6"] != "semantic" or
                any(entry[0]["pdp6_gcc_" + opt] != "semantic" for opt in
                    ("o0", "o1", "o2", "os"))):
            raise ValueError("GCC packed-string source not in semantic matrix: " + role)
    for row, (role, profile, status, fail_id, ccsha) in zip(rows, PROFILES):
        prefix = role + "/pdp6/" + profile
        expected = {"role": role, "source": SOURCES[role][0],
                    "source_sha256": SOURCES[role][1], "profile": profile,
                    "cpu": "pdp6", "status": status, "fail_id": fail_id,
                    "compiler_sha256": ccsha}
        for kind in KINDS:
            expected[kind + "_member"] = prefix + EXT[kind]
        if any(row[f] != v for f, v in expected.items()):
            raise ValueError("GCC string-fold source/profile result changed")
        for kind in KINDS:
            if not re.fullmatch(r"[0-9a-f]{64}", row[kind + "_sha256"]):
                raise ValueError("GCC string-fold invalid raw result checksum")


def expected_word(report, symbol):
    match = re.search(r"__P10RUN_EXPECT__ " + re.escape(symbol) +
                      r" [0-7]+ 000000000000\s*\n[0-7]+:\s*([0-7]{12})", report)
    if not match:
        raise ValueError("GCC string-fold missing actual guest result word")
    return int(match.group(1), 8)


def verify_archive(rows, raw):
    names = {r[kind + "_member"] for r in rows for kind in KINDS}
    if len(names) != 90:
        raise ValueError("GCC packed-string test must retain 90 raw artifacts")
    try:
        with tarfile.open(fileobj=io.BytesIO(raw), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 90 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("GCC string-fold evidence archive membership changed")

            def content(path):
                stream = tar.extractfile(path)
                if stream is None:
                    raise ValueError("GCC string-fold evidence member missing")
                return stream.read()

            for r in rows:
                fields = {}
                for kind in KINDS:
                    data = content(r[kind + "_member"])
                    if sha(data) != r[kind + "_sha256"]:
                        raise ValueError("GCC string-fold raw evidence corrupted")
                    fields[kind] = data.decode("utf-8", "replace")
                status = fields["status"]
                if ("status=" + r["status"] + "\n" not in status or
                        "profile=" + r["profile"] + "\n" not in status or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in status or
                        "runtime_library_sha256=" + LIB + "\n" not in status):
                    raise ValueError("GCC packed string result used wrong libc")
                report = fields["report"]
                if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                        "HALT instruction" not in report or
                        "result=" + ("PASS" if r["status"] == "pass" else "FAIL") +
                        "\n" not in report or
                        expected_word(report, "fail_id") != int(r["fail_id"]) or
                        expected_word(report, "__test_exit") !=
                        int(r["status"] == "run_fail")):
                    raise ValueError("GCC string-fold native guest result altered")
                if "main:" not in fields["asm"]:
                    raise ValueError("GCC packed-string compiled assembly absent")
                for symbol in ("main", "fail_id", "exit", "abort"):
                    if re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                 fields["map"], re.M) is None:
                        raise ValueError("GCC packed-string symbol map incomplete")
                if (r["role"] == "strcpy-fixed" and
                        r["profile"] in GCC_PROFILES[1:]):
                    asm = fields["asm"]
                    if (not re.search(r"\tmovei [0-7]+,5\n", asm) or
                            not re.search(r"\tdpb [0-7]+,[0-7]+\n", asm)):
                        raise ValueError("GCC optimized strcpy no longer stores all 5 bytes")
                if r["role"] == "wide-kcc":
                    if not re.search(r"^%L[0-9]+:\n\t\.byte\t9,0,0170,0$",
                                     fields["asm"], re.M):
                        raise ValueError("KCC high 9-bit octal escape failure hidden")
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("GCC packed-string archive unreadable") from exc


def audit():
    rows = read_tsv(MANIFEST)
    verify_rows(rows, read_tsv(MATRIX, True))
    verify_archive(rows, ARCHIVE.read_bytes())
    return rows


def main():
    rows = audit()
    matrix = read_tsv(MATRIX, True)
    checks = 0
    for field, value in (("role", "wide-old"), ("status", "run_fail"),
                         ("fail_id", "1"), ("source_sha256", "0" * 64),
                         ("profile", "gcc-ka10-o2"),
                         ("compiler_sha256", BEFORE),
                         ("report_member", "fake-report"),
                         ("asm_sha256", "bad")):
        mutated = [dict(r) for r in rows]
        mutated[13][field] = value
        try:
            verify_rows(mutated, matrix)
        except ValueError:
            checks += 1
        else:
            raise AssertionError("GCC string-fold false result accepted: " + field)
    for bad_rows, bad_matrix in ((rows[:-1], matrix), (rows, [dict(r) for r in matrix])):
        if bad_matrix is not matrix:
            for record in bad_matrix:
                if record["test"] == SOURCES["wide-old"][0]:
                    record["pdp6_gcc_o2"] = "no_test"
        try:
            verify_rows(bad_rows, bad_matrix)
        except ValueError:
            checks += 1
        else:
            raise AssertionError("GCC string-fold missing test accepted")
    broken = bytearray(ARCHIVE.read_bytes())
    broken[len(broken) // 2] ^= 1
    try:
        verify_archive(rows, bytes(broken))
    except ValueError:
        checks += 1
    else:
        raise AssertionError("GCC string-fold damaged evidence accepted")
    print("PASS: GCC 9-bit builtin fixed 12 native guest PASS, "
          "4 original GCC run_fail ID 1, 2 separate KCC run_fail ID 6, "
          "90 raw outputs and %d negative controls" % checks)


if __name__ == "__main__":
    main()
