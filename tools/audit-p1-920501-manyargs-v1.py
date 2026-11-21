#!/usr/bin/env python3
"""Verify real 920501-8 and freestanding many-argument failure evidence.

The full original requires hosted printf and times out or link-fails.
The source-specific companion executes all thirteen va_arg integer checks,
then reaches a real sprintf failure at default-precision %f.  Failure is
preserved as run_fail with a distinct exit code, not called a PASS.
"""

import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = "tests/todo/generic/920501-8.c"
ORIGINAL_SHA = "21884df76c9d24d4d4808d78de8e8a4e7909fffd1ee26a72f96f4be00a22b56a"
COMPANION = "tests/semantic/regression/pdp10-variadic-manyargs-sprintf-v1.c"
COMPANION_SHA = "3c0ca71e69bf55d9b13c9eff2715b856c8819a3e77a01ecfe730ab01fd4614d6"
PREVIOUS = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v17.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
MANIFEST = ROOT / "manifests/PDP10-P1-920501-MANYARGS-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-920501-manyargs-20261120-v1.tar.gz"
PROFILES = (
    ("original", "kcc-pdp6-noopt", "timeout"),
    ("original", "gcc-pdp6-o0", "link_fail"),
    ("companion", "kcc-pdp6-noopt", "run_fail"),
    ("companion", "kcc-pdp6-opt", "run_fail"),
    ("companion", "gcc-pdp6-o0", "run_fail"),
    ("companion", "gcc-pdp6-o1", "run_fail"),
    ("companion", "gcc-pdp6-o2", "run_fail"),
    ("companion", "gcc-pdp6-os", "run_fail"),
)
FIELDS = ("role", "source", "source_sha256", "profile", "status",
          "artifact_member", "artifact_sha256", "map_member", "map_sha256",
          "asm_member", "asm_sha256")


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream if line.strip() and
             (not comments or not line.startswith("#"))), delimiter="\t"))


def source_check(path, digest, phrases):
    source = ROOT / path
    if (not source.is_file() or
            hashlib.sha256(source.read_bytes()).hexdigest() != digest):
        raise ValueError("modified original/companion bytes: " + path)
    text = source.read_text(encoding="ascii")
    for phrase in phrases:
        if phrase not in text:
            raise ValueError("missing exact assertion or ABI action: " + phrase)
    return text


def validate(rows, matrix, previous):
    if len(rows) != 8 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("8 original/companion outcomes required")
    source_check(ORIGINAL, ORIGINAL_SHA,
                 ("#include <stdio.h>", "#include <stdarg.h>",
                  "va_start (ap, c);", "va_end (ap);", "va_arg (ap, int)",
                  "printf (", "sprintf (buf,", "strcmp (", "abort();"))
    companion = source_check(COMPANION, COMPANION_SHA,
                             ("#include <stdio.h>", "#include <stdarg.h>",
                              "va_start(args, third);", "va_end(args);",
                              "values[i] = va_arg(args, int)",
                              "values[i] != i + 3", "exit(20 + i);",
                              "length = sprintf(buffer_v1,",
                              "\"%d,%f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\"",
                              "1,1.000000,2,3,4,5,6,7,8,9,10,11,12,13,14,15",
                              "if (length < 0)", "exit(41);",
                              "buffer_v1[i] != expected_v1[i]", "length != i",
                              "!= 120", "return 0;"))
    if companion.count("values[i] = va_arg(args, int)") != 1:
        raise ValueError("all thirteen va_arg reads must be in bounded loop")
    matched = [r for r in previous if r["original_source"] == ORIGINAL]
    if (len(matched) != 1 or matched[0]["p1_state"] != "blocked" or
            matched[0]["original_sha256"] != ORIGINAL_SHA):
        raise ValueError("previous blocked original has been weakened")
    originals = [r for r in matrix if r["test"] == ORIGINAL]
    companions = [r for r in matrix if r["test"] == COMPANION]
    if (len(originals) != 1 or len(companions) != 1 or
            originals[0]["group"] != "semantic-upstream-deferred" or
            companions[0]["group"] != "semantic-regression" or
            originals[0]["pdp6"] not in ("semantic", "pending") or
            originals[0]["pdp6_gcc_o0"] not in ("semantic", "pending") or
            companions[0]["pdp6"] != "semantic" or
            any(companions[0]["pdp6_gcc_" + opt] != "semantic"
                for opt in ("o0", "o1", "o2", "os"))):
        raise ValueError("missing active original or source-specific companion")
    for row, (role, profile, status) in zip(rows, PROFILES):
        prefix = role + "/pdp6/" + profile
        source = ORIGINAL if role == "original" else COMPANION
        sha = ORIGINAL_SHA if role == "original" else COMPANION_SHA
        suffix = ".cell.log" if status == "link_fail" else ".report.txt"
        map_member = "-" if status == "link_fail" else prefix + ".map"
        if (row["role"] != role or row["source"] != source or
                row["source_sha256"] != sha or row["profile"] != profile or
                row["status"] != status or
                row["artifact_member"] != prefix + suffix or
                row["map_member"] != map_member or
                row["asm_member"] != prefix + ".s" or
                (status == "link_fail" and row["map_sha256"] != "-") or
                any(re.fullmatch("[0-9a-f]{64}", row[k]) is None
                    for k in ("artifact_sha256", "asm_sha256") +
                    (() if status == "link_fail" else ("map_sha256",)))):
            raise ValueError("incorrect source, outcome, or archived output")


def validate_archive(rows, payload):
    names = {r[k] for r in rows for k in
             ("artifact_member", "map_member", "asm_member") if r[k] != "-"}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 23 or
                    {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("incomplete original/guest/assembler evidence")
            for row in rows:
                data = {}
                for field in ("artifact", "map", "asm"):
                    if row[field + "_member"] == "-":
                        continue
                    handle = tar.extractfile(row[field + "_member"])
                    if handle is None:
                        raise ValueError("missing expected artifact")
                    raw = handle.read()
                    if hashlib.sha256(raw).hexdigest() != row[field + "_sha256"]:
                        raise ValueError("artifact SHA256 differs from manifest")
                    data[field] = raw.decode("utf-8", "replace")
                outcome = row["status"]
                text = data["artifact"]
                if outcome == "link_fail":
                    if ("dlink: duplicate global: vsprintf" not in text or
                            "p10run: link failed" not in text):
                        raise ValueError("GCC original linker duplicate was hidden")
                elif outcome == "timeout":
                    if (not re.search(r"^rc=124$", text, re.M) or
                            not re.search(r"^result=FAIL$", text, re.M) or
                            "HALT instruction" in text):
                        raise ValueError("SIMH original timeout misreported")
                else:
                    if (not re.search(r"^rc=0$", text, re.M) or
                            not re.search(r"^result=FAIL$", text, re.M) or
                            "HALT instruction" not in text or
                            not re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                          r"[^\n]+\t000000000051\b", text)):
                        raise ValueError("companion did not execute checkpoint 41")
                    for symbol in ("main", "sprintf", "exit", "__test_exit"):
                        if re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                     data["map"], re.M) is None:
                            raise ValueError("missing genuine target linkage: " + symbol)
                    if "many_args_v1:" not in data["asm"]:
                        raise ValueError("generated varargs test body missing")
                if "main:" not in data["asm"]:
                    raise ValueError("original/companion assembler body missing")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt compressed regression evidence") from error


def audit():
    rows = read(MANIFEST)
    validate(rows, read(MATRIX, True), read(PREVIOUS))
    validate_archive(rows, ARCHIVE.read_bytes())
    print("PASS: 920501 original timeout/duplicate-vsprintf preserved; "
          "six real manyargs sprintf checkpoint-41 run_fail cells retained")


if __name__ == "__main__":
    audit()
