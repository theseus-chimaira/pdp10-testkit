#!/usr/bin/env python3
import sys
from pathlib import Path

MASK36 = (1 << 36) - 1
MASK18 = (1 << 18) - 1

def read_rim_word(data, off):
    w = 0
    for b in data[off:off+6]:
        if (b & 0o300) != 0o200:
            raise SystemExit('bad RIM byte marker at offset %d' % off)
        w = (w << 6) | (b & 0o77)
    return w & MASK36

simh = Path(sys.argv[1]).read_text().splitlines()
rim = Path(sys.argv[2]).read_bytes()
pt = Path(sys.argv[3]).read_bytes()
pdp6 = Path(sys.argv[4]).read_bytes()
expect_simh = [
    'deposit 001000 201040001003',
    'deposit 001001 260740001002',
    'deposit 001002 263740000000',
    'deposit 001003 504554545700',
    'go 001000',
]
if simh != expect_simh:
    raise SystemExit('bad SIMH output: %r' % (simh,))
if rim != pt:
    raise SystemExit('RIM and PT output should match for DXR V1 RIM10B paper-tape mode')
if len(rim) != 132:
    raise SystemExit('bad RIM length %d' % len(rim))
words = [read_rim_word(rim, i) for i in range(0, len(rim), 6)]
if words[0] != ((0o777762 << 18) | 0):
    raise SystemExit('bad RIM header %012o' % words[0])
if any(words[i] != 0 for i in range(1, 15)):
    raise SystemExit('nonzero RIM bootstrap filler')
image = [0o201040001003, 0o260740001002, 0o263740000000, 0o504554545700]
iowd = (((-len(image)) & MASK18) << 18) | ((0o1000 - 1) & MASK18)
if words[15] != iowd:
    raise SystemExit('bad IOWD %012o expected %012o' % (words[15], iowd))
if words[16:20] != image:
    raise SystemExit('bad RIM image words')
checksum = iowd
for w in image:
    checksum = (checksum + w) & MASK36
if words[20] != checksum:
    raise SystemExit('bad RIM checksum %012o expected %012o' % (words[20], checksum))
if words[21] != ((0o254 << 27) | 0o1000):
    raise SystemExit('bad RIM JRST %012o' % words[21])

# PDP-6 executable read-in stream: each DATAI deposits the following word.
if len(pdp6) % 6 != 0:
    raise SystemExit('bad PDP-6 read-in byte length %d' % len(pdp6))
pdp6_words = [read_rim_word(pdp6, i) for i in range(0, len(pdp6), 6)]
expect_pdp6 = []
for i, w in enumerate(image):
    expect_pdp6.extend([0o710440000000 | (0o1000 + i), w])
expect_pdp6.append((0o254 << 27) | 0o1000)
expect_pdp6.append(0)
if pdp6_words != expect_pdp6:
    raise SystemExit('bad PDP-6 read-in output: %r' % ([format(w, '012o') for w in pdp6_words],))
