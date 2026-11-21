#!/usr/bin/env python3
"""Pin 941014 original missing-libc failures and true volatile guest oracles.

This validator never runs the full compiler or CPU sweep.  It protects
the exact unchanged historical source, the newly registered C89
companion, six PDP-6 native compiler outcomes, the compiler-owned
stdlib identity, and the three genuine GCC optimization failures.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = "tests/todo/generic/941014-2.c"
COMPANION = "tests/semantic/regression/pdp10-volatile-short-offset-v1.c"
ORIGINAL_SHA = "2e4ed285b175681b5c72b1de67f95329e915e0e2b88d25e004a68389f245cae9"
COMPANION_SHA = "fed85b731df2c480eed32c1c3c174e6c19ebcb36ab546e63ff20f401495d3c26"
LIBRARY_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
MANIFEST = ROOT / "manifests/PDP10-P1-941014-VOLATILE-SHORT-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-941014-volatile-short-20261120-v1.tar.gz"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v20.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
FIELDS = ("role", "source", "source_sha256", "profile", "cpu",
          "status", "failure_id", "report_member", "report_sha256",
          "map_member", "map_sha256", "asm_member", "asm_sha256",
          "status_member", "status_sha256")
PROFILES = (
    ("original", "kcc-pdp6-noopt", "link_fail", ""),
    ("original", "gcc-pdp6-o0", "link_fail", ""),
    ("companion", "kcc-pdp6-noopt", "pass", "0"),
    ("companion", "kcc-pdp6-opt", "pass", "0"),
    ("companion", "gcc-pdp6-o0", "pass", "0"),
    ("companion", "gcc-pdp6-o1", "run_fail", "11"),
    ("companion", "gcc-pdp6-o2", "run_fail", "16"),
    ("companion", "gcc-pdp6-os", "run_fail", "16"),
)


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def source_guard(name, digest, phrases):
    source = ROOT / name
    if not source.is_file() or hashlib.sha256(source.read_bytes()).hexdigest() != digest:
        raise ValueError("changed 941014 original or companion source")
    content = source.read_text(encoding="ascii")
    for phrase in phrases:
        if phrase not in content:
            raise ValueError("missing compiler oracle: " + phrase)


def validate(rows, matrix, previous):
    if not rows or len(rows) != len(PROFILES) or tuple(rows[0]) != FIELDS:
        raise ValueError("941014 requires two link failures and six native guests")
    source_guard(ORIGINAL, ORIGINAL_SHA, (
        "volatile foo_t *", "malloc (sizeof (foo_t))", "foo_p->a & 0xf000",
        "foo_p->b = 0x0100", "a1((unsigned long)foo_p-30)",
        "a1 ((unsigned long)foo_p + 2)", "printf(", "abort ();"))
    source_guard(COMPANION, COMPANION_SHA, (
        "unsigned short a;", "unsigned short b;", "volatile foo_t payload;",
        "CHECK_V1(sizeof(unsigned short) == 2, 1)",
        "CHECK_V1(sizeof(foo_t) == 4, 2)",
        "storage_v1.payload.a = INITIAL_A_V1;",
        "storage_v1.payload.b = INITIAL_B_V1;",
        "a1((unsigned long)foo_p - 30)",
        "a1((unsigned long)foo_p + 2)",
        "foo_p->b = FINAL_B_V1;", "CHECK_V1(foo_p->b == FINAL_B_V1, 6)",
        "CHECK_V1(a1_count_v1 == 3, 10)",
        "CHECK_V1(a1_values_v1[0] == address - 30, 11)",
        "CHECK_V1(a1_values_v1[1] == address + 2, 12)",
        "CHECK_V1(a1_values_v1[2] == address - 30, 13)",
        "CHECK_V1(a1_values_v1[1] - a1_values_v1[0] == 32, 16)",
        "CHECK_V1(storage_v1.left == LEFT_V1, 8)",
        "CHECK_V1(storage_v1.right == RIGHT_V1, 9)", "return 0;"))
    old = [r for r in previous if r["original_source"] == ORIGINAL]
    if (len(old) != 1 or old[0]["p1_state"] != "blocked" or
            old[0]["original_sha256"] != ORIGINAL_SHA or
            old[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("941014 historical hosted-runtime blocker not preserved")
    a = [r for r in matrix if r["test"] == ORIGINAL]
    b = [r for r in matrix if r["test"] == COMPANION]
    if (len(a) != 1 or len(b) != 1 or
            a[0]["group"] != "semantic-upstream-deferred" or
            b[0]["group"] != "semantic-regression" or
            a[0]["pdp6"] != "semantic" or
            b[0]["pdp6"] != "semantic" or
            any(b[0]["pdp6_gcc_" + opt] != "semantic"
                for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("941014 companion/native compiler matrix changed")

    for row, (role, profile, status, failure) in zip(rows, PROFILES):
        source = ORIGINAL if role == "original" else COMPANION
        sha = ORIGINAL_SHA if role == "original" else COMPANION_SHA
        stem = role + "/pdp6/" + profile
        expected = {
            "role": role, "source": source, "source_sha256": sha,
            "profile": profile, "cpu": "pdp6", "status": status,
            "failure_id": failure, "report_member": stem + ".report.txt",
            "asm_member": stem + ".s", "status_member": stem + ".status",
            "map_member": stem + ".map" if role == "companion" else "",
            "map_sha256": "" if role == "original" else row["map_sha256"],
        }
        if any(row[key] != value for key, value in expected.items()):
            raise ValueError("941014 guest profile, source, result or oracle mutated")
        for kind in ("report", "map", "asm", "status"):
            sha_field = kind + "_sha256"
            if kind != "map" or role == "companion":
                if re.fullmatch(r"[0-9a-f]{64}", row[sha_field]) is None:
                    raise ValueError("941014 raw evidence SHA256 not recorded")


def validate_archive(rows, payload):
    required = {row[k] for row in rows for k in
                ("report_member", "map_member", "asm_member", "status_member")
                if row[k]}
    if len(required) != 30:
        raise ValueError("941014 real artifact list incomplete")
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 30 or {member.name for member in members} != required or
                    any(not member.isfile() for member in members)):
                raise ValueError("941014 artifact archive is incomplete/unsafe")
            for row in rows:
                actual = {}
                for kind in ("report", "map", "asm", "status"):
                    name = row[kind + "_member"]
                    if not name:
                        continue
                    stream = archive.extractfile(name)
                    if stream is None:
                        raise ValueError("941014 raw data absent")
                    body = stream.read()
                    if hashlib.sha256(body).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("941014 artifact SHA256 mismatch")
                    actual[kind] = body.decode("utf-8", "replace")
                text = actual["status"]
                if ("profile=" + row["profile"] + "\n" not in text or
                        "status=" + row["status"] + "\n" not in text or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in text or
                        "runtime_library_sha256=" + LIBRARY_SHA + "\n" not in text):
                    raise ValueError("941014 artifact not from compiler stdlib")
                if "main:" not in actual["asm"]:
                    raise ValueError("941014 compiler never emitted main")
                report = actual["report"]
                if row["role"] == "original":
                    missing = "printf" if row["profile"].startswith("kcc") else "malloc"
                    if ("dlink: undefined symbol: " + missing not in report or
                            "p10run: link failed" not in report or
                            "runtime_library_policy=compiler-stdlib-v1" not in report):
                        raise ValueError("original 941014 missing-libc link failure faked")
                else:
                    if ("machine=pdp6\n" not in report or
                            "result=" + ("PASS" if row["status"] == "pass" else "FAIL") + "\n" not in report or
                            "HALT instruction" not in report or
                            re.search(r"__P10RUN_EXPECT__ __test_exit [0-7]+ 000000000000",
                                      report) is None):
                        raise ValueError("941014 guest result unsupported")
                    observed = re.findall(
                        r"__P10RUN_EXPECT__ fail_id [0-7]+ 000000000000\s*\n"
                        r"[0-7]+:\s*([0-7]{12})", report)
                    if (len(observed) != 1 or
                            int(observed[0], 8) != int(row["failure_id"])):
                        raise ValueError("941014 optimized compiler defect hidden")
                    observed_exit = re.findall(
                        r"__P10RUN_EXPECT__ __test_exit [0-7]+ 000000000000\s*\n"
                        r"[0-7]+:\s*([0-7]{12})", report)
                    expected_exit = 0 if row["status"] == "pass" else 1
                    if (len(observed_exit) != 1 or
                            int(observed_exit[0], 8) != expected_exit):
                        raise ValueError("941014 guest did not reach expected exit")
                    for sym in ("a1", "main", "fail_id", "abort", "exit"):
                        if re.search(r"^" + sym + r"\s+[0-7]+\s*$",
                                     actual["map"], re.M) is None:
                            raise ValueError("941014 missing genuine linker symbol " + sym)
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("941014 guest evidence archive corrupt") from exc


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    return rows


def reject(rows, matrix, previous):
    try:
        validate(rows, matrix, previous)
    except ValueError:
        return
    raise AssertionError("accepted modified 941014 compiler/guest result")


def main():
    rows = audit()
    matrix = read(MATRIX, True)
    previous = read(PREVIOUS)
    count = 0
    for field, wrong in (("source_sha256", "0" * 64),
                         ("profile", "gcc-ka10-o1"),
                         ("status", "pass"),
                         ("failure_id", "0"),
                         ("report_sha256", "bad"),
                         ("role", "original"),
                         ("asm_member", "not-the-source.s")):
        altered = [dict(row) for row in rows]
        altered[5][field] = wrong
        reject(altered, matrix, previous)
        count += 1
    reject(rows[:-1], matrix, previous)
    count += 1
    bad_matrix = [dict(row) for row in matrix]
    for row in bad_matrix:
        if row["test"] == COMPANION:
            row["pdp6_gcc_os"] = "no_test"
    reject(rows, bad_matrix, previous)
    count += 1
    bad_history = [dict(row) for row in previous]
    for row in bad_history:
        if row["original_source"] == ORIGINAL:
            row["p1_state"] = "covered"
    reject(rows, matrix, bad_history)
    count += 1
    damaged = bytearray(ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        validate_archive(rows, bytes(damaged))
    except ValueError:
        count += 1
    else:
        raise AssertionError("accepted corrupted 941014 real guest output")
    print("PASS: 941014 original 2 compiler-library link failures; native "
          "3 PASS/3 GCC optimization run_fail; 30 outputs; %d negative controls" %
          count)


if __name__ == "__main__":
    main()
