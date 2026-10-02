#!/usr/bin/env python3
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text().strip()
expect = 'RELOCS count=2 000000 000001'
if text != expect:
    raise SystemExit('bad dxrcheck relocs output: %r expected %r' % (text, expect))
