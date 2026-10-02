#!/usr/bin/env python3
import sys

with open(sys.argv[1], "r", encoding="ascii") as f:
    lines = [line.rstrip("\n") for line in f]

need = {
    "global_common                    000001",
    "local_common                     000003",
}
if set(lines) != need:
    raise SystemExit("unexpected common labels:\n" + "\n".join(lines))
