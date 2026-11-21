#!/usr/bin/env python3
"""Verify 105 C-to-ISA instruction tests are scheduled, not silently skipped.

These are C codegen/assembly-observation sources, not original KL10
MACRO-10 .s programs.  Scheduling an instruction source does not prove
that its intended opcode was emitted or executed.  Any compiler ICE
must still be reported by the common compiler harness.
"""

import argparse
import csv
import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
MANIFEST = ROOT / "docs/PDP10-ISA-C-HARNESS-20261121-v1.tsv"
SOURCE_LIST = ROOT / "docs/PDP10-ISA-C-SOURCES-20261121-v1.txt"
FIELDS = ("source", "source_sha256", "matrix_group",
          "active_compiler_columns")
ACTIVE = frozenset(("isa", "pending", "codegen", "ok", "fail",
                    "timeout", "error"))


def rows():
    with MATRIX.open(encoding="ascii", newline="") as stream:
        return list(csv.DictReader((line for line in stream
                                    if line.strip() and not line.startswith("#")),
                                   delimiter="\t"))


def expected(matrix):
    sources = [row for row in matrix if row["group"] == "isa"]
    if len(sources) != 105 or len({r["test"] for r in sources}) != 105:
        raise ValueError("expected 105 unique compiler instruction sources")
    out = []
    for row in sources:
        path = row["test"]
        if (not path.startswith("tests/isa/pdp10-insn/") or
                not path.endswith(".c") or not (ROOT / path).is_file()):
            raise ValueError("ISA C source is absent or misregistered: " + path)
        active = [col for col, value in row.items()
                  if col not in ("test", "group", "name") and
                  value in ACTIVE]
        if not active:
            raise ValueError("ISA compiler instruction source is unreachable: " + path)
        if any(value not in ACTIVE | {"no_test", "unsupported", "obsolete", ""}
               for col, value in row.items()
               if col not in ("test", "group", "name")):
            raise ValueError("ISA source has an ignored matrix status: " + path)
        out.append(dict(source=path,
                        source_sha256=hashlib.sha256(
                            (ROOT / path).read_bytes()).hexdigest(),
                        matrix_group="isa",
                        active_compiler_columns=str(len(active))))
    return out


def audit():
    out = expected(rows())
    if not MANIFEST.is_file() or not SOURCE_LIST.is_file():
        raise ValueError("ISA C source manifest and selection list missing")
    with MANIFEST.open(encoding="ascii", newline="") as stream:
        observed = list(csv.DictReader(stream, delimiter="\t"))
    if observed != out or tuple(observed[0]) != FIELDS:
        raise ValueError("ISA source hashes/profile column ownership changed")
    selection = "".join(row["source"] + "\n" for row in out)
    if SOURCE_LIST.read_text(encoding="ascii") != selection:
        raise ValueError("ISA source selection list changed")
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.write:
        out = expected(rows())
        with MANIFEST.open("w", encoding="ascii", newline="") as stream:
            writer = csv.DictWriter(stream, FIELDS, delimiter="\t",
                                    lineterminator="\n")
            writer.writeheader()
            writer.writerows(out)
        SOURCE_LIST.write_text("".join(x["source"] + "\n" for x in out),
                               encoding="ascii")
    out = audit()
    print("PASS: 105 native C-to-ISA codegen sources registered and "
          "source-pinned, with all ISA/pending compiler cells reachable")


if __name__ == "__main__":
    main()
