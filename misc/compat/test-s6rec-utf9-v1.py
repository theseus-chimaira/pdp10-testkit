#!/usr/bin/env python3
"""Test reversible raw SIXBIT/S6REC and UTF-9 interchange conversion."""
import pathlib
import subprocess
import sys
import tempfile


def run(*args):
    return subprocess.run(args, stdout=subprocess.DEVNULL,
                          stderr=subprocess.DEVNULL).returncode


def main(to_s6, from_s6, utf8_to_utf9):
    with tempfile.TemporaryDirectory() as d:
        root = pathlib.Path(d)
        text, packed, native, restored = [root / name for name in
                                         ('source', 'packed', 'native', 'restored')]
        for content in (b'', b'HELLO\nWORLD\n', b'\n\n',
                        b'A' * 10000 + b'\n', b' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO\\]^_\n'):
            text.write_bytes(content)
            assert run(utf8_to_utf9, str(text), str(packed)) == 0
            assert run(to_s6, str(packed), str(native)) == 0
            assert run(from_s6, str(native), str(restored)) == 0
            assert packed.read_bytes() == restored.read_bytes()
        for bad in (b'\x00', b'\x00' * 8, b'\x00' * 8 + b'\xff',
                    (1 << 30).to_bytes(8, 'little') + b'\xff',
                    (1 << 30 | 1).to_bytes(8, 'little') + b'\xff'):
            native.write_bytes(bad)
            assert run(from_s6, str(native), str(restored)) != 0
            assert not restored.exists()
        text.write_bytes(b'KEEP')
        alias = root / 'alias'
        alias.hardlink_to(native)
        assert run(from_s6, str(native), str(alias)) != 0
        assert native.read_bytes() == bad
    print('s6rec-utf9-v1: PASS')


if __name__ == '__main__':
    if len(sys.argv) != 4:
        raise SystemExit('usage: test-s6rec-utf9-v1.py UTF9-S6REC S6REC-UTF9 UTF9-FILE')
    main(*sys.argv[1:])
