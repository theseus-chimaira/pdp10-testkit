#!/usr/bin/env python3
"""Review frozen P1 batches against verified v16 current source closure."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_source_batches_v13", ROOT / "tools/audit-p1-source-batches-v13.py")
original = importlib.util.module_from_spec(spec)
spec.loader.exec_module(original)
original.LIVE = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v16.tsv"
original.OUT = ROOT / "manifests/PDP10-P1-SOURCE-BATCHES-20261120-v15.tsv"


if __name__ == "__main__":
    raise SystemExit(original.main())
