#!/usr/bin/env python3
import os
import struct
import subprocess
import sys
import tempfile

DXR_MAGIC = (0o44 << 12) | (0o70 << 6) | 0o62
WORD_MASK = 0o777777777777

def word(lh, rh):
    return ((lh & 0o777777) << 18) | (rh & 0o777777)

def write_words(path, words):
    with open(path, 'wb') as f:
        for w in words:
            f.write(struct.pack('<Q', w))

def run_bad(dxrcheck, name, words, expect):
    fd, path = tempfile.mkstemp(prefix='dxrcheck-bad-%s-' % name)
    os.close(fd)
    try:
        if isinstance(words, bytes):
            with open(path, 'wb') as f:
                f.write(words)
        else:
            write_words(path, words)
        p = subprocess.run([dxrcheck, '-q', path], stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, text=True)
        if p.returncode == 0:
            print('%s: dxrcheck accepted corrupt file' % name, file=sys.stderr)
            return 1
        if expect not in p.stderr:
            print('%s: expected diagnostic substring %r' % (name, expect), file=sys.stderr)
            print('stderr was: %s' % p.stderr, file=sys.stderr)
            return 1
        return 0
    finally:
        try:
            os.unlink(path)
        except OSError:
            pass

def main():
    if len(sys.argv) != 2:
        print('usage: dxrcheck-bad-check.py dxrcheck', file=sys.stderr)
        return 2
    dxrcheck = sys.argv[1]
    cases = [
        ('partial-word', b'\x00\x01', 'partial container word'),
        ('high-bits', [1 << 40], 'nonzero container high bits'),
        ('short-header', [word(DXR_MAGIC, 0)], 'short header'),
        ('bad-magic', [word(0o123456, 0), word(1, 0), 0, 0], 'bad magic'),
        ('zero-image', [word(DXR_MAGIC, 0), word(0, 0)], 'image and bss are both zero'),
        ('bad-entry', [word(DXR_MAGIC, 2), word(1, 0), 0, 0], 'outside image size'),
        ('trunc-image', [word(DXR_MAGIC, 0), word(3, 0), 0], 'truncated image'),
        ('trunc-bitmap', [word(DXR_MAGIC, 0), word(3, 0), 0, 0, 0], 'truncated relocation bitmap'),
        ('bad-dxr2-tag', [word(DXR_MAGIC, 0), word(1, 0), 0, 0, 0], 'bad DXR2 text metadata tag'),
        ('trailing', [word(DXR_MAGIC, 0), word(1, 0), 0, 0, 0, 0], 'trailing words'),
    ]
    rc = 0
    for name, words, expect in cases:
        rc |= run_bad(dxrcheck, name, words, expect)
    return rc

if __name__ == '__main__':
    sys.exit(main())
