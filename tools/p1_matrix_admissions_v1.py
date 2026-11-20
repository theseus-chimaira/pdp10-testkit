"""Verify the SHA-pinned P1 C admissions against historical classifications.

The 2026-11-18 classification is immutable historical evidence. A source
classified there as deferred may nevertheless be scheduled later in the
normal compiler matrix; scheduling is not an assertion of compiler success.
"""

import csv
import hashlib
from pathlib import Path

from p1_source_replacement_v1 import (
    HISTORICAL_PATH, current_path_for, source_matches_historical,
)


ROOT = Path(__file__).resolve().parents[1]
RESOLUTION = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v9.tsv"
SCHEDULED = frozenset(("semantic", "run", "runtime", "ok", "pending",
                       "fail", "timeout", "error"))


def admitted_sources(upstream, matrix, problems):
    """Return the exact later-admitted C set, rejecting any unpinned entry."""
    with RESOLUTION.open(encoding="utf8", newline="") as stream:
        ledger = list(csv.DictReader(stream, delimiter="\t"))

    historic = {row["classified_path"]: row for row in upstream}
    current = {row["test"]: row for row in matrix}
    unresolved = [row for row in ledger
                  if row["p1_state"] in ("partial", "blocked")]
    original_isa = "tests/semantic/upstream/support/920428-1.s"
    if len(unresolved) != 29:
        problems.append("P1 late-admission resolution ledger is not 29 sources")

    admitted = set()
    assembly = set()
    for row in unresolved:
        path = row["original_source"]
        source = ROOT / path
        if not source_matches_historical(path, row["original_sha256"]):
            problems.append("P1 late-admission source hash changed: " + path)
        if path.endswith(".s"):
            assembly.add(path)
            if path in current:
                problems.append("KL10 assembly mistakenly entered C matrix: " +
                                path)
            continue
        if not path.endswith(".c") or path in admitted:
            problems.append("unexpected/duplicate P1 late-admission: " + path)
            continue
        admitted.add(path)
        old = historic.get(path)
        active = current.get(current_path_for(path))
        if old is None or old["activation"] != "deferred":
            problems.append("P1 admission has no historical deferral: " + path)
        valid_group = ("semantic-regression" if path == HISTORICAL_PATH
                       else "semantic-upstream-deferred")
        if active is None or active["group"] != valid_group:
            problems.append("P1 admitted C source lacks matrix owner: " + path)
        elif any(active[column] not in SCHEDULED
                 for column in ("pdp6", "pdp6_gcc_o0")):
            problems.append("P1 admitted C source is no longer scheduled: " +
                            path)

    if len(admitted) != 28 or assembly != {original_isa}:
        problems.append("P1 late admissions differ from 28 C + 1 KL10 ISA")
    return admitted
