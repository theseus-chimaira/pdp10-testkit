#!/usr/bin/env python3
"""Authenticate source-specific matrix extensions after frozen P1 snapshots.

Older P1 admission ledgers describe the profile set at their creation.
They must keep validating their original rows and selected profiles, but
may tolerate later *independently proven* source-specific additions.
Never accept a generic new pending profile or silently edit old ledgers.
"""

import importlib.util
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/todo/generic/930513-1.c"
ADDED_PROFILES = frozenset(("pdp6_gcc_o1", "pdp6_gcc_o2", "pdp6_gcc_os"))


def verify_930513_evidence():
    """Fail closed on six real original test profiles and immutable bytes."""
    spec = importlib.util.spec_from_file_location(
        "p10tk_post_admission_930513_v1",
        ROOT / "tools/audit-p1-930513-original-v1.py")
    verifier = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(verifier)
    rows = verifier.read(verifier.MANIFEST)
    verifier.validate(rows, verifier.read(verifier.MATRIX, True),
                      verifier.read(verifier.PREVIOUS))
    verifier.validate_archive(rows, verifier.ARCHIVE.read_bytes())
    return True


def is_proven_extension(source, column, frozen, live):
    """Allow exactly the three source-pinned GCC options added in v15."""
    if (source != SOURCE or column not in ADDED_PROFILES or
            frozen != "no_test" or live != "pending"):
        return False
    return verify_930513_evidence()
