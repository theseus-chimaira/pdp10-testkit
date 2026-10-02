#!/usr/bin/env python3
"""Validate the linked native DAS DXR image and its stack-frame contract."""

import argparse
import pathlib
import re
import sys

WORD_MASK = 0o777777777777
HALF_MASK = 0o777777
DXR_MAGIC = 0o447062
DEFAULT_STACK_WORDS = 0o2000
MAX_IMAGE_WORDS = 0o20000
MAX_BSS_WORDS = 0o20000
MAX_PROCESS_WORDS = 0o40000
PROJECT_MAX_WORDS = 0o200000
MAX_SINGLE_FRAME_WORDS = 0o200


def fail(message):
    raise SystemExit("check-das-native-image: " + message)


def read_words(path):
    words = []
    for lineno, raw in enumerate(path.read_text(encoding="ascii").splitlines(), 1):
        text = raw.strip()
        if not text:
            continue
        if not re.fullmatch(r"[0-7]{1,12}", text):
            fail("%s:%d is not an octal word" % (path, lineno))
        value = int(text, 8)
        if value > WORD_MASK:
            fail("%s:%d exceeds 36 bits" % (path, lineno))
        words.append(value)
    return words


def read_frames(path):
    label_re = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*):$")
    frame_re = re.compile(r"\badd\s+0*17,\[([0-7]+),,([0-7]+)\]", re.I)
    frames = []
    current = "<unknown>"
    text = path.read_text(encoding="ascii")
    for raw in text.splitlines():
        line = raw.strip()
        match = label_re.match(line)
        if match:
            current = match.group(1)
            continue
        match = frame_re.search(line)
        if match:
            if match.group(1) != match.group(2):
                fail("asymmetric stack adjustment in %s" % current)
            frames.append((int(match.group(1), 8), current))
    if not frames:
        fail("no GCC stack frames found in %s" % path)
    return text, frames


def main(argv):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", required=True, type=pathlib.Path)
    parser.add_argument("--assembly", required=True, type=pathlib.Path)
    args = parser.parse_args(argv)

    words = read_words(args.image)
    if len(words) < 2:
        fail("truncated DXR image")
    magic = (words[0] >> 18) & HALF_MASK
    entry = words[0] & HALF_MASK
    image_words = (words[1] >> 18) & HALF_MASK
    bss_words = words[1] & HALF_MASK
    reloc_words = (image_words + 35) // 36
    expected_words = 2 + image_words + reloc_words
    process_words = image_words + bss_words + DEFAULT_STACK_WORDS

    if magic != DXR_MAGIC:
        fail("bad DXR magic %06o" % magic)
    if entry >= image_words:
        fail("entry %06o lies outside image" % entry)
    if len(words) != expected_words:
        fail("DXR has %d words, expected %d" % (len(words), expected_words))
    if image_words > MAX_IMAGE_WORDS:
        fail("image %o exceeds DAIMOS limit %o" %
             (image_words, MAX_IMAGE_WORDS))
    if bss_words > MAX_BSS_WORDS:
        fail("BSS %o exceeds DAIMOS limit %o" %
             (bss_words, MAX_BSS_WORDS))
    if process_words > MAX_PROCESS_WORDS:
        fail("process %o exceeds DAIMOS limit %o" %
             (process_words, MAX_PROCESS_WORDS))
    if process_words > PROJECT_MAX_WORDS:
        fail("process %o exceeds project limit %o" %
             (process_words, PROJECT_MAX_WORDS))

    assembly, frames = read_frames(args.assembly)
    largest_frame, largest_name = max(frames)
    if largest_frame > MAX_SINGLE_FRAME_WORDS:
        fail("frame %s=%o exceeds %o words" %
             (largest_name, largest_frame, MAX_SINGLE_FRAME_WORDS))
    for required in ("das_native_ctx", "das_native_file_buffers"):
        if required not in assembly:
            fail("native static workspace %s is missing" % required)
    for forbidden in ("malloc", "calloc", "realloc", "tmpfile"):
        if re.search(r"\b%s\b" % forbidden, assembly):
            fail("native image references %s" % forbidden)

    print("native DAS DXR contract passed")
    print("image-words=%d (%06o)" % (image_words, image_words))
    print("bss-words=%d (%06o)" % (bss_words, bss_words))
    print("stack-words=%d (%06o)" %
          (DEFAULT_STACK_WORDS, DEFAULT_STACK_WORDS))
    print("process-words=%d (%06o)" % (process_words, process_words))
    print("largest-frame=%s:%d (%o)" %
          (largest_name, largest_frame, largest_frame))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
