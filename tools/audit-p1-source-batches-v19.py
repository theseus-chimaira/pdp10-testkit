#!/usr/bin/env python3
"""Audit frozen 59 P1 source batches against v20 original ledger."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_source_batches_v13", ROOT / "tools/audit-p1-source-batches-v13.py")
previous = importlib.util.module_from_spec(spec)
spec.loader.exec_module(previous)
previous.LIVE = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v20.tsv"
previous.OUT = ROOT / "docs/PDP10-P1-SOURCE-BATCHES-20261120-v19.tsv"


if __name__ == "__main__":
    raise SystemExit(previous.main())
