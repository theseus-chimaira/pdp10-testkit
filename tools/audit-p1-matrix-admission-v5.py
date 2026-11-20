#!/usr/bin/env python3
"""Fail-closed P1 unresolved-source native matrix admission policy (v1).

Admission schedules compiler cells; it does not imply a compiler PASS.
Exactly one KL10 ISA source remains outside the C compiler matrix.
Historical original hashes remain immutable, including the retired
byte-pointer import with its SHA-pinned current regression replacement.
"""

import collections
import csv
import hashlib
import io
from pathlib import Path
import re
import tarfile

from p1_source_replacement_v1 import (
    HISTORICAL_PATH, current_path_for, source_matches_historical,
)

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/PDP10-P1-MATRIX-ADMISSION-20261120-v5.tsv"
LEDGER = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v13.tsv"
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
SMOKE = ROOT / "docs/PDP10-P1-NATIVE-ADMISSION-SMOKE-20261120-v1.tsv"
SMOKE_ARCHIVE = ROOT / "refs/p10tk-p1-native-admission-smoke-20261120-v1.tar.gz"
FIELDS = ("original_source", "matrix_source", "source_sha256",
          "p1_state", "tier")
CPUS = ("ka10", "ki10", "ks10")
GCC_OPTS = ("o0", "o1", "o2", "os")
EXTRA_OPTS = ("o1", "o2", "os")
DUAL = frozenset((
    "builtin-prefetch-6.c", "20010518-2.c", "20020412-1.c",
    "conversion.c", "comp-goto-1.c", "builtin-noret-1.c",
))
KCC = frozenset((
    "920726-1.c", "930513-1.c", "960327-1.c", "980605-1.c",
))
RESOURCE = frozenset((
    "960521-1.c", "20020406-1.c", "990628-1.c",
))
COUNTS = {
    "dual-native": 3, "kcc-native": 3, "pdp6-gcc-opt": 14,
    "resource-gated": 3, "already-native": 1, "isa-separate": 1,
}
SMOKE_CASES = (
    ("tests/semantic/upstream/extensions/builtin-prefetch-6.c",
     "gcc-ka10-o2", "pass", "ka10_gcc_o2"),
    ("tests/todo/generic/920726-1.c",
     "kcc-ka10-noopt", "pass", "ka10"),
    ("tests/semantic/upstream/extensions/stdio-opt-2.c",
     "gcc-pdp6-o2", "link_fail", "pdp6_gcc_o2"),
)


def read(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream
             if line.strip() and (not comments or
                                  not line.startswith("#"))),
            delimiter="\t"))


def tier_for(source):
    if source.endswith(".s"):
        return "isa-separate"
    if source == HISTORICAL_PATH:
        return "already-native"
    name = source.rsplit("/", 1)[-1]
    if name in DUAL:
        return "dual-native"
    if name in KCC:
        return "kcc-native"
    if name in RESOURCE:
        return "resource-gated"
    return "pdp6-gcc-opt"


def enabled_columns(tier):
    """Only new profiles; existing PDP-6 KCC and GCC O0 are preserved."""
    cols = []
    if tier in ("dual-native", "pdp6-gcc-opt"):
        cols += ["pdp6_gcc_" + opt for opt in EXTRA_OPTS]
    if tier in ("dual-native", "kcc-native"):
        cols += list(CPUS)
    if tier == "dual-native":
        cols += [cpu + "_gcc_" + opt for cpu in CPUS for opt in GCC_OPTS]
    return tuple(cols)


def validate(manifest, matrix, ledger):
    if (len(manifest) != 25 or not manifest or
            tuple(manifest[0]) != FIELDS):
        raise ValueError("P1 admission needs 25 source-pinned obligations")
    unresolved = {
        r["original_source"]: r for r in ledger
        if r["p1_state"] in ("blocked", "partial")
    }
    if len(unresolved) != 25:
        raise ValueError("original P1 state unexpectedly changed")
    by_source = {r["test"]: r for r in matrix}
    if len(by_source) != len(matrix):
        raise ValueError("duplicate compiler matrix rows")
    old_sources = set()
    current_sources = set()
    counts = collections.Counter()
    new_columns = 0
    actual_native_cells = 0

    for entry in manifest:
        old = entry["original_source"]
        current = entry["matrix_source"]
        tier = entry["tier"]
        if old in old_sources or old not in unresolved:
            raise ValueError("duplicate/unknown historical P1 source: " + old)
        old_sources.add(old)
        original = unresolved[old]
        if (tier != tier_for(old) or
                entry["p1_state"] != original["p1_state"] or
                current != current_path_for(old) or
                not source_matches_historical(old, original["original_sha256"])):
            raise ValueError("source replacement/tier/ledger mismatch: " + old)
        source = ROOT / current
        if (not source.is_file() or
                hashlib.sha256(source.read_bytes()).hexdigest()
                != entry["source_sha256"]):
            raise ValueError("current source SHA-256 mismatch: " + current)
        counts[tier] += 1
        if tier == "isa-separate":
            if (old != "tests/semantic/upstream/support/920428-1.s" or
                    current in by_source):
                raise ValueError("KL10 ISA fixture registered as a C test")
            continue
        if current in current_sources or current not in by_source:
            raise ValueError("missing/duplicate C matrix owner: " + current)
        current_sources.add(current)
        matrix_row = by_source[current]
        group = ("semantic-regression" if tier == "already-native"
                 else "semantic-upstream-deferred")
        if matrix_row["group"] != group:
            raise ValueError("wrong compiler test group: " + current)

        if tier == "already-native":
            # Verified by the dedicated six-profile source-replacement
            # auditor; do not overwrite its existing profile choices.
            if (matrix_row["pdp6"] != "fail" or
                    any(matrix_row["pdp6_gcc_" + opt] != "fail"
                        for opt in GCC_OPTS) or
                    any(matrix_row[cpu] != "pending" for cpu in CPUS) or
                    any(matrix_row[cpu + "_gcc_" + opt] != "pending"
                        for cpu in CPUS for opt in GCC_OPTS)):
                raise ValueError("native byte-pointer regression was disabled")
            actual_native_cells += 24
            continue

        if (matrix_row["pdp6"] != "semantic" or
                matrix_row["pdp6_gcc_o0"] != "semantic"):
            raise ValueError("original PDP-6 KCC/GCC baseline lost")
        planned = set(enabled_columns(tier))
        new_columns += len(planned)
        actual_native_cells += 3
        for opt in EXTRA_OPTS:
            col = "pdp6_gcc_" + opt
            want = "pending" if col in planned else "no_test"
            if matrix_row[col] != want:
                raise ValueError("incorrect PDP-6 GCC opt admission: " + col)
            if col in planned:
                actual_native_cells += 1
        for cpu in CPUS:
            want = "pending" if cpu in planned else "no_test"
            if matrix_row[cpu] != want:
                raise ValueError("incorrect KCC native CPU admission: " + cpu)
            if cpu in planned:
                actual_native_cells += 2  # KCC opt and noopt
            for opt in GCC_OPTS:
                col = cpu + "_gcc_" + opt
                want = "pending" if col in planned else "no_test"
                if matrix_row[col] != want:
                    raise ValueError("incorrect GCC native CPU admission: " + col)
                if col in planned:
                    actual_native_cells += 1
        for cpu in ("pdp6",) + CPUS:
            # The old deferred originals are not automatically portable
            # to BASE or the generic PDP10 compile family.
            if (matrix_row[cpu + "_base"] != "no_test" or
                    matrix_row[cpu + "_gcc_base_o0"] != "no_test"):
                raise ValueError("unapproved alternate-family activation")

    if set(unresolved) != old_sources or counts != COUNTS:
        raise ValueError("missing or reclassified P1 source")
    if new_columns != 105 or actual_native_cells != 216:
        raise ValueError("incorrect native matrix admission total")
    return counts, new_columns, actual_native_cells


def validate_smoke(rows, archive_bytes, matrix):
    """Retain only exact successful guest exits or the real linker error."""
    if len(rows) != 3 or not rows:
        raise ValueError("expected three targeted smoke observations")
    owners = {r["test"]: r for r in matrix}
    names = set()
    try:
        with tarfile.open(fileobj=io.BytesIO(archive_bytes),
                          mode="r:gz") as archive:
            members = archive.getmembers()
            if len(members) != 3 or any(not member.isfile()
                                        for member in members):
                raise ValueError("incomplete targeted guest evidence archive")
            for row, expected in zip(rows, SMOKE_CASES):
                source, profile, status, column = expected
                member = ("native/" + profile +
                          (".report.txt" if status == "pass"
                           else ".cell.log"))
                if ((row["source"], row["profile"], row["status"],
                     row["archive_member"]) !=
                        (source, profile, status, member) or
                        row["source_sha256"] != hashlib.sha256(
                            (ROOT / source).read_bytes()).hexdigest() or
                        owners[source][column] not in
                        ("pending", "semantic", "fail")):
                    raise ValueError("smoke source/profile/matrix differs")
                if member in names:
                    raise ValueError("duplicate archived smoke evidence")
                names.add(member)
                raw = archive.extractfile(member)
                if raw is None:
                    raise ValueError("missing actual smoke result")
                data = raw.read()
                if hashlib.sha256(data).hexdigest() != (
                        row["evidence_sha256"]):
                    raise ValueError("smoke report checksum changed")
                text = data.decode("utf-8", errors="replace")
                if status == "pass":
                    if (not re.search(r"^rc=0$", text, re.M) or
                            not re.search(r"^result=PASS$", text, re.M) or
                            "HALT instruction" not in text or
                            not re.search(
                                r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                r"[^\n]+\t000000000000\b", text)):
                        raise ValueError("smoke PASS not executed to guest HALT")
                elif ("dlink: undefined symbol: putchar" not in text or
                      "p10run: link failed" not in text):
                    raise ValueError("stdio linker failure provenance changed")
            if {m.name for m in members} != names:
                raise ValueError("unexpected smoke archive member")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt smoke evidence archive") from error


def main():
    matrix = read(MATRIX, True)
    counts, new, total = validate(read(MANIFEST), matrix, read(LEDGER))
    validate_smoke(read(SMOKE), SMOKE_ARCHIVE.read_bytes(), matrix)
    print("PASS: 25 unresolved P1 obligations; 24 C sources already "
          "owned; 1 KL10 ISA separate; %d new native matrix columns; "
          "%d total native runtime cells (including both KCC modes), "
          "3 archived target smoke results, all unresolved states retained"
          % (new, total))


if __name__ == "__main__":
    main()
