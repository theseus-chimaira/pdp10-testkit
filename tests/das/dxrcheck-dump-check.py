#!/usr/bin/env python3
import sys

path = sys.argv[1]
with open(path, "r", encoding="ascii") as f:
    lines = [line.rstrip("\n") for line in f]

need = [
    "DXR magic=DXR entry=000000 image=000004 bss=000004 reloc=000001 words=7 purity=UNKNOWN",
    "HEADER 000000 447062000000 ; DXR,,000000",
    "HEADER 000001 000004000004 ; image,,bss",
    "IMAGE  000000 201040000003",
    "IMAGE  000001 260740000002",
    "IMAGE  000002 263740000000",
    "IMAGE  000003 504554545700",
    "RELOC  000000 600000000000 000000 000001",
]
if lines != need:
    raise SystemExit("unexpected dump:\n" + "\n".join(lines))
