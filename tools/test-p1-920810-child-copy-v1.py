#!/usr/bin/env python3
"""Verify original 920810 malloc failures and real child-copy PDP-6 guests.

Only compiler-owned libc is accepted.  Eight exact original/companion
outcomes, original source identities and 30 raw outputs are pinned.
This audit does not execute a compiler or CPU sweep.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = "tests/todo/generic/920810-1.c"
COMPANION = "tests/semantic/regression/pdp10-memcpy-child-inheritance-v1.c"
ORIGINAL_SHA = "23405fde00c057160ef5881b0561d2e5921be68a07cb11f7b2f2e6e66952dbb5"
COMPANION_SHA = "005d0573c2ad44d4881211a1c8b340b04cc4482e9c042d363f73e38a832e6a77"
LIBRARY_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
MANIFEST = ROOT / "docs/PDP10-P1-920810-CHILD-COPY-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-920810-child-copy-20261120-v1.tar.gz"
PREVIOUS = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v21.tsv"
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
    with path.open(encoding="ascii", newline="") as source:
        return list(csv.DictReader(
            (line for line in source if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def check_source(name, digest, phrases):
    source = ROOT / name
    if not source.is_file() or hashlib.sha256(source.read_bytes()).hexdigest() != digest:
        raise ValueError("920810 original or compiler companion changed")
    contents = source.read_text(encoding="ascii")
    for phrase in phrases:
        if phrase not in contents:
            raise ValueError("missing 920810 assertion or original operation: " + phrase)


def validate(rows, matrix, previous):
    if len(rows) != 8 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("920810 needs two failed original links and six real guests")
    check_source(ORIGINAL, ORIGINAL_SHA, (
        "t*child=(t*)malloc(size);", "memcpy(child,clas,clas->size);",
        "child->super=clas;", "child->name=0;", "child->size=size;",
        "memset(&foo,37,sizeof(t));", "bar=f(&foo,sizeof(t));",
        "if(bar->super!=&foo||bar->name!=0||bar->size!=sizeof(t))abort();"))
    check_source(COMPANION, COMPANION_SHA, (
        "#include <string.h>", "void *super;", "int name;", "int size;",
        "memcpy(child, clas, clas->size);",
        "memset(&foo, P10_CHILD_BYTE_V1, sizeof(t));",
        "CHECK_V1(child->super == clas->super, 1)",
        "CHECK_V1(child->name == clas->name, 2)",
        "CHECK_V1(child->size == clas->size, 3)",
        "CHECK_V1(foo.name == P10_CHILD_PATTERN_V1, 7)",
        "child->super = clas;", "child->name = 0;", "child->size = size;",
        "CHECK_V1(bar->super == &foo, 10)",
        "CHECK_V1(bar->name == 0, 11)",
        "CHECK_V1(bar->size == sizeof(t), 12)",
        "CHECK_V1(foo.name == P10_CHILD_PATTERN_V1, 14)",
        "CHECK_V1(storage_v1.before == P10_CHILD_LEFT_V1, 16)",
        "CHECK_V1(storage_v1.after == P10_CHILD_RIGHT_V1, 17)",
        "return 0;"))
    original = [row for row in previous if row["original_source"] == ORIGINAL]
    if (len(original) != 1 or original[0]["p1_state"] != "blocked" or
            original[0]["original_sha256"] != ORIGINAL_SHA or
            original[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("920810 original hosted malloc obligation lost")
    orig = [row for row in matrix if row["test"] == ORIGINAL]
    comp = [row for row in matrix if row["test"] == COMPANION]
    if (len(orig) != 1 or len(comp) != 1 or
            orig[0]["group"] != "semantic-upstream-deferred" or
            comp[0]["group"] != "semantic-regression" or
            orig[0]["pdp6"] != "semantic" or
            comp[0]["pdp6"] != "semantic" or
            any(comp[0]["pdp6_gcc_" + x] != "semantic" for x in
                ("o0", "o1", "o2", "os"))):
        raise ValueError("920810 compiler cell ownership changed")
    for row, (role, profile, status) in zip(rows, PROFILES):
        source = ORIGINAL if role == "original" else COMPANION
        prefix = role + "/pdp6/" + profile
        expected = {
            "role": role, "source": source,
            "source_sha256": ORIGINAL_SHA if role == "original" else COMPANION_SHA,
            "profile": profile, "cpu": "pdp6", "status": status,
            "report_member": prefix + ".report.txt",
            "map_member": prefix + ".map" if role == "companion" else "",
            "asm_member": prefix + ".s", "status_member": prefix + ".status",
            "map_sha256": row["map_sha256"] if role == "companion" else "",
        }
        if any(row[key] != val for key, val in expected.items()):
            raise ValueError("920810 original source/profile/result changed")
        for kind in ("report", "asm", "status") + (("map",) if role == "companion" else ()):
            if re.fullmatch(r"[0-9a-f]{64}", row[kind + "_sha256"]) is None:
                raise ValueError("920810 SHA256 evidence identity changed")


def validate_archive(rows, payload):
    names = {r[k] for r in rows for k in
             ("report_member", "map_member", "asm_member", "status_member") if r[k]}
    if len(names) != 30:
        raise ValueError("920810 guest output evidence is incomplete")
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 30 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("920810 guest evidence archive missing outputs")
            for row in rows:
                content = {}
                for kind in ("report", "map", "asm", "status"):
                    member = row[kind + "_member"]
                    if not member:
                        continue
                    stream = archive.extractfile(member)
                    if stream is None:
                        raise ValueError("920810 guest output missing")
                    data = stream.read()
                    if hashlib.sha256(data).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("920810 guest archive sha mismatch")
                    content[kind] = data.decode("utf-8", "replace")
                stamp = content["status"]
                if ("profile=" + row["profile"] + "\n" not in stamp or
                        "status=" + row["status"] + "\n" not in stamp or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in stamp or
                        "runtime_library_sha256=" + LIBRARY_SHA + "\n" not in stamp):
                    raise ValueError("920810 guest linked noncompiler libc")
                if "main:" not in content["asm"]:
                    raise ValueError("920810 compiler assembly missing")
                report = content["report"]
                if row["role"] == "original":
                    if ("dlink: undefined symbol: malloc" not in report or
                            "p10run: link failed" not in report or
                            "runtime_library_policy=compiler-stdlib-v1" not in report):
                        raise ValueError("920810 original malloc failure hidden")
                else:
                    if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                            "result=PASS\n" not in report or
                            "HALT instruction" not in report):
                        raise ValueError("920810 actual PDP-6 guest did not pass")
                    for name in ("__test_exit", "fail_id"):
                        match = re.search(r"__P10RUN_EXPECT__ " + name +
                                          r" [0-7]+ 000000000000\s*\n"
                                          r"[0-7]+:\s*([0-7]{12})", report)
                        if not match or int(match.group(1), 8) != 0:
                            raise ValueError("920810 guest assertion was not zero")
                    for sym in ("main", "memset", "memcpy", "exit", "abort", "fail_id"):
                        if re.search(r"^" + sym + r"\s+[0-7]+\s*$",
                                     content["map"], re.M) is None:
                            raise ValueError("920810 real compiler libc symbol missing " + sym)
                    if not re.search(r"(?i)pushj\s+17,memcpy", content["asm"]):
                        raise ValueError("920810 real memcpy call optimized away")
                    if not re.search(r"(?i)pushj\s+17,memset", content["asm"]):
                        raise ValueError("920810 real memset call optimized away")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("920810 raw evidence archive corrupt") from error


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
    raise AssertionError("bad 920810 source/profile accepted")


def main():
    rows = audit()
    matrix = read(MATRIX, True)
    previous = read(PREVIOUS)
    count = 0
    for field, value in (("source_sha256", "0" * 64),
                         ("profile", "gcc-ki10-o0"),
                         ("status", "run_fail"),
                         ("role", "original"),
                         ("asm_member", "fake.s"),
                         ("report_sha256", "bad"),
                         ("map_sha256", "bad")):
        altered = [dict(r) for r in rows]
        altered[4][field] = value
        reject(altered, matrix, previous)
        count += 1
    reject(rows[:-1], matrix, previous)
    count += 1
    changed_matrix = [dict(r) for r in matrix]
    for row in changed_matrix:
        if row["test"] == COMPANION:
            row["pdp6_gcc_o2"] = "no_test"
    reject(rows, changed_matrix, previous)
    count += 1
    changed_previous = [dict(r) for r in previous]
    for row in changed_previous:
        if row["original_source"] == ORIGINAL:
            row["p1_state"] = "covered"
    reject(rows, matrix, changed_previous)
    count += 1
    damaged = bytearray(ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        validate_archive(rows, bytes(damaged))
    except ValueError:
        count += 1
    else:
        raise AssertionError("mutated 920810 raw guest archive accepted")
    print("PASS: original 920810 two compiler malloc link failures, "
          "six genuine PDP-6 memcpy/memset child guests, 30 artifacts, "
          "%d negative controls" % count)


if __name__ == "__main__":
    main()
