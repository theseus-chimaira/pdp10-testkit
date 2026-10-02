#!/usr/bin/env python3
"""Reject overlong user identifiers in GCC-derived PDP-10 tests."""

from pathlib import Path
import re
import sys

LIMIT = 31
IDENT = re.compile(r"\b[A-Za-z_][A-Za-z0-9_]*\b")
SKIP_PREFIXES = ("__builtin_", "__atomic_", "__sync_")
SUFFIXES = {".c", ".h"}


def gcc_test(path):
    return "gcc" in path.parts or "upstream-gcc" in path.parts


def code_only(text):
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    text = re.sub(r"//[^\n]*", " ", text)
    text = re.sub(r'"(?:\\.|[^"\\])*"', '""', text)
    return re.sub(r"'(?:\\.|[^'\\])*'", "''", text)


def main():
    bad = []
    for path in sorted(Path("tests").rglob("*")):
        if not path.is_file() or path.suffix not in SUFFIXES or not gcc_test(path):
            continue
        text = code_only(path.read_text(errors="replace"))
        for lineno, line in enumerate(text.splitlines(), 1):
            for name in IDENT.findall(line):
                if len(name) <= LIMIT or name.startswith(SKIP_PREFIXES):
                    continue
                bad.append((path, lineno, name))
    if bad:
        for path, lineno, name in bad:
            print(f"{path}:{lineno}: identifier exceeds {LIMIT} characters: {name}", file=sys.stderr)
        return 1
    print("GCC-derived test identifiers fit KCC 31-character significance")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
