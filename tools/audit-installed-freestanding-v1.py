#!/usr/bin/env python3
"""Audit the semantic selector against the installed freestanding sources.

This is a static prerequisite check. Archive extraction and executable
behavior are covered separately by the registered production-link test.
"""

import hashlib
import os
from pathlib import Path
import re
import sys

from freestanding_selection_v1 import (DEPENDENCIES, MEMBERS, REFERENCES,
                                        select_freestanding)


EXPORT = re.compile(r"(?mi)^\s*\.glob(?:l|al)\s+([A-Za-z_][\w]*)\b")
LABEL = re.compile(r"(?m)^\s*([A-Za-z_][\w]*):")


def normalized_assembly(source):
    """Ignore layout-only whitespace, not operands or instruction spelling."""
    return tuple(line.rstrip().strip() for line in source.splitlines()
                 if line.strip())


def audit(prefix):
    kcc = prefix / "lib/kcc/freestanding"
    gcc = prefix / "lib/gcc-lib/pdp10-dec-none/3.2/freestanding"
    problems = []
    archives = [d / "libp10c-v2.a" for d in (kcc, gcc)]
    # Real C-locale classification is packaged separately from the
    # SHA-frozen core compiler C archive, and must match for both ABIs.
    ctype_archives = [d / "libp10ctype-c-locale-v1.a" for d in (kcc, gcc)]
    float_archives = [d / "libp10fp36-pdp6-v1.a" for d in (kcc, gcc)]
    for archive in archives:
        if not archive.is_file():
            problems.append("missing installed archive: " + str(archive))
    if not problems:
        hashes = [hashlib.sha256(p.read_bytes()).hexdigest()
                  for p in archives]
        if hashes[0] != hashes[1]:
            problems.append("installed KCC/GCC archives differ")
    for archive in ctype_archives:
        if not archive.is_file() or archive.is_symlink():
            problems.append("missing or linked compiler C-locale archive: " + str(archive))
    if all(p.is_file() and not p.is_symlink() for p in ctype_archives):
        if (hashlib.sha256(ctype_archives[0].read_bytes()).digest() !=
                hashlib.sha256(ctype_archives[1].read_bytes()).digest()):
            problems.append("installed KCC/GCC C-locale archives differ")
    for archive in float_archives:
        if not archive.is_file() or archive.is_symlink():
            problems.append("missing or linked compiler unsigned-FP archive: " + str(archive))
    if all(p.is_file() and not p.is_symlink() for p in float_archives):
        if (hashlib.sha256(float_archives[0].read_bytes()).digest() !=
                hashlib.sha256(float_archives[1].read_bytes()).digest()):
            problems.append("installed KCC/GCC unsigned-FP archives differ")

    members = sorted(set(MEMBERS.values()))
    actual = {}
    for member in members:
        for directory in (kcc, gcc):
            path = directory / member
            if not path.is_file():
                problems.append("missing installed member: " + str(path))
                continue
            source = path.read_text(encoding="ascii")
            exports = set(EXPORT.findall(source))
            definitions = set(LABEL.findall(source))
            if not exports <= definitions:
                problems.append("undefined exported label in " + str(path))
            if directory == kcc:
                actual[member] = (exports, definitions, source)
            elif (member in actual and
                  normalized_assembly(source) !=
                  normalized_assembly(actual[member][2])):
                problems.append("KCC/GCC installed member differs: " + member)

    for symbol, member in sorted(MEMBERS.items()):
        if member in actual and symbol not in actual[member][0]:
            problems.append("selector claims missing export: " + symbol)
    all_exports = {}
    for member, (exports, _, _) in actual.items():
        for symbol in exports:
            if symbol in all_exports:
                problems.append("duplicate installed export: " + symbol)
            all_exports[symbol] = member
            if MEMBERS.get(symbol) != member:
                problems.append("unmapped installed export: " + symbol)

    for member, (_, labels, source) in actual.items():
        # A call to a label in this same source is not a member dependency.
        external = set(REFERENCES.findall(source)) - labels
        # Only references to known freestanding exports belong in this
        # dependency graph. Runtime helpers remain owned by their toolchain.
        required = {symbol for symbol in external if symbol in all_exports}
        declared = set(DEPENDENCIES.get(member, ()))
        if required != declared:
            problems.append("%s dependencies: actual=%s declared=%s" %
                            (member, sorted(required), sorted(declared)))
        # A symbol that selects this member must also select its dependencies.
        for symbol in sorted(MEMBERS):
            if MEMBERS[symbol] != member:
                continue
            selected, _ = select_freestanding(
                ".extern %s\n" % symbol, "pdp6")
            for dependency in required:
                if all_exports[dependency] not in selected:
                    problems.append("missing transitive selection: " +
                                    symbol + " -> " + dependency)

    if problems:
        for problem in problems:
            print("ERROR: " + problem, file=sys.stderr)
        return 1
    print("PASS: installed freestanding selector: %d exports, %d members, "
          "KCC/GCC core, C-locale and unsigned-FP archive parity" %
          (len(all_exports), len(members)))
    return 0


if __name__ == "__main__":
    prefix = os.environ.get("PDP10_PREFIX")
    if not prefix:
        sys.exit("PDP10_PREFIX must identify the installed toolchain")
    sys.exit(audit(Path(prefix)))
