#!/usr/bin/env python3
"""Validate counted MSB-first packed 9-bit UTF-9 interchange files."""
import pathlib
import subprocess
import sys
import tempfile


def pack(text):
    units = []
    for char in text:
        scalar = ord(char)
        chunks = 1 if scalar <= 0xff else 2 if scalar <= 0xffff else 3
        for index in range(chunks):
            shift = 8 * (chunks - index - 1)
            units.append(((scalar >> shift) & 255) | (256 if index + 1 < chunks else 0))
    bits = ''.join(f'{unit:09b}' for unit in units)
    bits += '0' * (-len(bits) % 8)
    return len(units).to_bytes(8, 'big') + bytes(
        int(bits[i:i + 8], 2) for i in range(0, len(bits), 8)
    )


def main(tool):
    with tempfile.TemporaryDirectory() as d:
        root = pathlib.Path(d)
        source, output = root / 'source', root / 'target'
        cases = ['', 'ASCII\x00test', 'AÿΑ𐌰', '\u00ff\u0100\uffff\U0010ffff',
                 '漢字😀' * 1024]
        for item in cases:
            source.write_bytes(item.encode('utf-8'))
            subprocess.run([tool, str(source), str(output)], check=True)
            assert output.read_bytes() == pack(item), repr(item[:32])
        for invalid in [b'\xff', b'\xc0\x80', b'\xe0\x80\x80',
                        b'\xed\xa0\x80', b'\xf4\x90\x80\x80',
                        b'\xe2\x82', b'ABC\xff', b'\xe2(\xa1']:
            source.write_bytes(invalid)
            result = subprocess.run([tool, str(source), str(output)],
                                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            assert result.returncode != 0 and not output.exists()
        source.write_text('keep', encoding='ascii')
        alias = root / 'alias'
        alias.hardlink_to(source)
        result = subprocess.run([tool, str(source), str(alias)],
                                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        assert result.returncode != 0 and source.read_text() == 'keep'
    print('utf9-file-v1: PASS')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('usage: test-utf9-file-v1.py /path/to/utf9-file-v1')
    main(sys.argv[1])
