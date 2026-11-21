#!/usr/bin/env python3
"""Audit immutable P1 59-source batch positions against ledger v26."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_source_batches_v13", ROOT / "tools/audit-p1-source-batches-v13.py")
previous = importlib.util.module_from_spec(spec)
spec.loader.exec_module(previous)
previous.LIVE = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v26.tsv"
previous.OUT = ROOT / "manifests/PDP10-P1-SOURCE-BATCHES-20261120-v25.tsv"


if __name__ == "__main__":
    raise SystemExit(previous.main())
