#!/usr/bin/env python3
"""One explicitly authorized P1 source replacement, not a general SHA bypass.

The historic evidence describes bytes that are no longer present in the
checkout. Only the exact new checked-in test at the same pathname can
replace them. Any further edit requires a versioned replacement review.
"""

import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HISTORICAL_PATH = "tests/semantic/upstream/extensions/old.tort.c"
CURRENT_PATH = "tests/semantic/regression/pdp10-byte-pointer-torture-v1.c"
HISTORICAL_SHA = (
    "c4476261cb571a4e2666da59d8fc8438f7d0e6acebd1570ca955e20d05f3c96c"
)
REPLACEMENT_SHA = (
    "2b7543b425ffa690cd73848b581bb18791989d07af5d7372969664cea1bfe534"
)


def source_matches_historical(path, expected_sha):
    """Accept ordinary exact SHA matches or the reviewed one-source rewrite."""
    if path == HISTORICAL_PATH:
        return (expected_sha == HISTORICAL_SHA and
                not (ROOT / HISTORICAL_PATH).exists() and
                (ROOT / CURRENT_PATH).is_file() and
                hashlib.sha256((ROOT / CURRENT_PATH).read_bytes()).hexdigest()
                == REPLACEMENT_SHA)
    file = ROOT / path
    return (file.is_file() and
            hashlib.sha256(file.read_bytes()).hexdigest() == expected_sha)


def current_path_for(path):
    """Resolve the single retired historical source to its live matrix test."""
    return CURRENT_PATH if path == HISTORICAL_PATH else path


def check_replacement():
    source = (ROOT / CURRENT_PATH).read_text(encoding="ascii")
    if not source_matches_historical(HISTORICAL_PATH, HISTORICAL_SHA):
        raise ValueError("unreviewed change to rewritten byte-pointer test")
    if any(token in source.lower() for token in ("tops20", "xkl", "stdio")):
        raise ValueError("system-specific/hosted dependency reintroduced")
    if ("volatile unsigned int fail_id" not in source or
            "void *" not in source or
            "sizeof(byte_v1) == 1" not in source or
            "sizeof(half_v1) == 2" not in source or
            "sizeof(word_v1) == 4" not in source or
            "return 0;" not in source):
        raise ValueError("missing native PDP-10 test semantic oracle")
    return True


if __name__ == "__main__":
    check_replacement()
    print("PASS: imported source absent, native replacement SHA-pinned")
