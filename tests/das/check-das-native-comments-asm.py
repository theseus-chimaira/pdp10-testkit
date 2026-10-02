#!/usr/bin/env python3
"""Check native DAS comment-reader code-size and runtime dependencies."""

import pathlib
import re
import sys

LIMITS = {
    "das_strip_c_comments": 68,
    "das_read_line": 136,
}
OPTIMIZATION_TARGETS = {
    "das_strip_c_comments": 68,
    "das_read_line": 104,
}


def fail(message):
    raise SystemExit("check-das-native-comments-asm: " + message)


def function_instruction_count(lines, name):
    label = name + ":"
    try:
        start = next(i for i, line in enumerate(lines) if line.strip() == label)
    except StopIteration:
        fail("missing function %s" % name)
    count = 0
    for line in lines[start + 1:]:
        text = line.strip()
        if text.endswith(":") and not (
                text.startswith("%L") or text.startswith(".") or
                text.startswith("dcc_")):
            break
        if not line[:1].isspace():
            continue
        if text.startswith(".") or text.startswith("/*") or not text:
            continue
        count += 1
    return count


def main(argv):
    if len(argv) != 1:
        fail("usage: check-das-native-comments-asm.py phase1.s")
    phase1 = pathlib.Path(argv[0])
    phase1_text = phase1.read_text(encoding="ascii")
    if re.search(r"\bsprintf\b", phase1_text):
        fail("native DAS still references sprintf")
    counts = {
        "das_strip_c_comments": function_instruction_count(
            phase1_text.splitlines(), "das_strip_c_comments"),
        "das_read_line": function_instruction_count(
            phase1_text.splitlines(), "das_read_line"),
    }
    for name, count in counts.items():
        limit = LIMITS[name]
        if count > limit:
            fail("%s grew to %d instructions (limit %d)" %
                 (name, count, limit))
        target = OPTIMIZATION_TARGETS[name]
        if count > target:
            print("%s-instructions exceeds optimization target %d" %
                  (name, target))
    print("native DAS C-comment code-size contract passed")
    for name in sorted(counts):
        print("%s-instructions=%d" % (name, counts[name]))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
