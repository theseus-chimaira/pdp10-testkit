#!/usr/bin/env python3
"""Authenticate the 20020406 recursive pointer-swap PDP-6 evidence.

The original remains blocked by real compiler-library malloc. The
companion tests the reachable recursive call without replacing hosted
allocator or console services. No full compiler sweep is executed.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = "tests/todo/generic/20020406-1.c"
COMPANION = "tests/semantic/regression/pdp10-duptree-recursive-pointer-swap-v1.c"
ORIGINAL_SHA = "25ba3fe43fc4109bd2eb1a2fb651f9ca0443800db46e67d60b4946e9c3e90e7c"
COMPANION_SHA = "27b29ef587c6ac726bce5f84f83e6946b2f8d5f93ee4a0aad723584d51b73302"
LIBRARY_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
MANIFEST = ROOT / "manifests/PDP10-P1-20020406-RECURSIVE-SWAP-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-20020406-recursive-swap-20261120-v1.tar.gz"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v22.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "report_member", "report_sha256", "map_member", "map_sha256",
          "asm_member", "asm_sha256", "status_member", "status_sha256")
PROFILES = (
    ("original", "kcc-pdp6-noopt", "link_fail"),
    ("original", "gcc-pdp6-o0", "link_fail"),
    ("companion", "kcc-pdp6-noopt", "pass"),
    ("companion", "kcc-pdp6-opt", "pass"),
    ("companion", "gcc-pdp6-o0", "pass"),
    ("companion", "gcc-pdp6-o1", "pass"),
    ("companion", "gcc-pdp6-o2", "pass"),
    ("companion", "gcc-pdp6-os", "pass"),
)


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def check_source(path, digest, phrases):
    source = ROOT / path
    if not source.is_file() or hashlib.sha256(source.read_bytes()).hexdigest() != digest:
        raise ValueError("20020406 historical or companion source hash changed")
    content = source.read_text(encoding="ascii")
    for phrase in phrases:
        if phrase not in content:
            raise ValueError("20020406 recursive oracle missing: " + phrase)


def validate(rows, matrix, previous):
    if len(rows) != 8 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("20020406 needs two original failures, six guests")
    check_source(ORIGINAL, ORIGINAL_SHA, (
        "extern void * malloc (__SIZE_TYPE__);",
        "extern void * calloc (__SIZE_TYPE__, __SIZE_TYPE__);",
        "DUPFFexgcd(gcofac, fcofac, g, f)",
        "if (f->coeffs[0] == 0) return f;",
        "f = DUPFFnew(1); f->coeffs[1] = 1; f->deg = 1;",
        "g = DUPFFnew(2); g->coeffs[2] = 1; g->deg = 2;",
        "h = DUPFFexgcd(&cf, &cg, f, g);"))
    check_source(COMPANION, COMPANION_SHA, (
        "DUPFFexgcd(DUPFF *fcofac, DUPFF *gcofac, const DUPFF f, const DUPFF g)",
        "return DUPFFexgcd(gcofac, fcofac, g, f);",
        "if (f->coeffs[0] == 0)",
        "CHECK_V1(invocation_count_v1 == 2, 5)",
        "CHECK_V1(first_slot_v1[1] == &cg, 8)",
        "CHECK_V1(second_slot_v1[1] == &cf, 9)",
        "CHECK_V1(first_arg_v1[1] == g, 12)",
        "CHECK_V1(second_arg_v1[1] == f, 13)",
        "CHECK_V1(result == g, 14)",
        "CHECK_V1(cf == f, 15)",
        "CHECK_V1(cg == g, 16)",
        "CHECK_V1(g_coeffs[0] == 0 && g_coeffs[1] == 0 && g_coeffs[2] == 1, 20)",
        "return 0;"))
    old = [r for r in previous if r["original_source"] == ORIGINAL]
    if (len(old) != 1 or old[0]["original_sha256"] != ORIGINAL_SHA or
            old[0]["historical_disposition"] != "hosted-runtime" or
            old[0]["p1_state"] != "blocked"):
        raise ValueError("20020406 historical runtime blocker lost")
    first = [r for r in matrix if r["test"] == ORIGINAL]
    second = [r for r in matrix if r["test"] == COMPANION]
    if (len(first) != 1 or len(second) != 1 or
            first[0]["group"] != "semantic-upstream-deferred" or
            second[0]["group"] != "semantic-regression" or
            first[0]["pdp6"] != "semantic" or second[0]["pdp6"] != "semantic" or
            any(second[0]["pdp6_gcc_" + opt] != "semantic" for opt in
                ("o0", "o1", "o2", "os"))):
        raise ValueError("20020406 native compiler matrix registration altered")
    for row, (role, profile, status) in zip(rows, PROFILES):
        prefix = role + "/pdp6/" + profile
        expected = {
            "role": role, "source": ORIGINAL if role == "original" else COMPANION,
            "source_sha256": ORIGINAL_SHA if role == "original" else COMPANION_SHA,
            "profile": profile, "cpu": "pdp6", "status": status,
            "report_member": prefix + ".report.txt",
            "map_member": prefix + ".map" if role == "companion" else "",
            "map_sha256": row["map_sha256"] if role == "companion" else "",
            "asm_member": prefix + ".s", "status_member": prefix + ".status",
        }
        if any(row[key] != value for key, value in expected.items()):
            raise ValueError("20020406 source/profile/outcome was changed")
        for kind in ("report", "asm", "status") + (("map",) if role == "companion" else ()):
            if re.fullmatch(r"[0-9a-f]{64}", row[kind + "_sha256"]) is None:
                raise ValueError("20020406 source output hash missing")


def validate_archive(rows, data):
    names = {r[k] for r in rows for k in
             ("report_member", "map_member", "asm_member", "status_member") if r[k]}
    if len(names) != 30:
        raise ValueError("20020406 output archive requires 30 raw artifacts")
    try:
        with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
            entries = archive.getmembers()
            if (len(entries) != 30 or {e.name for e in entries} != names or
                    any(not e.isfile() for e in entries)):
                raise ValueError("20020406 artifact collection changed")
            for row in rows:
                contents = {}
                for kind in ("report", "map", "asm", "status"):
                    name = row[kind + "_member"]
                    if not name:
                        continue
                    stream = archive.extractfile(name)
                    if stream is None:
                        raise ValueError("20020406 missing archive member")
                    raw = stream.read()
                    if hashlib.sha256(raw).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("20020406 guest archive SHA256 mismatch")
                    contents[kind] = raw.decode("utf-8", "replace")
                stamp = contents["status"]
                if ("profile=" + row["profile"] + "\n" not in stamp or
                        "status=" + row["status"] + "\n" not in stamp or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in stamp or
                        "runtime_library_sha256=" + LIBRARY_SHA + "\n" not in stamp):
                    raise ValueError("20020406 linked unrelated libc")
                if "main:" not in contents["asm"]:
                    raise ValueError("20020406 compiled main missing")
                report = contents["report"]
                if row["role"] == "original":
                    if ("dlink: undefined symbol: malloc" not in report or
                            "p10run: link failed" not in report or
                            "runtime_library_policy=compiler-stdlib-v1" not in report):
                        raise ValueError("20020406 missing malloc blocker hidden")
                else:
                    if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                            "result=PASS\n" not in report or
                            "HALT instruction" not in report):
                        raise ValueError("20020406 native PDP-6 guest did not pass")
                    for name in ("__test_exit", "fail_id"):
                        match = re.search(
                            r"__P10RUN_EXPECT__ " + name + r" [0-7]+ 000000000000\s*\n"
                            r"[0-7]+:\s*([0-7]{12})", report)
                        if not match or int(match.group(1), 8) != 0:
                            raise ValueError("20020406 guest assertion not zero")
                    for sym in ("DUPFFdeg", "DUPFFexgcd", "main", "fail_id", "abort", "exit"):
                        if re.search(r"^" + sym + r"\s+[0-7]+\s*$",
                                     contents["map"], re.M) is None:
                            raise ValueError("20020406 linker map lacks " + sym)
                    if ("DUPFFexgcd:" not in contents["asm"] or
                            not re.search(r"(?i)(?:pushj\s+17,|jrst\s+)DUPFFexgcd",
                                          contents["asm"])):
                        raise ValueError("20020406 recursive compiler path absent")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("20020406 compressed guest archive corrupt") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    return rows


def main():
    rows = audit()
    matrix = read(MATRIX, True)
    previous = read(PREVIOUS)
    count = 0
    for field, val in (("source_sha256", "0" * 64), ("profile", "gcc-ka10-o0"),
                       ("status", "run_fail"), ("role", "original"),
                       ("report_sha256", "bad"), ("asm_member", "fake.s")):
        fake = [dict(r) for r in rows]
        fake[4][field] = val
        try:
            validate(fake, matrix, previous)
        except ValueError:
            count += 1
        else:
            raise AssertionError("invalid recursive guest claim accepted")
    for changed, mx, old in ((rows[:-1], matrix, previous),
                             (rows, [dict(r) for r in matrix], previous),
                             (rows, matrix, [dict(r) for r in previous])):
        if mx is not matrix:
            for row in mx:
                if row["test"] == COMPANION:
                    row["pdp6_gcc_os"] = "no_test"
        if old is not previous:
            for row in old:
                if row["original_source"] == ORIGINAL:
                    row["p1_state"] = "covered"
        try:
            validate(changed, mx, old)
        except ValueError:
            count += 1
        else:
            raise AssertionError("untrue 20020406 ledger/source passed")
    damaged = bytearray(ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        validate_archive(rows, bytes(damaged))
    except ValueError:
        count += 1
    else:
        raise AssertionError("damaged 20020406 archive accepted")
    print("PASS: original 20020406 two malloc link failures, six real "
          "native recursive-swap guests, 30 raw artifacts, %d negative controls" %
          count)


if __name__ == "__main__":
    main()
