#!/usr/bin/env python3
"""Test reversible raw SIXBIT/S6REC and UTF-9 interchange conversion."""
import pathlib
import random
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
        # The full native 64-character repertoire, including @ and \\.
        text.write_bytes(bytes(range(32, 96)) + b'\n')
        assert run(utf8_to_utf9, str(text), str(packed)) == 0
        assert run(to_s6, str(packed), str(native)) == 0
        assert run(from_s6, str(native), str(restored)) == 0
        assert packed.read_bytes() == restored.read_bytes()
        # Exercise record padding in every position, with deterministic data.
        rng = random.Random(4042)
        for length in range(0, 32):
            text.write_bytes(bytes(rng.randrange(32, 96) for _ in range(length)) + b'\n')
            assert run(utf8_to_utf9, str(text), str(packed)) == 0
            assert run(to_s6, str(packed), str(native)) == 0
            assert run(from_s6, str(native), str(restored)) == 0
            assert packed.read_bytes() == restored.read_bytes()
        # Reject excess bits beyond the low 36 bits, nonzero payload padding,
        # invalid header types, and truncated records or word containers.
        def word(value):
            return value.to_bytes(8, 'little')

        malformed = [b'\x00', word(0), word(2 << 30), word((1 << 30) | 1),
                     word((1 << 30) | 1) + word(1),
                     word((1 << 30) | 1) + word(1 << 36),
                     word((1 << 30) | 1) + word(1 << 29 | 1),
                     word((1 << 30) | 1) + b'\x00' * 7,
                     word((1 << 30) | 0) + b'\x00']
        for bad in malformed:
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
