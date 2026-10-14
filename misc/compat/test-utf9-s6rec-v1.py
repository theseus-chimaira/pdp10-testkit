#!/usr/bin/env python3
"""Test explicit strict and lossy UTF-9 -> native SIXBIT/S6REC conversion."""
import pathlib
import subprocess
import sys
import tempfile


def run(*args):
    return subprocess.run(args, stdout=subprocess.DEVNULL,
                          stderr=subprocess.DEVNULL).returncode


def main(encode, convert, csix):
    with tempfile.TemporaryDirectory() as d:
        root = pathlib.Path(d)
        text, packed, native, decoded = [root / s for s in ('in', 'u9', 's6', 'out')]
        text.write_bytes(b'HELLO\nWORLD\n')
        assert run(encode, str(text), str(packed)) == 0
        assert run(convert, str(packed), str(native)) == 0
        assert run(csix, '-d', str(native), str(decoded)) == 0
        assert decoded.read_bytes() == b'hello\nworld\n'

        text.write_bytes('HELLO\u00ff\n'.encode('utf-8'))
        assert run(encode, str(text), str(packed)) == 0
        assert run(convert, str(packed), str(native)) != 0
        assert not native.exists()
        assert run(convert, '--lossy', str(packed), str(native)) == 0
        assert run(csix, '-d', str(native), str(decoded)) == 0
        assert decoded.read_bytes() == b'hello?\n'

        alias = root / 'alias'
        alias.hardlink_to(packed)
        old = packed.read_bytes()
        assert run(convert, str(packed), str(alias)) != 0
        assert packed.read_bytes() == old
        packed.write_bytes(b'\x00' * 8 + b'\xff')
        assert run(convert, str(packed), str(native)) != 0
        assert not native.exists()
    print('utf9-s6rec-v1: PASS')


if __name__ == '__main__':
    if len(sys.argv) != 4:
        raise SystemExit('usage: test-utf9-s6rec-v1.py UTF9-FILE UTF9-S6REC CSIX')
    main(*sys.argv[1:])
