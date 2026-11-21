#!/usr/bin/env python3
"""Check the real PDP-6 va-arg-21/va_end compiler-oracle evidence.

The original is unmodified; its hosted malloc/vprintf requirements
must not be replaced. The companion uses real installed stdarg.h,
and the KCC macro discards the va_end argument's pointer side effect.
This verifier never invokes a compiler, linker or emulator.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = "tests/semantic/upstream/extensions/va-arg-21.c"
COMPANION = "tests/semantic/regression/pdp10-vaend-pointer-sideeffect-v1.c"
ORIGINAL_SHA = "dedc44188f3fd1c561cd63e1d964c7f0beb5c077b4802c961b0eb7f4a6c7fbd9"
COMPANION_SHA = "b117d54a8dbc8ffbed6be25e8c841a9c7f9d9edf25ad47ccb5014ceb4b0aa4c8"
LIB_SHA = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
KCC_HEADER_SHA = "99d3e321cd11dc44db2545be9c5b12f0336dcb12e002b0b504904a7e3723de42"
GCC_HEADER_SHA = "a43e740c99baa8b131033c467cbef49ebbf86761df76de321c0b23d893af1901"
MANIFEST = ROOT / "manifests/PDP10-P1-VAARG21-VAEND-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-vaarg21-vaend-20261120-v1.tar.gz"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v24.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
KINDS = ("log", "status", "asm", "map", "report")
EXT = {"log": ".log.txt", "status": ".status", "asm": ".s",
       "map": ".map", "report": ".report.txt"}
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "fail_id") + tuple(key for kind in KINDS for key in
                             (kind + "_member", kind + "_sha256"))
PROFILES = (
    ("original", "kcc-pdp6-noopt", "link_fail", "-"),
    ("original", "gcc-pdp6-o0", "link_fail", "-"),
    ("companion", "kcc-pdp6-noopt", "run_fail", "4"),
    ("companion", "kcc-pdp6-opt", "run_fail", "4"),
    ("companion", "gcc-pdp6-o0", "pass", "0"),
    ("companion", "gcc-pdp6-o1", "pass", "0"),
    ("companion", "gcc-pdp6-o2", "pass", "0"),
    ("companion", "gcc-pdp6-os", "pass", "0"),
)


def read_tsv(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader((line for line in stream if line.strip() and
                                   (not comments or not line.startswith("#"))),
                                   delimiter="\t"))


def require_source(path, digest, phrases):
    source = ROOT / path
    if not source.is_file() or hashlib.sha256(source.read_bytes()).hexdigest() != digest:
        raise ValueError("P1 va-arg-21 original or compiler companion modified")
    text = source.read_text(encoding="ascii")
    for phrase in phrases:
        if phrase not in text:
            raise ValueError("P1 va_end source assertion missing: " + phrase)


def validate_rows(rows, matrix, previous):
    if len(rows) != 8 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("va-arg-21 must preserve eight exact compiler cells")
    require_source(ORIGINAL, ORIGINAL_SHA, (
        "#include <stdarg.h>", "#include <stdio.h>", "#include <stdlib.h>",
        "va_list *ap_array[3], **ap_ptr = ap_array;",
        "ap_array[0] = malloc (sizeof(va_list));",
        "ap_array[1] = NULL;", "ap_array[2] = malloc (sizeof(va_list));",
        "va_start (*ap_array[0], s);", "vprintf (s, **ap_ptr);",
        "va_end (**ap_ptr++);", "ap_ptr++;", "va_start (*ap_array[2], s);",
        "if (*ap_ptr == 0)", "doit (\"%s\", \"hello world\\n\");"))
    require_source(COMPANION, COMPANION_SHA, (
        "#include <stdarg.h>", "va_list first_v1;", "va_list third_v1;",
        "va_list *ap_array[3];", "va_list **ap_ptr = ap_array;",
        "ap_array[0] = &first_v1;", "ap_array[1] = (va_list *)0;",
        "ap_array[2] = &third_v1;", "va_start(*ap_array[0], marker);",
        "va_arg(**ap_ptr, int);", "va_end(**ap_ptr++);",
        "CHECK_V1(ap_ptr == &ap_array[1], 4);", "ap_ptr++;",
        "CHECK_V1(ap_ptr == &ap_array[2], 5);",
        "va_start(*ap_array[2], marker);", "va_end(**ap_ptr);",
        "CHECK_V1(a == 012345, 7);", "CHECK_V1(b == 07654, 8);",
        "CHECK_V1(ap_array[1] == (va_list *)0, 11);", "return 0;"))
    entry = [r for r in previous if r["original_source"] == ORIGINAL]
    if (len(entry) != 1 or entry[0]["p1_state"] != "blocked" or
            entry[0]["original_sha256"] != ORIGINAL_SHA or
            entry[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("original va-arg-21 runtime obligations disappeared")
    orig = [r for r in matrix if r["test"] == ORIGINAL]
    comp = [r for r in matrix if r["test"] == COMPANION]
    if (len(orig) != 1 or len(comp) != 1 or
            orig[0]["group"] != "semantic-upstream-deferred" or
            comp[0]["group"] != "semantic-regression" or
            orig[0]["pdp6"] != "semantic" or comp[0]["pdp6"] != "semantic" or
            any(comp[0]["pdp6_gcc_" + opt] != "semantic" for opt in
                ("o0", "o1", "o2", "os"))):
        raise ValueError("va-arg-21 matrix cell registration changed")
    for row, (role, profile, status, fail_id) in zip(rows, PROFILES):
        prefix = role + "/pdp6/" + profile
        expected = {
            "role": role, "source": ORIGINAL if role == "original" else COMPANION,
            "source_sha256": ORIGINAL_SHA if role == "original" else COMPANION_SHA,
            "profile": profile, "cpu": "pdp6", "status": status,
            "fail_id": fail_id,
        }
        for kind in KINDS:
            exists = role == "companion" or kind in ("log", "status", "asm")
            expected[kind + "_member"] = prefix + EXT[kind] if exists else "-"
            if not exists:
                expected[kind + "_sha256"] = "-"
        if any(row[key] != value for key, value in expected.items()):
            raise ValueError("va-arg-21 source/profile/outcome changed: " + profile)
        for kind in KINDS:
            if row[kind + "_member"] != "-" and not re.fullmatch(
                    r"[0-9a-f]{64}", row[kind + "_sha256"]):
                raise ValueError("va-arg-21 evidence SHA256 malformed")


def expected_word(report, symbol):
    match = re.search(r"__P10RUN_EXPECT__ " + re.escape(symbol) +
                      r" [0-7]+ 000000000000\s*\n[0-7]+:\s*([0-7]{12})", report)
    if match is None:
        raise ValueError("va-arg-21 actual PDP-6 result word not present")
    return int(match.group(1), 8)


def validate_archive(rows, raw):
    names = {row[kind + "_member"] for row in rows for kind in KINDS
             if row[kind + "_member"] != "-"}
    names.update(("headers/kcc-stdarg.h", "headers/gcc-stdarg.h"))
    if len(names) != 38:
        raise ValueError("va-arg-21 evidence requires 38 authentic artifacts")
    try:
        with tarfile.open(fileobj=io.BytesIO(raw), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 38 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("va-arg-21 evidence archive membership invalid")

            def get(name):
                source = tar.extractfile(name)
                if source is None:
                    raise ValueError("va-arg-21 evidence member missing: " + name)
                return source.read()

            kcc = get("headers/kcc-stdarg.h")
            gcc = get("headers/gcc-stdarg.h")
            if (hashlib.sha256(kcc).hexdigest() != KCC_HEADER_SHA or
                    hashlib.sha256(gcc).hexdigest() != GCC_HEADER_SHA or
                    b"#define va_end(ap) ((void)0)" not in kcc or
                    b"#define va_end\t\t__builtin_va_end" not in gcc):
                raise ValueError("va-arg-21 compiler header provenance invalid")
            for row in rows:
                data = {}
                for kind in KINDS:
                    member = row[kind + "_member"]
                    if member == "-":
                        continue
                    content = get(member)
                    if hashlib.sha256(content).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("va-arg-21 raw result altered: " + member)
                    data[kind] = content.decode("utf-8", "replace")
                status = data["status"]
                if ("profile=" + row["profile"] + "\n" not in status or
                        "status=" + row["status"] + "\n" not in status or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in status or
                        "runtime_library_sha256=" + LIB_SHA + "\n" not in status):
                    raise ValueError("va-arg-21 result used incorrect target libc")
                if "main:" not in data["asm"]:
                    raise ValueError("va-arg-21 compiler assembly lacks main")
                if row["role"] == "original":
                    missing = ("vprintf" if row["profile"].startswith("kcc")
                               else "malloc")
                    if ("dlink: undefined symbol: " + missing not in data["log"] or
                            "p10run: link failed" not in data["log"]):
                        raise ValueError("va-arg-21 original hosted link failure hidden")
                else:
                    report = data["report"]
                    if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                            "HALT instruction" not in report or
                            "result=" + ("FAIL" if row["status"] == "run_fail"
                                         else "PASS") + "\n" not in report):
                        raise ValueError("va-arg-21 native SIMH result incorrect")
                    if (expected_word(report, "fail_id") != int(row["fail_id"]) or
                            expected_word(report, "__test_exit") !=
                            int(row["status"] == "run_fail")):
                        raise ValueError("va-arg-21 actual assertion value changed")
                    for name in ("main", "fail_id", "abort", "exit"):
                        if re.search(r"^" + name + r"\s+[0-7]+\s*$",
                                     data["map"], re.M) is None:
                            raise ValueError("va-arg-21 linked symbol missing: " + name)
                    if "check_va_end_v1:" not in data["asm"]:
                        raise ValueError("va-arg-21 actual va_end test code missing")
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("va-arg-21 evidence tarball cannot be read") from exc


def audit():
    rows = read_tsv(MANIFEST)
    validate_rows(rows, read_tsv(MATRIX, True), read_tsv(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    return rows


def main():
    rows = audit()
    matrix = read_tsv(MATRIX, True)
    previous = read_tsv(PREVIOUS)
    failures = 0
    for field, val in (("role", "original"), ("status", "pass"),
                       ("fail_id", "0"), ("profile", "gcc-pdp6-o0"),
                       ("source_sha256", "0" * 64),
                       ("report_sha256", "bad"), ("report_member", "fake")):
        clone = [dict(r) for r in rows]
        clone[2][field] = val
        try:
            validate_rows(clone, matrix, previous)
        except ValueError:
            failures += 1
        else:
            raise AssertionError("altered KCC va_end failure accepted: " + field)
    for altered, mx, prev in ((rows[:-1], matrix, previous),
                              (rows, [dict(r) for r in matrix], previous),
                              (rows, matrix, [dict(r) for r in previous])):
        if mx is not matrix:
            for r in mx:
                if r["test"] == COMPANION:
                    r["pdp6_gcc_o2"] = "no_test"
        if prev is not previous:
            for r in prev:
                if r["original_source"] == ORIGINAL:
                    r["p1_state"] = "covered"
        try:
            validate_rows(altered, mx, prev)
        except ValueError:
            failures += 1
        else:
            raise AssertionError("incorrect va_end ledger/matrix accepted")
    damaged = bytearray(ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        validate_archive(rows, bytes(damaged))
    except ValueError:
        failures += 1
    else:
        raise AssertionError("corrupt va_end raw archive accepted")
    print("PASS: unchanged va-arg-21 two hosted link_fail, "
          "native GCC 4 PASS/KCC 2 run_fail ID 4, "
          "38 artifacts and %d negative controls" % failures)


if __name__ == "__main__":
    main()
