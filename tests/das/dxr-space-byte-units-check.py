#!/usr/bin/env python3
import sys
from pathlib import Path

labels = {}
for line in Path(sys.argv[1]).read_text(encoding="ascii").splitlines():
    parts = line.split()
    if len(parts) == 2:
        labels[parts[0]] = int(parts[1], 8)

if "region_map" not in labels or "mres_member" not in labels:
    raise SystemExit("missing BSS labels")
if labels["mres_member"] - labels["region_map"] != 0o221:
    raise SystemExit(".space 580 did not reserve 0221 words")

print("DAS .space decimal-byte contract passed")
