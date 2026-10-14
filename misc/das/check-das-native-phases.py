#!/usr/bin/env python3
"""Check native DAS phase images against current and final size contracts."""

import argparse
import pathlib
import re

WORD_MASK = 0o777777777777
HALF_MASK = 0o777777
DXR_MAGIC = 0o447062
PHASE1_IMAGE_CEILING = 0o34000
PHASE2_IMAGE_CEILING = 0o31000
PHASE1_BSS_CEILING = 0o2500
PHASE2_BSS_CEILING = 0o3000
STACK_WORDS = 0o2000
PROCESS_CEILING = 0o40000
PROCESS_OPTIMIZATION_TARGET = 0o40000


def fail(message):
    raise SystemExit("check-das-native-phases-v1: " + message)


def read_image(path):
    raw = path.read_bytes()
    if len(raw) % 8:
        fail("%s has a partial host word" % path)
    words = [int.from_bytes(raw[i:i + 8], "little") & WORD_MASK
             for i in range(0, len(raw), 8)]
    if len(words) < 2:
        fail("%s is a truncated DXR" % path)
    magic = (words[0] >> 18) & HALF_MASK
    image = (words[1] >> 18) & HALF_MASK
    bss = words[1] & HALF_MASK
    if magic != DXR_MAGIC:
        fail("%s has bad DXR magic %06o" % (path, magic))
    reloc = (image + 35) // 36
    expected = 2 + image + reloc
    if len(words) == expected + 1:
        if (words[2] & HALF_MASK) != 0o647022:
            fail("%s has bad DXR2 metadata tag" % path)
    elif len(words) != expected:
        fail("%s has inconsistent image length" % path)
    return image, bss


def require_symbols(path, required, forbidden):
    text = path.read_text(encoding="ascii")
    for name in required:
        if not re.search(r"(?m)^%s:$" % re.escape(name), text):
            fail("%s is missing %s" % (path, name))
    for name in forbidden:
        if re.search(r"(?m)^%s:$" % re.escape(name), text):
            fail("%s unexpectedly contains %s" % (path, name))


def check_phase(label, image_path, assembly_path, image_ceiling, bss_ceiling,
                required, forbidden):
    image, bss = read_image(image_path)
    if image > image_ceiling:
        fail("%s image %06o exceeds %06o" % (label, image, image_ceiling))
    if bss > bss_ceiling:
        fail("%s BSS %06o exceeds %06o" % (label, bss, bss_ceiling))
    require_symbols(assembly_path, required, forbidden)
    process = image + bss + STACK_WORDS
    if process > PROCESS_CEILING:
        fail("%s process %06o exceeds %06o" %
             (label, process, PROCESS_CEILING))
    print("%s-image=%06o %s-bss=%06o %s-process=%06o" %
          (label, image, label, bss, label, process))
    if process > PROCESS_OPTIMIZATION_TARGET:
        print("%s-process exceeds optimization target %06o" %
              (label, PROCESS_OPTIMIZATION_TARGET))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--phase1-image", required=True, type=pathlib.Path)
    ap.add_argument("--phase1-assembly", required=True, type=pathlib.Path)
    ap.add_argument("--phase2-image", required=True, type=pathlib.Path)
    ap.add_argument("--phase2-assembly", required=True, type=pathlib.Path)
    args = ap.parse_args()

    check_phase(
        "das1", args.phase1_image, args.phase1_assembly,
        PHASE1_IMAGE_CEILING, PHASE1_BSS_CEILING,
        ("das_strip_c_comments", "macro_parse_definition", "pass1_file",
         "phase_export_stream"),
        ("phase_import_state", "pass2_phase_stream"))
    check_phase(
        "das2", args.phase2_image, args.phase2_assembly,
        PHASE2_IMAGE_CEILING, PHASE2_BSS_CEILING,
        ("phase_import_state", "pass2_phase_stream"),
        ("das_strip_c_comments", "macro_parse_definition", "pass1_file",
         "phase_export_stream"))
    print("native DAS phase size/ownership contract passed")


if __name__ == "__main__":
    main()
