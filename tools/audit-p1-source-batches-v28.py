#!/usr/bin/env python3
"""Recheck 59 immutable P1 source slots against live ledger v29."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_p1_frozen_batches_v13", ROOT / "tools/audit-p1-source-batches-v13.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
module.LIVE = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261121-v29.tsv"
module.OUT = ROOT / "docs/PDP10-P1-SOURCE-BATCHES-20261121-v28.tsv"


if __name__ == "__main__":
    raise SystemExit(module.main())
