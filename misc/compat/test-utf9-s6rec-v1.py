#!/usr/bin/env python3
"""Test explicit strict and lossy UTF-9 -> native SIXBIT/S6REC conversion."""
import os
import pathlib
import subprocess
import sys
import tempfile


def require(condition, description):
    if not condition:
        raise RuntimeError('utf9-s6rec-v1: ' + description)


def run(*args):
    return subprocess.run(args, stdout=subprocess.DEVNULL,
                          stderr=subprocess.DEVNULL).returncode


def main(encode, convert, csix):
    scratch = pathlib.Path(os.environ.get('TMPDIR') or pathlib.Path.home() / 'tmp')
    scratch.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='utf9-s6rec-v1.', dir=scratch) as d:
        root = pathlib.Path(d)
        text, packed, native, decoded = [root / s for s in ('in', 'u9', 's6', 'out')]
        text.write_bytes(b'HELLO\nWORLD\n')
        require(run(encode, str(text), str(packed)) == 0, 'encoding failed')
        require(run(convert, str(packed), str(native)) == 0,
                'strict conversion failed')
        require(run(csix, '-d', str(native), str(decoded)) == 0,
                'native decoding failed')
        require(decoded.read_bytes() == b'hello\nworld\n',
                'strict converted text differs')

        text.write_bytes('HELLO\u00ff\n'.encode('utf-8'))
        require(run(encode, str(text), str(packed)) == 0,
                'lossy source encoding failed')
        require(run(convert, str(packed), str(native)) != 0,
                'strict conversion accepted unrepresentable text')
        require(not native.exists(), 'strict rejection left native output')
        require(run(convert, '--lossy', str(packed), str(native)) == 0,
                'lossy conversion failed')
        require(run(csix, '-d', str(native), str(decoded)) == 0,
                'lossy decoding failed')
        require(decoded.read_bytes() == b'hello?\n',
                'lossy converted text differs')

        alias = root / 'alias'
        alias.hardlink_to(packed)
        old = packed.read_bytes()
        require(run(convert, str(packed), str(alias)) != 0,
                'aliased conversion was accepted')
        require(packed.read_bytes() == old, 'aliased source changed')
        packed.write_bytes(b'\x00' * 8 + b'\xff')
        require(run(convert, str(packed), str(native)) != 0,
                'invalid packed input was accepted')
        require(not native.exists(), 'invalid input left native output')
    print('utf9-s6rec-v1: PASS')


if __name__ == '__main__':
    if len(sys.argv) != 4:
        raise SystemExit('usage: test-utf9-s6rec-v1.py UTF9-FILE UTF9-S6REC CSIX')
    main(*sys.argv[1:])
