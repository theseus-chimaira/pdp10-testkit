#!/usr/bin/env python3
"""Pin real 960521 large-allocation timeouts and bounded pointer oracle.

The unchanged original's two 32768-word allocations do not fit a
complete bare PDP-6 program.  A separate native 4096-word-per-array
C89 test checks the shifted pointer, all stores and two guard words.
This covers compiler pointer semantics, not malloc or memory pressure.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = "tests/todo/generic/960521-1.c"
ORIGINAL_SHA = "e3fe6e96cbd7d6334c99fc332c1e3f689ca9ee1e6de498b3892c71160002ade7"
COMPANION = "tests/semantic/regression/pdp10-shifted-array-boundary-v1.c"
COMPANION_SHA = "661419efb39603fb257fe2d9760c8e4ccb30dd45ffea2f64275114a6f35a5b04"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v18.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
MANIFEST = ROOT / "manifests/PDP10-P1-960521-SHIFTED-ARRAY-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-960521-shifted-array-20261120-v1.tar.gz"
PROFILES = (
    ("original", "kcc-pdp6-noopt", "timeout"),
    ("original", "gcc-pdp6-o0", "timeout"),
    ("companion", "kcc-pdp6-noopt", "pass"),
    ("companion", "kcc-pdp6-opt", "pass"),
    ("companion", "gcc-pdp6-o0", "pass"),
    ("companion", "gcc-pdp6-o1", "pass"),
    ("companion", "gcc-pdp6-o2", "pass"),
    ("companion", "gcc-pdp6-os", "pass"),
)
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "report_member", "report_sha256", "map_member", "map_sha256",
          "asm_member", "asm_sha256")


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def check_source(path, digest, phrases):
    source = ROOT / path
    if (not source.is_file() or
            hashlib.sha256(source.read_bytes()).hexdigest() != digest):
        raise ValueError("original/companion source changed: " + path)
    text = source.read_text(encoding="ascii")
    for phrase in phrases:
        if phrase not in text:
            raise ValueError("original or companion assertion missing: " + phrase)
    return text


def validate(rows, matrix, previous):
    if len(rows) != 8 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("two original timeouts and six companion passes required")
    check_source(ORIGINAL, ORIGINAL_SHA, (
        "#define BLOCK_SIZE 32768", "a = malloc (n * sizeof(*a));",
        "b = malloc (n * sizeof(*b));", "*b++ = 0;", "foo ();",
        "for (i = 0; i < n; i++)", "for (i = 0; i < BLOCK_SIZE - 1; i++)",
        "if (b[-1])", "abort ();", "exit (0);"))
    check_source(COMPANION, COMPANION_SHA, (
        "#define P10_BLOCK_WORDS_V1 4096", "volatile int data[P10_BLOCK_WORDS_V1]",
        "b_v1 = b_storage_v1.data;", "*b_v1++ = 0;", "fill_v1();",
        "for (i = 0; i < n_v1; i++)", "a_v1[i] = -1;",
        "for (i = 0; i < P10_BLOCK_WORDS_V1 - 1; i++)",
        "b_v1[i] = -1;", "b_v1[-1] != 0", "b_storage_v1.data[0] != 0",
        "b_storage_v1.before != P10_LEFT_GUARD_V1",
        "b_storage_v1.after != P10_RIGHT_GUARD_V1",
        "a_storage_v1[i] != -1", "b_storage_v1.data[i + 1] != -1",
        "return 0;"))
    old = [r for r in previous if r["original_source"] == ORIGINAL]
    if (len(old) != 1 or old[0]["p1_state"] != "blocked" or
            old[0]["original_sha256"] != ORIGINAL_SHA or
            old[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("previous original P1 blocker changed unexpectedly")
    orig = [r for r in matrix if r["test"] == ORIGINAL]
    comp = [r for r in matrix if r["test"] == COMPANION]
    if (len(orig) != 1 or len(comp) != 1 or
            orig[0]["group"] != "semantic-upstream-deferred" or
            comp[0]["group"] != "semantic-regression" or
            orig[0]["pdp6"] != "semantic" or
            orig[0]["pdp6_gcc_o0"] != "semantic" or
            comp[0]["pdp6"] != "semantic" or
            any(comp[0]["pdp6_gcc_" + opt] != "semantic"
                for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("original or companion missing normal matrix cells")
    for row, (role, profile, status) in zip(rows, PROFILES):
        path = ORIGINAL if role == "original" else COMPANION
        digest = ORIGINAL_SHA if role == "original" else COMPANION_SHA
        stem = role + "/pdp6/" + profile
        if (row["role"] != role or row["source"] != path or
                row["source_sha256"] != digest or row["profile"] != profile or
                row["cpu"] != "pdp6" or row["status"] != status or
                row["report_member"] != stem + ".report.txt" or
                row["map_member"] != stem + ".map" or
                row["asm_member"] != stem + ".s" or
                any(re.fullmatch(r"[0-9a-f]{64}", row[k]) is None for k in
                    ("report_sha256", "map_sha256", "asm_sha256"))):
            raise ValueError("source/profile/result evidence is not pinned")


def validate_archive(rows, payload):
    names = {r[k] for r in rows for k in
             ("report_member", "map_member", "asm_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
            members = archive.getmembers()
            if (len(members) != 24 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("missing or unsafe 960521 compiler evidence")
            for row in rows:
                evidence = {}
                for kind in ("report", "map", "asm"):
                    stream = archive.extractfile(row[kind + "_member"])
                    if stream is None:
                        raise ValueError("missing compiler output artifact")
                    data = stream.read()
                    if hashlib.sha256(data).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("compiler output digest differs")
                    evidence[kind] = data.decode("utf-8", "replace")
                report = evidence["report"]
                if row["status"] == "timeout":
                    if (re.search(r"^rc=124$", report, re.M) is None or
                            re.search(r"^result=FAIL$", report, re.M) is None or
                            "HALT instruction" in report or
                            "__P10RUN_EXPECT__" in report):
                        raise ValueError("original timeout was silently promoted")
                    symbols = ("foo", "malloc", "main", "abort", "exit")
                else:
                    if (re.search(r"^rc=0$", report, re.M) is None or
                            re.search(r"^result=PASS$", report, re.M) is None or
                            "HALT instruction" not in report or
                            re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                      r"[^\n]+\t000000000000\b", report) is None):
                        raise ValueError("companion did not complete its oracle")
                    symbols = ("main", "abort", "exit")
                for symbol in symbols:
                    if re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                 evidence["map"], re.M) is None:
                        raise ValueError("missing genuine linked runtime symbol " + symbol)
                if "main:" not in evidence["asm"]:
                    raise ValueError("generated C compiler body not present")
                if row["role"] == "companion":
                    for symbol in ("a_storage_v1:", "b_storage_v1:"):
                        if symbol not in evidence["asm"]:
                            raise ValueError("static native array missing from assembly")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt compressed original/companion evidence") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    print("PASS: 960521 unchanged original 2 real timeouts; native pointer "
          "boundary companion 6 guest PASS and 24 SHA-pinned outputs")


if __name__ == "__main__":
    audit()
