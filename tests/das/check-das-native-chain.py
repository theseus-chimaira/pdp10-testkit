#!/usr/bin/env python3
"""Validate the native DAS driver and private phase image budgets."""

import argparse
import pathlib

WORD_MASK = 0o777777777777
HALF_MASK = 0o777777
DXR_MAGIC = 0o447062
STACK_WORDS = 0o2000
MAX_IMAGE_WORDS = 0o34000
MAX_BSS_WORDS = 0o20000
MAX_PROCESS_WORDS = 0o40000
PROCESS_OPTIMIZATION_TARGET = 0o40000
MAX_DRIVER_IMAGE_WORDS = 0o2000


def fail(message):
    raise SystemExit("check-das-native-chain: " + message)


def read_words(path):
    raw = path.read_bytes()
    if len(raw) % 8:
        fail("%s has a partial host word" % path)
    return [int.from_bytes(raw[i:i + 8], "little") & WORD_MASK
            for i in range(0, len(raw), 8)]


def image_info(path):
    words = read_words(path)
    if len(words) < 2:
        fail("%s is truncated" % path)
    magic = (words[0] >> 18) & HALF_MASK
    entry = words[0] & HALF_MASK
    image = (words[1] >> 18) & HALF_MASK
    bss = words[1] & HALF_MASK
    reloc = (image + 35) // 36
    if magic != DXR_MAGIC:
        fail("%s has bad DXR magic" % path)
    if image == 0 or entry >= image:
        fail("%s has invalid entry/image" % path)
    expected = 2 + image + reloc
    if len(words) == expected + 1:
        if (words[2] & HALF_MASK) != 0o647022:
            fail("%s has bad DXR2 metadata tag" % path)
    elif len(words) != expected:
        fail("%s has inconsistent length" % path)
    return image, bss, image + bss + STACK_WORDS


def check_phase(label, path):
    image, bss, process = image_info(path)
    if image > MAX_IMAGE_WORDS:
        fail("%s image %06o exceeds %06o" % (label, image, MAX_IMAGE_WORDS))
    if bss > MAX_BSS_WORDS:
        fail("%s BSS %06o exceeds %06o" % (label, bss, MAX_BSS_WORDS))
    if process > MAX_PROCESS_WORDS:
        fail("%s process %06o exceeds %06o" %
             (label, process, MAX_PROCESS_WORDS))
    print("%s image=%06o bss=%06o process=%06o" %
          (label, image, bss, process))
    if process > PROCESS_OPTIMIZATION_TARGET:
        print("%s process exceeds optimization target %06o" %
              (label, PROCESS_OPTIMIZATION_TARGET))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--driver", required=True, type=pathlib.Path)
    ap.add_argument("--phase1", required=True, type=pathlib.Path)
    ap.add_argument("--phase2", required=True, type=pathlib.Path)
    ap.add_argument("--phase1-assembly", required=True, type=pathlib.Path)
    args = ap.parse_args()

    image, bss, process = image_info(args.driver)
    if image > MAX_DRIVER_IMAGE_WORDS:
        fail("driver image %06o exceeds %06o" %
             (image, MAX_DRIVER_IMAGE_WORDS))
    if process > MAX_PROCESS_WORDS:
        fail("driver process exceeds DAIMOS process budget")
    print("driver image=%06o bss=%06o process=%06o" %
          (image, bss, process))

    check_phase("phase1", args.phase1)
    check_phase("phase2", args.phase2)

    assembly = args.phase1_assembly.read_text(encoding="ascii")
    if "das_native_file_paths" not in assembly:
        fail("phase1 static include path workspace is missing")
    if "das_native_file_buffers" in assembly:
        fail("phase1 still retains per-depth static read buffers")

    print("native DAS phase-chain contract passed")


if __name__ == "__main__":
    main()
