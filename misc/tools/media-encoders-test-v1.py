#!/usr/bin/env python3
"""Independent byte-exact PDP-6 DECtape, Stage-1, and PTR tool checks.

Run the actual executables from one isolated pdp10-tools source build.
The expected layouts below are constructed independently of tool code.
"""

import pathlib
import struct
import subprocess
import sys


MASK36 = (1 << 36) - 1
MASK18 = (1 << 18) - 1
DAIMON_MAGIC = 0o444151555756


def require(condition, message):
    if not condition:
        raise SystemExit("media-encoders-test-v1: " + message)


def invoke(command, succeed):
    proc = subprocess.run([str(part) for part in command],
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          text=True)
    if (proc.returncode == 0) != succeed:
        raise SystemExit("media-encoders-test-v1: unexpected exit %d: %s\n%s" %
                         (proc.returncode, " ".join(map(str, command)),
                          proc.stderr))


def test_mkdt(binary, root):
    source = root / "dec-tape-words-v1.txt"
    output = root / "dec-tape-image-v1.bin"
    values = (0o123456701234, MASK36, 0)
    source.write_text("# skip this\n   %012o\n%012o\n%012o\n" % values,
                      encoding="ascii")
    invoke((binary, "-t", "dtc", "-p", source, "-o", output), True)
    expected = b"".join(struct.pack("<II", (word >> 18) & MASK18,
                                    word & MASK18) for word in values)
    expected += bytes((128 - len(values)) * 8)
    require(len(expected) == 1024 and output.read_bytes() == expected,
            "mkdt 18-bit halves, little-endian layout or padding differs")

    source.write_text("1000000000000\n", encoding="ascii")
    invoke((binary, "-t", "dtc", "-p", source, "-o", output), False)
    invoke((binary, "-t", "wrong", "-p", source, "-o", output), False)
    print("mkdt: PASS (128-word padding, 18-bit halves, bad input)")


def test_mkstream(binary, root):
    source = root / "stage1-deposit-v1.txt"
    output = root / "stage1-stream-v1.txt"
    source.write_text("deposit 001000 000000000005\n"
                      "deposit 001002 123456701234\n"
                      "ignored other line\n"
                      "deposit 001000 000000000007\n", encoding="ascii")
    invoke((binary, "-i", source, "-o", output, "-b", "1000", "-w", "4"),
           True)
    image = (DAIMON_MAGIC, 4 << 18, 7, 0, 0o123456701234, 0)
    expected = "".join("%012o\n" % value for value in image)
    require(output.read_text(encoding="ascii") == expected,
            "mkstream magic, count/entry, sparse deposit or overwrite differs")

    source.write_text("deposit 001004 1\n", encoding="ascii")
    invoke((binary, "-i", source, "-o", output, "-b", "1000", "-w", "4"),
           False)
    source.write_text("deposit 001001 888\n", encoding="ascii")
    invoke((binary, "-i", source, "-o", output, "-b", "1000", "-w", "4"),
           False)
    invoke((binary, "-i", source, "-o", output, "-b", "1000", "-w", "0"),
           False)
    print("mkstream: PASS (DAIMON stream, sparse deposits, invalid input)")


def test_words2pt(binary, root):
    source = root / "paper-tape-words-v1.txt"
    output = root / "paper-tape-v1.bin"
    values = (0o123456701234, MASK36, 1)
    source.write_text("# comment\n%012o  # inline comment\n%012o\n"
                      "   %012o\n" % values, encoding="ascii")
    invoke((binary, "-t", "ptr", "-p", source, "-o", output), True)
    expected = b"".join(value.to_bytes(5, "big") for value in values)
    require(len(expected) == 15 and output.read_bytes() == expected,
            "words2pt five-byte MSB-first 36-bit encoding differs")

    source.write_text("1000000000000\n", encoding="ascii")
    invoke((binary, "-t", "ptr", "-p", source, "-o", output), False)
    source.write_text("8\n", encoding="ascii")
    invoke((binary, "-t", "ptr", "-p", source, "-o", output), False)
    invoke((binary, "-t", "dtc", "-p", source, "-o", output), False)
    print("words2pt: PASS (five-byte 36-bit encoding, bad input)")


def main(argv):
    require(len(argv) == 4, "usage: media-encoders-test-v1.py MKDT MKSTREAM WORDS2PT WORKDIR")
    mkdt, mkstream, words2pt, work = argv
    root = pathlib.Path(work)
    root.mkdir(parents=True, exist_ok=True)
    test_mkdt(mkdt, root)
    test_mkstream(mkstream, root)
    test_words2pt(words2pt, root)
    print("pdp10-tools media encoders: PASS")


if __name__ == "__main__":
    main(sys.argv[1:])
