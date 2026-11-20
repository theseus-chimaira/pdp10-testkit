#!/usr/bin/env python3
"""Validate real PDP-6 990628 compiler-record-copy oracle evidence.

The unchanged original still times out with malloc linked. The new
fixture uses native static storage and a genuine linked memset while
checking the original struct assignment and fetch-loop semantics.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = "tests/todo/generic/990628-1.c"
ORIGINAL_SHA = "eae56aa6d888dbdab7d545d7146e40153a3fd5a2663e741c97a9cf6a2bae212c"
COMPANION = "tests/semantic/regression/pdp10-record-fetch-copy-v1.c"
COMPANION_SHA = "1b1ec7a6e10d90916748dd17ccc06d0e3331bc220db66fe018389a1bf33ea486"
PREVIOUS = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v19.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
MANIFEST = ROOT / "docs/PDP10-P1-990628-RECORD-COPY-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-990628-record-copy-20261120-v1.tar.gz"
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
        raise ValueError("990628 historical/companion source hash changed")
    data = source.read_text(encoding="ascii")
    for phrase in phrases:
        if phrase not in data:
            raise ValueError("990628 assertion/oracle phrase missing: " + phrase)


def validate(rows, matrix, history):
    if len(rows) != 8 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("990628 guest evidence needs 2 timeouts + 6 passes")
    check_source(ORIGINAL, ORIGINAL_SHA, (
        "int a[100];", "malloc(num * sizeof(struct data_record))",
        "memset(&data_tmp, 0x55, sizeof(data_tmp))",
        "memset(data_ptr, 0xaa, num * sizeof(struct data_record))",
        "*p++ = data_tmp;", "sqlca.sqlcode == 0",
        "data_ptr[0].dummy != 0x55 * 01001001001", "abort ();"))
    check_source(COMPANION, COMPANION_SHA, (
        "#define P10_RECORD_WORDS_V1 100", "#define P10_BYTE_PATTERN_V1",
        "struct p10_record_v1 {", "int a[P10_RECORD_WORDS_V1];",
        "data_ptr_v1 = &dest_v1.record;",
        "memset(&data_tmp_v1, 0x55, sizeof(data_tmp_v1));",
        "memset(data_ptr_v1, 0xaa, sizeof(*data_ptr_v1));",
        "*p++ = data_tmp_v1;", "sqlca_v1.sqlcode == 0",
        "sizeof(struct p10_record_v1) != 404",
        "fetch_count_v1 != 2", "store_count_v1 != 1",
        "dest_v1.record.dummy != P10_BYTE_PATTERN_V1",
        "dest_v1.record.a[i] != P10_BYTE_PATTERN_V1",
        "data_tmp_v1.a[i] != P10_BYTE_PATTERN_V1",
        "dest_v1.before != P10_RECORD_LEFT_V1",
        "dest_v1.after != P10_RECORD_RIGHT_V1", "return 0;"))
    historic = [row for row in history if row["original_source"] == ORIGINAL]
    if (len(historic) != 1 or historic[0]["p1_state"] != "blocked" or
            historic[0]["original_sha256"] != ORIGINAL_SHA or
            historic[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("original 990628 still needs live hosted work")
    original_rows = [row for row in matrix if row["test"] == ORIGINAL]
    companion_rows = [row for row in matrix if row["test"] == COMPANION]
    if (len(original_rows) != 1 or len(companion_rows) != 1 or
            original_rows[0]["group"] != "semantic-upstream-deferred" or
            companion_rows[0]["group"] != "semantic-regression" or
            original_rows[0]["pdp6"] != "semantic" or
            original_rows[0]["pdp6_gcc_o0"] != "semantic" or
            companion_rows[0]["pdp6"] != "semantic" or
            any(companion_rows[0]["pdp6_gcc_" + opt] != "semantic"
                for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("990628 source or companion not registered")
    for row, (role, profile, status) in zip(rows, PROFILES):
        path = ORIGINAL if role == "original" else COMPANION
        digest = ORIGINAL_SHA if role == "original" else COMPANION_SHA
        prefix = role + "/pdp6/" + profile
        if (row["role"] != role or row["source"] != path or
                row["source_sha256"] != digest or row["profile"] != profile or
                row["cpu"] != "pdp6" or row["status"] != status or
                row["report_member"] != prefix + ".report.txt" or
                row["map_member"] != prefix + ".map" or
                row["asm_member"] != prefix + ".s" or
                any(re.fullmatch(r"[0-9a-f]{64}", row[k]) is None for k in
                    ("report_sha256", "map_sha256", "asm_sha256"))):
            raise ValueError("990628 source/profile/success evidence changed")


def validate_archive(rows, payload):
    expected = {r[k] for r in rows for k in
                ("report_member", "map_member", "asm_member")}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as tar:
            entries = tar.getmembers()
            if (len(entries) != 24 or {e.name for e in entries} != expected or
                    any(not e.isfile() for e in entries)):
                raise ValueError("missing or unsafe 990628 archived output")
            for row in rows:
                result = {}
                for kind in ("report", "map", "asm"):
                    stream = tar.extractfile(row[kind + "_member"])
                    if stream is None:
                        raise ValueError("missing 990628 raw artifact")
                    data = stream.read()
                    if hashlib.sha256(data).hexdigest() != row[kind + "_sha256"]:
                        raise ValueError("990628 raw artifact SHA mismatch")
                    result[kind] = data.decode("utf-8", "replace")
                report = result["report"]
                if row["status"] == "timeout":
                    if (re.search(r"^rc=124$", report, re.M) is None or
                            re.search(r"^result=FAIL$", report, re.M) is None or
                            "HALT instruction" in report):
                        raise ValueError("990628 original timeout silently passed")
                    symbols = ("main", "fetch", "load_data", "malloc",
                               "memset", "abort", "exit")
                else:
                    if (re.search(r"^rc=0$", report, re.M) is None or
                            re.search(r"^result=PASS$", report, re.M) is None or
                            "HALT instruction" not in report or
                            "__P10RUN_EXPECT__ __test_exit" not in report):
                        raise ValueError("990628 companion lacks guest PASS")
                    symbols = ("main", "memset", "abort", "exit")
                for sym in symbols:
                    if re.search(r"^" + sym + r"\s+[0-7]+\s*$",
                                 result["map"], re.M) is None:
                        raise ValueError("missing 990628 real linker symbol " + sym)
                if "main:" not in result["asm"] or "memset" not in result["asm"]:
                    raise ValueError("990628 compiler assembly not present")
                if row["role"] == "companion":
                    for sym in ("data_tmp_v1:", "dest_v1:"):
                        if sym not in result["asm"]:
                            raise ValueError("native record buffer not emitted")
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("990628 compressed archive corrupt") from exc


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    print("PASS: original 990628 two linked-malloc timeouts; six genuine "
          "PDP-6 struct-copy/memset guest passes, 24 SHA-pinned outputs")


if __name__ == "__main__":
    audit()
