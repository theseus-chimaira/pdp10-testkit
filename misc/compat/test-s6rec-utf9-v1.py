#!/usr/bin/env python3
"""Test reversible raw SIXBIT/S6REC and UTF-9 interchange conversion."""
import os
import pathlib
import random
import subprocess
import sys
import tempfile


def require(condition, description):
    if not condition:
        raise RuntimeError('s6rec-utf9-v1: ' + description)


def run(*args):
    return subprocess.run(args, stdout=subprocess.DEVNULL,
                          stderr=subprocess.DEVNULL).returncode


def main(to_s6, from_s6, utf8_to_utf9):
    scratch = pathlib.Path(os.environ.get('TMPDIR') or pathlib.Path.home() / 'tmp')
    scratch.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='s6rec-utf9-v1.', dir=scratch) as d:
        root = pathlib.Path(d)
        text, packed, native, restored = [root / name for name in
                                         ('source', 'packed', 'native', 'restored')]
        for content in (b'', b'HELLO\nWORLD\n', b'\n\n',
                        b'A' * 10000 + b'\n', b' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO\\]^_\n'):
            text.write_bytes(content)
            require(run(utf8_to_utf9, str(text), str(packed)) == 0,
                    'packed UTF-9 encoding failed')
            require(run(to_s6, str(packed), str(native)) == 0,
                    'S6REC conversion failed')
            require(run(from_s6, str(native), str(restored)) == 0,
                    'S6REC roundtrip decoding failed')
            require(packed.read_bytes() == restored.read_bytes(),
                    'S6REC roundtrip changed packed UTF-9 bytes')
        # The full native 64-character repertoire, including @ and \\.
        text.write_bytes(bytes(range(32, 96)) + b'\n')
        require(run(utf8_to_utf9, str(text), str(packed)) == 0,
                'native SIXBIT repertoire UTF-9 encoding failed')
        require(run(to_s6, str(packed), str(native)) == 0,
                'native SIXBIT repertoire S6REC conversion failed')
        require(run(from_s6, str(native), str(restored)) == 0,
                'native SIXBIT repertoire S6REC decode failed')
        require(packed.read_bytes() == restored.read_bytes(),
                'native SIXBIT repertoire bytes differ')
        # Exercise record padding in every position, with deterministic data.
        rng = random.Random(4042)
        for length in range(0, 32):
            text.write_bytes(bytes(rng.randrange(32, 96) for _ in range(length)) + b'\n')
            require(run(utf8_to_utf9, str(text), str(packed)) == 0,
                    'padding-case UTF-9 encoding failed')
            require(run(to_s6, str(packed), str(native)) == 0,
                    'padding-case S6REC conversion failed')
            require(run(from_s6, str(native), str(restored)) == 0,
                    'padding-case S6REC decode failed')
            require(packed.read_bytes() == restored.read_bytes(),
                    'padding-case roundtrip differs')
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
            require(run(from_s6, str(native), str(restored)) != 0,
                    'malformed S6REC was accepted')
            require(not restored.exists(), 'malformed S6REC left output')
        text.write_bytes(b'KEEP')
        alias = root / 'alias'
        alias.hardlink_to(native)
        require(run(from_s6, str(native), str(alias)) != 0,
                'aliased S6REC output was accepted')
        require(native.read_bytes() == bad, 'aliased S6REC changed source')
    print('s6rec-utf9-v1: PASS')


if __name__ == '__main__':
    if len(sys.argv) != 4:
        raise SystemExit('usage: test-s6rec-utf9-v1.py UTF9-S6REC S6REC-UTF9 UTF9-FILE')
    main(*sys.argv[1:])
