#!/usr/bin/env python3
import pathlib
import sys

WORD_MASK = 0o777777777777


def fail(message):
    raise SystemExit("check-dxr-long-decimal: " + message)


def main(argv):
    if len(argv) != 2:
        fail("usage: check-dxr-long-decimal.py image.dxr")
    data = pathlib.Path(argv[1]).read_bytes()
    if len(data) % 8:
        fail("partial host word")
    words = [int.from_bytes(data[i:i + 8], "little") & WORD_MASK
             for i in range(0, len(data), 8)]
    if len(words) < 5:
        fail("truncated image")
    image_words = (words[1] >> 18) & 0o777777
    image = words[2:2 + image_words]
    label = 3
    expected = [
        10,
        (-10) & WORD_MASK,
        10,
        (label + 29142024192) & WORD_MASK,
        label + 10,
        label + 0o10,
        label + 0x10,
        label + 0b10,
    ]
    if image != expected:
        fail("unexpected image: %s" %
             " ".join("%012o" % word for word in image))
    print("DAS decimal .long contract passed")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
